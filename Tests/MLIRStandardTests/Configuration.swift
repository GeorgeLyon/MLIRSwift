
import MLIR
import MLIRStandard

enum Test:
  MLIRConfiguration,
  ProvidesStandardDialect
{
  static let dialects: [RegisteredDialect] = [
    .standard
  ]
  static let context = Context()
}
