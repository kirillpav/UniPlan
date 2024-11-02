//
//  ContentView.swift
//  UniPlan
//
//  Created by Kirill Pavlov on 11/1/24.
//

import SwiftUI

let backgroundColor = Color(red: 0.157, green: 0.157, blue: 0.169)

struct ContentView: View {
    
    let semesters = ["Fall '24", "Summer '24", "Spring '24"]
    
    var body: some View {
        
        VStack{
            Text("Your Semesters: ")
            semesterCard
        }
        .padding()
        
        
        
        TabView {
            
            Tab("HOME", systemImage: "house") {
                
            }
            
            Tab("TASKS", systemImage: "checklist") {
                
            }
            
            Tab("SEARCH", systemImage: "magnifyingglass"){
                
            }
            
            Tab("Account", systemImage: "person.crop.circle.fill") {
                
            }
        }
        .tint(.black)
        .onAppear {
            UITabBar.appearance().unselectedItemTintColor = .gray
        }
    }
    var semesterCard: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))]) {
            ForEach(0..<semesters.count, id: \.self){
                index in SemesterView(content: semesters[index])
                    .aspectRatio(1, contentMode: .fit)
            }
            
        }
    }
    
}


struct SemesterView: View {
    let content: String
    
    
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12)
            Group{
                base.fill(backgroundColor)
                base.strokeBorder(lineWidth: 2)
                Text(content).foregroundStyle(.white)
            }
        }
    }
}

#Preview {
    ContentView()
}
