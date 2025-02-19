import SwiftUI

struct AddClassView: View {

    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    @ObservedObject var classViewModel: ClassViewModel

    @State private var title: String = ""
    @State private var instructor: String = ""
    @State private var instructorEmail: String = ""
    
    @State private var showError: Bool = false
    
    var body: some View {
        VStack {
            TextField("Title", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                

            TextField("Instructor", text: $instructor)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Instructor Email", text: $instructorEmail)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                
            
            Button(action: {
                if title.isEmpty {
                    showError = true
                } else {
                    classViewModel.addClass(Class(id: UUID(), title: title, instructor: instructor, instructorEmail: instructorEmail, assignments: [], schedule: []))
                    dismiss()
                    print("Class added successfuly")
                }
                
            }) {
                Text("Add Class")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
            }
        }
    }   

    
}
