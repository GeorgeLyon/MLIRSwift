import CMLIR

// MARK: - Attribute

/**
 A representation of an MLIR attribute that is independent of a context
 */
public protocol ContextualAttribute {
  func `in`(_ context: Context) -> Attribute
}

/**
 A Swift representation of an MLIR attribute
 */
public struct Attribute: ContextualAttribute, MlirRepresentable {

  public init(_ mlir: MlirAttribute) {
    self.init(mlir: mlir)
  }
  public let mlir: MlirAttribute

  /**
   Attribute implements `ContextualAttribute`, but requires that `context`be the context owning this type.
   */
  public func `in`(_ context: Context) -> Attribute {
    precondition(context == self.context)
    return self
  }

  /**
   The context which owns this attribute
   */
  public var context: UnownedContext {
    UnownedContext(mlirAttributeGetContext(mlir))
  }

  /// Suppress synthesized initializer
  private init() { fatalError() }

}

// MARK: Equality

extension Attribute: Equatable {
  public static func == (lhs: Attribute, rhs: Attribute) -> Bool {
    mlirAttributeEqual(lhs.mlir, rhs.mlir)
  }
}

/**
 Attributes can be equated with contextual attributes

 - note: This operation is defined on optionals so we get optional comparisons as well
 */
public func == (lhs: ContextualAttribute?, rhs: Attribute?) -> Bool {
  switch (lhs, rhs) {
  case (.none, .none): return true
  case (.some, .none), (.none, .some): return false
  case let (lhs?, rhs?):
    return lhs.in(rhs.context) == rhs
  }
}

public func == (lhs: Attribute?, rhs: ContextualAttribute?) -> Bool {
  rhs == lhs
}

// MARK: - Named Attribute

/**
 A representation of an MLIR named attribute that is independent of a context

 - note: Unlike `ContextualType` and `ContextualAttribute`, named attributes are most often just the union of an identifier and an attribute, so we provide a concrete `ContextualNamedAttribute` type to simplify the common case.
 */
public protocol ContextualNamedAttributeProtocol {
  func `in`(_ context: Context) -> NamedAttribute
}

/**
 A concrete type for the common case of contextual named attributes
 */
public struct ContextualNamedAttribute: ContextualNamedAttributeProtocol {
  public init(name: String, attribute: ContextualAttribute) {
    self.name = name
    self.attribute = attribute
  }
  public func `in`(_ context: Context) -> NamedAttribute {
    NamedAttribute(name: name, attribute: attribute.in(context))
  }
  let name: String
  let attribute: ContextualAttribute
}

/**
 Represent an identifier-attribute pair.

 - note: We model this as its own type, and collections of named attributes as arrays of `NamedAttribute`, because often the type of an attribute can be inferred from the identifier which we would not have access to if we represented the collection as a dictionary of attributes.
 */
public struct NamedAttribute: ContextualNamedAttributeProtocol {

  /**
   Creates a named attribute from an identifier and an attribute
   */
  public init(name: Identifier, attribute: Attribute) {
    self.init(mlirNamedAttributeGet(name.mlir, attribute.mlir))
  }

  /**
   Creates a named attribute from a string and an attribute
   */
  public init(name: String, attribute: Attribute) {
    self.init(
      name: Identifier(name, in: attribute.context),
      attribute: attribute)
  }

  /**
   Creates a named attribute from an `MlirNamedAttribute`

   - precondition: The attribute must not be null
   - precondition: `name` and `attribute` must be in the same context
   */
  public init(_ mlir: MlirNamedAttribute) {
    precondition(!mlirAttributeIsNull(mlir.attribute))
    self.mlir = mlir
    precondition(name.context == attribute.context)
  }
  public let mlir: MlirNamedAttribute

  /**
   - precondition: `context` must be equal to the context which owns this named attribute
   */
  public func `in`(_ context: Context) -> NamedAttribute {
    precondition(context == self.context)
    return self
  }

  /**
   The context which owns the identifier and attribute comprising `self`
   */
  public var context: UnownedContext {
    /// This is ensured during initialization
    assert(name.context == attribute.context)
    return name.context
  }

  /**
   The name of this named attribute
   */
  public var name: Identifier {
    Identifier(mlir.name)
  }

  /**
   The attribute of this named attribute
   */
  public var attribute: Attribute {
    Attribute(mlir.attribute)
  }
}

extension Array where Element == NamedAttribute {
  func withUnsafeMlirRepresentation<R>(
    _ body: (UnsafeBufferPointer<MlirNamedAttribute>) throws -> R
  ) rethrows -> R {
    precondition(MemoryLayout<NamedAttribute>.size == MemoryLayout<MlirNamedAttribute>.size)
    precondition(MemoryLayout<NamedAttribute>.stride == MemoryLayout<MlirNamedAttribute>.stride)
    precondition(
      MemoryLayout<NamedAttribute>.alignment == MemoryLayout<MlirNamedAttribute>.alignment)
    return try withUnsafeBufferPointer { buffer in
      try buffer.withMemoryRebound(to: MlirNamedAttribute.self, body)
    }
  }
}
