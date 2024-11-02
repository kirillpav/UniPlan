//
//  Semesters.swift
//  UniPlan
//
//  Created by Kirill Pavlov on 11/1/24.
//

import Foundation

struct Semester: Identifiable, Encodable {
    let id: UUID
    var title: String
    var startDate: Date
    var endDate: Date
    var classes: [Class] // <- Will add later
    
    init(id: UUID = UUID(), title: String, startDate: Date, endDate: Date, classes: [Class] = []) {
        self.id = id
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.classes = classes
    }
}
