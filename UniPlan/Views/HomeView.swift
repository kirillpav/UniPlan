import SwiftUI

struct HomeView: View {
    @StateObject private var classViewModel = ClassViewModel()
    @StateObject private var assignmentsViewModel = AssignmentsViewModel()
    @State private var showAddClassView = false

    var body: some View {
        NavigationStack {
            VStack {
                Text("My Courses (\(classViewModel.classes.count))").font(.largeTitle)
                    .padding()
                    .cornerRadius(10) 
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                
                ScrollView {
                    let columns = [GridItem(.flexible()), GridItem(.flexible())]
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(classViewModel.classes) { currentClass in
                            let assignmentCount = assignmentsViewModel.assignments.filter { $0.classId == currentClass.id }.count
                            ClassCard(classId: currentClass.id,title: currentClass.title, instructor: currentClass.instructor, instructorEmail: currentClass.instructorEmail, numberOfAssignments: assignmentCount)
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
                AddClassView(classViewModel: classViewModel)
            }
            .onAppear {
                classViewModel.fetchClasses()
                assignmentsViewModel.fetchAssignments()
            }
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
