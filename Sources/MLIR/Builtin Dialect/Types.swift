import CMLIR

extension Type {
  public static func function<Inputs, Results>(of inputs: Inputs, to results: Results) -> Self
  where
    Inputs: Sequence,
    Inputs.Element == Self,
    Results: Sequence,
    Results.Element == Self
  {
    Array(inputs).withUnsafeBorrowedValues { inputs in
      Array(results).withUnsafeBorrowedValues { results in
        .borrow(
          mlirFunctionTypeGet(
            MLIR.context, inputs.count, inputs.baseAddress, results.count, results.baseAddress))!
      }
    }
  }

  public enum Signedness {
    case signed, unsigned
  }
  public static func integer(_ signedness: Signedness? = nil, bitWidth: Int) -> Self {
    precondition(bitWidth > 0)
    let c: MlirType
    switch signedness {
    case .signed:
      c = mlirIntegerTypeSignedGet(MLIR.context, UInt32(bitWidth))
    case .unsigned:
      c = mlirIntegerTypeUnsignedGet(MLIR.context, UInt32(bitWidth))
    case .none:
      c = mlirIntegerTypeGet(MLIR.context, UInt32(bitWidth))
    }
    return .borrow(c)!
  }

}
