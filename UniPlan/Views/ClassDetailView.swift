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
        VStack {
            Text(title)
                .font(.largeTitle)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            Text("Instructor: \(instructor)")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            Text("Instructor Email: \(instructorEmail)")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
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



