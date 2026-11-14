import AVKit
import SwiftUI

struct TrainingVideo: View {
    @State private var player: AVPlayer?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("波動拳・訓練場演示", systemImage: "play.rectangle")
                .font(.headline)
                .accessibilityAddTraits(.isHeader)
            Text("自製像素動畫 · Classic · 面向右方")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            if let player {
                VideoPlayer(player: player)
                    .aspectRatio(16 / 9.0, contentMode: .fit)
                    .clipShape(.rect(cornerRadius: 12))
                    .accessibilityIdentifier("hadoken-video")

                Button {
                    player.seek(to: .zero)
                    player.play()
                } label: {
                    Label("從頭播放短片", systemImage: "play.circle")
                        .frame(minHeight: 32)
                }
                .buttonStyle(.bordered)
                .accessibilityIdentifier("play-training-video")
            }
        }
        .atlasPanel()
        .task {
            if player == nil,
               let url = Bundle.main.url(forResource: "HadokenTraining", withExtension: "mp4") {
                player = AVPlayer(url: url)
            }
        }
        .onDisappear {
            player?.pause()
        }
    }
}
