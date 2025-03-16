//
//  AssignmentsViewModel.swift
//  UniPlan
//
//  Created by Kirill Pavlov on 2/18/25.
//

import Foundation

class AssignmentsViewModel: ObservableObject {
    @Published var assignments: [Assignment] = []
    @Published var classes: [Class] = []
    
    init() {
        fetchAssignments()
        fetchClasses()
    }
    
    func saveAssignments() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(assignments) {
            UserDefaults.standard.set(encoded, forKey: "assignments")
        }
    }
    
    func addAssignment(_ assignment: Assignment) {
        assignments.append(assignment)
        saveAssignments()
    }
    
    func fetchAssignments() {
        if let encoded = UserDefaults.standard.data(forKey: "assignments") {
            if let decoded = try? JSONDecoder().decode([Assignment].self, from: encoded) {
                assignments = decoded
            }
        }
    }
    
    func fetchClasses() {
        if let encoded = UserDefaults.standard.data(forKey: "classes") {
            if let decoded = try? JSONDecoder().decode([Class].self, from: encoded) {
                classes = decoded
            }
        }
    }
    
    func getClassForAssignment(_ assignment: Assignment) -> Class? {
        return classes.first(where: { $0.id == assignment.classId })
    }
    
    func toggleAssignmentCompletion(assignmentId: UUID) {
        if let index = assignments.firstIndex(where: { $0.id == assignmentId}) {
            var updatedAssignment = assignments[index]
            updatedAssignment.isCompleted.toggle()
            
            assignments[index] = updatedAssignment
            saveAssignments()
        }
    }
    
    func deleteAssignment(_ assignment: Assignment) {
        if let index = assignments.firstIndex(where: { $0.id == assignment.id }) {
            assignments.remove(at: index)
            saveAssignments()
        }
    }
    
}
