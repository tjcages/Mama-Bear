//
//  FirestoreFAQRepository.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/20/20.
//

import Foundation

import FirebaseFirestore
import FirebaseFirestoreSwift

import Resolver
import Combine

class BaseFAQRepository {
    @Published var faq = [FAQ]()
    @Published var admin = [Admin]()
}

class FirestoreFAQRepository: BaseFAQRepository, ObservableObject {
    var database = Firestore.firestore()
    @Injected var authenticationService: AuthenticationService

    var path: String = "FAQ"
    var adminPath: String = "Admin"

    private var listenerRegistration: ListenerRegistration?
    private var cancellables = Set<AnyCancellable>()

    override init() {
        super.init()

        // Reload data if user changes
        authenticationService.$user
            .receive(on: DispatchQueue.main)
            .sink { user in
                self.loadData()
            }
            .store(in: &cancellables)
    }

    private func loadData() {
        // Pull data from Firestore
        // Organize data based on 'createdTime' <- will need update
        if listenerRegistration != nil {
            listenerRegistration?.remove()
        }
        // FAQ
        listenerRegistration = database.collection(path)
            .addSnapshotListener { (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    self.faq = querySnapshot.documents.compactMap { document -> FAQ? in
                        try? document.data(as: FAQ.self)
                    }
                }
        }
        
        // Admin
        listenerRegistration = database.collection(adminPath)
            .addSnapshotListener { (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    self.admin = querySnapshot.documents.compactMap { document -> Admin? in
                        try? document.data(as: Admin.self)
                    }
                }
        }
    }
}
