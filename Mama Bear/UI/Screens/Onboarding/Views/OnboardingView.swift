//
//  OnboardingView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/1/20.
//

import SwiftUI

struct OnboardingView: View {
    @ObservedObject var authenticationService: AuthenticationService
    
    @State private var currentPage = 0
    @State private var onboardingComplete = false
    @State private var showingWelcome = false

    var onboardingContent: [Onboarding] = [
        Onboarding(image: "onboardingGraphic_1", title: "Get a job next to you", subtitle: "Find interesting offer and manage your schedule right from the app.", id: 0),
        Onboarding(image: "onboardingGraphic_2", title: "Find the best babysitter", subtitle: "Add an advertisement and wait. Then choose the best sitter.", id: 1),
        Onboarding(image: "onboardingGraphic_3", title: "Manage & pay from the app", subtitle: "Pay you babysitter using the app. Manage payments, and chat.", id: 2)
    ]

    var body: some View {
        ZStack {
            Colors.background
                .edgesIgnoringSafeArea(.all)

            if !showingWelcome {
                ZStack(alignment: .bottom) {
                    PagerView(pageCount: 3, currentIndex: $currentPage) {
                        ForEach(onboardingContent) { content in
                            OnboardingSingleView(content: content)
                        }
                    }

                    if currentPage != (onboardingContent.count - 1) {
                        VStack {
                            SkipButton() {
                                animateOnboardingComplete()
                            }

                            Spacer()
                        }
                    }

                    HStack {
                        PageControl(currentlySelectedId: currentPage)

                        Spacer()

                        NextButton(title: currentPage == (onboardingContent.count - 1) ? "Get started" : "Next") {
                            if currentPage != (onboardingContent.count - 1) {
                                currentPage += 1
                            } else {
                                animateOnboardingComplete()
                            }
                        }
                    }
                        .padding(.horizontal, Sizes.xLarge)
                        .padding(.bottom, Sizes.Default)
                }
                    .edgesIgnoringSafeArea(.top)
                    .opacity(onboardingComplete ? 0 : 1)

            } else {
                WelcomeView(authenticationService: authenticationService)
                    .opacity(showingWelcome ? 1 : 0)
            }
        }
    }

    func animateOnboardingComplete() {
        withAnimation(Animation.easeOut(duration: Animation.animationIn)) {
            self.onboardingComplete = true
            self.showingWelcome = true
        }
    }

}
