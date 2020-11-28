
protocol MlirSequence: Sequence where Element: MlirStructWrapper {
  static var mlirNextElement: (Element.MlirStruct) -> Element.MlirStruct { get }
  static var mlirElementIsNull: (Element.MlirStruct) -> Bool { get }
  var mlirFirstElement: Element.MlirStruct { get }
}

extension MlirSequence {
  public func makeIterator() -> AnyIterator<Element> {
    AnyIterator(MlirSequenceIterator<Self>(nextMlirElement: mlirFirstElement))
  }
}

private struct MlirSequenceIterator<S: MlirSequence>: IteratorProtocol {
  mutating func next() -> S.Element? {
    guard S.mlirElementIsNull(nextMlirElement) else { return nil }
    let element = S.Element(c: nextMlirElement)
    nextMlirElement = S.mlirNextElement(nextMlirElement)
    return element
  }
  fileprivate var nextMlirElement: S.Element.MlirStruct
}
