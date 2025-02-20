//
//  Assignment.swift
//  UniPlan
//
//  Created by Kirill Pavlov on 11/1/24.
//

import Foundation

struct Assignment: Identifiable, Codable {
    let id: UUID
    var title: String
    var dueDate: Date
    var isCompleted: Bool
    var classId: UUID
    
    init(id: UUID, title: String, dueDate: Date, isCompleted: Bool, classId: UUID) {
        self.id = id
        self.title = title
        self.dueDate = dueDate
        self.isCompleted = isCompleted
        self.classId = classId
    }
}
