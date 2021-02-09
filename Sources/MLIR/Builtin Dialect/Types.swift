import CMLIR

extension Type {
  public static func function<Inputs, Results>(
    of inputs: Inputs,
    to results: Results,
    in context: Context) -> Self
  where
    Inputs: Sequence,
    Inputs.Element == Self,
    Results: Sequence,
    Results.Element == Self
  {
    let c: MlirType =  Array(inputs).withUnsafeCRepresentation { inputs in
      Array(results).withUnsafeCRepresentation { results in
        mlirFunctionTypeGet(
          context.cRepresentation,
          inputs.count, inputs.baseAddress,
          results.count, results.baseAddress)
      }
    }
    return Self(c: c)!
  }

  public enum Signedness {
    case signed, unsigned
  }
  public static func integer(_ signedness: Signedness? = nil, bitWidth: Int, in context: Context) -> Self {
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

}
