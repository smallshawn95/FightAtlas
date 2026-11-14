import SwiftUI

struct MoveRoute: Hashable {
    let fighter: Fighter.ID
    let move: Move.ID
}

struct MoveListView: View {
    let fighter: Fighter

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    FighterCard(fighter: fighter)
                    Text(fighter.overview)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("下列指令以角色面向右方為準。")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }

            Section("代表招式") {
                ScrollView(.horizontal) {
                    HStack(spacing: 10) {
                        ForEach(fighter.moves.prefix(3)) { move in
                            NavigationLink(value: MoveRoute(fighter: fighter.id, move: move.id)) {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(move.name).font(.headline)
                                    Text("\(move.directionText) + \(move.button.rawValue)")
                                        .font(.subheadline.monospaced())
                                        .foregroundStyle(Color.accentColor)
                                }
                                .padding(14)
                                .frame(minWidth: 132, alignment: .leading)
                                .background(.tint.opacity(0.12), in: RoundedRectangle(cornerRadius: 12))
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel("\(move.name)，\(move.spokenCommand)")
                        }
                    }
                }
                .scrollBounceBehavior(.basedOnSize)
                .padding(.vertical, 4)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }

            ForEach(Move.Category.allCases, id: \.self) { category in
                Section(category.rawValue) {
                    ForEach(fighter.moves.filter { $0.category == category }) { move in
                        NavigationLink(value: MoveRoute(fighter: fighter.id, move: move.id)) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(move.name)
                                    .font(.headline)
                                Text("\(move.directionText) + \(move.button.rawValue)")
                                    .font(.subheadline.monospaced())
                                    .foregroundStyle(.secondary)
                                    .accessibilityLabel(move.spokenCommand)
                                if let level = move.superLevel {
                                    Text("SA\(level)")
                                        .font(.caption.weight(.semibold).monospaced())
                                        .foregroundStyle(Color.accentColor)
                                        .accessibilityLabel("等級 \(level)")
                                }
                            }
                            .padding(.vertical, 5)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                        }
                        .accessibilityIdentifier("move-\(move.id)")
                    }
                }
            }

            Section("官方角色指南") {
                CharacterGuideVideo(fighter: fighter)
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("\(fighter.name)・招式表")
        .navigationBarTitleDisplayMode(.inline)
    }
}
