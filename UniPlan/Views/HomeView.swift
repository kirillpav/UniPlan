import SwiftUI

struct HomeView: View {
    @StateObject private var classViewModel = ClassViewModel()
    @State private var showAddClassView = false
    var body: some View {
        VStack {
            Text("My Courses (\(classViewModel.classes.count))").font(.largeTitle)
                .padding()
                .cornerRadius(10) 
                .frame(maxWidth: .infinity, alignment: .leading)
                
            
            ScrollView {
                let columns = [GridItem(.flexible()), GridItem(.flexible())]
                
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(classViewModel.classes) { currentClass in
                        ClassCard(title: currentClass.title, instructor: currentClass.instructor, instructorEmail: currentClass.instructorEmail)
                            .padding()
                    }
                }
            }

            Button(action: {
                showAddClassView = true
            }) {
                Text("Add Class")
                    .padding()
            }
            
            
        }
        .padding()
        .sheet(isPresented: $showAddClassView) {
            AddClassView()
        }
        
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
