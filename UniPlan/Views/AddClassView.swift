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
    
    // Schedule states
    @State private var startDate = Date()
    @State private var startTime = Date()
    @State private var endTime = Date().addingTimeInterval(3600) // 1 hour later by default
    @State private var isRecurring = false
    @State private var recurringPattern: RecurringPattern = .weekly
    @State private var selectedDays: [Weekday] = []
    
    // Custom colors
    private let accentColor = Color("AccentColor") // Create this in Assets.xcassets
    private var backgroundColor: Color { colorScheme == .dark ? Color.black.opacity(0.8) : Color.white }
    private var textColor: Color { colorScheme == .dark ? Color.white : Color.black.opacity(0.8) }
    
    var body: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("New Class")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(textColor)
                    
                    // Basic info section
                    VStack(spacing: 20) {
                        inputField(title: "Class Title", text: $title, placeholder: "e.g. Biology 101")
                        
                        inputField(title: "Instructor", text: $instructor, placeholder: "e.g. Dr. Smith")
                        
                        inputField(title: "Email", text: $instructorEmail, placeholder: "e.g. smith@university.edu")
                    }
                    
                    // Schedule section
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Schedule")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(textColor)
                        
                        // Date picker
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Start Date")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(textColor.opacity(0.7))
                            
                            DatePicker("", selection: $startDate, displayedComponents: .date)
                                .datePickerStyle(.compact)
                                .labelsHidden()
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        // Time pickers
                        HStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Start Time")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(textColor.opacity(0.7))
                                
                                DatePicker("", selection: $startTime, displayedComponents: .hourAndMinute)
                                    .datePickerStyle(.compact)
                                    .labelsHidden()
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("End Time")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(textColor.opacity(0.7))
                                
                                DatePicker("", selection: $endTime, displayedComponents: .hourAndMinute)
                                    .datePickerStyle(.compact)
                                    .labelsHidden()
                            }
                        }
                        
                        // Recurring toggle
                        Toggle(isOn: $isRecurring) {
                            Text("Recurring Class")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(textColor)
                        }
                        .toggleStyle(SwitchToggleStyle(tint: accentColor))
                        
                        // Recurring options - only show if recurring is enabled
                        if isRecurring {
                            VStack(alignment: .leading, spacing: 16) {
                                // Recurring pattern
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Repeat")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(textColor.opacity(0.7))
                                    
                                    Picker("", selection: $recurringPattern) {
                                        Text("Daily").tag(RecurringPattern.daily)
                                        Text("Weekly").tag(RecurringPattern.weekly)
                                        Text("Monthly").tag(RecurringPattern.monthly)
                                    }
                                    .pickerStyle(.segmented)
                                    .background(colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.03))
                                    .cornerRadius(8)
                                }
                                
                                // Day selection for weekly pattern
                                if recurringPattern == .weekly {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Days")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .foregroundColor(textColor.opacity(0.7))
                                        
                                        WeekdaySelector(selectedDays: $selectedDays)
                                    }
                                }
                            }
                        }
                    }
                    
                    Spacer(minLength: 30)
                    
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
                                // Extract dates from class sessions
                                let schedule = createClassSchedule()
                                let sessionDates = schedule.map { $0.startTime }
                                
                                // Create and add the class
                                classViewModel.addClass(Class(
                                    id: UUID(),
                                    title: title,
                                    instructor: instructor,
                                    instructorEmail: instructorEmail,
                                    assignments: [],
                                    schedule: sessionDates
                                ))
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
    
    // Helper function to create class schedule based on user selections
    private func createClassSchedule() -> [ClassSession] {
        var sessions: [ClassSession] = []
        
        // Create the initial date components
        var components = Calendar.current.dateComponents([.year, .month, .day], from: startDate)
        
        // Set the time components from the time pickers
        let startComponents = Calendar.current.dateComponents([.hour, .minute], from: startTime)
        let endComponents = Calendar.current.dateComponents([.hour, .minute], from: endTime)
        
        components.hour = startComponents.hour
        components.minute = startComponents.minute
        
        let startDateTime = Calendar.current.date(from: components)!
        
        components.hour = endComponents.hour
        components.minute = endComponents.minute
        
        let endDateTime = Calendar.current.date(from: components)!
        
        // Add the first session
        sessions.append(ClassSession(startTime: startDateTime, endTime: endDateTime))
        
        // If recurring, add more sessions
        if isRecurring {
            // Generate dates for the next 15 occurrences
            let occurrenceCount = 15
            
            switch recurringPattern {
            case .daily:
                for i in 1..<occurrenceCount {
                    if let newStart = Calendar.current.date(byAdding: .day, value: i, to: startDateTime),
                       let newEnd = Calendar.current.date(byAdding: .day, value: i, to: endDateTime) {
                        sessions.append(ClassSession(startTime: newStart, endTime: newEnd))
                    }
                }
                
            case .weekly:
                // If no days selected, use the same day of week as the start date
                if selectedDays.isEmpty {
                    let weekday = Calendar.current.component(.weekday, from: startDate)
                    let adjustedWeekday = weekday == 1 ? 7 : weekday - 1 // Convert to Mon=1, Sun=7 format
                    selectedDays = [Weekday(rawValue: adjustedWeekday) ?? .monday]
                }
                
                // Get all occurrences for the selected days in the next several weeks
                for week in 0..<(occurrenceCount / selectedDays.count + 1) {
                    for day in selectedDays {
                        // Skip first week's day if it's the same as the start date day
                        if week == 0 && day.rawValue == (Calendar.current.component(.weekday, from: startDate) - 1) {
                            continue
                        }
                        
                        // Calculate the next date for this weekday
                        if var newComponents = getNextWeekdayComponents(after: startDate, weekday: day, weeksToAdd: week) {
                            // Set time from the original selections
                            newComponents.hour = startComponents.hour
                            newComponents.minute = startComponents.minute
                            
                            if let newStart = Calendar.current.date(from: newComponents) {
                                // Calculate session duration
                                let duration = endDateTime.timeIntervalSince(startDateTime)
                                let newEnd = newStart.addingTimeInterval(duration)
                                
                                sessions.append(ClassSession(startTime: newStart, endTime: newEnd))
                                
                                if sessions.count >= occurrenceCount {
                                    break
                                }
                            }
                        }
                    }
                }
                
            case .monthly:
                for i in 1..<occurrenceCount {
                    if let newStart = Calendar.current.date(byAdding: .month, value: i, to: startDateTime),
                       let newEnd = Calendar.current.date(byAdding: .month, value: i, to: endDateTime) {
                        sessions.append(ClassSession(startTime: newStart, endTime: newEnd))
                    }
                }
            }
        }
        
        return sessions.sorted { $0.startTime < $1.startTime }
    }
    
    // Helper to get the next occurrence of a weekday
    private func getNextWeekdayComponents(after date: Date, weekday: Weekday, weeksToAdd: Int) -> DateComponents? {
        let calendar = Calendar.current
        
        // Get the current weekday (1 = Sunday, 2 = Monday, ..., 7 = Saturday)
        let currentWeekday = calendar.component(.weekday, from: date)
        
        // Convert our weekday (Monday = 1) to Calendar weekday (Sunday = 1)
        let targetWeekday = weekday.rawValue == 7 ? 1 : weekday.rawValue + 1
        
        // Calculate days to add
        var daysToAdd = targetWeekday - currentWeekday
        if daysToAdd <= 0 {
            daysToAdd += 7 // Move to next week if the day has already passed this week
        }
        
        // Add extra weeks
        daysToAdd += weeksToAdd * 7
        
        if let nextDate = calendar.date(byAdding: .day, value: daysToAdd, to: date) {
            return calendar.dateComponents([.year, .month, .day, .hour, .minute], from: nextDate)
        }
        
        return nil
    }
}

// MARK: - Supporting Types

// Recurring pattern types
enum RecurringPattern {
    case daily, weekly, monthly
}

// Weekday enum for selection
enum Weekday: Int, CaseIterable, Identifiable {
    case monday = 1, tuesday, wednesday, thursday, friday, saturday, sunday
    
    var id: Int { self.rawValue }
    
    var shortName: String {
        switch self {
        case .monday: return "M"
        case .tuesday: return "T"
        case .wednesday: return "W"
        case .thursday: return "T"
        case .friday: return "F"
        case .saturday: return "S"
        case .sunday: return "S"
        }
    }
}

// Class Session struct to represent a single occurrence
struct ClassSession: Identifiable, Codable {
    var id = UUID()
    var startTime: Date
    var endTime: Date
}

// MARK: - Weekday Selector Component

struct WeekdaySelector: View {
    @Binding var selectedDays: [Weekday]
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(Weekday.allCases) { day in
                WeekdayButton(
                    day: day,
                    isSelected: selectedDays.contains(day),
                    action: {
                        if selectedDays.contains(day) {
                            selectedDays.removeAll { $0 == day }
                        } else {
                            selectedDays.append(day)
                        }
                    }
                )
            }
        }
    }
}

struct WeekdayButton: View {
    let day: Weekday
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(day.shortName)
                .font(.system(size: 14, weight: .medium))
                .frame(width: 36, height: 36)
                .background(isSelected ? Color("AccentColor") : Color.gray.opacity(0.2))
                .foregroundColor(isSelected ? .white : .primary)
                .clipShape(Circle())
        }
    }
}
