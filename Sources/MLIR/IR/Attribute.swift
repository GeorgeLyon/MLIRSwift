
import CMLIR

public struct Attribute: MlirTypeWrapper, MlirStringCallbackStreamable {
    func print(with unsafeCallback: MlirStringCallback!, userData: UnsafeMutableRawPointer) {
        mlirAttributePrint(c, unsafeCallback, userData)
    }
    let c: MlirAttribute
}

public struct NamedAttribute: CustomDebugStringConvertible, MlirTypeWrapper {
    public var attribute: Attribute {
        Attribute(c: c.attribute)
    }
    public var name: String {
        String(cString: c.name)
    }
    public var debugDescription: String {
        "(name: \(name), attribue: \(attribute))"
    }
    let c: MlirNamedAttribute
}
