import CMLIR
import CMLIRStandard
import MLIR

extension Type {
  public static var index: Self { MLIR.bridge(mlirIndexTypeGet(MLIR.context))! }

  public static var f32: Self { MLIR.bridge(mlirF32TypeGet(MLIR.context))! }

  public struct MemRefSize: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int64) {
      precondition(value >= 0)
      self.value = value
    }

    static var dynamic: Self { Self(value: -1) }

    fileprivate let value: Int64
    private init(value: Int64) {
      self.value = value
    }
  }
  public static func memref(shape: [MemRefSize], element: `Type`) -> Self {
    precondition(MemoryLayout<Int64>.size == MemoryLayout<MemRefSize>.size)
    precondition(MemoryLayout<Int64>.stride == MemoryLayout<MemRefSize>.stride)
    return shape.withUnsafeBufferPointer { shape in
      shape.withMemoryRebound(to: Int64.self) { shape in
        let unsafeMutable = UnsafeMutablePointer(mutating: shape.baseAddress)
        return MLIR.bridge(
          mlirMemRefTypeContiguousGet(MLIR.bridge(element), shape.count, unsafeMutable, 0))!
      }
    }
  }
}
