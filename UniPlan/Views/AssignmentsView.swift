//
//  SwiftUIView.swift
//  UniPlan
//
//  Created by Kirill Pavlov on 3/16/25.
//

import SwiftUI

struct AssignmentsView: View {
    @StateObject var assignmentsViewModel = AssignmentsViewModel()
    
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(assignmentsViewModel.assignments) { assignment in
                    let associatedClass = assignmentsViewModel.getClassForAssignment(assignment)
                    
                    AssignmentRow(assignment: assignment, assignmentCourse: associatedClass) {
                        if let index = assignmentsViewModel.assignments.firstIndex(where: { $0.id == assignment.id }) {
                            assignmentsViewModel.assignments[index].isCompleted.toggle()
                            assignmentsViewModel.saveAssignments()
                        }
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets())
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            assignmentsViewModel.deleteAssignment(assignment)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .padding(.horizontal)
            
        }
    }
}

