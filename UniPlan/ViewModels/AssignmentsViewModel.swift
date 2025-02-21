//
//  AssignmentsViewModel.swift
//  UniPlan
//
//  Created by Kirill Pavlov on 2/18/25.
//

import Foundation

class AssignmentsViewModel: ObservableObject {
    @Published var assignments: [Assignment] = []

    init() {
        fetchAssignments()
    }
    
    private func saveAssignments() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(assignments) {
            UserDefaults.standard.set(encoded, forKey: "assignments")
        }
    }

    func addAssignment(_ assignment: Assignment) {
        assignments.append(assignment)
        saveAssignments()
    }

    private func fetchAssignments() {
        if let encoded = UserDefaults.standard.data(forKey: "assignments") {
            if let decoded = try? JSONDecoder().decode([Assignment].self, from: encoded) {
                assignments = decoded
            }
        }
    }
    
    
    
}
