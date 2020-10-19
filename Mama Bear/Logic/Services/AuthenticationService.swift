//
//  AuthenticationService.swift
//  Gather
//
//  Created by Tyler Cagle on 9/28/20.
//

import Foundation
import FirebaseAuth
import Resolver

import FirebaseFirestore
import FirebaseFirestoreSwift

enum SignInState: String {
    case signIn
    case link
    case reauth
}

class AuthenticationService: ObservableObject {
    @Published var user: User?
    @Published var userLoggedIn: Bool = false
    
    @LazyInjected private var taskRepository: TaskRepository
    private var handle: AuthStateDidChangeListenerHandle?
    
    private var database = Firestore.firestore()
    private var usersPath: String = "users"

    init() {
        registerStateListener()
    }
    
    func registerUser(newUser user: FirestoreUser, phoneNumberCredential: PhoneAuthCredential, password: String, completion: @escaping AuthDataResultCallback) {
        Auth.auth().createUser(withEmail: user.email, password: password) { (result, error) in
            if let error = error {
                print("Error signing user in with credentials: \(error.localizedDescription)")
            }
            Auth.auth().currentUser?.updatePhoneNumber(phoneNumberCredential, completion: { (err) in
                if let error = err {
                    print("Error updating user phone credential: \(error.localizedDescription)")
                }
            })
            self.updateDisplayName(displayName: user.name) { (result) in
                if case .failure(let err) = result {
                    print("Error updating user display name: \(err.localizedDescription)")
                }
            }
            
            print("Successfully registered new user: \(String(describing: result?.user.uid))")
            // Add user data to Firestore
            do {
                var newUser = user
                newUser.id = result?.user.uid
                let _ = try self.database.collection(self.usersPath).addDocument(from: newUser)
            }
            catch {
                print("Error saving user information to Firestore")
            }
        }
    }

    func signIn(withEmail: String, password: String, completion: @escaping AuthDataResultCallback) {
        if Auth.auth().currentUser == nil {
//            Auth.auth().signin()
            Auth.auth().signIn(withEmail: withEmail, password: password, completion: completion)
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            userLoggedIn = false
        }
        catch {
            print("Error when trying to sign out: \(error.localizedDescription).")
        }
    }

    private func registerStateListener() {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
        self.handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            print("Sign in state has changed.")
            self.user = user

            if let user = user {
                let anonymous = user.isAnonymous ? "anonymously " : ""
                print("User signed in \(anonymous)with user ID \(user.uid). Email: \(user.email ?? "(empty)"), display name: [\(user.displayName ?? "(empty)")]")
                
                self.userLoggedIn = true
            } else {
                print("User signed out.")
//                self.signIn()
            }
        }
    }

    func updateDisplayName(displayName: String, completionHandler: @escaping (Result<User, Error>) -> Void) {
        if let user = Auth.auth().currentUser {
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = displayName
            changeRequest.commitChanges { error in
                if let error = error {
                    completionHandler(.failure(error))
                }
                else {
                    if let updatedUser = Auth.auth().currentUser {
                        print("Successfully updated display name for user [\(user.uid)] to [\(updatedUser.displayName ?? "(empty)")].")

                        // Force update the local user to trigger the publisher
                        self.user = updatedUser
                        completionHandler(.success(updatedUser))
                    }
                }
            }
        }
    }
}
