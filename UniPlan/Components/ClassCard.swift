import SwiftUI

struct ClassCard: View {
    
    var classId: UUID
    var title: String
    var instructor: String
    var instructorEmail: String
    var numberOfAssignments: Int
    
    var body: some View {
        NavigationLink(destination: ClassDetailView(classId: classId)) {

        ZStack {
            // Background
            RoundedRectangle(cornerRadius: 10)
                .fill(.orange)
                .frame(height: 160)
                .shadow(radius: 5)

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                    }
                    Spacer()
                }
                
                // Title
                Text(title)
                    .font(.title3)
                    .bold()
                    .foregroundColor(.white)

                // Course Details
                Text(instructor)
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.8))
                Text("\(numberOfAssignments) Items Due")
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.8))
                Spacer()
            }
            .padding()
        }
        .frame(height: 160)
        .frame(width: 160)
        }
    }
}

