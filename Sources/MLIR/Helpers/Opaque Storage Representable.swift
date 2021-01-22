
/**
 A type which can be initialized from some opaque storage.
 - invariant: Types conforming to this protocol should not have any other stored properties
 */
protocol OpaqueStorageRepresentable {
  associatedtype Storage
  init(storage: Storage)
  var storage: Storage { get }
}
