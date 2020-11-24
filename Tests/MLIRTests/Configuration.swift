
import MLIR

enum Test:
    MLIRConfiguration,
    ProvidesStandardDialect
{
    static let context = Context(dialects: [.standard])
}
