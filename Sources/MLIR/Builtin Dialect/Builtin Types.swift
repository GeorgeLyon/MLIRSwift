import CMLIR

// MARK: - Index

public struct IndexType: ContextualType {
  public func `in`(_ context: Context) -> Type {
    Type(mlirIndexTypeGet(context.mlir))
  }
}
extension ContextualType where Self == IndexType {
  public static var index: IndexType { IndexType() }
}
extension Type {
  public var isIndex: Bool { mlirTypeIsAIndex(mlir) }
}

// MARK: - Float

public struct Float32Type: ContextualType {
  public func `in`(_ context: Context) -> Type {
    Type(mlirF32TypeGet(context.mlir))
  }
}
extension ContextualType where Self == Float32Type {
  public static var float32: Float32Type { Float32Type() }
}
extension Type {
  public var isFloat32: Bool { mlirTypeIsAF32(mlir) }
}

// MARK: - Integer

public struct IntegerType: ContextualType {

  public enum Signedness {
    case signed, unsigned
  }
  public let signedness: Signedness?

  public let bitWidth: Int

  public func `in`(_ context: Context) -> Type {
    precondition(bitWidth > 0)
    let c: MlirType
    switch signedness {
    case .signed:
      c = mlirIntegerTypeSignedGet(context.mlir, UInt32(bitWidth))
    case .unsigned:
      c = mlirIntegerTypeUnsignedGet(context.mlir, UInt32(bitWidth))
    case .none:
      c = mlirIntegerTypeGet(context.mlir, UInt32(bitWidth))
    }
    return Type(c)
  }
}
extension ContextualType where Self == IntegerType {
  public static func integer(_ signedness: IntegerType.Signedness? = nil, bitWidth: Int)
    -> IntegerType
  {
    IntegerType(signedness: signedness, bitWidth: bitWidth)
  }
}
extension Type {
  public func asIntegerType() -> IntegerType? {
    guard mlirTypeIsAInteger(mlir) else { return nil }
    let signedness: IntegerType.Signedness?
    if mlirIntegerTypeIsSignless(mlir) {
      signedness = nil
    } else if mlirIntegerTypeIsSigned(mlir) {
      signedness = .signed
    } else if mlirIntegerTypeIsUnsigned(mlir) {
      signedness = .unsigned
    } else {
      preconditionFailure()
    }
    return IntegerType(signedness: signedness, bitWidth: Int(mlirIntegerTypeGetWidth(mlir)))
  }
}

// MARK: - Memory Reference

public struct MemoryReferenceType: ContextualType {

  public struct Size: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int64) {
      precondition(value >= 0)
      self.value = value
    }

    public static var dynamic: Self { Self(value: -1) }

    fileprivate let value: Int64
    fileprivate init(value: Int64) {
      self.value = value
    }
  }
  public let dimensions: [Size]
  public let element: Type

  public func `in`(_ context: Context) -> Type {
    precondition(element.context == context)
    precondition(MemoryLayout<Int64>.size == MemoryLayout<Size>.size)
    precondition(MemoryLayout<Int64>.stride == MemoryLayout<Size>.stride)
    return dimensions.withUnsafeBufferPointer { dimensions in
      dimensions.withMemoryRebound(to: Int64.self) { dimensions in
        let unsafeMutable = UnsafeMutablePointer(mutating: dimensions.baseAddress)
        return Type(
          mlirMemRefTypeContiguousGet(
            element.mlir,
            dimensions.count,
            unsafeMutable,
            0))
      }
    }
  }
}
extension ContextualType where Self == MemoryReferenceType {
  public static func memoryReference(
    to element: `Type`, withDimensions dimensions: [MemoryReferenceType.Size]
  )
    -> Self
  {
    MemoryReferenceType(dimensions: dimensions, element: element)
  }
}

// MARK: - Function

public struct FunctionType: ContextualType {
  public let inputs, results: [ContextualType]

  public func `in`(_ context: Context) -> Type {
    let c: MlirType =
      inputs
      .map { $0.in(context) }
      .withUnsafeMlirRepresentation { inputs in
        results
          .map { $0.in(context) }
          .withUnsafeMlirRepresentation { results in
            mlirFunctionTypeGet(
              context.mlir,
              inputs.count, inputs.baseAddress,
              results.count, results.baseAddress)
          }
      }
    return Type(c)
  }
}
extension ContextualType where Self == FunctionType {
  public static func function<Inputs, Results>(
    of inputs: Inputs,
    to results: Results
  ) -> Self
  where
    Inputs: Sequence,
    Inputs.Element == Type,
    Results: Sequence,
    Results.Element == Type
  {
    FunctionType(inputs: Array(inputs), results: Array(results))
  }
}
