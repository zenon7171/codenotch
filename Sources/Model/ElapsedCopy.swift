import Foundation

/// "how long has it been like this" — the second half of answering "is Claude
/// still working".
enum ElapsedCopy {
    /// The same span, phrased as a point in the past.
    static func ago(since: Date, now: Date = Date()) -> String {
        let elapsed = text(since: since, now: now)
        return elapsed == "たった今" ? elapsed : "\(elapsed)前"
    }

    static func text(since: Date, now: Date = Date()) -> String {
        let seconds = max(0, now.timeIntervalSince(since))
        if seconds < 45 { return "たった今" }

        let minutes = Int((seconds / 60).rounded())
        if minutes < 60 { return "\(max(1, minutes))分" }

        let hours = minutes / 60
        let rest = minutes % 60
        if rest == 0 { return "\(hours)時間" }
        return "\(hours)時間\(rest)分"
    }
}
