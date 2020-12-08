/*
protocol LinkedList where Index == LinkedListIndex<Self> {
  
}

protocol _LinkedList: Collection where Element: Bridged {
  static var next: (Element.MlirStruct) -> Element.MlirStruct
}

struct LinkedListIndex<List: _LinkedList>: Comparable {
  let value: (offset: Int, element: List.Element)
  
}
*/
