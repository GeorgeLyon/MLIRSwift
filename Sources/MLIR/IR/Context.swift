
import CMLIR

public final class Context: MlirTypeWrapper {
    public init(dialects: [Dialect.Type]) {
        c = mlirContextCreate()
        for dialect in dialects {
            dialect.register(c)
        }
    }
    let c: MlirContext
}

