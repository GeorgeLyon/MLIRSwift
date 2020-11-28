
import CCoreMLIR
import Foundation

/**
 This protocol bridges MLIR's callback-style printing API and Swifts `TextOutputStreamable` protocol
 */
protocol MlirStringCallbackStreamable: TextOutputStreamable, CustomDebugStringConvertible {
  /**
   - parameter unsafeCallback: The callback with a callback-based C printing API such as `mlirOperationPrint`. While this callback _looks_ like it is `@escaping`, it is very much not safe to have it escape the function scope.
   */
  func print(with unsafeCallback: MlirStringCallback!, userData: UnsafeMutableRawPointer)
}

extension MlirStringCallbackStreamable {
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
  public var debugDescription: String {
    "\(Self.self)(\(self))"
  }
}

/// This typealias is only needed  to allow writing `assumingMemoryBound(to: StringCallback.self)`
private typealias StringCallback = (MlirStringRef) -> Void

