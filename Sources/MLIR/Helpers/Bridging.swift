
import CMLIR

/**
 This file defines the core mechanisms for bridging types from the MLIR C bindings into Swift. Whe bridging, we are mainly concerned with two things: ownership and nullability. The `BridgedStorage` mechanism provides a bottleneck for `Bridged` type initialization, allowing us to require defining an `isNull` accessor, and regusing to create a `Bridged` type if the underlying MLIR struct is indeed `NULL`.
 We leverage the same initialization bottleneck to encourage thoughtful memory management. `Bridged` types can be initailized either by taking ownership of an MLIR type, or by borrowing one owned by `MLIR`. While Swift currently has little in the way of lifetime semantics, these mechanisms make it easier for developers to reason about the lifetimes of MLIR types.
 */

// MARK: - Bridging

protocol Bridged {
  associatedtype MlirStruct: Bridgable
  associatedtype Ownership
  init(storage: Storage)
  var storage: Storage { get }
}

extension Bridged {
  var c: MlirStruct { storage.c }
}

protocol Bridgable: Equatable {
  static var areEqual: (Self, Self) -> Int32 { get }
  static var isNull: (Self) -> Int32 { get }
}

extension Bridgable {
  public static func ==(lhs: Self, rhs: Self) -> Bool {
    areEqual(lhs, rhs) != 0
  }
}

// MARK: - Ownership Semantics

/**
 `OwnedBySwift` types are not owned by an MLIR type, and are managed by Swift's reference counting mechanisms. Once the last reference to such a type goes away, the type will be destroyed.
 */
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

/**
 Signals that a type is owned by another MLIR type. Developers should take care to not access `OwnedByMLIR` types ourside of the lifetime of their owner.
 - note: The parent of an `OwnedByMLIR` type may be an `OwnedBySwift` type. This just means that the developer must ensure that at least one strong reference to the `OwnedBySwift` parent exist while they are accessing the `OwnedByMLIR` child.
 */
public struct OwnedByMLIR {
  fileprivate init() { }
}

// MARK: - Initialization

extension Bridged where Ownership == OwnedBySwift {
  
  /**
   Transfers ownership of an MLIR type to Swift. Unless `assumeOwnership` is called, this means the type will be destroyed with the last Swift reference to it.
   */
  init?(takingOwnershipOf c: MlirStruct) where MlirStruct: Destroyable {
    guard let storage = Storage(c: c, ownership: OwnedBySwift(c)) else { return nil }
    self.init(storage: storage)
  }
  
  /**
   Certain API can "consume" `OwnedBySwift` types, and transfer their ownership to MLIR. Such API **must** call `assumeOwnership` so that Swift knows not to destroy the wrapped type once there are no more references to it (which should be pretty soon, since values shouldn't be consume multiple times.
   */
  func assumeOwnership() -> MlirStruct {
    storage.ownership.didTransferOwnershipToMLIR()
    return storage.c
  }
}

extension Bridged where Ownership == OwnedByMLIR {
  
  /**
   Bridges a type without transferring ownership. Developers should care that the value is not accessed outside of the lifetime of its parent.
   */
  init?(borrowing c: MlirStruct) {
    guard let storage = Storage(c: c, ownership: OwnedByMLIR()) else { return nil }
    self.init(storage: storage)
  }
}

// MARK: - Convenience

extension Array where Element: Bridged, Element.Ownership == OwnedBySwift {
  
  /**
   Convenience method for transfering ownership of an array of values from MLIR to Swift.
   */
  func assumeOwnership() -> [Element.MlirStruct] { map { $0.assumeOwnership() } }
}

// MARK: - Implementation Details

/**
 A `Bridgable` type that can be explicitly destroyed.
 */
protocol Destroyable: Bridgable {
  static var destroy: (Self) -> () { get }
}

/**
 Opaque storage for a `Bridged` type
 */
struct BridgedStorage<Bridged: MLIR.Bridged> {
  fileprivate init?(c: Bridged.MlirStruct, ownership: Bridged.Ownership) {
    guard Bridged.MlirStruct.isNull(c) == 0 else { return nil }
    self.c = c
    self.ownership = ownership
  }
  fileprivate let c: Bridged.MlirStruct
  fileprivate let ownership: Bridged.Ownership
}

extension Bridged {
  typealias Storage = BridgedStorage<Self>
}
