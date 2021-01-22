import CMLIR
import CMLIRStandard
import MLIR

/**
  The types defined here are defined in `StandardTypes.h`, though they are _technically_ not part of the standard dialect, similar to Attributes. We chose not to promote these types to `MLIR`, because they are semantically more coupled to the standard dialect. For instance, it is reasonable for an HDL dialect to use string attributes, but they may not need types like `f32`.
 */

extension Type where MLIR: ProvidesStandardDialect {
  public static var index: Self { Self(mlirIndexTypeGet(ctx))! }

  public static var f32: Self { Self(mlirF32TypeGet(ctx))! }

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
          mlirMemRefTypeContiguousGet(element.bridgedValue, shape.count, unsafeMutable, 0))!
      }
    }
  }
}
