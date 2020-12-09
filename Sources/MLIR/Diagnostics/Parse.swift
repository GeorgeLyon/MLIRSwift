
import CMLIR

extension OpaqueStorageRepresentable where Self: MLIRConfigurable {
  static func parse<T: Bridged>(body: () -> Self?) throws -> Self
  where
    Storage == BridgingStorage<T, OwnedByMLIR>
  {
    let pair = MLIR.collectDiagnostics(minimumSeverity: .error) {
      body()
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
