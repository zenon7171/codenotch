import AppKit
import Combine

/// The Japanese fork has no signed update feed. Never start the upstream updater.
@MainActor
final class Updater: ObservableObject {
    enum Outcome: Equatable {
        case idle, checking, upToDate(Date), found(String), unreachable, failed(String)
        var message: String? {
            switch self {
            case .idle: return nil
            case .checking: return "確認中…"
            case .upToDate: return "最新バージョンです。"
            case .found(let version): return "バージョン \(version) が利用できます。"
            case .unreachable: return "更新情報を取得できませんでした。"
            case .failed(let message): return message
            }
        }
    }
    @Published private(set) var outcome: Outcome = .idle
    var automatic: Bool {
        get { false }
        set { /* Disabled until this fork has its own signed update feed. */ }
    }
    var currentVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "?"
    }
    var lastChecked: Date? { nil }
    func start() {}
    func checkNow() {
        NSWorkspace.shared.open(URL(string: "https://github.com/zenon7171/codenotch/releases")!)
    }
}
