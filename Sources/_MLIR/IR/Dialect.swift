
import MLIRDialect

public extension RegisteredDialect {
  var namespace: String {
    DialectMetadata.of(self).getNamespace().string
  }
}
