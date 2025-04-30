//
//  Class.swift
//  UniPlan
//
//  Created by Kirill Pavlov on 11/1/24.
//

import Foundation

struct Course: Identifiable, Codable {
    let id: UUID
    var title: String
    var code: String
    var instructor: String
    var instructorEmail: String
    var assignments: [Assignment]
    var startTime: Date
    var endTime: Date
    var date: Date
    var selectedDays: [Weekday]
    var firstDayOfInstruction: Date
    var finalExam: Date
    
    // Class status logic
    var isCompleted: Bool {
        let calendar = Calendar.current
        let today = Date()
        return calendar.compare(today, to: finalExam, toGranularity: .day) == .orderedDescending
    }
    
    var daysString: String {
            let sortedDays = selectedDays.sorted { $0.rawValue < $1.rawValue }
            return sortedDays.map { $0.shortName }.joined(separator: ", ")
        }
        
        // Format the class time as a string (e.g. "9:30 AM - 10:45 AM")
    var timeRangeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return "\(formatter.string(from: startTime)) - \(formatter.string(from: endTime))"
    }
           
    
    init(id: UUID, title: String, code: String, instructor: String, instructorEmail: String, assignments: [Assignment], startTime: Date, endTime: Date, date: Date, selectedDays: [Weekday], firstDayOfInstruction: Date, finalExam: Date) {
        self.id = id
        self.title = title
        self.code = code
        self.instructor = instructor
        self.instructorEmail = instructorEmail
        self.assignments = assignments
        self.startTime = startTime
        self.endTime = endTime
        self.date = date
        self.selectedDays = selectedDays
        self.firstDayOfInstruction = firstDayOfInstruction
        self.finalExam = finalExam
    }
}

extension Weekday: Codable {}
