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
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading, spacing: 0) {
                Text("Semesters")
                    .fontWeight(.bold)
                    .padding(.horizontal)
                    .padding(.top)
                HStack {
                    BasicDropdownMenu(viewModel: viewModel).padding()
                    // semesterGrid
                    Button(action: {showingAddSemester = true}) {
                        AddSemesterCard()
                    }
                    .padding(.trailing)
                }
                .sheet(isPresented: $showingAddSemester) {
                    AddSemesterView(viewModel: viewModel)
                }
                
            }
            .padding(.top, 1)
        }
        
        TabView {
            
            Tab("DASHBOARD", systemImage: "house") {
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
    
    
    
}


struct SemesterCard: View {
    let semester: Semester
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12).fill(backgroundColor)
            
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(backgroundColor)
            
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
                    .foregroundColor(backgroundColor)
                
                HStack {
                    Image(systemName: "plus.circle")
                        .font(.title2)
                        .foregroundColor(.white)
                    
                    Text("Add")
                        .font(.headline)
                        .foregroundStyle(.white)
                }
                .padding()
            }
            .frame(height: 40)
        }
}

struct BasicDropdownMenu: View {
    @State private var selectedOption: String = "Select a semester"
    @ObservedObject var viewModel: SemesterViewModel
    
    var body: some View {
        Menu {
            ForEach(viewModel.semesters) { semester in 
                Button(action: { 
                    selectedOption = semester.title 
                }) {
                    Text(semester.title)
                        .foregroundColor(.black)
                }
            }
        } label: {
            Label(selectedOption, systemImage: "chevron.down")
                .padding()
                .frame(width: 200)
                .background(backgroundColor)
                .foregroundColor(.white)
                .cornerRadius(12)
        }
    }
}

//struct ClassRow: View {
//    let scheduleItem: Class
//    
//    private let timeFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.timeStyle = .short
//        return formatter
//    }()
//    
//    var body: some View {
//        
//    }
//}


#Preview {
    ContentView()
}
