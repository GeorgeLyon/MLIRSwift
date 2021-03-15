import CMLIR

// MARK: - Arguments and Results

public struct NestedNamedAttributes: ContextualNamedAttribute {
  public let name: String
  public let attributes: [ContextualNamedAttribute]
  public func `in`(_ context: Context) -> NamedAttribute {
    NamedAttribute(
      name: name,
      attribute: DictionaryAttribute.dictionary(attributes).in(context))
  }
}
public extension
  NestedNamedAttributes /* ContextualNamedAttribute where Self == NestedNamedAttributes */
{
  static func argument(
    _ index: Int,
    attributes: [ContextualNamedAttribute]
  ) -> Self {
    Self(name: "arg\(index)", attributes: attributes)
  }
  static func argument(
    _ index: Int,
    attributes: ContextualNamedAttribute...
  ) -> Self {
    .argument(index, attributes: attributes)
  }
  static func result(
    _ index: Int,
    attributes: [ContextualNamedAttribute]
  ) -> Self {
    Self(name: "result\(index)", attributes: attributes)
  }
  static func result(
    _ index: Int,
    attributes: ContextualNamedAttribute...
  ) -> Self {
    .result(index, attributes: attributes)
  }
}

// MARK: - Symbol Name

public struct SymbolNameNamedAttribute: ContextualNamedAttribute {
  public let name: String
  public func `in`(_ context: Context) -> NamedAttribute {
    NamedAttribute(
      name: "sym_name",
      attribute: StringAttribute.string(name).in(context))
  }
}
public extension
  SymbolNameNamedAttribute /* ContextualNamedAttribute where Self == SymbolNameNamedAttribute */
{
  static func symbolName(_ name: String) -> Self {
    Self(name: name)
  }
}

// MARK: - Type Attribute

public struct TypeNamedAttribute: ContextualNamedAttribute {
  public let type: ContextualType
  public func `in`(_ context: Context) -> NamedAttribute {
    NamedAttribute(
      name: "type",
      attribute: TypeAttribute.type(type.in(context)).in(context))
  }
}
public extension TypeNamedAttribute /* ContextualNamedAttribute where Self == TypeNamedAttribute */
{
  static func type(_ type: ContextualType) -> Self {
    Self(type: type)
  }
}
