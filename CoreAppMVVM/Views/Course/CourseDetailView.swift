import SwiftUI
import SwiftData
import MapKit

struct CourseDetailView: View {
    @Environment(\.modelContext) private var modelContext
    let course: Course
    @State private var showingEditSheet = false

    var body: some View {
        List {
            Section("Course Information") {
                LabeledContent("Name", value: course.name)
                LabeledContent("Number of Holes", value: "\(course.numberOfHoles)")
                if let locationName = course.locationName {
                    LabeledContent("Location", value: locationName)
                }
            }

            if let coordinate = course.coordinate {
                Section("Map") {
                    Map(initialPosition: .region(MKCoordinateRegion(
                        center: coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    ))) {
                        Marker(course.name, coordinate: coordinate)
                            .tint(.red)
                    }
                    .frame(height: 200)
                    .listRowInsets(EdgeInsets())
                }
            }

            Section("Par for Each Hole") {
                ForEach(0..<course.numberOfHoles, id: \.self) { index in
                    LabeledContent("Hole \(index + 1)", value: "Par \(course.parPerHole[index])")
                }
            }

            Section {
                LabeledContent("Total Par", value: "\(course.parPerHole.reduce(0, +))")
            }
        }
        .navigationTitle(course.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    showingEditSheet = true
                }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            CourseFormView(course: course)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Course.self, configurations: config)
    let course = Course(name: "Test Course", numberOfHoles: 18)
    container.mainContext.insert(course)

    return NavigationStack {
        CourseDetailView(course: course)
            .modelContainer(container)
    }
}
