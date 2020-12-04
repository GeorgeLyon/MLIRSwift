
import CMLIR

public extension MlirAttribute {
  static func from<MLIR>(_ attribute: Attribute<MLIR>) -> MlirAttribute {
    attribute.c
  }
  func attribute<MLIR>(for _: MLIR.Type = MLIR.self) -> Attribute<MLIR> {
    Attribute(c: self)
  }
}

public struct Attribute<MLIR> {
  fileprivate let c: MlirAttribute
}
