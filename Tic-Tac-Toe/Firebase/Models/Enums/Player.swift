enum PlayerType: String, Codable {
    case x
    case o

    func playerToken() -> PlayerToken {
        switch self {
        case .x:
            return .x
        case .o:
            return .o
        }
    }
}
