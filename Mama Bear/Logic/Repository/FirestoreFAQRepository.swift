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
}

class FirestoreFAQRepository: BaseFAQRepository, ObservableObject {
    var database = Firestore.firestore()
    @Injected var authenticationService: AuthenticationService

    var path: String = "FAQ"

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
        listenerRegistration = database.collection(path)
            .addSnapshotListener { (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    self.faq = querySnapshot.documents.compactMap { document -> FAQ? in
                        try? document.data(as: FAQ.self)
                    }
                    print(self.faq)
                }
        }
    }
}
