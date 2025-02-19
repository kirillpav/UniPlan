//
//  AddSemesterView.swift
//  UniPlan
//
//  Created by Kirill Pavlov on 11/2/24.
//

import SwiftUI

struct AddSemesterView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: SemesterViewModel
    
    @State private var title = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    
    var body: some View {
        
        NavigationView {
            Form {
                Section(header: Text("Semester Information")){
                    TextField("Semester Name", text: $title)
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                    DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                }
            }
            .navigationTitle("Add Semester")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction){
                    Button("Save") {
                        saveSemester()
                    }
                    .disabled(title.isEmpty || endDate <= startDate)
                }
                
            }
            
        }
    }
    
    private func saveSemester() {
        let newSemester = Semester(title: title, startDate: startDate, endDate: endDate, classes: [])
        viewModel.addSemester(semester: newSemester)
        dismiss()
    }
}

//#Preview {
//    AddSemesterView()
//}
