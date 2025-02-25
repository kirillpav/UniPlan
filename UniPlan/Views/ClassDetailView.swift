import SwiftUI

struct ClassDetailView: View {
    var classId: UUID
    var title: String
    var instructor: String
    var instructorEmail: String
    var numberOfAssignments: Int
    @StateObject var assignmentsViewModel = AssignmentsViewModel()

    @State private var showAddAssignmentView: Bool = false
    

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)                
            VStack {
                Text("Instructor: \(instructor)")
                    .foregroundColor(.secondary)
                Text("Instructor Email: \(instructorEmail)")
                    .foregroundColor(.secondary)
            }

            Divider()

            if assignmentsViewModel.assignments.isEmpty {
                VStack(spacing: 8) {
                    Spacer()
                    Text("No assignments yet")
                        .foregroundColor(.secondary)
                        .italic()
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding()
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        ForEach(assignmentsViewModel.assignments) { assignment in
                            HStack(spacing: 12) {
                                Circle()
                                    .strokeBorder(Color.primary, lineWidth: 1)
                                    .frame(width: 20, height: 20)
                                
                                Text(assignment.title)
                                    .fontWeight(.medium)
                                
                                Spacer()
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(Color(.systemBackground))
                            .cornerRadius(8)
                            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
        }
        .padding()
        .sheet(isPresented: $showAddAssignmentView) {
            AddAssignmentView(assignmentsViewModel: assignmentsViewModel, classId: classId)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showAddAssignmentView = true
                }) {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

struct ClassDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ClassDetailView(classId: UUID(), title: "Test", instructor: "Test", instructorEmail: "Test", numberOfAssignments: 0)
    }
}



