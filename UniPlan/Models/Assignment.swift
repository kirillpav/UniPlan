//
//  Assignment.swift
//  UniPlan
//
//  Created by Kirill Pavlov on 11/1/24.
//

import Foundation

struct Assignment: Identifiable, Codable {
    let id: UUID
    var classId: UUID
    var title: String
    var dueDate: Date
    var status: String?
    var isCompleted: Bool
    
    // Computed property to get the course title
    var courseTitle: String {
        // This will be populated by the view model
        return ""
    }
    
    init(id: UUID, title: String, dueDate: Date, isCompleted: Bool, classId: UUID) {
        self.id = id
        self.title = title
        self.dueDate = dueDate

        self.isCompleted = isCompleted
        self.classId = classId
    }
}
