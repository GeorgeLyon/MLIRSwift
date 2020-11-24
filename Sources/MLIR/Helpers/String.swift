
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

extension String {
    func withUnsafeMlirStringRef<T>(_ body: (MlirStringRef) throws -> T) rethrows -> T {
        var string = self
        return try string.withUTF8 {
            try $0.withMemoryRebound(to: Int8.self) {
                try body(mlirStringRefCreate($0.baseAddress, $0.count))
            }
        }
    }
    
}

extension StaticString {
    func withUnsafeMlirStringRef<T>(_ body: (MlirStringRef) -> T) -> T {
        return withUTF8Buffer {
            $0.withMemoryRebound(to: Int8.self) {
                body(mlirStringRefCreate($0.baseAddress, $0.count))
            }
        }
    }
}
