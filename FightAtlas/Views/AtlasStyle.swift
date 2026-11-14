import SwiftUI

extension Fighter.ID {
    var artworkTint: Color {
        switch self {
        case .ken: Color(red: 1, green: 0.72, blue: 0.49)
        case .akuma: Color(red: 0.88, green: 0.73, blue: 1)
        case .ryu: Color(red: 0.65, green: 0.92, blue: 0.91)
        }
    }

    var artworkShadow: Color {
        switch self {
        case .ken: Color(red: 0.20, green: 0.09, blue: 0.07)
        case .akuma: Color(red: 0.15, green: 0.08, blue: 0.22)
        case .ryu: Color(red: 0.06, green: 0.16, blue: 0.17)
        }
    }
}

struct AtlasPanel: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.background, in: RoundedRectangle(cornerRadius: 22))
            .overlay {
                RoundedRectangle(cornerRadius: 22)
                    .strokeBorder(.primary.opacity(0.09))
                    .allowsHitTesting(false)
            }
    }
}

extension View {
    func atlasPanel() -> some View {
        modifier(AtlasPanel())
    }
}
