//
//  AuthenticationService.swift
//  Gather
//
//  Created by Tyler Cagle on 9/28/20.
//

import Foundation
import SwiftUI
import FirebaseAuth
import Resolver

import FirebaseFirestore
import FirebaseFirestoreSwift
import FBSDKLoginKit

enum SignInState: String {
    case signIn
    case link
    case reauth
}

class AuthenticationService: ObservableObject {
    @Published var user: User?
    @Published var firestoreUser: FirestoreUser?
    @Published var userAddress: Address?
    @Published var userChildren: [Child]?
    @Published var userPets: [Pet]?
    @Published var userLoggedIn: Bool = false

    private var listenerRegistration: ListenerRegistration?
    private var handle: AuthStateDidChangeListenerHandle?

    private var database = Firestore.firestore()
    private var usersPath: String = "users"
    private var addressPath: String = "addresses"
    private var childrenPath: String = "children"
    private var petsPath: String = "pets"

    init() {
        registerStateListener()
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
                print("User signed in \(anonymous)")

                // Now get Firestore data
                self.loadData(id: user.uid)

                withAnimation(Animation.easeOut(duration: Animation.animationIn)) {
                    self.userLoggedIn = true
                }
            } else {
                print("User signed out.")
//                self.signIn()
            }
        }
    }

    // MARK: - Add Items to Firestore
    func addUserToFirestore(user: FirestoreUser) {
        do {
            guard let uid = user.id else { return }
            let _ = try database.collection(self.usersPath).document(uid).setData(from: user)
        }
        catch { print("Error saving user data to Firestore") }
    }
    
    func addAddressToFirestore(address: Address) {
        do {
            guard let uid = address.userId else { return }
            let _ = try database.collection(self.addressPath).document(uid).setData(from: address)
        }
        catch { print("Error saving user address data to Firestore") }
    }
    
    func removeAddress(_ address: Address) {
        if let id = address.id {
            database.collection(addressPath).document(id).delete { (error) in
                if let error = error {
                    print("Error removing document: \(error.localizedDescription).")
                }
            }
        }
    }
    
    func addChildToFirestore(child: Child) {
        do {
            guard let uid = user?.uid else { return }
            var child = child
            child.userId = uid
            child.updatedTime = nil
            if let id = child.id {
                // Update Firestore document
                let _ = try database.collection(childrenPath).document(id).setData(from: child)
            } else {
                // Create Firestore document
                let _ = try database.collection(childrenPath).addDocument(from: child)
            }
        }
        catch { print("Error saving user address data to Firestore") }
    }
    
    func removeChild(_ child: Child) {
        if let childId = child.id {
            database.collection(childrenPath).document(childId).delete { (error) in
                if let error = error {
                    print("Error removing document: \(error.localizedDescription).")
                }
            }
        }
    }
    
    func addPetToFirestore(pet: Pet) {
        do {
            guard let uid = user?.uid else { return }
            var pet = pet
            pet.userId = uid
            pet.updatedTime = nil
            if let id = pet.id {
                // Update Firestore document
                let _ = try database.collection(petsPath).document(id).setData(from: pet)
            } else {
                // Create Firestore document
                let _ = try database.collection(petsPath).addDocument(from: pet)
            }
        }
        catch { print("Error saving user address data to Firestore") }
    }
    
    func removePet(_ pet: Pet) {
        if let petId = pet.id {
            database.collection(petsPath).document(petId).delete { (error) in
                if let error = error {
                    print("Error removing document: \(error.localizedDescription).")
                }
            }
        }
    }
    
    // MARK: - Register New User to Firebase
    func registerUser(newUser user: FirestoreUser, phoneNumberCredential: PhoneAuthCredential, password: String, completion: @escaping AuthDataResultCallback) {
        Auth.auth().createUser(withEmail: user.email, password: password) { (result, error) in
            if let error = error {
                print("Error signing user in with credentials: \(error.localizedDescription)")
                completion(result, error)
            }
            Auth.auth().currentUser?.updatePhoneNumber(phoneNumberCredential, completion: { (err) in
                if let error = err {
                    print("Error updating user phone credential: \(error.localizedDescription)")
                    completion(result, error)
                }
            })
            self.updateDisplayName(displayName: user.name) { (res) in
                if case .failure(let err) = res {
                    print("Error updating user display name: \(err.localizedDescription)")
                    completion(result, error)
                }
            }

            print("Successfully registered new user")
            // Add user data to Firestore
            var newUser = user
            newUser.id = result?.user.uid
            self.addUserToFirestore(user: newUser)
        }
    }

    // MARK: - Sign User in to Firebase
    func signIn(withEmail: String, password: String, completion: @escaping AuthDataResultCallback) {
        if Auth.auth().currentUser == nil {
//            Auth.auth().signin()
            Auth.auth().signIn(withEmail: withEmail, password: password, completion: completion)
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            withAnimation(Animation.easeOut(duration: Animation.animationIn)) {
                self.userLoggedIn = false
            }
        }
        catch {
            print("Error when trying to sign out: \(error.localizedDescription).")
        }
    }

    // MARK: - Load and Mutate User Firestore Data
    private func loadData(id: String) {
        // Pull data from Firestore
        if listenerRegistration != nil {
            listenerRegistration?.remove()
        }
        // Firestore user data
        loadUserData(id: id)
    }
    
    private func loadUserData(id: String) {
        // User data
        listenerRegistration = database.collection(usersPath).document(id).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("Error listening to Firestore user at document id: \(error)")
            }
            if let snapshot = snapshot {
                self.firestoreUser = try? snapshot.data(as: FirestoreUser.self)
            }
        }
        
        // Address data
        listenerRegistration = database.collection(addressPath).document(id).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("Error listening to Firestore user address at document id: \(error)")
            }
            if let snapshot = snapshot {
                self.userAddress = try? snapshot.data(as: Address.self)
            }
        }
        
        // Children data
        listenerRegistration = database.collection(childrenPath)
            .whereField("userId", isEqualTo: id)
            .order(by: "age")
            .addSnapshotListener { (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    self.userChildren = querySnapshot.documents.compactMap { document -> Child? in
                        try? document.data(as: Child.self)
                    }
                }
        }
        
        // Pet data
        listenerRegistration = database.collection(petsPath)
            .whereField("userId", isEqualTo: id)
            .addSnapshotListener { (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    self.userPets = querySnapshot.documents.compactMap { document -> Pet? in
                        try? document.data(as: Pet.self)
                    }
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
