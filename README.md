# 🥊 FightAtlas｜快打旋風 6 招式圖鑑

**FightAtlas** 是以 **SwiftUI** 開發的繁體中文《快打旋風 6》（Street Fighter 6）Classic 操作招式手冊。透過角色卡片、分類招式表、方向鍵動畫和練習提示，幫助玩家快速查詢並理解出招指令。

> 本專案為**非官方粉絲／課程練習作品**，並非完整角色或招式資料庫；目前收錄 **3 位角色、共 12 個招式**，不包含即時遊戲連線、輸入辨識或戰績追蹤。

## ✨ 主要功能

### 🎮 角色圖鑑
- 使用 `LazyVGrid` 呈現 **肯（Ken）**、**豪鬼（Akuma）**、**隆（Ryu）** 的插畫角色卡。
- 點選角色進入專屬招式表，查看戰鬥風格簡介、代表招式和分類列表。
- 以 `NavigationStack`、`NavigationLink(value:)` 與 `navigationDestination` 完成階層導覽。

### 📖 招式表與指令詳情
- 按 **必殺技**、**超必殺技** 分組顯示招式名稱、英文名稱、方向指令及拳／腳按鍵。
- 提供 **面向右方／面向左方** 切換，自動鏡像左右方向。
- 按下「**播放指令**」後，方向鍵逐步亮起；最後一個方向與拳／腳按鍵同時亮起。
- 動畫結束會顯示該招式的**使用說明和練習提示**；開啟系統「減少動態效果」時會略過動畫。
- 使用 `@State` 管理面向、播放進度和提示顯示。

### 🎬 影片輔助
- **離線示範**：隆的「波動拳」詳情頁使用 `AVKit.VideoPlayer` 播放專案內的 `HadokenTraining.mp4` 像素訓練場短片，可從頭重新播放。
- **官方角色指南**：各角色招式表內使用 `WKWebView` 嵌入 YouTube 指南，提供載入狀態、失敗重試及「在 YouTube 開啟」連結。
- 離線短片不需要網路；YouTube 內嵌影片需要網路，也可能受到影片擁有者的嵌入限制。

### 📱 操作指南與裝置介面
- 「**角色圖鑑**」及「**操作指南**」兩個主分頁。
- 指南透過可**左右滑動**的分頁介紹角色面向、方向與按鍵、SA 量表，並提供上一頁／下一頁按鈕。
- `.sidebarAdaptable` 分頁配置可依 iPhone、iPad 顯示環境調整。
- 支援系統淺色／深色模式、SF Symbols，以及部分動態字體與 VoiceOver 可及性標籤。

## 👤 目前收錄角色與招式

| 角色 | 必殺技（3 招） | 超必殺技（1 招） |
| --- | --- | --- |
| **肯 Ken** | 迅雷腳、龍尾腳、昇龍拳 | 疾風迅雷腳（SA2） |
| **豪鬼 Akuma** | 豪波動拳、豪昇龍拳、金剛灼火 | 滅殺豪波動（SA1） |
| **隆 Ryu** | 波動拳、昇龍拳、龍捲旋風腳 | 真空波動拳（SA1） |

**指令範例（角色面向右方）**

| 招式 | Classic 指令 |
| --- | --- |
| 波動拳 | `↓ ↘ → + P` |
| 昇龍拳 | `→ ↓ ↘ + P` |
| 龍捲旋風腳 | `↓ ↙ ← + K` |

`P` 代表拳（Punch），`K` 代表腳（Kick）；**「+」表示最後一個方向與按鍵同時輸入**。面向左方時，App 會替換左右方向。完整資料以程式內的 `MoveCatalog.swift` 為準。

## 🧰 開發技術

| 項目 | 技術 |
| --- | --- |
| 語言 | Swift |
| 介面 | SwiftUI |
| 導覽與版面 | `NavigationStack`、`TabView`、`List`、`LazyVGrid`、`ScrollView` |
| 狀態與動畫 | `@State`、`withAnimation`、`transition`、Swift Concurrency |
| 本地影片 | AVKit / `VideoPlayer` |
| YouTube 嵌入 | WebKit / `WKWebView` |
| 資料 | 內建 `Fighter`、`Move` 值型別資料；不需帳號或後端 |

## 🚀 安裝與執行

### 系統需求
- macOS 與可使用 **iOS 18 SDK 或更新版本**的 Xcode。
- iPhone 或 iPad 模擬器／實體裝置。
- App 最低部署版本：**iOS／iPadOS 18**。

### 操作步驟
1. 複製專案：
   ```bash
   git clone https://github.com/smallshawn95/FightAtlas.git
   ```
2. 使用 Xcode 開啟 `FightAtlas.xcodeproj`。
3. 選擇 **FightAtlas** scheme 與目標模擬器；實機執行時視需要設定 Signing Team。
4. 按下 **Run（⌘R）**。
5. 在「角色圖鑑」中選擇角色 → 招式 → 查看指令，切換角色面向並按「播放指令」；也可在「操作指南」查看教學。

> 目前未提供 App Store 安裝連結。這是可用 Xcode 執行的原始碼專案。

## 🗂️ 專案結構

```text
FightAtlas/
├── FightAtlas.xcodeproj/              # Xcode 專案
├── FightAtlas/
│   ├── FightAtlasApp.swift            # App 入口與雙主分頁
│   ├── MoveCatalog.swift              # 角色、招式模型與內建招式資料
│   ├── Assets.xcassets/               # 角色插畫與 App 圖示
│   ├── Resources/
│   │   └── HadokenTraining.mp4        # 離線波動拳演示
│   └── Views/
│       ├── AtlasStyle.swift           # 角色配色及共用面板樣式
│       ├── FighterGalleryView.swift   # 角色卡片網格與導覽
│       ├── MoveListView.swift         # 分類招式表與代表招式卡
│       ├── MoveDetailView.swift       # 指令、換邊、播放動畫與提示
│       ├── GuideView.swift            # Classic 操作分頁指南
│       ├── TrainingVideo.swift        # 本地影片播放器
│       └── CharacterGuideVideo.swift  # YouTube 嵌入播放器
├── .gitignore
└── README.md
```

## 📚 SwiftUI 課程功能對照（#88）

| 練習項目 | 本專案的實作 |
| --- | --- |
| 多頁面與獨立 View 檔案 | `FighterGalleryView`、`MoveListView`、`MoveDetailView`、`GuideView` |
| `NavigationStack` 與值型別導覽 | 角色 ID、`MoveRoute`、`navigationDestination` |
| `TabView`、`Tab` | 兩個主分頁及可適應側邊欄的配置 |
| 水平滑動頁面 | 操作指南使用 `.tabViewStyle(.page)` |
| 動畫與 `transition` | 出招按鍵逐格亮起，練習提示淡入／位移 |
| `Identifiable` 自訂資料與 `List` | `Fighter`、`Move` 與分類招式表 |
| `Link` | 官方 Capcom 手冊及 YouTube 外部連結 |
| 深色／淺色模式 | 採用系統自適應背景、文字和強調色 |
| SF Symbols | 分頁、操作、影片與指南圖示 |
| `LazyVGrid` | 三位角色的插畫卡 |
| 垂直 `List` + 水平 `ScrollView` | 代表招式橫向卡片列 |
| `VideoPlayer` | 隆的波動拳離線演示 |
| App 名稱與圖示 | 「快打旋風 6 招式圖鑑」及自製方向鍵圖示 |

課程參考：[#88 作業原文](https://medium.com/p/3ae9c256c960)。

## 🔗 參考來源

- [Capcom《Street Fighter 6》官方操作手冊](https://game.capcom.com/manual/SF6/)
- [肯：官方角色指南（YouTube）](https://www.youtube.com/watch?v=1SX2m7sqbtA)
- [豪鬼：官方角色指南（YouTube）](https://www.youtube.com/watch?v=13tKXXxmiek)
- [隆：官方角色指南（YouTube）](https://www.youtube.com/watch?v=iAs1p3LVdAs)

## 📌 素材與權利聲明

本專案的角色卡為專案製作的 **AI 插畫**；離線像素動畫使用相關圖像製作，App 圖示為自製。所有《Street Fighter 6》相關名稱、角色及其智慧財產權歸 **Capcom** 或各自權利人所有。本專案為非官方粉絲課程作品，不代表 Capcom 官方立場。

招式與操作資訊僅供學習和查詢，實際遊戲內容可能隨版本更新而變動；以遊戲內說明及官方資料為準。
