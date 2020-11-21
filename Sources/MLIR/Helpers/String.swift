
import CMLIR

extension MlirStringRef {
    var buffer: UnsafeBufferPointer<Int8> {
        UnsafeBufferPointer(start: data, count: length)
    }
    var string: String {
        buffer.withMemoryRebound(to: UInt8.self) {
            String(bytes: $0, encoding: .utf8)!
        }
    }
}
