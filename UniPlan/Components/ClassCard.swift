import SwiftUI

struct ClassCard: View {
    
    var classId: UUID
    var title: String
    var instructor: String
    var instructorEmail: String
    var numberOfAssignments: Int
    
    var body: some View {
        NavigationLink {
            ClassDetailView(classId: classId, title: title, instructor: instructor, instructorEmail: instructorEmail, numberOfAssignments: numberOfAssignments)
        } label: {
            ZStack(alignment: .leading) {
                // Background
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color("SecondaryColor"))
                    .frame(height: 160)
                
                VStack(alignment: .leading, spacing: 10) {
                    
                    
                    
                    // Course Details
                    
                    HStack {
                        Text("\(numberOfAssignments) Items Due")
                            .font(.headline)
                            .foregroundColor(.black)
                        Spacer()
                            Image(systemName: "chevron.forward.circle.fill")
                                .font(.title2)
                                .foregroundColor(.black)
                                
                    }
                    Text(instructor)
                        .font(.subheadline)
                        .foregroundColor(.black)
                    Spacer()
                    // Title
                    Text(title)
                        .font(.title2)
                        .bold()
                        .foregroundColor(.black)
                }
                .padding(20)
                
            }
            .frame(height: 160)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

