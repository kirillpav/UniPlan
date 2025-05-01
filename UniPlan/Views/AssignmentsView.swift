//
//  SwiftUIView.swift
//  UniPlan
//
//  Created by Kirill Pavlov on 3/16/25.
//

import SwiftUI

struct AssignmentsView: View {
    @StateObject var assignmentsViewModel = AssignmentsViewModel()
    
    var filterPredicate: ((Assignment) -> Bool)? = nil
    
    init(filterPredicate: ((Assignment) -> Bool)? = nil) {
        self.filterPredicate = filterPredicate
    }
    
    
    var body: some View {
        List {
            let filteredAssignments = filterPredicate != nil ? assignmentsViewModel.assignments.filter(filterPredicate!) : assignmentsViewModel.assignments
            
            ForEach(filteredAssignments) { assignment in
                let associatedClass = assignmentsViewModel.getClassForAssignment(assignment)
                
                AssignmentRow(assignment: assignment, assignmentCourse: associatedClass) {
                    assignmentsViewModel.toggleAssignmentCompletion(assignmentId: assignment.id)
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
                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                    Button {
                        assignmentsViewModel.toggleAssignmentCompletion(assignmentId: assignment.id)
                    } label: {
                        Label("Complete", systemImage: "checkmark.rectangle.stack")
                    }
                    .tint(.green)
                }
            }

        }
        .listStyle(PlainListStyle())
        .onAppear {
            assignmentsViewModel.fetchCourses()
            assignmentsViewModel.fetchAssignments()
        }
    }
}

struct AssignmentsView_Previews: PreviewProvider {
    static var previews: some View {
        AssignmentsView()
    }
}
