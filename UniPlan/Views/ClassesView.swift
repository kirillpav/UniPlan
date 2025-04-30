import SwiftUI

struct ClassesView: View {
    @StateObject private var courseViewModel = CourseViewModel()
    @StateObject private var assignmentsViewModel = AssignmentsViewModel()
    @State private var showAddClassView = false
    
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("My Courses (\(courseViewModel.courses.count))").font(.largeTitle)
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
                        ForEach(courseViewModel.courses) { currentCourse in
                            let assignmentCount = assignmentsViewModel.assignments.filter { $0.classId == currentCourse.id }.count
                            
                            ClassCard(classId: currentCourse.id,title: currentCourse.title, code: currentCourse.code, instructor: currentCourse.instructor, instructorEmail: currentCourse.instructorEmail, numberOfAssignments: assignmentCount, date: currentCourse.daysString, timeRange: currentCourse.timeRangeString)
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
                AddClassView(courseViewModel: courseViewModel)
            }
            .onAppear {
                courseViewModel.fetchCourses()
                assignmentsViewModel.fetchAssignments()
            }
        }
    }
}


struct ClassesView_Previews: PreviewProvider {
    static var previews: some View {
        ClassesView()
    }
}
