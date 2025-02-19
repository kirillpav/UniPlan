import Foundation

class ClassViewModel: ObservableObject {
    @Published var classes: [Class] = [
        Class(id: UUID(),
             title: "Physics 1",
             instructor: "Dr. John Doe",
             instructorEmail: "john.doe@example.com",
             assignments: [],
             schedule: []),
        Class(id: UUID(),
             title: "Calculus II",
             instructor: "Dr. Jane Smith",
             instructorEmail: "jane.smith@example.com",
             assignments: [],
             schedule: []),
        Class(id: UUID(),
             title: "Computer Science 101",
             instructor: "Prof. Alan Turing",
             instructorEmail: "alan.turing@example.com",
             assignments: [],
             schedule: [])
    ]

    init() {
      
    }

    private func saveClasses() {
        if let encoded = try? JSONEncoder().encode(classes) {
            UserDefaults.standard.set(encoded, forKey: "Classes")
        }
    }

    func addClass(_ newClass: Class) {
        classes.append(newClass)
        saveClasses()
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
