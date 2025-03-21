import SwiftUI

struct HomeView: View {
    @StateObject private var classViewModel = ClassViewModel()
    @StateObject private var assignmentsViewModel = AssignmentsViewModel()
    
    @State private var selectedCategory: Category = .today
    
    // Enum for view selections
    enum Category: String, CaseIterable {
        case today = "Today"
        case assignments = "Assignments"
        case allCourses = "All Courses"
    }
    
    let currentDate = Date()
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Greeting section
                VStack(alignment: .leading, spacing: 0) {
                    Text("Hello,")
                        .font(.system(size: 40, weight: .regular))
                    
                    Text("Timothy Jones")
                        .font(.system(size: 40, weight: .bold))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.top, 10)
                
                // Horizontal filters/categories
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(Category.allCases, id: \.self) { category in
                            CategoryPill(
                                title: category.rawValue,
                                isSelected: selectedCategory == category
                            )
                            .onTapGesture {
                                selectedCategory = category
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 20)
                }
                
                if selectedCategory == .allCourses {
                    ClassesView()
                } else if selectedCategory == .assignments {
                    AssignmentsView()
                } else {
                    upcomingView
                    Spacer()
                    dueTodayView
                }
                // Bottom navigation bar
                HStack(spacing: 0) {
                    TabBarButton(icon: "house.fill")
                    TabBarButton(icon: "calendar")
                    
                    TabBarButton(icon: "chart.bar.fill")
                    TabBarButton(icon: "hexagon")
                }
                .frame(height: 90)
                .background(Color("SecondaryColor"))
                .cornerRadius(20)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(Color(UIColor.systemBackground))
        .onAppear {
            classViewModel.fetchClasses()
        }
    }
    
    // upcoming view section
    private var upcomingView: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Upcoming")
                    .font(.system(size: 32, weight: .bold))
                Spacer()
            }
            .padding(.horizontal)
            
            if classViewModel.classes.isEmpty {
                // Empty state
                VStack(spacing: 16) {
                    Spacer()
                    
                    Image(systemName: "calendar.badge.plus")
                        .font(.system(size: 50))
                        .foregroundColor(.gray.opacity(0.5))
                        .padding()
                    
                    Text("No upcoming classes")
                        .font(.title3)
                        .foregroundColor(.gray)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 60)
            } else {
                // Course cards from view model
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(classViewModel.classes) { classItem in
                            let assignmentCount = assignmentsViewModel.assignments.filter { $0.classId == classItem.id }.count
                            
                            ClassCard(classId: classItem.id,title: classItem.title, instructor: classItem.instructor, instructorEmail: classItem.instructorEmail, numberOfAssignments: assignmentCount, date: classItem.daysString, timeRange: classItem.timeRangeString)
                                
                        }
                    }
                }
            }
        }
        
    }
    
    // Due today View
    private var dueTodayView: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Due Today")
                    .font(.system(size: 32, weight: .bold))
                Spacer()
            }
            .padding(.horizontal)
            
            ScrollView() {
                LazyVStack(spacing: 16) {
                    ForEach(assignmentsViewModel.assignments) { assignment in
                        //                        let _ = assignmentsViewModel.assignments.filter { Calendar.current.isDate($0.dueDate, inSameDayAs: currentDate) }
                        
                        if Calendar.current.isDate(assignment.dueDate, inSameDayAs: currentDate) {
                            AssignmentRow(assignment: assignment) {
                                if let index = assignmentsViewModel.assignments.firstIndex(where: { $0.id == assignment.id }) {
                                    assignmentsViewModel.assignments[index].isCompleted.toggle()
                                    assignmentsViewModel.saveAssignments()
                                }
                            }
                            .padding(.horizontal)
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
                }
            }
        }
    }
    
    
    // Helper methods for formatting date and time
        private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM, yy"
        return formatter.string(from: date)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
}

// Upcoming view
//private var UpcomingView: some View {
//    
//}

// Category pill component (unchanged)
struct CategoryPill: View {
    let title: String
    let isSelected: Bool
    
    var body: some View {
        Text(title)
            .font(.system(size: 16, weight: .medium))
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(isSelected ? Color(UIColor.systemGray6) : Color.white)
            .foregroundColor(.black)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(Color(UIColor.systemGray5), lineWidth: isSelected ? 0 : 1)
            )
    }
}

// Tab bar button component (unchanged)
struct TabBarButton: View {
    let icon: String
    
    var body: some View {
        Button(action: {
            // Tab action
        }) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
        }
    }
}

// This is an assumed structure of your Class model
// Replace with your actual Class model implementation if different
// struct Class: Identifiable, Codable {
//     var id: UUID
//     var title: String
//     var instructor: String
//     var date: Date
//     var startTime: Date
//     var endTime: Date
// }

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
