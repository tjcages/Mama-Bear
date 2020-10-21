//
//  SocialLoginView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/1/20.
//

import SwiftUI
import FirebaseAuth
import FBSDKLoginKit

struct SocialLoginView: View {
    @Environment(\.window) var window: UIWindow?
    @ObservedObject var authenticationService: AuthenticationService

    @State var signInHandler: SignInWithAppleCoordinator?
    @State var accountType: AccountType
    @State private var googlePresented = false

    let size = Sizes.xLarge
    let space = Sizes.Spacer

    var body: some View {
        HStack {
            Spacer()

            // Apple
            Button {
                signInWithAppleButtonTapped()
            } label: {
                Image("apple")
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size, height: size)
                    .padding(.horizontal, space)
                    .foregroundColor(Colors.blue)
                    .contentShape(Circle())
            }

            // Google
            Button {
                signInWithGoogleButtonTapped()
            } label: {
                Image("google")
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size, height: size)
                    .padding(.horizontal, space)
                    .foregroundColor(Colors.blue)
                    .contentShape(Circle())
            }

            // Facebook
            Button {
                signInWithFacebookButtonTapped()
            } label: {
                Image("facebook")
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size, height: size)
                    .padding(.horizontal, space)
                    .foregroundColor(Colors.blue)
                    .contentShape(Circle())
            }

            Spacer()
        }
            .sheet(isPresented: $googlePresented) {
                GoogleSignInRepresentable() { result in
                    authenticateWithGoogle(result: result)
                }
        }
    }
}

// MARK: -Login functions
extension SocialLoginView {
    func signInWithAppleButtonTapped() {
        signInHandler = SignInWithAppleCoordinator(window: self.window)
        signInHandler?.signIn { user in
            print("Successfully signed in with Apple")
        }
    }

    func signInWithGoogleButtonTapped() {
        googlePresented = true
    }
    
    func authenticateWithGoogle(result: AuthDataResult) {
        if result.additionalUserInfo?.isNewUser ?? false {
            let user = FirestoreUser(id: result.user.uid, name: result.user.displayName ?? "", email: result.user.email ?? "", phoneNumber: result.user.phoneNumber, accountType: accountType.rawValue)
            authenticationService.addUserToFirestore(user: user)
            authenticationService.updatePhotoURL(url: result.user.photoURL) { _ in
                //
            }
        }
    }

    func signInWithFacebookButtonTapped() {
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print("Error logging into Facebook: \(error)")
            }
            // Successful sign in
            if let result = authResult {
                if result.additionalUserInfo?.isNewUser ?? false {
                    let user = FirestoreUser(id: result.user.uid, name: result.user.displayName ?? "", email: result.user.email ?? "", phoneNumber: result.user.phoneNumber, accountType: accountType.rawValue)
                    authenticationService.addUserToFirestore(user: user)
                    authenticationService.updatePhotoURL(url: result.user.photoURL) { _ in
                        //
                    }
                }
            }
        }
    }
}
