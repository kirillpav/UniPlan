import SwiftUI

struct AddAssignmentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    @ObservedObject var assignmentsViewModel: AssignmentsViewModel
    let classId: UUID

    @State private var title: String = ""
    @State private var dueDate: Date = Date()
    @State private var isCompleted: Bool = false

    @State private var showError: Bool = false
    
    var body: some View {
        VStack {
            TextField("Title", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            DatePicker("Due Date", selection: $dueDate)
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()

            Toggle("Completed", isOn: $isCompleted)
                .padding()

            Button(action: {
                if title.isEmpty {
                    showError = true
                } else {
                    assignmentsViewModel.addAssignment(Assignment(id: UUID(), title: title, dueDate: dueDate, isCompleted: isCompleted, classId: classId))
                    dismiss()
                    print("Assignment added successfully")
                }
            }) {
                Text("Add Assignment")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
            }
        }
    }
}
