import Foundation
import SwiftData

struct CourseStats {
    let course: Course
    let gamesPlayed: Int
    let averageScore: Double
    let bestScore: Int
    let worstScore: Int
    let holeAverages: [Int: Double] // hole number: average strokes
}

struct PlayerStats {
    let player: Player
    let totalGamesPlayed: Int
    let courseStats: [CourseStats]
    let overallAverageScore: Double
}

class StatsService {

    /// Calculate comprehensive statistics for a player
    static func calculatePlayerStats(player: Player, modelContext: ModelContext) -> PlayerStats {
        // Get all scores for this player
        let playerScores = player.scores ?? []

        // Group scores by game to get unique games
        let gameIds = Set(playerScores.compactMap { $0.game?.id })
        let totalGamesPlayed = gameIds.count

        // Calculate overall average score
        let totalStrokes = playerScores.reduce(0) { $0 + $1.strokes }
        let overallAverageScore = totalGamesPlayed > 0 ? Double(totalStrokes) / Double(totalGamesPlayed) : 0.0

        // Group scores by course
        var coursesDict: [UUID: [Score]] = [:]
        for score in playerScores {
            guard let courseId = score.game?.course?.id else { continue }
            coursesDict[courseId, default: []].append(score)
        }

        // Calculate stats for each course
        let courseStats = coursesDict.compactMap { (courseId, scores) -> CourseStats? in
            guard let course = scores.first?.game?.course else { return nil }

            // Get unique games on this course
            let courseGameIds = Set(scores.compactMap { $0.game?.id })
            let gamesPlayed = courseGameIds.count

            // Calculate total scores per game
            var gameScores: [Int] = []
            for gameId in courseGameIds {
                let gameTotal = scores.filter { $0.game?.id == gameId }.reduce(0) { $0 + $1.strokes }
                gameScores.append(gameTotal)
            }

            let averageScore = gameScores.isEmpty ? 0.0 : Double(gameScores.reduce(0, +)) / Double(gameScores.count)
            let bestScore = gameScores.min() ?? 0
            let worstScore = gameScores.max() ?? 0

            // Calculate average per hole
            var holeAverages: [Int: Double] = [:]
            let groupedByHole = Dictionary(grouping: scores) { $0.holeNumber }

            for (holeNumber, holeScores) in groupedByHole {
                let total = holeScores.reduce(0) { $0 + $1.strokes }
                holeAverages[holeNumber] = Double(total) / Double(holeScores.count)
            }

            return CourseStats(
                course: course,
                gamesPlayed: gamesPlayed,
                averageScore: averageScore,
                bestScore: bestScore,
                worstScore: worstScore,
                holeAverages: holeAverages
            )
        }.sorted { $0.gamesPlayed > $1.gamesPlayed } // Sort by most played

        return PlayerStats(
            player: player,
            totalGamesPlayed: totalGamesPlayed,
            courseStats: courseStats,
            overallAverageScore: overallAverageScore
        )
    }

    /// Calculate statistics for a specific player on a specific course
    static func calculateCourseStats(player: Player, course: Course) -> CourseStats? {
        let playerScores = player.scores ?? []

        // Filter scores for this course
        let courseScores = playerScores.filter { $0.game?.course?.id == course.id }

        guard !courseScores.isEmpty else { return nil }

        // Get unique games on this course
        let courseGameIds = Set(courseScores.compactMap { $0.game?.id })
        let gamesPlayed = courseGameIds.count

        // Calculate total scores per game
        var gameScores: [Int] = []
        for gameId in courseGameIds {
            let gameTotal = courseScores.filter { $0.game?.id == gameId }.reduce(0) { $0 + $1.strokes }
            gameScores.append(gameTotal)
        }

        let averageScore = gameScores.isEmpty ? 0.0 : Double(gameScores.reduce(0, +)) / Double(gameScores.count)
        let bestScore = gameScores.min() ?? 0
        let worstScore = gameScores.max() ?? 0

        // Calculate average per hole
        var holeAverages: [Int: Double] = [:]
        let groupedByHole = Dictionary(grouping: courseScores) { $0.holeNumber }

        for (holeNumber, holeScores) in groupedByHole {
            let total = holeScores.reduce(0) { $0 + $1.strokes }
            holeAverages[holeNumber] = Double(total) / Double(holeScores.count)
        }

        return CourseStats(
            course: course,
            gamesPlayed: gamesPlayed,
            averageScore: averageScore,
            bestScore: bestScore,
            worstScore: worstScore,
            holeAverages: holeAverages
        )
    }
}
