import CMLIR

extension Type {
  public static func function(of inputs: [Self], to results: [Self]) -> Self {
    inputs.withUnsafeBorrowedValues { inputs in
      results.withUnsafeBorrowedValues { results in
        .borrow(
          mlirFunctionTypeGet(
            ctx, inputs.count, inputs.baseAddress, results.count, results.baseAddress))!
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
      c = mlirIntegerTypeSignedGet(ctx, UInt32(bitWidth))
    case .unsigned:
      c = mlirIntegerTypeUnsignedGet(ctx, UInt32(bitWidth))
    case .none:
      c = mlirIntegerTypeGet(ctx, UInt32(bitWidth))
    }
    return .borrow(c)!
  }

}
