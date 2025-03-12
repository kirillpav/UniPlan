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
    @State private var startTime = Date()
    @State private var endTime = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
    @State private var selectedDays: [Weekday] = []
    @State private var firstDayOfInstruction = Date() // First class session
    @State private var finalExamDate = Calendar.current.date(byAdding: .month, value: 3, to: Date())! // Final exam date
    
    // Custom colors
    private let accentColor = Color("AccentColor")
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
                        
                        // Day selection
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Days")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(textColor.opacity(0.7))
                            
                            WeekdaySelector(selectedDays: $selectedDays)
                        }
                        
                        // Time range pickers
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Time")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(textColor.opacity(0.7))
                            
                            HStack(spacing: 12) {
                                VStack(alignment: .leading) {
                                    Text("From")
                                        .font(.caption)
                                        .foregroundColor(textColor.opacity(0.6))
                                    
                                    DatePicker("", selection: $startTime, displayedComponents: .hourAndMinute)
                                        .datePickerStyle(.compact)
                                        .labelsHidden()
                                        .onChange(of: startTime) { newValue in
                                            // If end time is earlier than start time, set it to start time + 1 hour
                                            if endTime < startTime {
                                                endTime = Calendar.current.date(byAdding: .hour, value: 1, to: startTime)!
                                            }
                                        }
                                }
                                
                                VStack(alignment: .leading) {
                                    Text("To")
                                        .font(.caption)
                                        .foregroundColor(textColor.opacity(0.6))
                                    
                                    DatePicker("", selection: $endTime, displayedComponents: .hourAndMinute)
                                        .datePickerStyle(.compact)
                                        .labelsHidden()
                                }
                            }
                        }
                        
                        // Course dates
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Course Dates")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(textColor.opacity(0.7))
                            
                            HStack(spacing: 12) {
                                VStack(alignment: .leading) {
                                    Text("First Day")
                                        .font(.caption)
                                        .foregroundColor(textColor.opacity(0.6))
                                    
                                    DatePicker("", selection: $firstDayOfInstruction, displayedComponents: .date)
                                        .datePickerStyle(.compact)
                                        .labelsHidden()
                                        .onChange(of: firstDayOfInstruction) { newValue in
                                            // If first day is after final exam, adjust final exam
                                            if finalExamDate < newValue {
                                                finalExamDate = Calendar.current.date(byAdding: .month, value: 3, to: newValue)!
                                            }
                                        }
                                }
                                
                                VStack(alignment: .leading) {
                                    Text("Final Exam")
                                        .font(.caption)
                                        .foregroundColor(textColor.opacity(0.6))
                                    
                                    DatePicker("", selection: $finalExamDate, displayedComponents: .date)
                                        .datePickerStyle(.compact)
                                        .labelsHidden()
                                        .onChange(of: finalExamDate) { newValue in
                                            // Ensure final exam is after first day
                                            if newValue < firstDayOfInstruction {
                                                finalExamDate = firstDayOfInstruction
                                            }
                                        }
                                }
                            }
                        }
                    }
                    
                    Spacer(minLength: 30)
                    
                    VStack(spacing: 16) {
                        if showError {
                            if title.isEmpty {
                                Text("Please enter a class title")
                                    .font(.caption)
                                    .foregroundColor(.red)
                                    .padding(.horizontal)
                            } else if selectedDays.isEmpty {
                                Text("Please select at least one day")
                                    .font(.caption)
                                    .foregroundColor(.red)
                                    .padding(.horizontal)
                            } else if endTime <= startTime {
                                Text("End time must be after start time")
                                    .font(.caption)
                                    .foregroundColor(.red)
                                    .padding(.horizontal)
                            } else if finalExamDate < firstDayOfInstruction {
                                Text("Final exam must be after first day of instruction")
                                    .font(.caption)
                                    .foregroundColor(.red)
                                    .padding(.horizontal)
                            }
                        }
                        
                        Button(action: {
                            if title.isEmpty {
                                showError = true
                            } else if selectedDays.isEmpty {
                                showError = true
                            } else if endTime <= startTime {
                                showError = true
                            } else if finalExamDate < firstDayOfInstruction {
                                showError = true
                            } else {
                                // Find the first occurrence date based on selected days and firstDayOfInstruction
                                if let firstDate = getNextOccurrenceDate() {
                                    // Extract time components
                                    let startTimeComponents = Calendar.current.dateComponents([.hour, .minute], from: startTime)
                                    let endTimeComponents = Calendar.current.dateComponents([.hour, .minute], from: endTime)
                                    
                                    // Create date with just the date part
                                    let classDate = firstDate
                                    
                                    // Create start time by combining date and time components
                                    var fullStartTime = Calendar.current.date(from:
                                        Calendar.current.dateComponents([.year, .month, .day], from: firstDate))!
                                    fullStartTime = Calendar.current.date(bySettingHour: startTimeComponents.hour!, minute: startTimeComponents.minute!, second: 0, of: fullStartTime)!
                                    
                                    // Create end time by combining date and time components
                                    var fullEndTime = Calendar.current.date(from:
                                        Calendar.current.dateComponents([.year, .month, .day], from: firstDate))!
                                    fullEndTime = Calendar.current.date(bySettingHour: endTimeComponents.hour!, minute: endTimeComponents.minute!, second: 0, of: fullEndTime)!
                                    
                                    classViewModel.addClass(Class(
                                        id: UUID(),
                                        title: title,
                                        instructor: instructor,
                                        instructorEmail: instructorEmail,
                                        assignments: [],
                                        startTime: fullStartTime,
                                        endTime: fullEndTime,
                                        date: classDate,
                                        selectedDays: selectedDays,
                                        firstDayOfInstruction: firstDayOfInstruction,
                                        finalExam: finalExamDate
                                    ))
                                    dismiss()
                                }
                            }
                        }) {
                            Text("Add Class")
                                .fontWeight(.medium)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(title.isEmpty || selectedDays.isEmpty ? accentColor.opacity(0.5) : accentColor)
                                .cornerRadius(12)
                        }
                        .disabled(title.isEmpty || selectedDays.isEmpty || endTime <= startTime || finalExamDate < firstDayOfInstruction)
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
    
    // Helper to get the next occurrence date based on selected days and firstDayOfInstruction
    private func getNextOccurrenceDate() -> Date? {
        guard !selectedDays.isEmpty else { return nil }
        
        let calendar = Calendar.current
        let currentWeekday = calendar.component(.weekday, from: firstDayOfInstruction)
        
        // Find the closest selected day
        var closestDay: Weekday?
        var minDaysToAdd = Int.max
        
        for day in selectedDays {
            // Convert our weekday (Monday = 1) to Calendar weekday (Sunday = 1)
            let targetWeekday = day.rawValue == 7 ? 1 : day.rawValue + 1
            
            // Calculate days to add
            var daysToAdd = targetWeekday - currentWeekday
            if daysToAdd < 0 {
                daysToAdd += 7 // Move to next week if the day has already passed this week
            }
            
            if daysToAdd < minDaysToAdd {
                minDaysToAdd = daysToAdd
                closestDay = day
            }
        }
        
        if let _ = closestDay, minDaysToAdd != Int.max {
            return calendar.date(byAdding: .day, value: minDaysToAdd, to: firstDayOfInstruction)
        }
        
        return nil
    }
}

// MARK: - Supporting Types

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
