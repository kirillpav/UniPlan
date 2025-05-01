//
//  AssignmentRow.swift
//  UniPlan
//
//  Created by Kirill Pavlov on 3/16/25.
//

import SwiftUI

struct AssignmentRow: View {
    
    var assignment: Assignment
    var assignmentCourse: Course?
    var toggleCompletion: () -> Void
    
    
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .background(Color.white)
                .frame(height: 1)
            
            HStack(spacing: 16) {
                // Completion circle
//                Button(action: toggleCompletion) {
//                    ZStack {
//                        Circle()
//                            .strokeBorder(Color.white, lineWidth: 1.5)
//                            .frame(width: 24, height: 24)
//                        
//                        if assignment.isCompleted {
//                            Circle()
//                                .fill(Color.black.opacity(0.3))
//                                .frame(width: 18, height: 18)
//                            
//                        }
//                    }
//                }
                
                // Assignment details
                HStack(spacing: 4) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(assignment.title)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(assignment.isCompleted ? Color("PrimaryColor") : .gray)
                            .strikethrough(assignment.isCompleted)
                        
                        if let course = assignmentCourse {
                            Text(course.title)
                                .font(.subheadline)
                                .foregroundColor(Color("AccentColor"))
                        }
                    }
                    
                    Spacer()
                    
                    Text(formattedDueDate(assignment.dueDate))
                        .font(.subheadline)
                        .foregroundColor(Color("AccentColor"))
                }
                
                Spacer()
            }
            .padding(16)
        }
    }
    
    // Format the due date
    private func formattedDueDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
