import XCTest

#if !canImport(ObjectiveC)
func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(BehandlaTests.allTests),
    ]
}
#endif
