import SwiftUI

struct GuideView: View {
    @State private var selection = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @ScaledMetric(relativeTo: .body) private var pageHeight = 260.0

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Classic 指令讀法")
                        .font(.system(.largeTitle, weight: .black))
                        .accessibilityAddTraits(.isHeader)
                    Text("左右滑動，認識方向、按鍵與超必殺技。")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    TabView(selection: $selection) {
                        guideCard(
                            title: "看角色面向",
                            icon: "arrow.left.and.right.circle",
                            text: "圖鑑預設角色面向右方。角色換到右側、面向左方時，指令的左右方向也要對調。"
                        ) {
                            Text("↓ ↘ →　⇄　↓ ↙ ←")
                                .font(.title3.bold().monospaced())
                                .accessibilityLabel("下、右下、右，對應到下、左下、左")
                        }
                        .tag(0)

                        guideCard(
                            title: "最後一個方向加按鍵",
                            icon: "gamecontroller",
                            text: "P 代表拳，K 代表腳。Classic 各有輕、中、重三種拳與腳。加號表示同時輸入。"
                        ) {
                            CommandStrip(directions: [.down, .downForward, .forward], button: .punch)
                        }
                        .tag(1)

                        guideCard(
                            title: "看超必殺技量表",
                            icon: "bolt.circle",
                            text: "SA1、SA2 表示超必殺技的等級。出招前，確認已經累積所需的 1 格或 2 格量表。"
                        ) {
                            Text("SA1 · 1 格　　SA2 · 2 格")
                                .font(.headline.monospaced())
                        }
                        .tag(2)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .frame(height: pageHeight)

                    HStack {
                        Button {
                            changePage(by: -1)
                        } label: {
                            Label("上一頁", systemImage: "chevron.left")
                                .labelStyle(.iconOnly)
                                .frame(width: 44, height: 44)
                        }
                        .disabled(selection == 0)

                        Spacer()

                        Text("\(selection + 1) / 3")
                            .font(.footnote.monospacedDigit())
                            .foregroundStyle(.secondary)
                            .accessibilityLabel("第 \(selection + 1) 頁，共 3 頁")

                        Spacer()

                        Button {
                            changePage(by: 1)
                        } label: {
                            Label("下一頁", systemImage: "chevron.right")
                                .labelStyle(.iconOnly)
                                .frame(width: 44, height: 44)
                        }
                        .disabled(selection == 2)
                    }
                    .buttonStyle(.bordered)

                    Link(destination: URL(string: "https://game.capcom.com/manual/SF6/")!) {
                        Label("Capcom 官方操作手冊", systemImage: "arrow.up.right.square")
                            .atlasPanel()
                    }

                    Text("粉絲製作的招式圖鑑。角色插畫為 AI 繪製。")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .padding(.top, 4)
                }
                .frame(maxWidth: 620)
                .padding(20)
                .frame(maxWidth: .infinity)
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationTitle("操作指南")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func changePage(by amount: Int) {
        withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.25)) {
            selection += amount
        }
    }

    private func guideCard<Example: View>(
        title: String, icon: String, text: String, @ViewBuilder example: () -> Example
    ) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: icon)
                    .font(.system(.title, weight: .medium))
                    .foregroundStyle(Color.accentColor)
                    .accessibilityHidden(true)
                Text(title)
                    .font(.title2.bold())
                    .accessibilityAddTraits(.isHeader)
                Text(text)
                    .foregroundStyle(.secondary)
                example()
                    .foregroundStyle(Color.accentColor)
            }
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .scrollBounceBehavior(.basedOnSize)
        .background(.background, in: RoundedRectangle(cornerRadius: 22))
        .overlay {
            RoundedRectangle(cornerRadius: 22)
                .strokeBorder(.primary.opacity(0.09))
                .allowsHitTesting(false)
        }
    }
}
