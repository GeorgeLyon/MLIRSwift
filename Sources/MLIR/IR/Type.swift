
import CMLIR

public struct Type<MLIR: MLIRConfiguration>: MlirStructWrapper {
    public init(parsing source: String) throws {
        c = try MLIR.parse {
            source.withUnsafeMlirStringRef { mlirTypeParseGet(MLIR.context.c, $0) }
        }
    }
    init(c: MlirType) {
        self.c = c
    }
    let c: MlirType
}

public struct Value: MlirStructWrapper {
    let c: MlirValue
}

public protocol TypeClass {
    associatedtype MLIR: MLIRConfiguration
    static var type: Type<MLIR> { get }
}

public struct TypedValue<TypeClass: MLIR.TypeClass> {
    let value: Value
}

public protocol MemberCollection: Collection {
    associatedtype Base
    static var keyPath: KeyPath<Base, Self> { get }
}

public struct TypeList<_MLIR: MLIRConfiguration, Values, MemberCollection: MLIR.MemberCollection>
where
    MemberCollection.Index == Int,
    MemberCollection.Element  == Value
{
    let types: [Type<_MLIR>]
    let reify: (MemberCollection.Base) -> Values
}
public extension TypeList where Values == Void {
    init() {
        types = []
        reify = { _ in () }
    }
}
public extension TypeList {
    init(_ t0: Type<_MLIR>) where Values == Value {
        types = [t0]
        reify = { base in
            let values = base[keyPath: MemberCollection.keyPath]
            return values[0]
        }
    }
    init<T0: TypeClass>(_ t0: T0.Type)
    where
        Values == TypedValue<T0>, T0.MLIR == _MLIR
    {
        types = [t0.type]
        reify = { base in
            let values = base[keyPath: MemberCollection.keyPath]
            return TypedValue(value: values[0])
        }
    }
    init(_ t0: Type<_MLIR>, _ t1: Type<_MLIR>)
    where Values == (Value, Value)
    {
        types = [t0, t1]
        reify = { base in
            let values = base[keyPath: MemberCollection.keyPath]
            return (values[0], values[1])
        }
    }
    init<T0: TypeClass, T1: TypeClass>(_ t0: T0.Type, _ t1: T1.Type)
    where
        T0.MLIR == _MLIR,
        T1.MLIR == _MLIR,
        Values == (TypedValue<T0>, TypedValue<T1>)
    {
        types = [t0.type, t1.type]
        reify = { base in
            let values = base[keyPath: MemberCollection.keyPath]
            return (TypedValue(value: values[0]), TypedValue(value: values[1]))
        }
    }
    init(_ t0: Type<_MLIR>, _ t1: Type<_MLIR>, t2: Type<_MLIR>)
    where
        Values == (Value, Value, Value)
    {
        types = [t0, t1, t2]
        reify = { base in
            let values = base[keyPath: MemberCollection.keyPath]
            return (values[0], values[1], values[2])
        }
    }
    init<T0: TypeClass, T1: TypeClass, T2: TypeClass>(_ t0: T0.Type, _ t1: T1.Type, _ t2: T2.Type)
    where
        T0.MLIR == _MLIR,
        T1.MLIR == _MLIR,
        T2.MLIR == _MLIR,
        Values == (TypedValue<T0>, TypedValue<T1>, TypedValue<T2>)
    {
        types = [t0.type, t1.type, t2.type]
        reify = { base in
            let values = base[keyPath: MemberCollection.keyPath]
            return (TypedValue(value: values[0]), TypedValue(value: values[1]), TypedValue(value: values[2]))
        }
    }
}
