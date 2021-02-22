import CMLIR

extension Type {
  public static func index(in context: Context) -> Self {
    Self(mlirIndexTypeGet(context.cRepresentation))!
  }
  public var isIndex: Bool { mlirTypeIsAIndex(c) }

  public static func float32(in context: Context) -> Self {
    Self(mlirF32TypeGet(context.cRepresentation))!
  }
  public var isFloat32: Bool { mlirTypeIsAF32(c) }
}

public struct IntegerType: ContextualTypeProtocol {
  public enum Signedness {
    case signed, unsigned
  }
  public let signedness: Signedness?

  public let bitWidth: Int

  public func type(in context: Context) -> Type {
    precondition(bitWidth > 0)
    let c: MlirType
    switch signedness {
    case .signed:
      c = mlirIntegerTypeSignedGet(context.cRepresentation, UInt32(bitWidth))
    case .unsigned:
      c = mlirIntegerTypeUnsignedGet(context.cRepresentation, UInt32(bitWidth))
    case .none:
      c = mlirIntegerTypeGet(context.cRepresentation, UInt32(bitWidth))
    }
    return Type(c)!
  }
}
extension ContextualType {
  public static func integer(_ signedness: IntegerType.Signedness? = nil, bitWidth: Int) -> Self {
    Self(IntegerType(signedness: signedness, bitWidth: bitWidth))
  }
}
extension Type {
  public func asIntegerType() -> IntegerType? {
    guard mlirTypeIsAInteger(c) else { return nil }
    let signedness: IntegerType.Signedness?
    if mlirIntegerTypeIsSignless(c) {
      signedness = nil
    } else if mlirIntegerTypeIsSigned(c) {
      signedness = .signed
    } else if mlirIntegerTypeIsUnsigned(c) {
      signedness = .unsigned
    } else {
      preconditionFailure()
    }
    return IntegerType(signedness: signedness, bitWidth: Int(mlirIntegerTypeGetWidth(c)))
  }
}

public struct MemoryReferenceType: ContextualTypeProtocol {
  public struct Size: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int64) {
      precondition(value >= 0)
      self.value = value
    }

    public static var dynamic: Self { Self(value: -1) }

    fileprivate let value: Int64
    private init(value: Int64) {
      self.value = value
    }
  }
  public let dimensions: [Size]
  public let element: Type

  public func type(in context: Context) -> Type {
    precondition(element.context == context)
    precondition(MemoryLayout<Int64>.size == MemoryLayout<Size>.size)
    precondition(MemoryLayout<Int64>.stride == MemoryLayout<Size>.stride)
    return dimensions.withUnsafeBufferPointer { dimensions in
      dimensions.withMemoryRebound(to: Int64.self) { dimensions in
        let unsafeMutable = UnsafeMutablePointer(mutating: dimensions.baseAddress)
        return Type(
          mlirMemRefTypeContiguousGet(element.cRepresentation, dimensions.count, unsafeMutable, 0))!
      }
    }
  }
}
extension ContextualType {
  public static func memoryReference(
    to element: `Type`, withDimensions dimensions: [MemoryReferenceType.Size]
  )
    -> Self
  {
    Self(MemoryReferenceType(dimensions: dimensions, element: element))
  }
}

public struct FunctionType: ContextualTypeProtocol {
  public let inputs, results: [Type]

  public func type(in context: Context) -> Type {
    let c: MlirType = inputs.withUnsafeCRepresentation { inputs in
      results.withUnsafeCRepresentation { results in
        mlirFunctionTypeGet(
          context.cRepresentation,
          inputs.count, inputs.baseAddress,
          results.count, results.baseAddress)
      }
    }
    return Type(c)!
  }
}
extension ContextualType {
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
    ContextualType(FunctionType(inputs: Array(inputs), results: Array(results)))
  }
}
