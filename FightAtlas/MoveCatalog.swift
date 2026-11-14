import Foundation

enum Direction: String, Hashable {
    case forward = "→"
    case downForward = "↘"
    case down = "↓"
    case downBack = "↙"
    case back = "←"

    var spokenName: String {
        switch self {
        case .forward: "右"
        case .downForward: "右下"
        case .down: "下"
        case .downBack: "左下"
        case .back: "左"
        }
    }

    func mirrored() -> Self {
        switch self {
        case .forward: .back
        case .downForward: .downBack
        case .down: .down
        case .downBack: .downForward
        case .back: .forward
        }
    }
}

enum AttackButton: String, Hashable {
    case punch = "P"
    case kick = "K"

    var title: String {
        switch self {
        case .punch: "拳"
        case .kick: "腳"
        }
    }
}

struct Move: Identifiable {
    enum Category: String, CaseIterable {
        case special = "必殺技"
        case superArt = "超必殺技"
    }

    let id: String
    let name: String
    let englishName: String
    let motion: [Direction]
    let button: AttackButton
    let use: String
    let tip: String
    var superLevel: Int? = nil

    var category: Category { superLevel == nil ? .special : .superArt }

    var directionText: String {
        motion.map(\.rawValue).joined(separator: " ")
    }

    var spokenCommand: String {
        let directions = motion.map(\.spokenName).joined(separator: "、")
        return "\(directions)，最後一個方向加\(button.title)"
    }
}

struct Fighter: Identifiable {
    enum ID: String, Hashable {
        case ken, akuma, ryu
    }

    let id: ID
    let name: String
    let englishName: String
    let style: String
    let overview: String
    let guideVideoID: String
    let moves: [Move]

    var artwork: String { "Fighter-\(id.rawValue)" }
    var guideURL: URL { URL(string: "https://www.youtube.com/watch?v=\(guideVideoID)")! }
}

enum MoveCatalog {
    static let fighters: [Fighter] = [
        Fighter(
            id: .ken,
            name: "肯",
            englishName: "KEN",
            style: "向前搶攻",
            overview: "用龍尾腳拉近距離，以迅雷腳的派生維持攻勢。",
            guideVideoID: "1SX2m7sqbtA",
            moves: [
                Move(id: "jinrai-kick", name: "迅雷腳", englishName: "Jinrai Kick",
                     motion: [.down, .downForward, .forward], button: .kick,
                     use: "向前踢擊，可接不同的派生踢擊。",
                     tip: "先練習單獨出招，再加入派生。可以在訓練模式將對手設成防禦，觀察各派生的距離。"),
                Move(id: "dragonlash-kick", name: "龍尾腳", englishName: "Dragonlash Kick",
                     motion: [.forward, .down, .downForward], button: .kick,
                     use: "跳向前方踢擊，可從中距離接近對手。",
                     tip: "最後停在斜下前並按腳。換用輕、中、重腳，觀察移動距離。"),
                Move(id: "shoryuken", name: "昇龍拳", englishName: "Shoryuken",
                     motion: [.forward, .down, .downForward], button: .punch,
                     use: "向上出拳，常用來迎擊跳入的對手。",
                     tip: "把訓練假人設定成前跳，讓指令停在斜下前時按拳。"),
                Move(id: "shippu-jinrai", name: "疾風迅雷腳", englishName: "Shippu Jinrai-kyaku",
                     motion: [.down, .downForward, .forward, .down, .downForward, .forward], button: .kick,
                     use: "耗費兩格超必殺技量表，適合練習接在命中的連段後。",
                     tip: "把兩次下、斜下前、前連起來，在第二次推到前時按腳。", superLevel: 2),
            ]
        ),
        Fighter(
            id: .akuma,
            name: "豪鬼",
            englishName: "AKUMA",
            style: "蓄力牽制",
            overview: "用可蓄力的豪波動拳牽制對手，再找機會以金剛灼火前進。",
            guideVideoID: "13tKXXxmiek",
            moves: [
                Move(id: "gou-hadoken", name: "豪波動拳", englishName: "Gou Hadoken",
                     motion: [.down, .downForward, .forward], button: .punch,
                     use: "向前發射氣彈，也可以按住拳鍵蓄力。",
                     tip: "先比較點按與按住拳鍵的差異，再試著用不同距離觀察對手的反應。"),
                Move(id: "gou-shoryuken", name: "豪昇龍拳", englishName: "Gou Shoryuken",
                     motion: [.forward, .down, .downForward], button: .punch,
                     use: "向上出拳，可用於對空與連段收尾。",
                     tip: "讓假人反覆前跳，從站定開始練習，不必先走動。"),
                Move(id: "adamant-flame", name: "金剛灼火", englishName: "Adamant Flame",
                     motion: [.down, .downBack, .back], button: .punch,
                     use: "帶著火焰向前推進，可接在連段中。",
                     tip: "這招的方向是下、斜下後、後。先練好第一段，再試著在命中後輸入前加拳追擊。"),
                Move(id: "messatsu-gohado", name: "滅殺豪波動", englishName: "Messatsu Gohado",
                     motion: [.down, .downForward, .forward, .down, .downForward, .forward], button: .punch,
                     use: "耗費一格超必殺技量表，向前射出高威力氣彈。",
                     tip: "先用固定量表練習兩次四分之一圈，再練習從命中的招式接入。", superLevel: 1),
            ]
        ),
        Fighter(
            id: .ryu,
            name: "隆",
            englishName: "RYU",
            style: "波動與對空",
            overview: "用波動拳控制中距離，對手跳過來時以昇龍拳迎擊。",
            guideVideoID: "iAs1p3LVdAs",
            moves: [
                Move(id: "hadoken", name: "波動拳", englishName: "Hadoken",
                     motion: [.down, .downForward, .forward], button: .punch,
                     use: "向前發射氣彈，適合在中遠距離牽制。",
                     tip: "先連續輸入下、斜下前、前。推到前的同時按拳，再交替試輕拳和重拳。"),
                Move(id: "shoryuken", name: "昇龍拳", englishName: "Shoryuken",
                     motion: [.forward, .down, .downForward], button: .punch,
                     use: "向上出拳，用來練習對空。",
                     tip: "讓假人從同一個距離反覆前跳，練習在對手落到你面前之前出拳。"),
                Move(id: "tatsumaki", name: "龍捲旋風腳", englishName: "Tatsumaki Senpu-kyaku",
                     motion: [.down, .downBack, .back], button: .kick,
                     use: "旋轉向前踢擊，可用來收尾並把對手往角落推。",
                     tip: "先練站在地面時的指令，再用不同腳鍵觀察移動距離。"),
                Move(id: "shinku-hadoken", name: "真空波動拳", englishName: "Shinku Hadoken",
                     motion: [.down, .downForward, .forward, .down, .downForward, .forward], button: .punch,
                     use: "耗費一格超必殺技量表，射出強化的波動拳。",
                     tip: "第二次推到前再按拳，避免太早按成普通波動拳。", superLevel: 1),
            ]
        ),
    ]
}
