import CMLIR

public struct Type: Equatable, CRepresentable, Printable, Parsable {
  public init?(_ cRepresentation: MlirType) {
    self.init(c: cRepresentation)
  }
  public var cRepresentation: MlirType { c }

  public var context: UnownedContext {
    UnownedContext(c: mlirTypeGetContext(c))!
  }

  public static func == (lhs: Self, rhs: Self) -> Bool {
    mlirTypeEqual(lhs.c, rhs.c)
  }

  let c: MlirType

  static let isNull = mlirTypeIsNull
  static let print = mlirTypePrint
  static let parse = mlirTypeParseGet
}

public protocol ContextualTypeProtocol {
  func type(in context: Context) -> Type
}

/**
 We may be able to get rid of this if https://forums.swift.org/t/se-0299-second-review-extending-static-member-lookup-in-generic-contexts/44565 is accepted
 */
public struct ContextualType {
  public init(_ wrapped: ContextualTypeProtocol) {
    self.body = wrapped.type(in:)
  }
  public static func explicit(_ type: Type) -> Self {
    Self { context in
      precondition(context == type.context)
      return type
    }
  }
  private init(_ body: @escaping (Context) -> Type) {
    self.body = body
  }
  fileprivate let body: (Context) -> Type
}

public extension Context {
  func get(_ type: ContextualType) -> Type {
    type.body(self)
  }
}
