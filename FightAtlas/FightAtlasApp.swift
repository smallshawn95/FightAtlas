import SwiftUI

@main
struct FightAtlasApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                Tab("角色圖鑑", systemImage: "square.grid.2x2") {
                    FighterGalleryView()
                }

                Tab("操作指南", systemImage: "gamecontroller") {
                    GuideView()
                }
            }
            .tabViewStyle(.sidebarAdaptable)
        }
    }
}
