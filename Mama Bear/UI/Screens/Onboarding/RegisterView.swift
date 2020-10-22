//
//  RegisterView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/1/20.
//

import SwiftUI
import Resolver
import FirebaseAuth

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
    @ObservedObject var authenticationService: AuthenticationService

    // MARK: -State variables
    @State var verifyCode: String = ""
    @State var verifyItems = VerifyModel(rows: [.init(), .init(), .init(), .init(), .init(), .init()])

    @State var startPos: CGPoint = .zero
    @State var isSwipping = true

    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var showingName = true
    @State private var showingEmail = false
    @State private var showingPhone = false
    @State private var showingVerify = false
    @State private var showingPassword = false

    @State private var attempts = 2
    @State private var canResendCode = false

    var accountType: AccountType

    @State var firstName = ""
    @State var lastName = ""
    @State var email = ""
    @State var phoneNumber = ""
    @State var verificationId: String?
    @State var password = ""
    @State var userPhoneCredential: PhoneAuthCredential?
    @State var newUser = FirestoreUser(id: "", name: "", email: "", phoneNumber: "", photoURL: "", accountType: "Nanny")

    var backPressed: () -> () = { }

    var body: some View {
        VStack(spacing: 0) {
            BackButton() {
                animateNextStep(forward: false)
            }
                .padding(.bottom, Sizes.Default)

            // Content to animate in
            ZStack {
                Name_RegisterView(firstName: $firstName, lastName: $lastName, account: accountType)
                    .offset(x: showingName ? 0 : -UIScreen.main.bounds.width)
                    .opacity(showingName ? 1 : 0)

                Email_RegisterView(email: $email)
                    .offset(x: showingEmail ? 0 : (showingPhone ? -UIScreen.main.bounds.width : UIScreen.main.bounds.width))
                    .opacity(showingEmail ? 1 : 0)

                Phone_RegisterView(phoneNumber: $phoneNumber)
                    .offset(x: showingPhone ? 0 : (showingVerify ? -UIScreen.main.bounds.width : UIScreen.main.bounds.width))
                    .opacity(showingPhone ? 1 : 0)

                Verify_RegisterView(model: $verifyItems, canResendCode: $canResendCode) {
                    sendPhoneCode(next: false)
                }
                    .offset(x: showingVerify ? 0 : (showingPassword ? -UIScreen.main.bounds.width : UIScreen.main.bounds.width))
                    .opacity(showingVerify ? 1 : 0)
                    .modifier(Shake(animatableData: CGFloat(attempts)))

                Password_RegisterView(password: $password)
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
                ConfirmButton(title: showingPassword ? "Register account" : "Next", style: .fill) {
                    if showingPhone { sendPhoneCode(next: true) }
                    else if showingVerify { validateCode() }
                    else if showingPassword { checkPassword() }
                    else { animateNextStep(forward: true) }
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

                    SocialLoginView(authenticationService: authenticationService, accountType: accountType)
                        .padding(.top, Sizes.xSmall)
                        .padding(.bottom, Sizes.Big)
                } else {
                    Spacer()
                }
            }
                .padding(.horizontal, Sizes.Default)
        }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Error registering new user"), message: Text(alertMessage), dismissButton: .default(Text("Okay")))
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

    func sendPhoneCode(next: Bool) {
        // SHOW LOADING
        let formattedPhoneNumber = format(with: "+1 (XXX) XXX-XXXX", phone: phoneNumber)
        PhoneAuthProvider.provider().verifyPhoneNumber(formattedPhoneNumber, uiDelegate: nil) { (verificationId, error) in
            if let error = error {
                // SHOW ERROR POPUP MESSAGE
                print("Error sending phone verification code: \(error)")
                return
            }
            // END LOADING – ADVANCE PAGE
            newUser.phoneNumber = formattedPhoneNumber
            if next { animateNextStep(forward: true) }
            self.verificationId = verificationId
        }
    }

    func validateCode() {
        // SHOW LOADING
        var text = ""
        for row in verifyItems.rows {
            text += row.textContent
        }
        verifyCode = text
        if let verificationId = self.verificationId {
            // END LOADING – ADVANCE PAGE
            let credential: PhoneAuthCredential? = PhoneAuthProvider.provider().credential(withVerificationID: verificationId, verificationCode: verifyCode)
            self.userPhoneCredential = credential
            animateNextStep(forward: true)
        } else {
            // Incorrect password attempt
            withAnimation(.default) {
                self.attempts += 1
            }
        }
    }

    func checkPassword() {
        // Check
        let name = "\(firstName) \(lastName)"
        newUser.accountType = accountType.rawValue
        newUser.name = name
        newUser.email = email
        if let phoneCredential = self.userPhoneCredential {
            authenticationService.registerUser(newUser: newUser, phoneNumberCredential: phoneCredential, password: password) { (result, error) in
                // Attempted login
                if let error = error {
                    alertMessage = error.localizedDescription
                    showingAlert = true
                    return
                }
            }
        }
    }

    func format(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex // numbers iterator

        // iterate over the mask characters until the iterator of numbers ends
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                // mask requires a number in this place, so take the next one
                result.append(numbers[index])

                // move numbers iterator to the next index
                index = numbers.index(after: index)

            } else {
                result.append(ch) // just append a mask character
            }
        }
        return result
    }
}
