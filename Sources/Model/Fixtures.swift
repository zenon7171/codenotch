import Foundation

/// The three providers from the design frame, at the levels it shows.
/// These stand in until the adapters in M4 land.
enum Fixtures {
    static func snapshots(now: Date = Date(), calendar: Calendar = .current) -> [ProviderSnapshot] {
        let sessionReset = now.addingTimeInterval(51 * 60)
        let midnight = calendar.startOfDay(for: now.addingTimeInterval(24 * 60 * 60))

        return [
            ProviderSnapshot(
                id: "claude",
                displayName: "Claude",
                glyph: .claude,
                fidelity: .derived,
                status: .ok,
                windows: [
                    LimitWindow(id: "claude.session", label: "現在のセッション",
                                usedFraction: 0.73, resetsAt: sessionReset),
                    LimitWindow(id: "claude.all", label: "すべてのモデル",
                                usedFraction: 0.07, resetsAt: midnight)
                ]
            ),
            ProviderSnapshot(
                id: "openai",
                displayName: "OpenAI",
                glyph: .openai,
                fidelity: .manual,
                status: .ok,
                windows: [
                    LimitWindow(id: "openai.session", label: "現在のセッション",
                                usedFraction: 0.21, resetsAt: now.addingTimeInterval(3 * 60 * 60))
                ]
            ),
            ProviderSnapshot(
                id: "third",
                displayName: "Perplexity",
                glyph: .third,
                fidelity: .manual,
                status: .ok,
                windows: [
                    LimitWindow(id: "third.daily", label: "1日の上限",
                                usedFraction: 0.52, resetsAt: midnight)
                ]
            )
        ]
    }
}
