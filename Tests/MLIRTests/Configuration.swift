
import MLIR

enum Test: MLIRConfiguration {
  struct DialectRegistry: MLIR.DialectRegistry {
    static let dialects: [RegisteredDialect] = []
  }
  static let context = Context()
}
