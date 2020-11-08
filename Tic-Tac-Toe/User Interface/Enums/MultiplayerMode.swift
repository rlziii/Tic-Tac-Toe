enum MultiplayerMode: String, CaseIterable, Identifiable {
    case localMode
    case networkMode

    var id: String {
        rawValue
    }

    var displayText: String {
        switch self {
        case .localMode:
            return "Local"
        case .networkMode:
            return "Network"
        }
    }
}
