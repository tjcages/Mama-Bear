//
//  SignInWithFacebookCoordinator.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/21/20.
//

import SwiftUI
import Resolver
import Firebase
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit

class SignInWithFacebookCoordinator: NSObject {
    @LazyInjected private var listingRepository: ListingRepository
    @LazyInjected private var authenticationService: AuthenticationService
    
    private var onSignedInHandler: ((User) -> Void)?
    
    @State var accountType: AccountType
    
    init(accountType: AccountType) {
        self.accountType = accountType
    }
    
    func signIn(onSignedInHandler: @escaping (User) -> Void) {
        if let token = AccessToken.current?.tokenString {
            let credential = FacebookAuthProvider.credential(withAccessToken: token)
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    print("Error logging into Facebook: \(error)")
                }
                // Successful sign in
                if let result = authResult {
                    if result.additionalUserInfo?.isNewUser ?? false {
                        let user = FirestoreUser(id: result.user.uid, name: result.user.displayName ?? "", email: result.user.email ?? "", phoneNumber: result.user.phoneNumber ?? "", photoURL: "", accountType: self.accountType.rawValue)
                        self.authenticationService.addUserToFirestore(user: user)
                        self.authenticationService.updatePhotoURL(url: result.user.photoURL) { _ in
                            //
                        }
                        
                        onSignedInHandler(result.user)
                    }
                }
            }
        } else {
            print("Could not log into Facebook. Retrying...")
            doFacebookLogin()
        }
    }

    func doFacebookLogin() {
        LoginManager().logIn(permissions: [.publicProfile, .email], viewController: nil) { loginResult in
            switch loginResult {
            case .failed(let error):
                print("Error gaining LoginManager permissions: \(error.localizedDescription)")
                return
            case .cancelled:
                print("User cancelled login.")
                return
            case .success(_, _, let accessToken):
                // Save Access Token string for silent login purpose later
                let strAuthenticationToken = accessToken.tokenString
                UserDefaults.standard.set(strAuthenticationToken,
                    forKey: "AccessToken_Facebook")

                // Proceed to get facebook profile data
                self.getAccountDetails(withAccessToken: accessToken)
            }
        }
    }

    func getAccountDetails(withAccessToken accessToken: AccessToken) {
        let graphRequest = GraphRequest(
            graphPath: "me",
            parameters: ["fields": "id, name, email"],
            tokenString: accessToken.tokenString,
            version: nil,
            httpMethod: GraphRequest(graphPath: "me").httpMethod
        )
        graphRequest.start { (connection, result, error) in
            if let error = error {
                print("Error requesting graph from Facebook: \(error.localizedDescription)")
                return
            }
            self.signIn { user in
                //
            }
        }
    }
}
