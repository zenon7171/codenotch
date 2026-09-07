import Foundation

/// How much of itself the notch shows when you are not using it.
///
/// Three states rather than the two that get asked for, because the default is
/// neither: at rest the notch is already a small pill that opens on contact.
/// Offering only "always" and "hidden" would quietly delete the behaviour the
/// app was designed around.
enum NotchVisibility: String, CaseIterable, Identifiable {
    /// Pinned open. The readings are always on screen.
    case alwaysShow
    /// A pill at the edge that unfolds when the pointer reaches it. The default.
    case onHover
    /// Nothing on screen at all.
    case hidden

    var id: String { rawValue }

    var title: String {
        switch self {
        case .alwaysShow: return "常に表示"
        case .onHover:    return "ポインタで表示"
        case .hidden:     return "非表示"
        }
    }

    var explanation: String {
        switch self {
        case .alwaysShow:
            return "ノッチを開いたままにして、すべての使用量を表示します。"
        case .onHover:
            return "画面の端に小さく表示し、ポインタを重ねると開きます。"
        case .hidden:
            // Said here because a hidden notch is also a hidden way back in.
            return "ノッチを表示しません。設定画面を再び開くには「アプリケーション」から Codenotch を起動してください。"
        }
    }
}
