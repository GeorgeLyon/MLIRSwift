
import Foundation

extension MlirStructWrapper where Self: MLIRConfigurable {
  /**
   Initialize a type by wrapping parsing API (like `mlirTypeParseGet`)
   - parameter isNull: the C API for checking whether a value of this type is null (for instance, `mlirTypeIsNull`)
   - throws: If any error diagnostics are emitted during `parse`
   */
  init(isNull: (MlirStruct) -> Int32, parse: () -> MlirStruct) throws {
    let (c, diagnostics) = MLIR.collectDiagnostics(minimumSeverity: .error, parse)
    guard diagnostics.isEmpty else {
      throw ParsingError(diagnostics: diagnostics)
    }
    guard isNull(c) == 0 else {
      throw ParsingError(diagnostics: [])
    }
    self.init(c: c)
  }
}

struct ParsingError: Swift.Error {
  let diagnostics: [Diagnostic]
}
