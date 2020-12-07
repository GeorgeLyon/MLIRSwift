
import CMLIR

// MARK: - Marker Types

public struct OwnedByMLIR {
  fileprivate init() { }
}

public final class OwnedBySwift {
  fileprivate init<T: Destroyable>(_ value: T) {
    destroy = { T.destroy(value) }
  }
  deinit {
    if isOwned { destroy() }
  }
  fileprivate func didTransferOwnershipToMLIR() {
    precondition(isOwned)
    isOwned = false
  }
  fileprivate var isOwned = true
  private let destroy: () -> Void
}

// MARK: - Internal API

extension OwnershipSemantics where Ownership == OwnedBySwift {
  init(takingOwnershipOf c: MlirStruct) {
    self.init(c: c, ownership: OwnedBySwift(c))
  }
  func transferOwnerhispToMLIR() -> MlirStruct {
    ownership.didTransferOwnershipToMLIR()
    return c
  }
}

// MARK: - Convenience

extension Array where Element: OwnershipSemantics, Element.Ownership == OwnedBySwift {
  func transferOwnerhispToMLIR() -> [Element.MlirStruct] { map { $0.transferOwnerhispToMLIR() } }
}

// MARK: - Implementation Details

protocol Destroyable {
  static var destroy: (Self) -> () { get }
}

protocol OwnershipSemantics: Bridged where Self.MlirStruct: Destroyable {
  associatedtype Ownership
  init(c: MlirStruct, ownership: Ownership)
  var ownership: Ownership { get }
}
