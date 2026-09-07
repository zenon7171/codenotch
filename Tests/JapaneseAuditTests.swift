import XCTest
@testable import Codenotch

final class JapaneseAuditTests: XCTestCase {
    func testNetworkErrorsDoNotExposeEnglishDescriptions() {
        for code in [NSURLErrorTimedOut, NSURLErrorNotConnectedToInternet,
                     NSURLErrorCannotFindHost, NSURLErrorSecureConnectionFailed,
                     NSURLErrorCancelled, -99999] {
            let error = NSError(domain: NSURLErrorDomain, code: code,
                                userInfo: [NSLocalizedDescriptionKey: "An English network error"])
            let text = JapaneseErrorCopy.text(for: error)
            XCTAssertFalse(text.contains("English"))
            XCTAssertTrue(text.contains("通信") || text.contains("接続"))
        }
    }

    func testUnknownErrorsKeepDiagnosticIdentityWithoutEnglishProse() {
        let error = NSError(domain: "ExampleDomain", code: 42,
                            userInfo: [NSLocalizedDescriptionKey: "Something went wrong"])
        XCTAssertEqual(JapaneseErrorCopy.text(for: error),
                       "データの取得に失敗しました（ExampleDomain：42）。")
    }

    func testUnmeteredCursorPlanIsJapaneseEvenWithoutMembershipName() throws {
        let json = #"{"individualUsage":{}}"#
        XCTAssertThrowsError(try CursorUsage.windows(fromJSON: json)) { error in
            guard case UsageProviderError.nothingMetered(let message) = error else {
                return XCTFail("Unexpected error: \(error)")
            }
            XCTAssertTrue(message.contains("計測対象"))
            XCTAssertFalse(message.contains("this"))
        }
    }

    @MainActor
    func testAccountReadCannotBlockTheMainActor() async {
        let entered = expectation(description: "Background account read began")
        let gate = DispatchSemaphore(value: 0)
        let provider = BlockingAccountProvider(entered: entered, gate: gate)
        let defaults = UserDefaults(suiteName: "JapaneseAuditTests.\(UUID().uuidString)")!
        let store = UsageStore(providers: [provider], archive: UsageArchive(defaults: defaults))
        let loading = Task { await store.loadProviderSummaries() }
        // This continuation must run while account() is waiting, not after its timeout.
        await fulfillment(of: [entered], timeout: 2)
        gate.signal()
        let result = await loading.value
        XCTAssertEqual(result.first?.name, "Test")
        XCTAssertFalse(provider.didTimeOut)
        XCTAssertFalse(provider.wasOnMainThread)
    }
}

private final class BlockingAccountProvider: UsageProvider {
    let id = "test"
    let displayName = "Test"
    let glyph = ProviderGlyph.claude
    let entered: XCTestExpectation
    let gate: DispatchSemaphore
    // Written by the worker and read only after awaiting its completion.
    private(set) var didTimeOut = false
    private(set) var wasOnMainThread = false
    init(entered: XCTestExpectation, gate: DispatchSemaphore) {
        self.entered = entered
        self.gate = gate
    }
    func account() -> ProviderAccount? {
        wasOnMainThread = Thread.isMainThread
        entered.fulfill()
        didTimeOut = gate.wait(timeout: .now() + 3) == .timedOut
        return nil
    }
    func fetchSnapshot() async throws -> ProviderSnapshot { throw UsageProviderError.needsAuth }
}
