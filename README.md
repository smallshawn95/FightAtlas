# 快打旋風 6 招式圖鑑

以 SwiftUI 製作的繁體中文招式手冊。收錄肯、豪鬼、隆共 12 招 Classic 招式，包含必殺技與超必殺技。

## 開啟專案

1. 用支援 iOS 18 SDK 或更新版本的 Xcode 開啟 `FightAtlas.xcodeproj`。
2. 選擇 `FightAtlas` scheme，指定 iPhone 或 iPad 模擬器並執行。最低系統版本為 iOS／iPadOS 18。
3. 點選角色與招式。詳情頁可換邊、播放指令，以及查看練習提示。隆的波動拳詳情有離線訓練場動畫。
4. 在角色招式表底部的「官方角色指南」點選 YouTube 播放器。此播放器需要網路連線。遇到載入問題時可重試，或用下方的連結開啟 YouTube。

## #88 功能對照

| 題目要求 | 專案中可展示的畫面或程式 |
|---|---|
| 多頁面，使用獨立檔案 | `Views` 內分別定義角色圖鑑、招式表、招式詳情與操作指南。 |
| `NavigationStack`、值型別 `NavigationLink`、`navigationDestination`、導覽標題 | 角色選擇傳入角色 ID，招式列傳入角色與招式 ID。各層皆設定 `navigationTitle`。 |
| `TabView` 與 `Tab` | 角色圖鑑、操作指南。iPhone 顯示底部分頁，iPad 全寬視窗顯示頂部分頁，並可切到側邊欄。 |
| 水平滑動分頁 | 操作指南使用 `.tabViewStyle(.page)`，也提供上一頁及下一頁。 |
| SwiftUI 動畫與 `transition` | 詳情按下「播放指令」會依序亮起方向鍵，最後一個方向與拳或腳同時亮起。練習提示以位移與淡入出現。系統開啟「減少動態效果」時直接顯示提示。 |
| `Identifiable` 的自訂 `struct` 陣列與 `List` | `Fighter`、`Move` 皆遵從 `Identifiable`，分組招式表使用 `List`。 |
| `Link` | 操作指南可開啟 Capcom 手冊，官方影片下方也提供 YouTube 連結。 |
| 淺色與深色外觀 | 隨系統外觀切換，文字、背景和強調色使用自適應色彩。 |
| SF Symbols | 分頁按鈕、播放按鈕與操作指南圖示。 |
| `LazyVGrid` 圖片牆 | 角色圖鑑的三張插畫卡。 |
| 垂直 `List` 內有水平 `ScrollView` | 招式表上方的代表招式卡。 |
| `VideoPlayer` | 隆的波動拳頁面使用原生播放器，示範架勢、輸入、氣彈與假人受擊。官方 YouTube 則使用內嵌播放器。 |
| App 名稱與圖示 | 主畫面名稱為「快打旋風 6 招式圖鑑」，圖示使用波動拳的三個方向鍵。 |

展示時可在 iPhone 錄下底部分頁、角色導覽與指令動畫，在 iPad 展示頂部分頁與側邊欄，並在 GIF 裡切換淺色與深色。作業文章可標示亮鍵動畫和練習提示的轉場。[#88 作業原文](https://medium.com/p/3ae9c256c960)

## 素材與資料

- 招式參考：[肯官方指南](https://www.youtube.com/watch?v=1SX2m7sqbtA)、[豪鬼官方指南（繁中）](https://www.youtube.com/watch?v=13tKXXxmiek)、[隆官方指南](https://www.youtube.com/watch?v=iAs1p3LVdAs)、[Capcom 官方操作手冊](https://game.capcom.com/manual/SF6/)。
- 角色卡與訓練場動畫的圖像是為此專案製作的 AI 插畫。訓練場 MP4 使用這些圖像製作像素動畫，App 圖示為自製。
- 本專案是粉絲製作的課程作品。《快打旋風 6》及其角色的權利歸 Capcom 所有。
