//
//  Class.swift
//  UniPlan
//
//  Created by Kirill Pavlov on 11/1/24.
//

import Foundation

struct Class: Identifiable, Codable {
    let id: UUID
    var title: String
    var instructor: String
    var instructorEmail: String
    var assignments: [Assignment]
    var schedule: [Date]
    
//    Figure out how to do scheduling
    
    init(id: UUID, title: String, instructor: String, instructorEmail: String, assignments: [Assignment], schedule: [Date]) {
        self.id = id
        self.title = title
        self.instructor = instructor
        self.instructorEmail = instructorEmail
        self.assignments = assignments
        self.schedule = schedule
    }
}
