import XCTest
@testable import MLIR

final class DiagnosticTests: XCTestCase {
    func testDiagnosticSeverity() {
        XCTAssertGreaterThan(Diagnostic.Severity.error, Diagnostic.Severity.warning)
        XCTAssertGreaterThan(Diagnostic.Severity.warning, Diagnostic.Severity.note)
        XCTAssertGreaterThan(Diagnostic.Severity.note, Diagnostic.Severity.remark)
        XCTAssertLessThan(Diagnostic.Severity.warning, Diagnostic.Severity.error)
        XCTAssertLessThan(Diagnostic.Severity.note, Diagnostic.Severity.warning)
        XCTAssertLessThan(Diagnostic.Severity.remark, Diagnostic.Severity.note)
    }
}
