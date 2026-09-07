import Foundation

/// Keep UI errors Japanese regardless of the language of a server or the host OS.
/// The original error is still recorded by UsageStore's diagnostic log.
enum JapaneseErrorCopy {
    static func text(for error: Error) -> String {
        if error is DecodingError {
            return "サービスからの応答を読み取れませんでした。"
        }
        let error = error as NSError
        if error.domain == NSURLErrorDomain {
            switch error.code {
            case NSURLErrorNotConnectedToInternet, NSURLErrorNetworkConnectionLost:
                return "ネットワークに接続できません。接続状態を確認してください。"
            case NSURLErrorTimedOut:
                return "通信がタイムアウトしました。時間をおいて再試行してください。"
            case NSURLErrorCannotFindHost, NSURLErrorCannotConnectToHost, NSURLErrorDNSLookupFailed:
                return "サービスのサーバーに接続できませんでした。"
            case NSURLErrorSecureConnectionFailed, NSURLErrorServerCertificateUntrusted,
                 NSURLErrorServerCertificateHasBadDate, NSURLErrorServerCertificateHasUnknownRoot,
                 NSURLErrorServerCertificateNotYetValid:
                return "安全な接続を確立できませんでした。"
            case NSURLErrorCancelled:
                return "通信がキャンセルされました。"
            default:
                return "通信に失敗しました（コード：\(error.code)）。"
            }
        }
        return "データの取得に失敗しました（\(error.domain)：\(error.code)）。"
    }
}
