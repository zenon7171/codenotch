import Foundation

/// What one release changed, in the app's own words.
struct ReleaseNote: Equatable {
    /// Matched against `CFBundleShortVersionString`, so it has to be exactly
    /// the string `MARKETING_VERSION` is set to.
    let version: String
    /// One line under the title. What this release is *about*.
    let headline: String
    let changes: [Change]

    /// A title carries the change; the detail is optional, so a small fix can
    /// be a single line rather than a line padded out to match its neighbours.
    struct Change: Equatable {
        let title: String
        let detail: String

        init(title: String, detail: String = "") {
            self.title = title
            self.detail = detail
        }
    }
}

/// The release history the app ships with.
///
/// Written here rather than fetched from the appcast: it has to be there on a
/// first launch with no network, and it belongs to the build it describes.
/// Bumping `MARKETING_VERSION` without adding an entry is caught by
/// `testTheCurrentVersionHasANote`.
enum ReleaseNotes {
    static let all: [ReleaseNote] = [
        ReleaseNote(version: "1.5.1", headline: "四隅にも配置できるようになりました", changes: [
            .init(title: "8か所から配置を選択", detail: "設定の「配置」から、右・左・上・下に加え、右上・右下・左上・左下を選べます。四隅では縦型で表示します。"),
            .init(title: "画面端での表示を調整", detail: "四隅ではメニューバーや Dock を避け、説明カードが収まる領域に配置します。")
        ]),
        ReleaseNote(version: "1.5.0", headline: "Codenotch 日本語版", changes: [
            .init(title: "日本語で使用量を確認", detail: "設定、メニュー、使用量、セッションの状態とリセット日時を日本語で表示します。"),
            .init(title: "本家 1.5.0 の機能を継承", detail: "Claude Code、Cursor、Codex、Antigravity、GLM、Grok、OpenCode に対応しています。"),
            .init(title: "日本語版の更新について", detail: "本家による上書きを防ぐため自動更新は無効です。設定の配布ページから日本語版の更新を確認できます。")
        ])
    ]

    static func note(for version: String) -> ReleaseNote? {
        all.first { $0.version == version }
    }

    /// The note worth showing on this launch, if there is one.
    ///
    /// `notes` is a parameter so the rule can be tested against a fixed history
    /// rather than against whatever the app happens to ship this week.
    static func unseen(in version: String,
                       lastSeen: String?,
                       notes: [ReleaseNote] = ReleaseNotes.all) -> ReleaseNote? {
        guard lastSeen != version else { return nil }
        return notes.first { $0.version == version }
    }
}
