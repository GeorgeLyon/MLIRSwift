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
public struct Attribute: ContextualAttribute, Equatable, MlirRepresentable {
  
  /**
   Creates an attribute from an `MlirAttribute`
   */
  public init(_ mlir: MlirAttribute) {
    precondition(!mlirAttributeIsNull(mlir))
    self.mlir = mlir
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
}

// MARK: Equality

extension Attribute {
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
 */
public protocol ContextualNamedAttribute {
  func `in`(_ context: Context) -> NamedAttribute
}

/**
 Represent an identifier-attribute pair.
 
 - note: We model this as its own type, and collections of named attributes as arrays of `NamedAttribute`, because often the type of an attribute can be inferred from the identifier which we would not have access to if we represented the collection as a dictionary of attributes.
 */
public struct NamedAttribute: ContextualNamedAttribute, MlirRepresentable {
  
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
