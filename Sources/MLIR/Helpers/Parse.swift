
import Foundation

extension MlirStructWrapper where Self: MLIRConfigurable {
    /**
     A convenience method for parsing-type operations that collects diagnostics and throws if any exceed a minimum severity.
     */
    init(isNull: (MlirStruct) -> Int32, parse: () -> MlirStruct) throws {
        let (c, diagnostics) = MLIR.collectDiagnostics(minimumSeverity: .error, parse)
        guard diagnostics.isEmpty else {
            throw ParsingError(diagnostics: diagnostics)
        }
        guard !isNull(c).boolValue else {
            throw ParsingError(diagnostics: [])
        }
        self.init(c: c)
    }
}

struct ParsingError: Swift.Error {
    let diagnostics: [Diagnostic]
}
