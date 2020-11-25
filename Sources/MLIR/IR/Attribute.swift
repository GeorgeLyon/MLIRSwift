
import CMLIR

public struct Attribute: MlirStructWrapper, MlirStringCallbackStreamable {
    func print(with unsafeCallback: MlirStringCallback!, userData: UnsafeMutableRawPointer) {
        mlirAttributePrint(c, unsafeCallback, userData)
    }
    let c: MlirAttribute
}

public struct NamedAttribute: CustomDebugStringConvertible, MlirStructWrapper {
    public var attribute: Attribute {
        Attribute(c: c.attribute)
    }
    public var name: String { c.name.string }
    public var debugDescription: String {
        "(name: \(name), attribue: \(attribute))"
    }
    let c: MlirNamedAttribute
}

extension Array: ExpressibleByDictionaryLiteral where Element == NamedAttribute {
    public init(dictionaryLiteral elements: (String, Attribute)...) {
        self = elements.map { key, value in
            key.withUnsafeMlirStringRef {
                NamedAttribute(c: mlirNamedAttributeGet($0, value.c))
            }
        }
    }
}
