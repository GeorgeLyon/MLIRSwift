
import CMLIR
import Foundation

extension Attribute: TextOutputStreamable, CustomStringConvertible, CustomDebugStringConvertible, StringCallbackStreamable {
  func print(with unsafeCallback: MlirStringCallback!, userData: UnsafeMutableRawPointer) {
    mlirAttributePrint(.borrow(self), unsafeCallback, userData)
  }
}

extension Block: TextOutputStreamable, CustomStringConvertible, CustomDebugStringConvertible, StringCallbackStreamable {
  func print(with unsafeCallback: MlirStringCallback!, userData: UnsafeMutableRawPointer) {
    mlirBlockPrint(.borrow(self), unsafeCallback, userData)
  }
}

extension Location: TextOutputStreamable, CustomStringConvertible, CustomDebugStringConvertible, StringCallbackStreamable {
  func print(with unsafeCallback: MlirStringCallback!, userData: UnsafeMutableRawPointer) {
    mlirLocationPrint(.borrow(self), unsafeCallback, userData)
  }
}

extension Operation: TextOutputStreamable, CustomStringConvertible, CustomDebugStringConvertible, StringCallbackStreamable {
  func print(with unsafeCallback: MlirStringCallback!, userData: UnsafeMutableRawPointer) {
    mlirOperationPrint(.borrow(self), unsafeCallback, userData)
  }
}

extension Type: TextOutputStreamable, CustomStringConvertible, CustomDebugStringConvertible, StringCallbackStreamable {
  func print(with unsafeCallback: MlirStringCallback!, userData: UnsafeMutableRawPointer) {
    mlirTypePrint(.borrow(self), unsafeCallback, userData)
  }
}

extension UnsafeDiagnostic: TextOutputStreamable, CustomStringConvertible, CustomDebugStringConvertible, StringCallbackStreamable {
  func print(with unsafeCallback: MlirStringCallback!, userData: UnsafeMutableRawPointer) {
    mlirDiagnosticPrint(.borrow(self), unsafeCallback, userData)
  }
}

extension Value: TextOutputStreamable, CustomStringConvertible, CustomDebugStringConvertible, StringCallbackStreamable {
  func print(with unsafeCallback: MlirStringCallback!, userData: UnsafeMutableRawPointer) {
    mlirValuePrint(.borrow(self), unsafeCallback, userData)
  }
}

// MARK: - Operation with Printing Options

public enum _OperationDebugInfoStyle: ExpressibleByNilLiteral {
  case none
  case standard
  case pretty
  
  public init(nilLiteral: ()) {
    self = .none
  }
}

public extension Operation {
  typealias DebugInfoStyle = _OperationDebugInfoStyle
  func withPrintingOptions(
    elideElementsAttributesLargerThan: Int32? = nil,
    debugInformationStyle: DebugInfoStyle = nil,
    alwaysPrintInGenericForm: Bool = false,
    useLocalScope: Bool = false) -> TextOutputStreamable & CustomStringConvertible
  {
    return OperationWithPrintingOptions(
      operation: .borrow(self),
      options: .init(
        elideElementsAttributesLargerThan: elideElementsAttributesLargerThan,
        debugInformationStyle: debugInformationStyle,
        alwaysPrintInGenericForm: alwaysPrintInGenericForm,
        useLocalScope: useLocalScope))
  }
}

private struct OperationWithPrintingOptions: TextOutputStreamable, CustomStringConvertible, StringCallbackStreamable {
  
  struct PrintingOptions {
    var elideElementsAttributesLargerThan: Int32? = nil
    var debugInformationStyle: _OperationDebugInfoStyle = nil
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
        mlirOpPrintingFlagsEnableDebugInfo(c, 0)
      case .pretty:
        mlirOpPrintingFlagsEnableDebugInfo(c, 1)
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
  
  func print(with unsafeCallback: MlirStringCallback!, userData: UnsafeMutableRawPointer) {
    options.withUnsafeMlirOpPrintingFlags { flags in
      mlirOperationPrintWithFlags(operation, flags, unsafeCallback, userData)
    }
  }
  
  fileprivate let operation: MlirOperation
  fileprivate let options: PrintingOptions
}

// MARK: - Implementation Details

/**
 This protocol bridges MLIR's callback-style printing API and Swift's `TextOutputStreamable` protocol
 */
private protocol StringCallbackStreamable: TextOutputStreamable, CustomDebugStringConvertible {
  /**
   - parameter unsafeCallback: The callback with a callback-based C printing API such as `mlirOperationPrint`. While this callback _looks_ like it is `@escaping`, it is very much not safe to have it escape the function scope.
   */
  func print(with unsafeCallback: MlirStringCallback!, userData: UnsafeMutableRawPointer)
}

extension StringCallbackStreamable {
  public func write<Target: TextOutputStream>(to target: inout Target) {
    withUnsafeMutablePointer(to: &target) { targetRef in
      let stringCallback: StringCallback = {
        targetRef.pointee.write($0.string)
      }
      withUnsafePointer(to: stringCallback) { stringCallbackRef in
        print(
          with: { mlirString, stringCallbackRef in
            stringCallbackRef!
              .assumingMemoryBound(to: StringCallback.self)
              .pointee(mlirString)
          },
          userData: UnsafeMutableRawPointer(mutating: stringCallbackRef))
      }
    }
  }
  public var description: String {
    "\(self)"
  }
  public var debugDescription: String {
    "\(Self.self)(\(self))"
  }
}

/// This typealias is only needed  to allow writing `assumingMemoryBound(to: StringCallback.self)`
private typealias StringCallback = (MlirStringRef) -> Void
