import SwiftUI
import WebKit

struct CharacterGuideVideo: View {
    let fighter: Fighter

    @State private var loadID = UUID()
    @State private var status: YouTubePlayer.Status = .loading

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Color.black
                .aspectRatio(16.0 / 9, contentMode: .fit)
                .frame(minWidth: 200, minHeight: 200)
                .overlay {
                    YouTubePlayer(videoID: fighter.guideVideoID) { status = $0 }
                        .id(loadID)
                }
                .accessibilityIdentifier("official-guide-player")

            if status == .loading || status == .buffering {
                ProgressView(status == .loading ? "載入 YouTube 播放器…" : "正在緩衝影片…")
                    .font(.caption)
            } else if case .failed(let code) = status {
                Text(errorMessage(code))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Button("重新載入播放器", systemImage: "arrow.clockwise") {
                    status = .loading
                    loadID = UUID()
                }
                .buttonStyle(.borderless)
                .accessibilityIdentifier("reload-official-guide")
            }

            Link(destination: fighter.guideURL) {
                Label("在 YouTube 開啟", systemImage: "arrow.up.right.square")
                    .font(.subheadline)
            }
            .buttonStyle(.borderless)
        }
        .padding(.vertical, 4)
        .task(id: status) {
            let pendingStatus = status
            guard pendingStatus == .loading || pendingStatus == .buffering else { return }
            do {
                try await Task.sleep(for: .seconds(15))
                if status == pendingStatus {
                    status = .failed(pendingStatus == .buffering ? -2 : nil)
                }
            } catch {
                // The row left the screen or the player was reloaded.
            }
        }
    }

    private func errorMessage(_ code: Int?) -> String {
        switch code {
        case 100: "這支影片目前無法觀看。"
        case 101, 150: "影片發布者限制嵌入播放，可在 YouTube 觀看。"
        case 153: "YouTube 無法驗證內嵌播放器，可在 YouTube 觀看。"
        case -2: "影片緩衝時間過長。可重新載入，或在 YouTube 開啟。"
        default: "無法載入影片。請確認網路連線，或從 YouTube 開啟。"
        }
    }
}

private struct YouTubePlayer: UIViewRepresentable {
    enum Status: Equatable {
        case loading
        case buffering
        case ready
        case failed(Int?)
    }

    let videoID: String
    let onStatusChange: (Status) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onStatusChange: onStatusChange)
    }

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.userContentController.add(context.coordinator, name: "playerStatus")

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.isOpaque = false
        webView.backgroundColor = .black
        webView.scrollView.isScrollEnabled = false

        // YouTube uses the bundle ID as the identity of the app embedding its player.
        let bundleID = Bundle.main.bundleIdentifier?.lowercased() ?? "com.fightatlas.sf6"
        let origin = "https://\(bundleID)"
        webView.loadHTMLString(playerHTML(origin: origin), baseURL: URL(string: origin))
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        context.coordinator.onStatusChange = onStatusChange
    }

    static func dismantleUIView(_ webView: WKWebView, coordinator: Coordinator) {
        webView.navigationDelegate = nil
        webView.configuration.userContentController.removeScriptMessageHandler(forName: "playerStatus")
        webView.stopLoading()
        webView.loadHTMLString("", baseURL: nil)
    }

    private func playerHTML(origin: String) -> String {
        """
        <!doctype html>
        <html lang="zh-Hant">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="referrer" content="strict-origin-when-cross-origin">
        <style>
          html, body { width:100%; height:100%; margin:0; background:#000; overflow:hidden }
          iframe { display:block; width:100%; height:100%; border:0 }
        </style>
        <body>
          <iframe id="guide" title="YouTube 官方角色指南"
            src="https://www.youtube.com/embed/\(videoID)?playsinline=1&amp;rel=0&amp;enablejsapi=1&amp;origin=\(origin)"
            referrerpolicy="strict-origin-when-cross-origin"
            allow="autoplay; encrypted-media; picture-in-picture; fullscreen"
            allowfullscreen></iframe>
          <script>
            function report(code) { window.webkit.messageHandlers.playerStatus.postMessage(code); }
            function onYouTubeIframeAPIReady() {
              new YT.Player("guide", {events: {
                onReady: () => report(0),
                onStateChange: event => report(event.data === YT.PlayerState.BUFFERING ? -2 : 0),
                onError: event => report(event.data)
              }});
            }
          </script>
          <script async src="https://www.youtube.com/iframe_api" onerror="report(-1)"></script>
        </body>
        </html>
        """
    }

    final class Coordinator: NSObject, WKScriptMessageHandler, WKNavigationDelegate {
        var onStatusChange: (Status) -> Void

        init(onStatusChange: @escaping (Status) -> Void) {
            self.onStatusChange = onStatusChange
        }

        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            guard message.frameInfo.isMainFrame, let code = message.body as? Int else { return }
            switch code {
            case 0: onStatusChange(.ready)
            case -2: onStatusChange(.buffering)
            default: onStatusChange(.failed(code))
            }
        }

        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            onStatusChange(.failed(nil))
        }

        func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
            onStatusChange(.failed(nil))
        }
    }
}
