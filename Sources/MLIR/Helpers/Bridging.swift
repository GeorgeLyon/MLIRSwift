
import CMLIR

/**
 This file defines the basic semantics for bridging types from the MLIR C bindings to Swift.
 When bridging, we are mainly concerned with two things: ownership and nullability. In the C bindings, a type may be semantically null, but this is not expressed as a null value, instead relying on a helper method like `mlirTypeIsNull`. When bridged to a Swift representation, we enforce that a type has been checked to be non-null. As such, the bridging APIs will return optionals when bridging from C to Swift.
 An value in the MLIR C bindings may also be owned either by a different MLIR value, or by "the user", meaning it expects to have a destructor called on it (such as `mlirOperationDestory`) or it will leak. Swift has automatic memory management, and we model this by enforcing that the Swift representation has clear ownership (either `OwnedBySwift` or `OwnedByMLIR`), and providing API to transition between ownership types.
 
 - note: Not all types are bridged using these mechanisms. Specifcally, simple types like `Location` and `UnsafeDiagnostic` are bridged directly, since they don't require or benefit from ownership semantics or nullability checking.
 - note: Historically, this is the third attempt at modelling ownership in Swift that we've explored. First, we tried to disallow types to be owned by Swift and only create builder functions where all types would end up owned by MLIR once the function returned. This proved to be too limiting, so we tried introducing an `Owned<T>` which would manage owned-by-Swift types. This resulted in some awkwardness deining initializers (since they would need to be extensions on `Owned` if we were to disallow the creation of not-owned values) and didn't allow us to enforce that values aren't accessed after ownership is transferred (since the inner T could have been arbitrarily copied out). `Owned`. By moving the `Owned` mechanisms _into_ the Swift representations of bridged types, we were able to solve these issues. As an added bonus, it will make it easier to move to lifetime semantics once those are implemented in Swift, since most use sites of types that are generic over `Ownership` should be able to infer the specific ownership from the context (and thus just write `Block` instead of `Owned<Block>` or `Block<OwnedBySwift>`, which I expect is closer what the code would look like with lifetime semantics.
 */

// MARK: - Bridged Types

/**
 An MLIR C type which is bridged into Swift.
 
 - note: This protocol does not specify a `SwiftRepresentation`. This is because MLIR C types can be bridged to different Swift types based on ownership semantics. For instance `MlirOperation` can be bridged to `Operation<OwnedBySwift>` or `Operation<OwnedByMLIR>`
 */
protocol Bridged {
  
  /**
   Initialization to/from opaque pointers
   */
  associatedtype Pointer
  init(ptr: Pointer!)
  var ptr: Pointer! { get }
  init(pointer: OpaquePointer)
  var pointer: OpaquePointer { get }
  
  /**
   We use this forumlation rather than a refinement protocol because we want to be able to express non-nullable types, and one cannot write `T != Nullable` in a `where` clause, but one can write `IsNull == Void`.
   */
  associatedtype IsNull = Void
  static var isNull: IsNull { get }
}

extension Bridged where IsNull == Void {
  static var isNull: Void { () }
}

extension Bridged where Pointer == UnsafeRawPointer {
  init(pointer: OpaquePointer) {
    self.init(ptr: UnsafeRawPointer(pointer))
  }
  var pointer: OpaquePointer { OpaquePointer(ptr) }
}

extension Bridged where Pointer == UnsafeMutableRawPointer {
  init(pointer: OpaquePointer) {
    self.init(ptr: UnsafeMutableRawPointer(pointer))
  }
  var pointer: OpaquePointer { OpaquePointer(ptr) }
}

// MARK: - Ownership

/**
 `Ownership` is a marker protocol which specifies that a generic argument is either `OwnedBySwift` or `OwnedByMLIR`. No other types should conform to this protocol.
 */
public protocol Ownership { }

/**
 `OwnedBySwift` types are not owned by an MLIR type, and are managed by Swift's reference counting mechanisms. Once the last reference to such a type goes away, the type will be destroyed.
 
 - note: Creating arrays of `OwnedBySwift` types and immediately transferring ownership to MLIR _should_ optimize away the object allocations (https://swift.godbolt.org/z/xbczfc).
 */
public final class OwnedBySwift: Ownership {
  fileprivate init?<T: Destroyable>(_ value: T) where T.IsNull == (T) -> Int32 {
    guard !value.isNull else { return nil }
    pointer = value.pointer
    destroy = { T.destroy(T(pointer: $0)) }
  }
  deinit {
    if isOwned { destroy(pointer) }
  }
  fileprivate func value<T: Bridged>(of type: T.Type = T.self) -> T {
    precondition(isOwned)
    return T(pointer: pointer)
  }
  fileprivate func didTransferOwnershipToMLIR() {
    precondition(isOwned)
    isOwned = false
  }
  private var isOwned = true
  private let pointer: OpaquePointer
  private let destroy: (OpaquePointer) -> Void
}

/**
 Signals that a type is owned by another MLIR type. Developers should take care to not access `OwnedByMLIR` types ourside of the lifetime of their owner.
 - note: The parent of an `OwnedByMLIR` type may be an `OwnedBySwift` type. This just means that the developer must ensure that at least one strong reference to the `OwnedBySwift` parent exist while they are accessing the `OwnedByMLIR` child.
 */
public struct OwnedByMLIR: Ownership {
  fileprivate init?<T: Bridged>(_ value: T) where T.IsNull == (T) -> Int32 {
    guard !value.isNull else { return nil }
    pointer = value.pointer
  }
  fileprivate init<T: Bridged>(_ value: T) where T.IsNull == Void {
    pointer = value.pointer
  }
  fileprivate func value<T: Bridged>(of type: T.Type = T.self) -> T {
    T(pointer: pointer)
  }
  private let pointer: OpaquePointer
}

// MARK: - Bridging

extension Bridged where Self: Destroyable {

  /**
   Transfers ownership from the Swift representation of an MLIR type back to MLIR.
   Subsequent accesses to `swiftRepresentation.bridged()` will crash.
   */
  static func assumeOwnership<T>(of swiftRepresentation: T) -> Self
  where
    T: OpaqueStorageRepresentable,
    T.Storage == BridgingStorage<Self, OwnedBySwift>
  {
    let ownership = swiftRepresentation.storage.ownership
    let value = ownership.value(of: Self.self)
    ownership.didTransferOwnershipToMLIR()
    return value
  }
  
}

extension OpaqueStorageRepresentable {
  
  /**
   Transfers ownership of an MLIR type to Swift.
   - returns: Either a value which will be destroy `self` when there are no more strong references to it left, or `nil` if the `self` is semantically null.
   */
  static func assumeOwnership<T: Bridged & Destroyable>(of value: T) -> Self?
  where
    Storage == BridgingStorage<T, OwnedBySwift>,
    T.IsNull == (T) -> Int32
  {
    OwnedBySwift(value).map(BridgingStorage.init).map(Self.init)
  }
  
  /**
   Bridges a type without transferring ownership.
   It is the caller's responsibility to either ensure the returned value is not accessed outside of the lifetime of its parent, or to document this invariant in its own API.
   - returns: Either a value which will never destroy `self`, or `nil` if `self` is semantically null.
   */
  static func borrow<T: Bridged>(_ value: T) -> Self?
  where
    Storage == BridgingStorage<T, OwnedByMLIR>,
    T.IsNull == (T) -> Int32
  {
    OwnedByMLIR(value).map(BridgingStorage.init).map(Self.init)
  }
  
  /**
   Bridges a type without transferring ownership.
   It is the caller's responsibility to either ensure the returned value is not accessed outside of the lifetime of its parent, or to document this invariant in its own API.
   - returns: A value which will never destroy `self`
   */
  static func borrow<T: Bridged>(_ value: T) -> Self
  where
    Storage == BridgingStorage<T, OwnedByMLIR>,
    T.IsNull == Void
  {
    Self(storage: BridgingStorage(OwnedByMLIR(value)))
  }
  
  func borrowedValue<T: Bridged, Ownership: MLIR.Ownership>() -> T
    where Storage == BridgingStorage<T, Ownership>
  {
    if Ownership.self == OwnedByMLIR.self {
      return (storage.ownership as! OwnedByMLIR).value()
    } else if Ownership.self == OwnedBySwift.self {
      return (storage.ownership as! OwnedBySwift).value()
    } else {
      preconditionFailure()
    }
  }
}

// MARK: - Convenience

extension Bridged where IsNull == (Self) -> Int32 {
  var isNull: Bool {
    Self.isNull(self) != 0
  }
}

/**
 This extension allows us to write generic arguments as `<MLIR: MLIRConfiguration, Ownership: MLIR.Ownership>` since calling the configuration `MLIR` make us unable to refer to the Swift module, and we cannot both have the generic argument be `Ownership` and refer to the protocol `Ownership` without going through the module.
 */
public extension MLIRConfiguration {
  typealias Ownership = MLIR.Ownership
}

// MARK: - Implementation Details

/**
 A `Bridgable` type that can be explicitly destroyed.
 */
protocol Destroyable: Bridged {
  static var destroy: (Self) -> () { get }
}

/**
 Opaque storage for a `Bridged` type
 */
struct BridgingStorage<Bridged, Ownership: MLIR.Ownership> {
  fileprivate init(_ ownership: Ownership) {
    self.ownership = ownership
  }
  fileprivate let ownership: Ownership
}
