import SwiftUI

struct ClassDetailView: View {
    var classId: UUID
    var title: String
    var instructor: String
    var instructorEmail: String
    var numberOfAssignments: Int
    @StateObject var assignmentsViewModel = AssignmentsViewModel()
    
    @State private var showAddAssignmentView: Bool = false
    @State private var showCopiedConfirmation = false
    
    var filteredAssignments: [Assignment] {
        assignmentsViewModel.assignments.filter { $0.classId == classId }
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 24) {
                    // Content inside the header
                    VStack(spacing: 8) {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(title)
                                    .font(.system(size: 36, weight: .bold))
                                    
                                
                                Text(instructor)
                                    .font(.headline)

                                Button {
                                    UIPasteboard.general.string = instructorEmail
                                    withAnimation {
                                        showCopiedConfirmation = true
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        withAnimation {
                                            showCopiedConfirmation = false
                                        }
                                    }
                                } label: {
                                    Text(instructorEmail)
                                        .font(.subheadline)
                                        .opacity(0.8)
                                }
                            }
                        }
                        .padding(.bottom, 20)
                    }
                    .padding(.horizontal, 24)
                
                // Assignments section
                VStack {
                    HStack {
                        Text("Assignments")
                            .font(.title2)
                            .fontWeight(.bold)
                        
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
                    .padding(.horizontal)
                    
                    if filteredAssignments.isEmpty {
                        VStack(spacing: 16) {
                            Spacer()
                            
                            Image(systemName: "list.clipboard")
                                .font(.system(size: 40))
                                .opacity(0.3)
                            
                            Text("No assignments yet")
                                .font(.headline)
                                .opacity(0.5)
                            
                            Button(action: {
                                showAddAssignmentView = true
                            }) {
                                Text("Add Your First Assignment")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 24)
                                    .background(Capsule().fill(Color("PrimaryColor")))
                            }
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 60)
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(filteredAssignments) { assignment in
                                    AssignmentRow(assignment: assignment) {
                                        if let index = assignmentsViewModel.assignments.firstIndex(where: { $0.id == assignment.id }) {
                                            assignmentsViewModel.assignments[index].isCompleted.toggle()
                                            assignmentsViewModel.saveAssignments()
                                        }
                                    }
                                    .listRowSeparator(.hidden)
                                    .listRowBackground(Color.clear)
                                    .listRowInsets(EdgeInsets())
                                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                        Button(role: .destructive) {
                                            assignmentsViewModel.deleteAssignment(assignment)
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .padding(.vertical)
            if showCopiedConfirmation {
                            Text("Copied")
                                .font(.headline)
                                .padding()
                                .background(Color.black.opacity(0.3))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .transition(.scale.combined(with: .opacity))
                                .zIndex(1000) // Ensure it's on top of everything
                        }
        }
        .sheet(isPresented: $showAddAssignmentView) {
            AddAssignmentView(assignmentsViewModel: assignmentsViewModel, classId: classId)
        }
    }
    
}

// Custom row component for assignments
struct AssignmentRow: View {
    var assignment: Assignment
    var toggleCompletion: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // Completion circle
            Button(action: toggleCompletion) {
                ZStack {
                    Circle()
                        .strokeBorder(Color.black.opacity(0.6), lineWidth: 1.5)
                        .frame(width: 24, height: 24)
                    
                    if assignment.isCompleted {
                        Circle()
                            .fill(Color.black.opacity(0.3))
                            .frame(width: 18, height: 18)
                    }
                }
            }
            
            
            // Assignment details
            HStack(spacing: 4) {
                Text(assignment.title)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(assignment.isCompleted ? .black.opacity(0.5) : .black)
                    .strikethrough(assignment.isCompleted)
                
                Spacer()
                
                Text(formattedDueDate(assignment.dueDate))
                    .font(.subheadline)
                    .foregroundColor(.black.opacity(0.5))
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("SecondaryColor"))
        )
    }
    
    // Format the due date
    private func formattedDueDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}






