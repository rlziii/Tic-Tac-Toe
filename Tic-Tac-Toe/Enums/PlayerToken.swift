enum PlayerToken {

    // MARK: - Enum Cases

    case x
    case o

    // MARK: - Public Properties

    var token: String {
        switch self {
        case .x:
            return "❌"
        case .o:
            return "⭕️"
        }
    }

    var next: PlayerToken {
        switch self {
        case .x:
            return .o
        case .o:
            return .x
        }
    }
}
