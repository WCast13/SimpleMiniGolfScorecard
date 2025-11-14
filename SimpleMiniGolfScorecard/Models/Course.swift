import Foundation
import SwiftData
import CoreLocation

@Model
final class Course {
    var id: UUID = UUID()
    var name: String = ""
    var numberOfHoles: Int = 18
    var parPerHole: [Int] = Array(repeating: 3, count: 18)
    var createdAt: Date = Date()
    var locationName: String?
    var latitude: Double?
    var longitude: Double?

    @Relationship(deleteRule: .cascade, inverse: \Game.course)
    var games: [Game]?

    init(name: String, numberOfHoles: Int, parPerHole: [Int]? = nil, locationName: String? = nil, latitude: Double? = nil, longitude: Double? = nil) {
        self.id = UUID()
        self.name = name
        self.numberOfHoles = numberOfHoles
        self.createdAt = Date()
        self.locationName = locationName
        self.latitude = latitude
        self.longitude = longitude
        self.games = []

        // Default par to 3 for all holes if not specified
        if let parPerHole = parPerHole {
            self.parPerHole = parPerHole
        } else {
            self.parPerHole = Array(repeating: 3, count: numberOfHoles)
        }
    }

    var coordinate: CLLocationCoordinate2D? {
        guard let latitude = latitude, let longitude = longitude else {
            return nil
        }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
