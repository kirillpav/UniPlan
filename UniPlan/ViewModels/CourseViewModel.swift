import Foundation

class CourseViewModel: ObservableObject {
    @Published var courses: [Course] = []

    init() {  }

    private func saveCourses() {
        if let encoded = try? JSONEncoder().encode(courses) {
            UserDefaults.standard.set(encoded, forKey: "Courses")
        }
    }

    func addCourse(_ newCourse: Course) {
        courses.append(newCourse)
        saveCourses()
    }

    func deleteCourse(_ course: Course) {
        if let index = courses.firstIndex(where: { $0.id == course.id }) {
            courses.remove(at: index)
            saveCourses()
        }
    }
    
    func fetchCourses() {
        // load classes from UserDefaults
        if let encoded = UserDefaults.standard.data(forKey: "Courses") {
            if let decoded = try? JSONDecoder().decode([Course].self, from: encoded) {
                courses = decoded
            }
        }
    }
}
