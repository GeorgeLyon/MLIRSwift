import CMLIR

// MARK: - String

public struct StringAttribute: ContextualAttribute {
  public let value: String
  public func `in`(_ context: Context) -> Attribute {
    Attribute(
      value.withUnsafeMlirStringRef {
        mlirStringAttrGet(context.mlir, $0)
      })
  }
}
extension ContextualAttribute where Self == StringAttribute {
  public static func string(_ value: String) -> Self {
    StringAttribute(value: value)
  }
}

// MARK: - Integer

public struct IntegerAttribute: ContextualAttribute {
  public let type: IntegerType
  public let value: Int
  public func `in`(_ context: Context) -> Attribute {
    Attribute(mlirIntegerAttrGet(type.in(context).mlir, Int64(value)))
  }
}
extension ContextualAttribute where Self == IntegerAttribute {
  public static func integer(
    type: IntegerType,
    value: Int
  ) -> Self {
    IntegerAttribute(type: type, value: value)
  }
}

// MARK: - Type

public struct TypeAttribute: ContextualAttribute {
  public let type: ContextualType
  public func `in`(_ context: Context) -> Attribute {
    Attribute(mlirTypeAttrGet(type.in(context).mlir))
  }
}
public extension ContextualAttribute where Self == TypeAttribute {
  static func type(_ type: ContextualType) -> Self {
    TypeAttribute(type: type)
  }
}

// MARK: - Array

public struct ArrayAttribute: ContextualAttribute {
  public let elements: [ContextualAttribute]
  public func `in`(_ context: Context) -> Attribute {
    elements
      .map { $0.in(context) }
      .withUnsafeMlirRepresentation { elements in
        Attribute(mlirArrayAttrGet(context.mlir, elements.count, elements.baseAddress))
      }
  }
}
public extension ContextualAttribute where Self == ArrayAttribute {
  static func array(_ elements: [ContextualAttribute]) -> Self {
    ArrayAttribute(elements: elements)
  }
  static func array(_ elements: ContextualAttribute...) -> Self {
    ArrayAttribute(elements: elements)
  }
}

// MARK: - Dictionary

public struct DictionaryAttribute: ContextualAttribute {
  public let elements: [ContextualNamedAttributeProtocol]
  public func `in`(_ context: Context) -> Attribute {
    elements
      .map { $0.in(context) }
      .withUnsafeMlirRepresentation { elements in
        Attribute(mlirDictionaryAttrGet(context.mlir, elements.count, elements.baseAddress))
      }
  }
}
public extension ContextualAttribute where Self == DictionaryAttribute {
  static func dictionary(_ elements: [ContextualNamedAttributeProtocol]) -> Self {
    DictionaryAttribute(elements: elements)
  }
  static func dictionary(_ elements: ContextualNamedAttributeProtocol...) -> Self {
    DictionaryAttribute(elements: elements)
  }
  static func dictionary<Pairs: Sequence>(_ pairs: Pairs) -> Self
  where
    Pairs.Element == (key: String, value: ContextualAttribute)
  {
    .dictionary(pairs.map(NameContextualAttributePair.init))
  }
}

private struct NameContextualAttributePair: ContextualNamedAttributeProtocol {
  let name: String
  let attribute: ContextualAttribute
  func `in`(_ context: Context) -> NamedAttribute {
    NamedAttribute(name: name, attribute: attribute.in(context))
  }
}

// MARK: - Flat Symbol Reference

public struct FlatSymbolReferenceAttribute: ContextualAttribute {
  public let name: String
  public func `in`(_ context: Context) -> Attribute {
    name.withUnsafeMlirStringRef {
      Attribute(mlirFlatSymbolRefAttrGet(context.mlir, $0))
    }
  }
}
public extension
  ContextualAttribute where Self == FlatSymbolReferenceAttribute
{
  static func flatSymbolReference(_ name: String) -> Self {
    FlatSymbolReferenceAttribute(name: name)
  }
}
