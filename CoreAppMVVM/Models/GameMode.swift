import Foundation

enum GameMode: String, Codable, CaseIterable {
    case strokePlay = "Stroke Play"
    case matchPlay = "Match Play"
    case teamMatchPlay = "Team Match Play"

    var description: String {
        return self.rawValue
    }

    var systemImage: String {
        switch self {
        case .strokePlay:
            return "chart.bar"
        case .matchPlay:
            return "person.2"
        case .teamMatchPlay:
            return "person.3"
        }
    }
}

enum TeamFormat: String, Codable, CaseIterable {
    case bestBall = "Best Ball"
    case combinedScores = "Combined Scores"

    var description: String {
        return self.rawValue
    }

    var detailedDescription: String {
        switch self {
        case .bestBall:
            return "Each hole, the better score from each team counts"
        case .combinedScores:
            return "Add all team member scores together"
        }
    }
}

enum TeamAssignment: String, Codable, CaseIterable {
    case manual = "Manual"
    case autoSplit = "Auto Split"

    var description: String {
        return self.rawValue
    }
}
