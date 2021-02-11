
import CMLIR

extension Pass {
  public static let canonicalization = Pass(mlirCreateTransformsCanonicalizer())
}
