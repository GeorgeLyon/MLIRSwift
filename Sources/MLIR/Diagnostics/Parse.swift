
import CMLIR

extension OpaqueStorageRepresentable where Self: MLIRConfigurable {
  static func parse<T: Bridged, Ownership: MLIR.Ownership>(
    _ bridge: (T) -> Self?,
    _ body: (MlirContext, MlirStringRef) -> T,
    _ source: String) throws -> Self
  where
    Storage == BridgingStorage<T, Ownership>
  {
    let pair = MLIR.collectDiagnostics(minimumSeverity: .error) {
      source.withUnsafeMlirStringRef { bridge(body(MLIR.ctx, $0)) }
    }
    guard pair.diagnostics.isEmpty else {
      throw ParsingError(diagnostics: pair.diagnostics)
    }
    guard let value = pair.value else {
      throw ParsingError(diagnostics: [])
    }
    return value
  }
}

struct ParsingError: Swift.Error {
  let diagnostics: [Diagnostic]
}
