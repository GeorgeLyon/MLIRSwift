
protocol MlirSequence: Sequence where Element: MlirTypeWrapper {
    static var nextMlirElement: (Element.MlirType) -> Element.MlirType { get }
    static var mlirElementIsNull: (Element.MlirType) -> Int32 { get }
    var firstMlirElement: Element.MlirType { get }
}

extension MlirSequence {
    public func makeIterator() -> AnyIterator<Element> {
        AnyIterator(MlirSequenceIterator<Self>(nextMlirElement: firstMlirElement))
    }
}

private struct MlirSequenceIterator<S: MlirSequence>: IteratorProtocol {
    mutating func next() -> S.Element? {
        guard S.mlirElementIsNull(nextMlirElement) == 0 else { return nil }
        let element = S.Element(c: nextMlirElement)
        nextMlirElement = S.nextMlirElement(nextMlirElement)
        return element
    }
    fileprivate var nextMlirElement: S.Element.MlirType
}
