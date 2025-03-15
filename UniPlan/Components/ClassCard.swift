import SwiftUI

struct ClassCard: View {
    var classId: UUID
    var title: String
    var instructor: String
    var instructorEmail: String
    var numberOfAssignments: Int
    var date: String
    var timeRange: String
    
    
    var body: some View {
        NavigationLink {
            ClassDetailView(classId: classId, title: title, instructor: instructor, instructorEmail: instructorEmail, numberOfAssignments: numberOfAssignments)
        } label: {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    // Date
                    HStack(spacing: 6) {
                        Image(systemName: "calendar")
                            .font(.system(size: 16))
                        
                        Text(date)
                            .font(.system(size: 14))
                    }
                    
                    Spacer()
                    
                    // Assignment count badge
                    if numberOfAssignments > 0 {
                        Text("\(numberOfAssignments) Items Due")
                            .font(.system(size: 14, weight: .medium))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.red.opacity(0.9))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
                
                if !title.isEmpty {
                    // Title and teacher
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.black)
                        
                        HStack(spacing: 4) {
                            Text(instructor)
                                .font(.system(size: 16))
                                .foregroundColor(.black)
                        }
                    }
                    
                    // Bottom section with time and open button
                    HStack {
                        // Time
                        HStack(spacing: 8) {
                            Image(systemName: "clock")
                                .font(.system(size: 16))
                            
                            Text(timeRange)
                                .font(.system(size: 16, weight: .medium))
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(.white)
                        .clipShape(Capsule())
                        
                        Spacer()
                        
                        // Open button/indicator
                        ZStack {
                            Circle()
                                .fill(.white)
                                .frame(width: 50, height: 50)
                            
                            Image(systemName: "arrow.up.right")
                                .font(.system(size: 20))
                                .foregroundColor(.black)
                        }
                    }
                }
            }
            .padding(20)
            .background(Color("SecondaryColor"))
            .cornerRadius(20)
            .padding(.horizontal)
        }
    }
}



