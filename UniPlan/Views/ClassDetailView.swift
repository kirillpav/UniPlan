import SwiftUI

struct ClassDetailView: View {
    let classId: UUID
    let title: String
    let instructor: String
    let instructorEmail: String
    let numberOfAssignments: Int
    @StateObject private var assignmentsViewModel = AssignmentsViewModel()
    
    @State private var showAddAssignmentView = false
    
    var filteredAssignments: [Assignment] {
        assignmentsViewModel.assignments.filter { $0.classId == classId }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(Color("AccentColor"))
                    
                    Text("Instructor: \(instructor)")
                        .font(.system(size: 18))
                    
                    Text(instructorEmail)
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                }
                
                // Assignments section
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Assignments")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(Color("AccentColor"))
                        
                        Spacer()
                        
                        Button(action: {
                            showAddAssignmentView = true
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.black)
                                .padding(10)
                                .background(Circle().fill(Color("PrimaryColor")))
                        }
                    }
                    
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
                                    if let index = assignmentsViewModel.assignments.firstIndex(where: { $0.id == assignment.id }) {
                                        assignmentsViewModel.assignments[index].isCompleted.toggle()
                                        assignmentsViewModel.saveAssignments()
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(Color("AppBackground"))
        .sheet(isPresented: $showAddAssignmentView) {
            AddAssignmentView(assignmentsViewModel: assignmentsViewModel, classId: classId)
        }
    }
}

#Preview {
    NavigationView {
        ClassDetailView(
            classId: UUID(),
            title: "Introduction to Computer Science",
            instructor: "Dr. Smith",
            instructorEmail: "smith@university.edu",
            numberOfAssignments: 5
        )
    }
}







