
import CMLIRStandard
import MLIR

/**
 This is a marker protocol which indicates that an `MLIRConfiguration` provides the `standard` dialect via its `context`. The compiler does not enforce this, and it is the responsibility of the conforming type to uphold this invariant.
 */
public protocol ProvidesStandardDialect: MLIRConfiguration {
  
}

public extension MLIRConfiguration where Self: ProvidesStandardDialect {
  static var standard: Dialect {
    Dialect(
      register: mlirContextRegisterStandardDialect,
      load: mlirContextLoadStandardDialect,
      getNamespace: mlirStandardDialectGetNamespace)
  }
}



public extension Type where MLIR: ProvidesStandardDialect {
  static var index: Self { Self(c: mlirIndexTypeGet(MLIR.context.c)) }
  
  static var f32: Self { Self(c: mlirF32TypeGet(MLIR.context.c)) }
  
  struct MemRefSize: ExpressibleByIntegerLiteral {
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
  static func memRef(shape: [MemRefSize], element: `Type`) -> Self {
    precondition(MemoryLayout<Int64>.size == MemoryLayout<MemRefSize>.size)
    precondition(MemoryLayout<Int64>.stride == MemoryLayout<MemRefSize>.stride)
    return shape.withUnsafeBufferPointer { shape in
      shape.withMemoryRebound(to: Int64.self) { shape in
        let unsafeMutable = UnsafeMutablePointer(mutating: shape.baseAddress)
        return Self(c: mlirMemRefTypeContiguousGet(element.c, shape.count, unsafeMutable, 0))
      }
    }
  }
}

public enum Index<MLIR: ProvidesStandardDialect>: TypeClass {
  public static var type: Type<MLIR> { .index }
}

public enum F32<MLIR: ProvidesStandardDialect>: TypeClass {
  public static var type: Type<MLIR> { .f32 }
}
