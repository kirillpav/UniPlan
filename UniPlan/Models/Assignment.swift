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
    var description: String
    var dueDate: Date
    var isCompleted: Bool
    
    init(id: UUID, title: String, description: String, dueDate: Date, isCompleted: Bool) {
        self.id = id
        self.title = title
        self.description = description
        self.dueDate = dueDate
        self.isCompleted = isCompleted
    }
}
