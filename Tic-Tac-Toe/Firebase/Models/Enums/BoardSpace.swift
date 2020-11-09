enum BoardSpace: String, Codable {
    case x
    case o
    case e // Empty space.

    func playerToken() -> PlayerToken? {
        switch self {
        case .x:
            return .x
        case .o:
            return .o
        case .e:
            return nil
        }
    }
}
