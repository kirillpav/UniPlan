import SwiftUI

struct HomeView: View {
    @StateObject private var classViewModel = ClassViewModel()
    
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
                        CategoryPill(title: "All courses", isSelected: true)
                        CategoryPill(title: "Design", isSelected: false)
                        CategoryPill(title: "Language", isSelected: false)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 20)
                }
                
                // Upcoming section
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
                                    CourseCard(
                                        title: classItem.title,
                                        teacher: classItem.instructor,
                                        teacherTitle: "Teacher",
                                        time: formatTime(classItem.startTime),
                                        date: formatDate(classItem.date)
                                    )
                                }
                            }
                        }
                    }
                    
                    Spacer()
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

// Course card component (unchanged)
struct CourseCard: View {
    let title: String
    let teacher: String
    let teacherTitle: String
    let time: String
    let date: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                // Date
                HStack(spacing: 6) {
                    Image(systemName: "calendar")
                        .font(.system(size: 16))
                    
                    Text(date)
                        .font(.system(size: 14))
                }
            }
            
            if !title.isEmpty {
                // Title and teacher
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 28, weight: .bold))
                    
                    HStack(spacing: 4) {
                        Text(teacher)
                            .font(.system(size: 16))
                        
                        Text("(\(teacherTitle))")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }
                }
                
                // Bottom section with time and open button
                HStack {
                    // Time
                    HStack(spacing: 8) {
                        Image(systemName: "clock")
                            .font(.system(size: 16))
                        
                        Text(time)
                            .font(.system(size: 16, weight: .medium))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(.white)
                    .clipShape(Capsule())
                    
                    Spacer()
                    
                    // Open button
                    ZStack {
                        Circle()
                            .fill(.white)
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: "arrow.up.right")
                            .font(.system(size: 20))
                    }
                }
            }
        }
        .padding(20)
        .background(Color("SecondaryColor"))
        .cornerRadius(20)
        .padding(.horizontal)
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
