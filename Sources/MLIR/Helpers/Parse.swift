
import Foundation

extension MLIRConfiguration {
    /**
     A convenience method for parsing-type operations that collects diagnostics and throws if any exceed a minimum severity.
     */
    static func parse<T>(minimumSeverity: Diagnostic.Severity = .error, body: () -> T) throws -> T {
        let (value, diagnostics) = collectDiagnostics(minimumSeverity: minimumSeverity, body)
        guard diagnostics.isEmpty else {
            throw ParsingError(diagnostics: diagnostics)
        }
        return value
    }
}

struct ParsingError: Swift.Error {
    let diagnostics: [Diagnostic]
}
