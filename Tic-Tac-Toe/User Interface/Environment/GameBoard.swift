struct GameBoard {

    // MARK: - Private Properties

    private var boardArray: [PlayerToken?] = Array(repeating: nil, count: 9)
    private static let rowLength = 3

    // MARK: - Public Subscripts

    subscript(index: Int) -> PlayerToken? {
        get {
            assert(validate(index), "Attempting to check board with index out of bounds...")
            return boardArray[index]
        }

        set {
            assert(validate(index), "Attempting to check board with index out of bounds...")
            boardArray[index] = newValue
        }
    }

    // MARK: - Public Methods

    func emptyIndexes() -> [Int] {
        boardArray.enumerated().compactMap { $1 == nil ? $0 : nil }
    }

    func indexFor(row: Int, column: Int) -> Int {
        let index = (row * Self.rowLength) + column

        assert(validate(row: row, column: column), "Attempting to check board with index out of bounds...")

        return index
    }

    // MARK: - Private Methods
    
    private func validate(_ index: Int) -> Bool {
        index < boardArray.count
    }

    private func validate(row: Int, column: Int) -> Bool {
        row >= 0 && row <= (Self.rowLength - 1) && column >= 0 && column <= (Self.rowLength - 1)
    }
}
