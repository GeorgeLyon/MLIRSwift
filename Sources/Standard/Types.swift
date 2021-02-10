import CMLIR
import CStandard
import MLIR

extension Type {
  public static func index(in context: Context) -> Self {
    Self(mlirIndexTypeGet(context.cRepresentation))!
  }
  public static func float32(in context: Context) -> Self {
    Self(mlirF32TypeGet(context.cRepresentation))!
  }

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
        return Self(
          mlirMemRefTypeContiguousGet(element.cRepresentation, shape.count, unsafeMutable, 0))!
      }
    }
  }
}
