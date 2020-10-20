//
//  WelcomeView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/1/20.
//

import SwiftUI

struct WelcomeView: View {
    @ObservedObject var authenticationService: AuthenticationService
    @ObservedObject var settingsVM: SettingsViewModel

    @State var accountType: AccountType = .unknown
    
    @State private var showingWelcome = true
    @State private var showingAccount = false
    @State private var showingRegister = false

    @State var startPos: CGPoint = .zero
    @State var isSwipping = true
    
    let size: CGFloat = 132

    var body: some View {
        ZStack {
            VStack {
                Spacer()

                // Mama Bear logo
                Image("mamaBearIcon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size, height: size)
                    .padding(.top, Sizes.Default)

                Text(!showingAccount ? "Welcome!" : "Create your account")
                    .customFont(.heavy, category: !showingAccount ? .large : .extraLarge)
                    .padding(.horizontal, Sizes.Default)

                Spacer(minLength: Sizes.Default)

                ZStack(alignment: .bottom) {
                    WelcomeDetailView(authenticationService: authenticationService, accountType: accountType) {
                        animateOnboardingComplete(forward: true)
                    }
                        .offset(x: showingWelcome ? 0 : -UIScreen.main.bounds.width)
                        .opacity(showingWelcome ? 1 : 0)

                    CreateAccountView(accountType: $accountType, backPressed: {
                        animateOnboardingComplete(forward: false)
                    }, accountPressed: {
                            animateRegistering(forward: true)
                        })
                        .offset(x: showingAccount ? 0 : UIScreen.main.bounds.width)
                        .opacity(showingAccount ? 1 : 0)
                }
            }
                .offset(x: showingRegister ? -UIScreen.main.bounds.width : 0, y: showingRegister ? -UIScreen.main.bounds.height : 0)

            if !showingWelcome {
                RegisterView(authenticationService: authenticationService, settingsVM: settingsVM, accountType: accountType) {
                    animateRegistering(forward: false)
                }
                    .offset(y: showingRegister ? 0 : UIScreen.main.bounds.height)
                    .opacity(showingRegister ? 1 : 0)
            }
        }
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
            .gesture(DragGesture()
                    .onChanged { gesture in
                        if self.isSwipping {
                            self.startPos = gesture.location
                            self.isSwipping.toggle()
                        }
                    }
                    .onEnded { gesture in
                        let xDist = abs(gesture.location.x - self.startPos.x)
                        let yDist = abs(gesture.location.y - self.startPos.y)
                        if self.startPos.y < gesture.location.y && yDist > xDist {
                            // End editing if the user swipes the keyboard down
                            UIApplication.shared.endEditing()
                        }
                        self.isSwipping.toggle()
                }
            )
    }

    func animateOnboardingComplete(forward: Bool) {
        withAnimation(Animation.easeOut(duration: Animation.animationIn)) {
            switch forward {
            case true:
                self.showingWelcome = false
            case false:
                self.showingAccount = false
            }
        }
        delayWithSeconds(Animation.animationOut) {
            withAnimation(Animation.easeOut(duration: Animation.animationIn)) {
                switch forward {
                case true:
                    self.showingAccount = true
                case false:
                    self.showingWelcome = true
                }
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
