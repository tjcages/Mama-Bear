//
//  FirestoreTaskRepository.swift
//  Gather
//
//  Created by Tyler Cagle on 9/28/20.
//

import Foundation

import FirebaseFirestore
import FirebaseFirestoreSwift

import Resolver
import Combine

class BaseListingRepository {
    @Published var listings = [Listing]()
}

protocol ListingRepository: BaseListingRepository {
    func addListing(_ task: Listing)
    func removeListing(_ task: Listing)
    func updateListing(_ task: Listing)
}

class FirestoreListingRepository: BaseListingRepository, ListingRepository, ObservableObject {
    var database = Firestore.firestore()
    @Injected var authenticationService: AuthenticationService

    var listingsPath: String = "listings"
    var userId: String = "unknown"

    private var listenerRegistration: ListenerRegistration?
    private var cancellables = Set<AnyCancellable>()

    override init() {
        super.init()

        authenticationService.$user
            .compactMap { user in
                user?.uid
            }
            .assign(to: \.userId, on: self)
            .store(in: &cancellables)

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
        listenerRegistration = database.collection(listingsPath)
            .order(by: "createdTime")
            .addSnapshotListener { (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    self.listings = querySnapshot.documents.compactMap { document -> Listing? in
                        try? document.data(as: Listing.self)
                    }
                }
        }
    }

    func addListing(_ listing: Listing) {
        do {
            var userListing = listing
            userListing.userId = self.userId
            userListing.updatedTime = nil
            let _ = try database.collection(listingsPath).addDocument(from: userListing)
        }
        catch {
            print("There was an error while trying to save a task: \(error.localizedDescription).")
        }
    }

    func removeListing(_ listing: Listing) {
        if let listingId = listing.id {
            database.collection(listingsPath).document(listingId).delete { (error) in
                if let error = error {
                    print("Error removing document: \(error.localizedDescription).")
                }
            }
        }
    }

    func updateListing(_ listing: Listing) {
        if let listingId = listing.id, authenticationService.user?.uid ==  listing.userId || authenticationService.user?.uid == listing.sitterId {
            do {
                var updatedListing = listing
                updatedListing.updatedTime = nil
                try database.collection(listingsPath).document(listingId).setData(from: updatedListing)
            }
            catch {
                print("There was an error while trying to update a task: \(error.localizedDescription).")
            }
        }
    }

}
