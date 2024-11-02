//
//  SwiftUIView.swift
//  UniPlan
//
//  Created by Kirill Pavlov on 11/1/24.
//

import SwiftUI

struct SemesterDetailView: View {
    let semester: Semester
    @State private var showingAddClass = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            VStack(alignment: .leading, spacing: 8) {
                Text("Semester Duration")
                    .font(.headline)
                Text("\(semester.startDate.formatted(date: .abbreviated, time: .omitted)) - \(semester.endDate.formatted(date: .abbreviated, time: .omitted))")
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal)
            
            // Classes List
            
            
        }
        .navigationTitle(semester.title)
        .toolbar {
            Button(action: { showingAddClass = true }) {
                Image(systemName: "plus")
            }
        }
    
    }
}

//#Preview {
//    SemesterDetailView()
//}
