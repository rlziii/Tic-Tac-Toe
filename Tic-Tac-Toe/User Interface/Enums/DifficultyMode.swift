enum DifficultyMode: String, CaseIterable, Identifiable {
    case easyMode
    case hardMode
    case impossibleMode

    var id: String {
        rawValue
    }

    var displayText: String {
        switch self {
        case .easyMode:
            return "Easy Mode"
        case .hardMode:
            return "Hard Mode"
        case .impossibleMode:
            return "Impossible Mode"
        }
    }
}
