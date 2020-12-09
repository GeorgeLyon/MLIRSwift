
import MLIR
import MLIRStandard

enum Test:
  MLIRConfiguration,
  ProvidesStandardDialect
{
  static let dialects: RegisteredDialects = [
    .standard
  ]
  static let context = Context()
}
