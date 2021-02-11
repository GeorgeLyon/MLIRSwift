import XCTest
import MLIR

import CMLIR

final class DiagnosticTests: XCTestCase {
  func testDiagnosticSeverity() {
    XCTAssertGreaterThan(Diagnostic.Severity.error, Diagnostic.Severity.warning)
    XCTAssertGreaterThan(Diagnostic.Severity.warning, Diagnostic.Severity.note)
    XCTAssertGreaterThan(Diagnostic.Severity.note, Diagnostic.Severity.remark)
    XCTAssertLessThan(Diagnostic.Severity.warning, Diagnostic.Severity.error)
    XCTAssertLessThan(Diagnostic.Severity.note, Diagnostic.Severity.warning)
    XCTAssertLessThan(Diagnostic.Severity.remark, Diagnostic.Severity.note)
  }
  func testDiagnosticHandling() {
    let context = MLIR.Context()
    defer { context.destroy() }
    let message = "Test Diagnostic"
    let diagnostics = context.collectDiagnostics {
      message.withCString {
        mlirEmitError(mlirLocationUnknownGet(context.cRepresentation), $0)
      }
    }
    XCTAssertEqual(diagnostics.count, 1)
    let diagnostic = diagnostics[0]
    XCTAssertEqual(diagnostic.severity, .error)
    XCTAssertEqual(diagnostic.message, message)
  }
}
