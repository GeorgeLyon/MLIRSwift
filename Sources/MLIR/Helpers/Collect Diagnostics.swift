
extension MLIRConfiguration {
  /**
   A convenience method that captures diagnostics of at least a certain severity level emitted during `body` (and stops them from being forwarded to other registered handlers).
   - parameter minimumSeverity: Diagnostics with severity lower than this value will not be collected and instead be forwarded to the existing handler chain
   */
  static func collectDiagnostics<T>(minimumSeverity: Diagnostic.Severity = .error, _ body: () -> T) -> (value: T, diagnostics: [Diagnostic]) {
    _collectDiagnostics(minimumSeverity: minimumSeverity, body)
  }
  
  static func collectDiagnostics(minimumSeverity: Diagnostic.Severity = .error, _ body: () -> Void) -> [Diagnostic] {
    _collectDiagnostics(minimumSeverity: minimumSeverity, body).diagnostics
  }
  
  private static func _collectDiagnostics<T>(minimumSeverity: Diagnostic.Severity, _ body: () -> T) -> (value: T, diagnostics: [Diagnostic]) {
    let collector = DiagnosticCollector()
    let registration = context.register(collector)
    let value = body()
    context.unregister(registration)
    return (value, collector.diagnostics)
  }
}

// MARK: - Private

private final class DiagnosticCollector: DiagnosticHandler {
  var diagnostics: [Diagnostic] = []
  func handle(_ unsafeDiagnostic: UnsafeDiagnostic) -> DiagnosticHandlingDirective {
    diagnostics.append(Diagnostic(unsafeDiagnostic))
    return .stop
  }
}

