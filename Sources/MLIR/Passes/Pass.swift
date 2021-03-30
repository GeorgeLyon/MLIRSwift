import CMLIR

/**
 An MLIR pass
 */
public struct Pass {

  /**
   We use a closure rather than an `MlirPass` because passes end up owned by `PassManager`, so it is invalid to register the same pass with multiple `PassManager`s. This way, we can create the pass on `PassManager` initialization and immediately transfer ownership.
   */
  public init(createdBy builder: @escaping () -> MlirPass) {
    self.builder = builder
  }

  func build() -> MlirPass {
    builder()
  }

  /// Suppress synthesized initializer
  private init() { fatalError() }

  private let builder: () -> MlirPass
}
