//
//  RegisterView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/1/20.
//

import SwiftUI

enum AccountType: String {
    case nanny = "Nanny"
    case family = "Family"
}

/**
 Creates a shake animation, useful in denoting a failed input attempt.

 With a little help from:
 - [How to create an explicit animation](https://www.hackingwithswift.com/quick-start/swiftui/how-to-create-an-explicit-animation)
 - [SwiftUI: Shake Animation](https://www.objc.io/blog/2019/10/01/swiftui-shake-animation/)
*/
struct Shake: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
                amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0))
    }
}

struct RegisterView: View {
    var backPressed: () -> () = { }
    var account: AccountType = .nanny

    @State var verifyCode: String?
    @State var verifyItems = VerifyModel(rows: [.init(), .init(), .init(), .init(), .init(), .init()])

    @State var startPos: CGPoint = .zero
    @State var isSwipping = true

    @State private var showingName = true
    @State private var showingEmail = false
    @State private var showingPhone = false
    @State private var showingVerify = false
    @State private var showingPassword = false

    @State private var attempts = 2
    @State private var canResendCode = false

    var body: some View {
        VStack {
            BackButton() {
                animateNextStep(forward: false)
            }
                .padding(.bottom, Sizes.Default)

            // Content to animate in
            ZStack {
                Name_RegisterView(account: .nanny)
                    .offset(x: showingName ? 0 : -UIScreen.main.bounds.width)
                    .opacity(showingName ? 1 : 0)

                Email_RegisterView()
                    .offset(x: showingEmail ? 0 : (showingPhone ? -UIScreen.main.bounds.width : UIScreen.main.bounds.width))
                    .opacity(showingEmail ? 1 : 0)

                Phone_RegisterView()
                    .offset(x: showingPhone ? 0 : (showingVerify ? -UIScreen.main.bounds.width : UIScreen.main.bounds.width))
                    .opacity(showingPhone ? 1 : 0)

                Verify_RegisterView(model: $verifyItems, canResendCode: $canResendCode)
                    .offset(x: showingVerify ? 0 : (showingPassword ? -UIScreen.main.bounds.width : UIScreen.main.bounds.width))
                    .opacity(showingVerify ? 1 : 0)
                    .modifier(Shake(animatableData: CGFloat(attempts)))
                
                Password_RegisterView()
                    .offset(x: showingPassword ? 0 : UIScreen.main.bounds.width)
                    .opacity(showingPassword ? 1 : 0)
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

            Spacer()

            // Next button
            Group {
                ConfirmButton(title: showingPassword ? "Get started" : "Next", style: .fill) {
                    animateNextStep(forward: true)

                    if showingVerify { validateCode() }
                }

                if showingName {
                    HStack {
                        Rectangle()
                            .foregroundColor(Colors.subheadline.opacity(0.4))
                            .frame(height: 1)

                        Text("Or login with")
                            .customFont(.medium, category: .small)
                            .foregroundColor(Colors.subheadline)
                            .fixedSize()
                            .padding(.horizontal, Sizes.Spacer)

                        Rectangle()
                            .foregroundColor(Colors.subheadline.opacity(0.4))
                            .frame(height: 1)
                    }
                        .padding(.top, Sizes.xSmall)

                    SocialLoginView()
                        .padding(.top, Sizes.xSmall)
                        .padding(.bottom, Sizes.Big)
                } else {
                    Spacer()
                }
            }
                .padding(.horizontal, Sizes.Default)
        }
    }

    func animateNextStep(forward: Bool) {
        withAnimation(Animation.easeOut(duration: Animation.animationIn)) {
            switch forward {
            case true:
                if self.showingName {
                    self.showingName = false
                    self.showingEmail = true
                } else if self.showingEmail {
                    self.showingEmail = false
                    self.showingPhone = true
                } else if self.showingPhone {
                    self.showingPhone = false
                    self.showingVerify = true
                    self.canResendCode.toggle()
                } else if self.showingVerify {
                    self.showingVerify = false
                    self.showingPassword = true
                }
            case false:
                if self.showingName {
                    self.backPressed()
                } else if self.showingEmail {
                    self.showingEmail = false
                    self.showingName = true
                } else if self.showingPhone {
                    self.showingPhone = false
                    self.showingEmail = true
                } else if self.showingVerify {
                    self.showingVerify = false
                    self.showingPhone = true
                } else if self.showingPassword {
                    self.showingPassword = false
                    self.showingVerify = true
                }
            }
        }
    }

    func validateCode() {
        var text = ""
        for row in verifyItems.rows {
            text += row.textContent
        }
        verifyCode = text

        // Incorrect password attempt
        withAnimation(.default) {
            self.attempts += 1
        }
        //
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
