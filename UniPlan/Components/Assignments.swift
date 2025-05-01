import SwiftUI

struct Assignments: View {
    @ObservedObject var assignmentsViewModel: AssignmentsViewModel
    let classItem: Course
    
    var filteredAssignments: [Assignment] {
        assignmentsViewModel.assignments.filter { $0.classId == classItem.id }
    }
    
    var body: some View {
        VStack {
            if filteredAssignments.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "list.clipboard")
                        .font(.system(size: 40))
                        .opacity(0.3)
                        .padding(.top, 20)
                    
                    Text("No assignments yet")
                        .font(.headline)
                        .opacity(0.5)
                }
                .frame(maxWidth: .infinity)
            } else {
                LazyVStack(spacing: 16) {
                    ForEach(filteredAssignments) { assignment in
                        AssignmentRow(assignment: assignment) {
                            assignmentsViewModel.toggleAssignmentCompletion(assignmentId: assignment.id)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                assignmentsViewModel.deleteAssignment(assignment)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            
                        }
                        .padding(.bottom, 12)
                    }
                }
            }
        }
        .padding()
    }
}

// Preview provider for development
struct Assignments_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = AssignmentsViewModel()
        let sampleClass = Course(
            id: UUID(),
            title: "Sample Class",
            code: "S101",
            instructor: "John Doe",
            instructorEmail: "john@example.com",
            assignments: [],
            startTime: Date(),
            endTime: Date(),
            date: Date(),
            selectedDays: [],
            firstDayOfInstruction: Date(),
            finalExam: Date()
        )
        
        Assignments(assignmentsViewModel: viewModel, classItem: sampleClass)
    }
}

