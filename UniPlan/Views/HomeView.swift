import SwiftUI

struct HomeView: View {
    @StateObject private var classViewModel = ClassViewModel()
    @StateObject private var assignmentsViewModel = AssignmentsViewModel()
    @State private var showAddClassView = false

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("My Courses (\(classViewModel.classes.count))").font(.largeTitle)
                    .cornerRadius(10) 
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()

                    Button(action: {
                        showAddClassView = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title)
                            .padding()
                    }
                }
                .padding(.horizontal)
                
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(classViewModel.classes) { currentClass in
                            let assignmentCount = assignmentsViewModel.assignments.filter { $0.classId == currentClass.id }.count
                            ClassCard(classId: currentClass.id,title: currentClass.title, instructor: currentClass.instructor, instructorEmail: currentClass.instructorEmail, numberOfAssignments: assignmentCount)
                                .padding(.horizontal, 20)
                        }
                    }
                    .padding(.bottom)
                }
            }
            .padding(.top)
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 20)
            }
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
