import SwiftUI

struct FighterGalleryView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    HStack {
                        Text("STREET FIGHTER 6")
                            .font(.subheadline.bold().monospaced())
                            .tracking(2)
                            .foregroundStyle(Color.accentColor)
                        Spacer()
                        Label("Classic", systemImage: "gamecontroller")
                            .font(.subheadline.weight(.semibold))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 7)
                            .background(Color.accentColor.opacity(0.12), in: Capsule())
                    }
                    .accessibilityElement(children: .combine)

                    VStack(alignment: .leading, spacing: 6) {
                        Text("角色選擇")
                            .font(.system(.largeTitle, design: .default, weight: .black))
                            .accessibilityAddTraits(.isHeader)
                        Text("選擇角色，查看出招指令與練習提示。")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 244), spacing: 14)], spacing: 14) {
                        ForEach(MoveCatalog.fighters) { fighter in
                            NavigationLink(value: fighter.id) {
                                FighterCard(fighter: fighter, showsDisclosure: true)
                            }
                            .buttonStyle(.plain)
                            .accessibilityIdentifier("fighter-\(fighter.id.rawValue)")
                        }
                    }
                }
                .frame(maxWidth: 1080)
                .padding(.horizontal, 20)
                .padding(.top, 14)
                .padding(.bottom, 24)
                .frame(maxWidth: .infinity)
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationTitle("招式圖鑑")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Fighter.ID.self) { id in
                if let fighter = MoveCatalog.fighters.first(where: { $0.id == id }) {
                    MoveListView(fighter: fighter)
                }
            }
            .navigationDestination(for: MoveRoute.self) { route in
                if let fighter = MoveCatalog.fighters.first(where: { $0.id == route.fighter }),
                   let move = fighter.moves.first(where: { $0.id == route.move }) {
                    MoveDetailView(fighter: fighter, move: move)
                }
            }
        }
    }
}

struct FighterCard: View {
    let fighter: Fighter
    var showsDisclosure = false

    @ScaledMetric(relativeTo: .title) private var minimumHeight = 145.0

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(fighter.englishName)
                .font(.caption.bold().monospaced())
                .tracking(2.5)
                .foregroundStyle(fighter.id.artworkTint)

            Text(fighter.name)
                .font(.system(.largeTitle, weight: .black))
                .foregroundStyle(.white)

            Text(fighter.style)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.white.opacity(0.88))
        }
        .padding(.vertical, 16)
        .padding(.leading, 20)
        .padding(.trailing, showsDisclosure ? 56 : 20)
        .frame(maxWidth: .infinity, minHeight: minimumHeight, alignment: .leading)
        .background {
            GeometryReader { geometry in
                Image(fighter.artwork)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .top)
                    .clipped()
                    .accessibilityHidden(true)
            }
            .overlay {
                LinearGradient(
                    stops: [.init(color: .black.opacity(0.56), location: 0),
                            .init(color: .clear, location: 0.66)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            }
            .background(fighter.id.artworkShadow)
            .allowsHitTesting(false)
            .accessibilityHidden(true)
        }
        .overlay(alignment: .trailing) {
            if showsDisclosure {
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(10)
                    .background(.black.opacity(0.64), in: Circle())
                    .padding(.trailing, 14)
                    .accessibilityHidden(true)
                    .allowsHitTesting(false)
            }
        }
        .clipShape(.rect(cornerRadius: 20))
        .contentShape(.rect(cornerRadius: 20))
    }
}
