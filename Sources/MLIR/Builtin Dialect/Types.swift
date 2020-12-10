
import CMLIR

extension Type {
  public static func function(of inputs: [Self], to results: [Self]) -> Self {
    inputs.withUnsafeBorrowedValues { inputs in
      results.withUnsafeBorrowedValues { results in
        .borrow(mlirFunctionTypeGet(ctx, inputs.count, inputs.baseAddress, results.count, results.baseAddress))!
      }
    }
  }
}
