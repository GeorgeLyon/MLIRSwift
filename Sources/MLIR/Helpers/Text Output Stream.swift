import CMLIR
import Foundation

// MARK: - Public

extension TextOutputStream {
  
  /**
   - parameter body: A block taking arguments suitable for use with MLIR printing APIs such as `mlirOperationPrint`. The callback passed to this closure is `@escaping` because the MLIR C APIs take optionals (which must be `@escaping`), but it is very much not safe for the callback to escape the body of the closure.
   */
  public mutating func write(_ body: (MlirStringCallback?, UnsafeMutableRawPointer) -> Void)
  {
    withUnsafeMutablePointer(to: &self) { targetRef in
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

// MARK: - Internal

protocol Printable: CRepresentable, TextOutputStreamable, CustomStringConvertible, CustomDebugStringConvertible {
  static var print: (CRepresentation, MlirStringCallback?, UnsafeMutableRawPointer?) -> Void { get }
}

extension Printable {
  public func write<Target: TextOutputStream>(to target: inout Target) {
    target.write { Self.print(c, $0, $1) }
  }
  public var description: String {
    "\(self)"
  }
  public var debugDescription: String {
    "\(Self.self)(\(self))"
  }
}

// MARK: - Private

/// This typealias is only needed  to allow writing `assumingMemoryBound(to: StringCallback.self)`
private typealias StringCallback = (MlirStringRef) -> Void
