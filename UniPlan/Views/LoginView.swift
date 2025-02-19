
import SwiftUI
import AuthenticationServices

struct LoginView: View {
    var body: some View {
        VStack {
            Text("Welcome to UniPlan")
            .font(.largeTitle)
            .padding()
            SignInWithAppleButton(.continue, onRequest: { request in
                request.requestedScopes = [.fullName, .email]
            }, onCompletion: { result in
                // redirect to onboarding view
            })
            .signInWithAppleButtonStyle(.black)
            .frame(width: 200, height: 50)
            .padding()
            .cornerRadius(10)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
