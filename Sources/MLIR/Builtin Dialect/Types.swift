import CMLIR

extension Type {

  public static func index(in context: Context) -> Self {
    Self(mlirIndexTypeGet(context.cRepresentation))!
  }
  public static func float32(in context: Context) -> Self {
    Self(mlirF32TypeGet(context.cRepresentation))!
  }

  public enum Signedness {
    case signed, unsigned
  }
  public static func integer(_ signedness: Signedness? = nil, bitWidth: Int, in context: Context)
    -> Self
  {
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
    return Self(c: c)!
  }

  public struct MemRefSize: ExpressibleByIntegerLiteral {
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
  public static func memoryReference(to element: `Type`, withDimensions dimensions: [MemRefSize])
    -> Self
  {
    precondition(MemoryLayout<Int64>.size == MemoryLayout<MemRefSize>.size)
    precondition(MemoryLayout<Int64>.stride == MemoryLayout<MemRefSize>.stride)
    return dimensions.withUnsafeBufferPointer { dimensions in
      dimensions.withMemoryRebound(to: Int64.self) { dimensions in
        let unsafeMutable = UnsafeMutablePointer(mutating: dimensions.baseAddress)
        return Self(
          mlirMemRefTypeContiguousGet(element.cRepresentation, dimensions.count, unsafeMutable, 0))!
      }
    }
  }

  public static func function<Inputs, Results>(
    of inputs: Inputs,
    to results: Results,
    in context: Context
  ) -> Self
  where
    Inputs: Sequence,
    Inputs.Element == Self,
    Results: Sequence,
    Results.Element == Self
  {
    let c: MlirType = Array(inputs).withUnsafeCRepresentation { inputs in
      Array(results).withUnsafeCRepresentation { results in
        mlirFunctionTypeGet(
          context.cRepresentation,
          inputs.count, inputs.baseAddress,
          results.count, results.baseAddress)
      }
    }
    return Self(c: c)!
  }
}
