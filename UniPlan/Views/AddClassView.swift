import SwiftUI

struct AddClassView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    @ObservedObject var classViewModel: ClassViewModel
    
    @State private var title: String = ""
    @State private var instructor: String = ""
    @State private var instructorEmail: String = ""
    @State private var showError: Bool = false
    
    // Custom colors
    private let accentColor = Color("AccentColor") // Create this in Assets.xcassets
    private var backgroundColor: Color { colorScheme == .dark ? Color.black.opacity(0.8) : Color.white }
    private var textColor: Color { colorScheme == .dark ? Color.white : Color.black.opacity(0.8) }
    
    var body: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 24) {
                Text("New Class")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(textColor)
                
                VStack(spacing: 20) {
                    inputField(title: "Class Title", text: $title, placeholder: "e.g. Biology 101")
                    
                    inputField(title: "Instructor", text: $instructor, placeholder: "e.g. Dr. Smith")
                    
                    inputField(title: "Email", text: $instructorEmail, placeholder: "e.g. smith@university.edu")
                }
                
                Spacer()
                
                VStack(spacing: 16) {
                    if showError {
                        Text("Please enter a class title")
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.horizontal)
                    }
                    
                    Button(action: {
                        if title.isEmpty {
                            showError = true
                        } else {
                            classViewModel.addClass(Class(id: UUID(), title: title, instructor: instructor, instructorEmail: instructorEmail, assignments: [], schedule: []))
                            dismiss()
                        }
                    }) {
                        Text("Add Class")
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(title.isEmpty ? accentColor.opacity(0.5) : accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .disabled(title.isEmpty)
                }
            }
            .padding(24)
        }
    }
    
    private func inputField(title: String, text: Binding<String>, placeholder: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(textColor.opacity(0.7))
            
            TextField(placeholder, text: text)
                .padding()
                .background(colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.03))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
        }
    }
}
