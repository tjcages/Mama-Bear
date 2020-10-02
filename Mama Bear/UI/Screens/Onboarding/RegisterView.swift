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

struct RegisterView: View {
    var backPressed: () -> () = { }
    var account: AccountType = .nanny

    @State var startPos: CGPoint = .zero
    @State var isSwipping = true

    @State private var showingName = true
    @State private var showingEmail = false
    @State private var showingPhone = false

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
                    .offset(x: showingPhone ? 0 : UIScreen.main.bounds.width)
                    .opacity(showingPhone ? 1 : 0)
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
                ConfirmButton(title: "Next", style: .fill) {
                    animateNextStep(forward: true)
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
                }
            }
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
