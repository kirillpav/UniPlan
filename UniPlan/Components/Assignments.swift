import SwiftUI

struct Assignments: View {
    @StateObject var viewModel = AssignmentsViewModel()
    var classItem: Class
    
    var filteredAssignments: [Assignment] {
        viewModel.assignments.filter { $0.classId == classItem.id}
    }
    
    var body: some View {
        List(filteredAssignments) { assignment in
            VStack(alignment: .leading) {
                Text(assignment.title)
                    .font(.headline)
                Text("Due: \(assignment.dueDate, style: .date)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .navigationTitle("Assignments")
    }
}

