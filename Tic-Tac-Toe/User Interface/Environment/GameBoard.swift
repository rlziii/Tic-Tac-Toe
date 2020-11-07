typealias GameBoard = [PlayerToken?]

extension GameBoard {
    private static let rowLength = 3

    static let new = Array(repeating: nil, count: 9)

    subscript(index index: Index) -> Element {
        get {
            assert(validateIndexAt(index: index), "Attempting to check board with index out of bounds...")
            return self[index]
        }

        set {
            assert(validateIndexAt(index: index), "Attempting to check board with index out of bounds...")
            self[index] = newValue
        }
    }

    private func validateIndexAt(index: Int) -> Bool {
        index < count
    }
}
