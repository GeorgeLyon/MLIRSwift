
import CMLIR

public extension MlirType {
  static func from<MLIR>(_ type: Type<MLIR>) -> MlirType {
    type.c
  }
  func type<MLIR>(for _: MLIR.Type = MLIR.self) -> Type<MLIR> {
    Type(c: self)
  }
}

public struct Type<MLIR> {
  fileprivate let c: MlirType
}
