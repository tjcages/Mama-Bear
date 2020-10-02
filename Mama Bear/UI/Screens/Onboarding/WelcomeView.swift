//
//  WelcomeView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/1/20.
//

import SwiftUI

struct WelcomeView: View {
    let size: CGFloat = 132

    @State private var showingWelcome = true
    @State private var showingAccount = false
    @State private var showingRegister = false

    var body: some View {
        ZStack {
            VStack {
                Spacer()

                // Mama Bear logo
                Rectangle()
                    .foregroundColor(Color.black.opacity(0.1))
                    .frame(width: size, height: size)
                    .padding(.vertical, Sizes.Default)

                Text(!showingAccount ? "Welcome!" : "Create your account")
                    .customFont(.heavy, category: !showingAccount ? .large : .extraLarge)
                    .padding(.horizontal, Sizes.Default)

                ZStack(alignment: .bottom) {
                    WelcomeDetailView() {
                        animateOnboardingComplete(forward: true)
                    }
                        .offset(x: showingWelcome ? 0 : -UIScreen.main.bounds.width)
                        .opacity(showingWelcome ? 1 : 0)

                    CreateAccountView(backPressed: {
                        animateOnboardingComplete(forward: false)
                    }, accountPressed: {
                            animateRegistering(forward: true)
                        })
                        .offset(x: showingAccount ? 0 : UIScreen.main.bounds.width)
                        .opacity(showingAccount ? 1 : 0)
                }
            }
                .offset(x: showingRegister ? -UIScreen.main.bounds.width : 0, y: showingRegister ? -UIScreen.main.bounds.height : 0)

            RegisterView() {
                animateRegistering(forward: false)
            }
                .offset(y: showingRegister ? 0 : UIScreen.main.bounds.height)
                .opacity(showingRegister ? 1 : 0)
        }
    }

    func animateOnboardingComplete(forward: Bool) {
        withAnimation(Animation.easeOut(duration: Animation.animationIn)) {
            switch forward {
            case true:
                self.showingWelcome = false
                self.showingAccount = true
            case false:
                self.showingAccount = false
                self.showingWelcome = true
            }
        }
    }

    func animateRegistering(forward: Bool) {
        withAnimation(Animation.easeOut(duration: Animation.animationIn)) {
            switch forward {
            case true:
                self.showingRegister = true
                self.showingAccount = false
            case false:
                self.showingRegister = false
                self.showingAccount = true
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
