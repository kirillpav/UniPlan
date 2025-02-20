import SwiftUI

struct ClassDetailView: View {
    var classId: UUID
    
    var body: some View {
        Text("Class Detail View")
    }
}

struct ClassDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ClassDetailView(classId: UUID())   
    }
}

