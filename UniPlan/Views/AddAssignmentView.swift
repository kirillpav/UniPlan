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
    @State private var currentMonth: Date = Date()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    private let days = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.1, green: 0.1, blue: 0.1)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                // Month navigation
                HStack {
                    Text(dateFormatter.string(from: currentMonth))
                        .font(.title2)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    HStack(spacing: 20) {
                        Button(action: {
                            withAnimation {
                                currentMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
                            }
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .font(.title3)
                        }
                        
                        Button(action: {
                            withAnimation {
                                currentMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
                            }
                        }) {
                            Image(systemName: "chevron.right")
                                .foregroundColor(.white)
                                .font(.title3)
                        }
                    }
                }
                .padding(.horizontal)
                
                // Calendar days
                HStack(spacing: 0) {
                    ForEach(days, id: \.self) { day in
                        Text(day)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.white.opacity(0.7))
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal)
                
                // Calendar dates
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 15) {
                    ForEach(getDaysInMonth(), id: \.self) { day in
                        Button(action: {
                            dueDate = day
                        }) {
                            Text(day.formatted(.dateTime.day()))
                                .font(.system(size: 18))
                                .frame(width: 40, height: 40)
                                .background(
                                    ZStack {
                                        if Calendar.current.isDate(day, inSameDayAs: dueDate) {
                                            Circle().fill(Color("PrimaryColor").opacity(0.5))
                                        } else if Calendar.current.isDateInToday(day) {
                                            Circle().stroke(Color.white.opacity(0.5), lineWidth: 1)
                                        }
                                    }
                                )
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Assignment details card
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.white.opacity(0.1))
                    
                    VStack(alignment: .leading, spacing: 15) {
                        // Assignment title
                        TextField("Assignment name", text: $title)
                            .foregroundStyle(Color("PrimaryColor"))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color("PrimaryColor"))
                            .padding(.vertical, 5)
                        
                        // Due date display
                        Text("Due: \(dueDate.formatted(.dateTime.day().month().year()))")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                        
                        if showError {
                            Text("Please enter an assignment title")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                        
                        // Add button
                        Button(action: {
                            if title.isEmpty {
                                showError = true
                            } else {
                                assignmentsViewModel.addAssignment(Assignment(id: UUID(), title: title, dueDate: dueDate, isCompleted: isCompleted, classId: classId))
                                dismiss()
                            }
                        }) {
                            Text("Add Assignment")
                                .font(.headline)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color("PrimaryColor")))
                        }
                        .padding(.top, 10)
                    }
                    .padding(20)
                }
                .frame(height: 200)
            }
            .padding(.vertical)
        }
    }
    
    // Function to get all days in the current month for the calendar
    private func getDaysInMonth() -> [Date] {
        let calendar = Calendar.current
        
        // Get start of the month
        let components = calendar.dateComponents([.year, .month], from: currentMonth)
        guard let startOfMonth = calendar.date(from: components),
              let range = calendar.range(of: .day, in: .month, for: startOfMonth) else {
            return []
        }
        
        // Get the first weekday of the month (e.g., is the 1st a Monday, Tuesday, etc)
        let firstWeekday = calendar.component(.weekday, from: startOfMonth)
        let weekdayOffset = (firstWeekday + 5) % 7 // Adjust for Monday-based week
        
        // Create array with leading empty days + all days in month
        var days: [Date] = []
        
        // Add leading empty spots for proper alignment
        if weekdayOffset > 0 {
            let previousMonth = calendar.date(byAdding: .month, value: -1, to: startOfMonth)!
            let previousMonthDays = calendar.range(of: .day, in: .month, for: previousMonth)!.count
            
            for i in (previousMonthDays - weekdayOffset + 1)...previousMonthDays {
                var previousComponents = calendar.dateComponents([.year, .month], from: previousMonth)
                previousComponents.day = i
                if let date = calendar.date(from: previousComponents) {
                    days.append(date)
                }
            }
        }
        
        // Add days from current month
        for day in range {
            var dateComponents = components
            dateComponents.day = day
            if let date = calendar.date(from: dateComponents) {
                days.append(date)
            }
        }
        
        // Add trailing days to complete a nice grid
        let remainingDays = 42 - days.count // 6 rows of 7 days
        if remainingDays > 0 {
            let nextMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)!
            
            for day in 1...remainingDays {
                var nextComponents = calendar.dateComponents([.year, .month], from: nextMonth)
                nextComponents.day = day
                if let date = calendar.date(from: nextComponents) {
                    days.append(date)
                }
            }
        }
        
        return days
    }
}
