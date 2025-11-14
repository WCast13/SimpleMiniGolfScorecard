import SwiftUI
import SwiftData

@Observable
class CourseFormViewModel {
    var name: String = ""
    var numberOfHoles: Int = 18
    var parPerHole: [Int] = Array(repeating: 3, count: 18)
    var locationName: String = ""
    var latitude: Double?
    var longitude: Double?
    var showingLocationPicker = false

    private let course: Course?
    private let modelContext: ModelContext

    var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var title: String {
        course == nil ? "New Course" : "Edit Course"
    }

    init(course: Course? = nil, modelContext: ModelContext) {
        self.course = course
        self.modelContext = modelContext

        if let course = course {
            self.name = course.name
            self.numberOfHoles = course.numberOfHoles
            self.parPerHole = course.parPerHole
            self.locationName = course.locationName ?? ""
            self.latitude = course.latitude
            self.longitude = course.longitude
        }
    }

    func updateParArray(to newHoleCount: Int) {
        if newHoleCount > parPerHole.count {
            parPerHole.append(contentsOf: Array(repeating: 3, count: newHoleCount - parPerHole.count))
        } else if newHoleCount < parPerHole.count {
            parPerHole = Array(parPerHole.prefix(newHoleCount))
        }
    }

    func save() {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        guard !trimmedName.isEmpty else { return }

        if let course = course {
            course.name = trimmedName
            course.numberOfHoles = numberOfHoles
            course.parPerHole = parPerHole
            course.locationName = locationName.isEmpty ? nil : locationName
            course.latitude = latitude
            course.longitude = longitude
        } else {
            let newCourse = Course(
                name: trimmedName,
                numberOfHoles: numberOfHoles,
                parPerHole: parPerHole,
                locationName: locationName.isEmpty ? nil : locationName,
                latitude: latitude,
                longitude: longitude
            )
            modelContext.insert(newCourse)
        }
    }
}
