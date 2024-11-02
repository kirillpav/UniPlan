//
//  ContentView.swift
//  UniPlan
//
//  Created by Kirill Pavlov on 11/1/24.
//

import SwiftUI

let backgroundColor = Color(red: 0.157, green: 0.157, blue: 0.169)

struct ContentView: View {
    
    @StateObject private var viewModel = SemesterViewModel()
    @State private var showingAddSemester = false
    
    let semesters = ["Fall '24", "Summer '24", "Spring '24"]
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 16){
            Text("Semesters")
                .font(.title)
                .fontWeight(.bold)
                .padding(.horizontal)
            semesterGrid
        }
        .padding()
        
        
        
        TabView {
            
            Tab("HOME", systemImage: "house") {
                // HomeView()
            }
            
            Tab("TASKS", systemImage: "checklist") {
                //                TaskView()
            }
            
            Tab("SEARCH", systemImage: "magnifyingglass"){
                //                SearchView()
            }
            
            Tab("Account", systemImage: "person.crop.circle.fill") {
                //                AccountView()
            }
        }
        .tint(.black)
        .onAppear {
            UITabBar.appearance().unselectedItemTintColor = .gray
        }
    }
    
    var semesterGrid: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 160), spacing: 16)], spacing: 16) {
            ForEach(viewModel.semesters){
                semester in NavigationLink(destination: SemesterDetailView(semester: semester)) {
                    SemesterCard(semester: semester)
                }
            }
            Button(action: {showingAddSemester = true}) {
                AddSemesterCard()
            }
        }
        .padding()
        //        .sheet()
    }
}


struct SemesterCard: View {
    let semester: Semester
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12).fill(backgroundColor)
            
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(lineWidth: 2)
                .foregroundColor(.white.opacity(0.3))
            
            VStack(spacing: 8) {
                Text(semester.title)
                    .font(.headline)
                    .foregroundStyle(.white)
            }
            .padding()
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

struct AddSemesterCard: View {
    var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(backgroundColor)
                
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [5]))
                    .foregroundColor(.white.opacity(0.3))
                
                VStack(spacing: 8) {
                    Image(systemName: "plus.circle")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                    
                    Text("Add Semester")
                        .font(.headline)
                        .foregroundStyle(.white)
                }
                .padding()
            }
            .aspectRatio(1, contentMode: .fit)
        }
}


#Preview {
    ContentView()
}
