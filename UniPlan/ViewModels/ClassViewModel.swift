import Foundation

class ClassViewModel: ObservableObject {
    @Published var classes: [Class] = []

    init() {  }

    private func saveClasses() {
        if let encoded = try? JSONEncoder().encode(classes) {
            UserDefaults.standard.set(encoded, forKey: "Classes")
        }
    }

    func addClass(_ newClass: Class) {
        classes.append(newClass)
        saveClasses()
    }

    func deleteClass(_ course: Class) {
        if let index = classes.firstIndex(where: { $0.id == course.id }) {
            classes.remove(at: index)
            saveClasses()
        }
    }
    
    func fetchClasses() {
        // load classes from UserDefaults
        if let encoded = UserDefaults.standard.data(forKey: "Classes") {
            if let decoded = try? JSONDecoder().decode([Class].self, from: encoded) {
                classes = decoded
            }
        }
    }
}
