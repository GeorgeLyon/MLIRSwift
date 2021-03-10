extension Context {
  /**
   This method captures diagnostics of at least a certain severity level emitted during `body` (and stops them from being forwarded to other registered handlers).
   - parameter minimumSeverity: Diagnostics with severity lower than this value will not be collected and instead be forwarded to the existing handler chain
   */
  public func collectDiagnostics<T>(
    minimumSeverity: Diagnostic.Severity = .remark, _ body: () -> T
  ) -> (value: T, diagnostics: [Diagnostic]) {
    _collectDiagnostics(minimumSeverity: minimumSeverity, body)
  }

  /**
   This method captures diagnostics of at least a certain severity level emitted during `body` (and stops them from being forwarded to other registered handlers).
   - parameter minimumSeverity: Diagnostics with severity lower than this value will not be collected and instead be forwarded to the existing handler chain
   */
  public func collectDiagnostics(
    minimumSeverity: Diagnostic.Severity = .remark, _ body: () -> Void
  ) -> [Diagnostic] {
    _collectDiagnostics(minimumSeverity: minimumSeverity, body).diagnostics
  }

  private func _collectDiagnostics<T>(minimumSeverity: Diagnostic.Severity, _ body: () -> T)
    -> (value: T, diagnostics: [Diagnostic])
  {
    let collector = DiagnosticCollector(minimumSeverity: minimumSeverity)
    let registration = register(collector)
    let value = body()
    unregister(registration)
    return (value, collector.diagnostics)
  }
}

// MARK: - Private

private final class DiagnosticCollector: DiagnosticHandler {
  init(minimumSeverity: Diagnostic.Severity) {
    self.minimumSeverity = minimumSeverity
  }
  let minimumSeverity: Diagnostic.Severity
  var diagnostics: [Diagnostic] = []
  func handle(_ unsafeDiagnostic: UnsafeDiagnostic) -> DiagnosticHandlingDirective {
    guard unsafeDiagnostic.severity >= minimumSeverity else { return .continue }
    diagnostics.append(Diagnostic(unsafeDiagnostic))
    return .stop
  }
}
