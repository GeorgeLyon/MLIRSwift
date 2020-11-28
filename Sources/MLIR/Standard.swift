
import CMLIR
import CoreMLIR

public extension Dialect {
  static let standard = Dialect(
    register: mlirContextRegisterStandardDialect,
    load: mlirContextLoadStandardDialect,
    getNamespace: mlirStandardDialectGetNamespace)
}

/**
 This is a marker protocol which indicates that an `MLIRConfiguration` provides the `.standard` dialect via its `context`. The compiler does not enforce this, and it is the responsibility of the conforming type to uphold this invariant.
 */
public protocol ProvidesStandardDialect: MLIRConfiguration {
  
}

public extension Type where MLIR: ProvidesStandardDialect {
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
        Self(c: mlirMemRefTypeContiguousGet(element.c, shape.count, shape.baseAddress, 0))
      }
    }
  }
}
