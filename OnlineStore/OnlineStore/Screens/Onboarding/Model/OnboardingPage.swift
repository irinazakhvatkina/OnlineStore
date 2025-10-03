import Foundation

struct OnboardingPage {
    let title: String
    let description: String?
    let imageName: String
    let hasCustomForm: Bool
    let buttonTitle: String? 
}


extension OnboardingPage {
    static var allPages: [OnboardingPage] {
        return [
            OnboardingPage(
                title: "New market \nplace in your \nsmartphone",
                description: nil,
                imageName: "onboarding1",
                hasCustomForm: false,
                buttonTitle: "Next"
            ),
            OnboardingPage(
                title: "Shop from \neverywhere",
                description: "clothes, gadgets and more",
                imageName: "onboarding2",
                hasCustomForm: false,
                buttonTitle: "Next"
            ),
            OnboardingPage(
                title: "Get the best \nsales offers",
                description: "up to 20% on every item",
                imageName: "onboarding3",
                hasCustomForm: false,
                buttonTitle: "Get Started"
            )
        ]
    }
}
