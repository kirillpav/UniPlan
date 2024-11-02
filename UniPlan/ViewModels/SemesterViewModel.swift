//
//  SemesterViewModel.swift
//  UniPlan
//
//  Created by Kirill Pavlov on 11/1/24.
//

import Foundation

class SemesterViewModel: ObservableObject {
    @Published private(set) var semesters: [Semester] = []
    
    func fetchSemester() {
//        loadSemesters()
    }
    
    func addSemester(semester: Semester){
        semesters.append(semester)
        saveSemesters()
    }
    
    private func saveSemesters() {
        if let encoded = try? JSONEncoder().encode(semesters){
            UserDefaults.standard.set(encoded, forKey: "Semesters")
        }
    }
}
