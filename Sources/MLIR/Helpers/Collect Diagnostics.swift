
extension MLIRConfiguration {
    /**
     A convenience method that captures diagnostics of at least a certain severity level emitted during `body` (and stops them from being forwarded to other registered handlers).
     - parameter minimumSeverity: Diagnostics with severity lower than this value will not be collected and instead be forwarded to the existing handler chain
     */
    static func collectDiagnostics<T>(minimumSeverity: Diagnostic.Severity = .error, _ body: () -> T) -> (value: T, diagnostics: [Diagnostic]) {
        let collector = DiagnosticCollector()
        let registration = context.register(collector)
        let value = body()
        context.unregister(registration)
        return (value, collector.diagnostics)
    }
}

// MARK: - Private

private final class DiagnosticCollector: DiagnosticsHandler {
    var diagnostics: [Diagnostic] = []
    func handle(_ diagnostic: Diagnostic) -> DiagnosticHandlingDirective {
        diagnostics.append(diagnostic)
        return .stop
    }
}

