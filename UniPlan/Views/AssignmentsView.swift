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
                }
            }
            .padding(.horizontal)
            .onAppear {
                assignmentsViewModel.fetchCourses()
            }
            
        }
    }
}


struct AssignmentsView_Previews: PreviewProvider {
    static var previews: some View {
        AssignmentsView()
    }
}
