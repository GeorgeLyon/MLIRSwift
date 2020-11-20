
import CMLIR

public final class Context: MlirTypeWrapper {
    public init() {
        c = mlirContextCreate()
    }
    let c: MlirContext
}

