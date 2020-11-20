
import CMLIR
import Foundation

protocol MlirStringCallbackStreamable: TextOutputStreamable {
    /**
     - parameter unsafeCallback: The callback with a callback-based C printing API such as `mlirOperationPrint`. While this callback _looks_ like it is `@escaping`, it is very much not safe to have it escape the function scope.
     */
    func print(with unsafeCallback: MlirStringCallback!, userData: UnsafeMutableRawPointer)
}

extension MlirStringCallbackStreamable {
    public func write<Target: TextOutputStream>(to target: inout Target) {
        withUnsafeMutablePointer(to: &target) { targetRef in
            let stringCallback = { string in
                targetRef.pointee.write(string)
            }
            withUnsafePointer(to: stringCallback) { stringCallbackRef in
                print(
                    with: { start, length, stringCallbackRef in
                        let string = String(
                            bytesNoCopy: UnsafeMutableRawPointer(mutating: start!),
                            length: length,
                            encoding: .utf8,
                            freeWhenDone: false)!
                        stringCallbackRef!
                            .assumingMemoryBound(to: StringCallback.self)
                            .pointee(string)
                    },
                    userData: UnsafeMutableRawPointer(mutating: stringCallbackRef))
            }
        }
    }
}

/// This typealias is only needed  to allow writing `assumingMemoryBound(to: StringCallback.self)`
private typealias StringCallback = (String) -> Void

