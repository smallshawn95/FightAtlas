import SwiftUI

struct MoveDetailView: View {
    let fighter: Fighter
    let move: Move

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.colorScheme) private var colorScheme
    @State private var facesRight = true
    @State private var playbackID: UUID?
    @State private var highlightedStep: Int?
    @State private var showsTip = false

    private var directions: [Direction] {
        facesRight ? move.motion : move.motion.map { $0.mirrored() }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(move.englishName)
                        .font(.subheadline.bold().monospaced())
                        .foregroundStyle(Color.accentColor)
                    Text(move.name)
                        .font(.system(.largeTitle, weight: .black))
                        .accessibilityAddTraits(.isHeader)
                    if let level = move.superLevel {
                        Text("超必殺技 · 等級 \(level)")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.secondary)
                    }
                    Text(move.use)
                        .font(.body)
                        .padding(.top, 4)
                }

                VStack(alignment: .leading, spacing: 16) {
                    Text("Classic 出招指令")
                        .font(.headline)
                        .accessibilityAddTraits(.isHeader)

                    Picker("角色面向", selection: $facesRight) {
                        Text("面向右方").tag(true)
                        Text("面向左方").tag(false)
                    }
                    .pickerStyle(.segmented)
                    .accessibilityIdentifier("facing-picker")

                    CommandStrip(
                        directions: directions,
                        button: move.button,
                        highlightedStep: highlightedStep
                    )

                    Text("最後一個方向與\(move.button.title)鍵一起輸入。")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Button {
                        startPlayback()
                    } label: {
                        Label(
                            playbackID != nil ? "播放中" : showsTip ? "再播一次" : "播放指令",
                            systemImage: showsTip ? "arrow.counterclockwise" : "play.fill"
                        )
                        .foregroundStyle(colorScheme == .dark ? Color.black : Color.white)
                        .frame(maxWidth: .infinity, minHeight: 28)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(playbackID != nil)
                    .accessibilityIdentifier("play-command")
                }
                .atlasPanel()

                if showsTip {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("練習提示", systemImage: "lightbulb")
                            .font(.headline)
                            .accessibilityAddTraits(.isHeader)
                        Text(move.tip)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .atlasPanel()
                    .transition(reduceMotion ? .identity : .move(edge: .bottom).combined(with: .opacity))
                    .accessibilityIdentifier("practice-tip")
                }

                if fighter.id == .ryu && move.id == "hadoken" {
                    TrainingVideo()
                }
            }
            .frame(maxWidth: 620)
            .padding(20)
            .frame(maxWidth: .infinity)
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("\(fighter.name)・招式詳情")
        .navigationBarTitleDisplayMode(.inline)
        .task(id: playbackID) {
            guard playbackID != nil else { return }
            await animateCommand()
        }
        .onChange(of: facesRight) {
            playbackID = nil
            highlightedStep = nil
        }
        .onDisappear {
            playbackID = nil
            highlightedStep = nil
        }
    }

    private func startPlayback() {
        if reduceMotion {
            showsTip = true
        } else {
            playbackID = UUID()
        }
    }

    @MainActor
    private func animateCommand() async {
        do {
            for index in directions.indices {
                try Task.checkCancellation()
                withAnimation(.easeInOut(duration: 0.16)) {
                    highlightedStep = index
                }
                try await Task.sleep(for: .milliseconds(290))
            }
            try Task.checkCancellation()
            withAnimation(.easeInOut(duration: 0.22)) {
                highlightedStep = nil
                showsTip = true
                playbackID = nil
            }
        } catch {
            // A new direction or leaving the page cancels playback.
        }
    }
}

struct CommandStrip: View {
    let directions: [Direction]
    let button: AttackButton
    var highlightedStep: Int?
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ViewThatFits(in: .horizontal) {
            keys
            ScrollView(.horizontal) {
                keys
            }
            .scrollIndicators(.hidden)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(
            directions.map(\.spokenName).joined(separator: "、")
                + "，最後一個方向加\(button.title)"
        )
    }

    private var keys: some View {
        HStack(spacing: 5) {
            ForEach(Array(directions.enumerated()), id: \.offset) { index, direction in
                key(direction.rawValue, isActive: highlightedStep == index)
            }
            Text("+")
                .font(.caption.bold())
                .foregroundStyle(.secondary)
            key(button.rawValue, isActive: highlightedStep == directions.count - 1)
        }
        .fixedSize(horizontal: true, vertical: false)
    }

    private func key(_ text: String, isActive: Bool) -> some View {
        Text(text)
            .font(.title3.monospaced().bold())
            .padding(.horizontal, 9)
            .frame(minWidth: 34, minHeight: 40)
            .foregroundStyle(isActive ? (colorScheme == .dark ? Color.black : Color.white) : .primary)
            .background(
                isActive ? Color.accentColor : Color(uiColor: .tertiarySystemFill),
                in: RoundedRectangle(cornerRadius: 8)
            )
    }
}
