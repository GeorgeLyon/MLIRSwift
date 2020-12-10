
import MLIR
import MLIRStandard

enum Test:
  MLIRConfiguration,
  ProvidesStandardDialect
{
  static let dialects: RegisteredDialects = [
    .std
  ]
  static let context = Context()
}
