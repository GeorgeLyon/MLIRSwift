import CMLIR

extension Operation: Printable {

  static let print = mlirOperationPrint

  public enum DebugInfoStyle: ExpressibleByNilLiteral {
    case none
    case standard
    case pretty

    public init(nilLiteral: ()) {
      self = .none
    }
  }

  public func withPrintingOptions(
    elideElementsAttributesLargerThan: Bool? = nil,
    debugInformationStyle: DebugInfoStyle = nil,
    alwaysPrintInGenericForm: Bool = false,
    useLocalScope: Bool = false
  ) -> TextOutputStreamable & CustomStringConvertible {
    return OperationWithPrintingOptions(
      operation: self,
      options: .init(
        elideElementsAttributesLargerThan: elideElementsAttributesLargerThan,
        debugInformationStyle: debugInformationStyle,
        alwaysPrintInGenericForm: alwaysPrintInGenericForm,
        useLocalScope: useLocalScope))
  }
}

private struct OperationWithPrintingOptions: TextOutputStreamable, CustomStringConvertible {

  struct PrintingOptions {
    var elideElementsAttributesLargerThan: Bool? = nil
    var debugInformationStyle: Operation.DebugInfoStyle = nil
    var alwaysPrintInGenericForm: Bool = false
    var useLocalScope: Bool = false

    func withUnsafeMlirOpPrintingFlags(_ body: (MlirOpPrintingFlags) -> Void) {
      let c = mlirOpPrintingFlagsCreate()
      if let value = elideElementsAttributesLargerThan {
        mlirOpPrintingFlagsEnableDebugInfo(c, value)
      }
      switch debugInformationStyle {
      case .none:
        break
      case .standard:
        mlirOpPrintingFlagsEnableDebugInfo(c, false)
      case .pretty:
        mlirOpPrintingFlagsEnableDebugInfo(c, true)
      }
      if alwaysPrintInGenericForm {
        mlirOpPrintingFlagsPrintGenericOpForm(c)
      }
      if useLocalScope {
        mlirOpPrintingFlagsUseLocalScope(c)
      }
      body(c)
      mlirOpPrintingFlagsDestroy(c)
    }
  }

  func write<Target: TextOutputStream>(to target: inout Target) {
    options.withUnsafeMlirOpPrintingFlags { flags in
      target.write { mlirOperationPrintWithFlags(operation.c, flags, $0, $1) }
    }
  }
  var description: String {
    "\(self)"
  }

  fileprivate let operation: Operation
  fileprivate let options: PrintingOptions
}
