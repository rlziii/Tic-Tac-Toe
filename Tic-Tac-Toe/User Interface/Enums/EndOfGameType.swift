enum EndOfGameType: Identifiable {

    // MARK: - Enum Cases

    case winner(PlayerToken)
    case tie

    // MARK: - Public Properties

    var id: String {
        String(describing: self)
    }

    var message: String {
        switch self {
        case let .winner(playerType):
            return "Player \(playerType.token) won the game!"
        case .tie:
            return "It's a tie! 😹"
        }
    }
}
