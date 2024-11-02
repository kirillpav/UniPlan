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
        List {
            // Header Section
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Semester Duration")
                        .font(.headline)
                    Text("\(semester.startDate.formatted(date: .abbreviated, time: .omitted)) - \(semester.endDate.formatted(date: .abbreviated, time: .omitted))")
                        
                }
            }
        }
    }
}

            
//            // Classes Section
//            Section(header: Text("Classes")) {
//                if semester.classes.isEmpty {
//                    Text("No classes added yet")
//                        .foregroundStyle(.secondary)
//                } else {
//                    ForEach(semester.classes) { class in
//                        ClassRow(class: class)
//                    }
//                }
//            }
//        }
//        .navigationTitle(semester.title)
//        .toolbar {
//            ToolbarItem(placement: .primaryAction) {
//                Button(action: { showingAddClass = true }) {
//                    Image(systemName: "plus")
//                }
//            }
//        }
//        .sheet(isPresented: $showingAddClass) {
//            // You'll need to create an AddClassView similar to AddSemesterView
//            Text("Add Class Form Coming Soon")
//        }


// Add this struct for displaying class rows
//struct ClassRow: View {
//    let class: Class
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 4) {
//            Text(class.name)
//                .font(.headline)
//            if let professor = class.professor {
//                Text(professor)
//                    .font(.subheadline)
//                    .foregroundStyle(.secondary)
//            }
//        }
//    }
//}

