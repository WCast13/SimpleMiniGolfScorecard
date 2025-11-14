import SwiftUI
import SwiftData

struct CourseFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var numberOfHoles: Int = 18
    @State private var parPerHole: [Int] = Array(repeating: 3, count: 18)
    @State private var locationName: String = ""
    @State private var latitude: Double?
    @State private var longitude: Double?
    @State private var showingLocationPicker = false

    let course: Course?

    init(course: Course? = nil) {
        self.course = course
        if let course = course {
            _name = State(initialValue: course.name)
            _numberOfHoles = State(initialValue: course.numberOfHoles)
            _parPerHole = State(initialValue: course.parPerHole)
            _locationName = State(initialValue: course.locationName ?? "")
            _latitude = State(initialValue: course.latitude)
            _longitude = State(initialValue: course.longitude)
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Course Details") {
                    TextField("Course Name", text: $name)
                    Picker("Number of Holes", selection: $numberOfHoles) {
                        ForEach([9, 18], id: \.self) { holes in
                            Text("\(holes) holes").tag(holes)
                        }
                    }
                    .onChange(of: numberOfHoles) { oldValue, newValue in
                        updateParArray(to: newValue)
                    }

                    Button {
                        showingLocationPicker = true
                    } label: {
                        HStack {
                            Text("Location")
                            Spacer()
                            Text(locationName.isEmpty ? "Not set" : locationName)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Section("Par for Each Hole") {
                    ForEach(0..<numberOfHoles, id: \.self) { index in
                        Stepper("Hole \(index + 1): Par \(parPerHole[index])", value: $parPerHole[index], in: 2...6)
                    }
                }
            }
            .navigationTitle(course == nil ? "New Course" : "Edit Course")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveCourse()
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
            .sheet(isPresented: $showingLocationPicker) {
                LocationPickerView(locationName: $locationName, latitude: $latitude, longitude: $longitude)
            }
        }
    }

    private func updateParArray(to newHoleCount: Int) {
        if newHoleCount > parPerHole.count {
            parPerHole.append(contentsOf: Array(repeating: 3, count: newHoleCount - parPerHole.count))
        } else if newHoleCount < parPerHole.count {
            parPerHole = Array(parPerHole.prefix(newHoleCount))
        }
    }

    private func saveCourse() {
        if let course = course {
            course.name = name
            course.numberOfHoles = numberOfHoles
            course.parPerHole = parPerHole
            course.locationName = locationName.isEmpty ? nil : locationName
            course.latitude = latitude
            course.longitude = longitude
        } else {
            let newCourse = Course(
                name: name,
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

#Preview {
    CourseFormView()
        .modelContainer(for: Course.self, inMemory: true)
}
