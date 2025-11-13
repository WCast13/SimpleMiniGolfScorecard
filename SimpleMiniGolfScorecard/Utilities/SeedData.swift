import Foundation
import SwiftData

struct SeedData {
    static func createPopstrokeCourses(modelContext: ModelContext) {
        // Popstroke Delray Beach location coordinates
        let delrayBeachLat = 26.4615
        let delrayBeachLon = -80.0728

        // Blue Course - Par values from the scorecard
        let blueCourseParValues = [2, 2, 2, 3, 3, 3, 2, 2, 2, 2, 2, 2, 2, 3, 2, 3, 2, 3]
        let blueCourse = Course(
            name: "Popstroke Delray Beach - Blue Course",
            numberOfHoles: 18,
            parPerHole: blueCourseParValues,
            locationName: "Popstroke Delray Beach",
            latitude: delrayBeachLat,
            longitude: delrayBeachLon
        )

        // Black Course - Par values from the scorecard
        let blackCourseParValues = [2, 2, 2, 3, 2, 2, 2, 3, 2, 2, 3, 2, 2, 2, 2, 3, 2, 3]
        let blackCourse = Course(
            name: "Popstroke Delray Beach - Black Course",
            numberOfHoles: 18,
            parPerHole: blackCourseParValues,
            locationName: "Popstroke Delray Beach",
            latitude: delrayBeachLat,
            longitude: delrayBeachLon
        )

        modelContext.insert(blueCourse)
        modelContext.insert(blackCourse)

        do {
            try modelContext.save()
        } catch {
            print("Failed to save Popstroke courses: \(error)")
        }
    }

    static func shouldSeedData(modelContext: ModelContext) -> Bool {
        let descriptor = FetchDescriptor<Course>()
        do {
            let courses = try modelContext.fetch(descriptor)
            return courses.isEmpty
        } catch {
            print("Failed to check for existing courses: \(error)")
            return false
        }
    }
}
