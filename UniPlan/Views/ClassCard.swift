import SwiftUI

struct ClassCard: View {

    var title: String
    var instructor: String
    var instructorEmail: String
    
    var body: some View {
        ZStack {
            // Background
            RoundedRectangle(cornerRadius: 10)
                .fill(.green)
                .frame(height: 160)
                .shadow(radius: 5)

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                    }
                    Spacer()
                    Image(systemName: "arrow.up.right.circle.fill")
                        .foregroundColor(.white)
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

                Spacer()
            }
            .padding()
        }
        .frame(height: 160)
        .frame(width: 160)
    }
}

