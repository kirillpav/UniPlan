import AuthenticationServices
import SwiftUI

struct OnboardingView {
    @Binding var hasCompletedOnboarding: Bool
    @State private var currentPage = 0
    @State private var navigateToHome = false
    @State private var isError = false

    @State private var name: String = ""

    private func validateInput() {
        if !name.isEmpty {
            currentPage += 1
        } else {
            isError = true
        }
    }

   
}