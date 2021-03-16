import CMLIR

// MARK: - Arguments and Results

public extension ContextualNamedAttributeProtocol where Self == ContextualNamedAttribute {
  static func argument(
    _ index: Int,
    attributes: [ContextualNamedAttributeProtocol]
  ) -> Self {
    Self(name: "arg\(index)", attribute: DictionaryAttribute.dictionary(attributes))
  }
  static func argument(
    _ index: Int,
    attributes: ContextualNamedAttributeProtocol...
  ) -> Self {
    .argument(index, attributes: attributes)
  }
  static func result(
    _ index: Int,
    attributes: [ContextualNamedAttributeProtocol]
  ) -> Self {
    Self(name: "result\(index)", attribute: DictionaryAttribute.dictionary(attributes))
  }
  static func result(
    _ index: Int,
    attributes: ContextualNamedAttributeProtocol...
  ) -> Self {
    .result(index, attributes: attributes)
  }
}

// MARK: - Symbol Name

public extension ContextualNamedAttributeProtocol where Self == ContextualNamedAttribute {
  static func symbolName(_ name: String) -> Self {
    ContextualNamedAttribute(
      name: "sym_name",
      attribute: StringAttribute.string(name))
  }
}

// MARK: - Type Attribute

public extension ContextualNamedAttributeProtocol where Self == ContextualNamedAttribute {
  static func type(_ type: ContextualType) -> Self {
    ContextualNamedAttribute(
      name: "type",
      attribute: TypeAttribute.type(type))
  }
}
