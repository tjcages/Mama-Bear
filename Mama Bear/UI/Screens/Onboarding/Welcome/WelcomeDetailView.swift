//
//  WelcomeDetailView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/1/20.
//

import SwiftUI

struct WelcomeDetailView: View {
    @ObservedObject var authenticationService: AuthenticationService
    @State var accountType: AccountType
    
    var registerPressed: () -> () = { }

    @State private var showingAlert = false
    @State var startPos: CGPoint = .zero
    @State var isSwipping = true

    @State var email: String = ""
    @State var password: String = ""

    var body: some View {
        VStack(alignment: .center, spacing: Sizes.Spacer) {
            BrandTextView($email, item: .email)
                .padding(.bottom, Sizes.Spacer)

            BrandTextView($password, item: .password)

            HStack {
                Spacer()

                Text("Forgot password?")
                    .customFont(.medium, category: .small)
                    .foregroundColor(Colors.subheadline)
            }
                .padding(.bottom, Sizes.xSmall)

            ConfirmButton(title: "Login now", style: .fill) {
                authenticationService.signIn(withEmail: email, password: password) { (result, error) in
                    if let error = error {
                        print("Error logging user in with credentials: \(error)")
                        showingAlert = true
                        return
                    }
                    // Successfully signed in
                }
            }
                .padding(.vertical, Sizes.Spacer)

            Text("New user?")
                .customFont(.medium, category: .small)
                .foregroundColor(Colors.subheadline)

            ConfirmButton(title: "Register", style: .lined) {
                registerPressed()
            }

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

            SocialLoginView(authenticationService: authenticationService, accountType: accountType)
                .padding(.top, Sizes.xSmall)

            Spacer()
        }
            .padding([.leading, .bottom, .trailing], Sizes.Large)
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
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Error logging in"), message: Text("The password is invalid or the user does not exist."), dismissButton: .default(Text("Okay")))
        }
    }
}
