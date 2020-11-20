
/**
 A protocol providing convenience APIs for Swift types which wrap an underlying C type.
 */
protocol MlirTypeWrapper {
    /**
     The type being wrapped
     */
    associatedtype MlirType
    
    var c: MlirType { get }
}
