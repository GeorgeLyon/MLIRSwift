import CMLIR
import Foundation

// MARK: - Public

extension TextOutputStream {

  /**
   Writes to `self` using MLIR-style string callbacks

   - parameter body: A block taking arguments suitable for use with MLIR printing APIs such as `mlirOperationPrint`. The callback passed to this closure is `@escaping` because the MLIR C APIs take optionals (which must be `@escaping`), but it is very much not safe for the callback to escape the body of the closure.
   */
  public mutating func write(_ body: (MlirStringCallback?, UnsafeMutableRawPointer) -> Void) {
    withUnsafeMutablePointer(to: &self) { targetRef in
      typealias StringCallback = (MlirStringRef) -> Void
      let stringCallback: StringCallback = {
        targetRef.pointee.write($0.string)
      }
      withUnsafePointer(to: stringCallback) { stringCallbackRef in
        body(
          // callback
          { mlirString, stringCallbackRef in
            stringCallbackRef!
              .assumingMemoryBound(to: StringCallback.self)
              .pointee(mlirString)
          },
          // userData
          UnsafeMutableRawPointer(mutating: stringCallbackRef))
      }
    }
  }
}

// MARK: - Printing

protocol Printable: TextOutputStreamable, CustomStringConvertible, CustomDebugStringConvertible {
  associatedtype MlirRepresentation
  var mlir: MlirRepresentation { get }
  static var print: PrintCallback { get }
}

extension Printable {
  public func write<Target: TextOutputStream>(to target: inout Target) {
    target.write { Self.print(mlir, $0, $1) }
  }
  public var description: String {
    "\(self)"
  }
  public var debugDescription: String {
    "\(Self.self)(\(self))"
  }

  typealias PrintCallback = (MlirRepresentation, MlirStringCallback?, UnsafeMutableRawPointer?) ->
    Void
}

extension Attribute: Printable {
  static let print = mlirAttributePrint
}
//extension Location: Printable {
//  static let print = mlirLocationPrint
//}
extension Operation: Printable {
  static var print: PrintCallback { mlirOperationPrint }
}
extension Type: Printable {
  static let print = mlirTypePrint
}
extension Value: Printable {
  static let print = mlirValuePrint
}
extension UnsafeDiagnostic: Printable {
  static let print = mlirDiagnosticPrint
}
