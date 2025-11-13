import SwiftUI
import SwiftData

struct CoursesListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Course.name) private var courses: [Course]
    @State private var showingAddCourse = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(courses) { course in
                    NavigationLink {
                        CourseDetailView(course: course)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(course.name)
                                .font(.headline)
                            Text("\(course.numberOfHoles) holes")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .onDelete(perform: deleteCourses)
            }
            .navigationTitle("Courses")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddCourse = true }) {
                        Label("Add Course", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddCourse) {
                CourseFormView()
            }
            .overlay {
                if courses.isEmpty {
                    ContentUnavailableView(
                        "No Courses",
                        systemImage: "flag.fill",
                        description: Text("Add a course to get started")
                    )
                }
            }
        }
    }

    private func deleteCourses(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(courses[index])
        }
    }
}

#Preview {
    CoursesListView()
        .modelContainer(for: Course.self, inMemory: true)
}
