import SwiftUI

struct ClassDetailView: View {
    let classId: UUID
    let title: String
    let code: String
    let instructor: String
    let instructorEmail: String
    let numberOfAssignments: Int
    @StateObject private var assignmentsViewModel = AssignmentsViewModel()
    
    @State private var showAddAssignmentView = false
    
    // Create a Class instance for the Assignments view
    private var classItem: Course {
        Course(
            id: classId,
            title: title,
            code: code,
            instructor: instructor,
            instructorEmail: instructorEmail,
            assignments: [],
            startTime: Date(),
            endTime: Date(),
            date: Date(),
            selectedDays: [],
            firstDayOfInstruction: Date(),
            finalExam: Date()
        )
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
                    
                    Assignments(assignmentsViewModel: assignmentsViewModel, classItem: classItem)
                }
            }
            .padding()
        }
        .background(Color("AppBackground"))
        .sheet(isPresented: $showAddAssignmentView) {
            AddAssignmentView(assignmentsViewModel: assignmentsViewModel, classId: classId)
        }
        .onAppear {
            assignmentsViewModel.fetchAssignments()
            assignmentsViewModel.fetchCourses()
        }
    }
}

#Preview {
    NavigationView {
        ClassDetailView(
            classId: UUID(),
            title: "Introduction to Computer Science",
            code: "CSC101",
            instructor: "Dr. Smith",
            instructorEmail: "smith@university.edu",
            numberOfAssignments: 5
        )
    }
}







