//
//  TaskCellViewModel.swift
//  Gather
//
//  Created by Tyler Cagle on 9/28/20.
//

import Foundation
import Combine
import Resolver
import Firebase

import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class ListingCellViewModel: ObservableObject, Identifiable {
    @Injected var listingRepository: ListingRepository

    @Published var listing: Listing
    @Published var firestoreUser: FirestoreUser?
    @Published var firestoreSitter: FirestoreUser?
    @Published var userAddress: Address?
    @Published var userChildren: [Child]?
    @Published var userPets: [Pet]?
    
    private var listenerRegistration: ListenerRegistration?

    var id: String = ""

    private var cancellables = Set<AnyCancellable>()
    
    private var database = Firestore.firestore()
    private var usersPath: String = "users"
    private var addressPath: String = "addresses"
    private var childrenPath: String = "children"
    private var petsPath: String = "pets"

    static func newListing() -> ListingCellViewModel {
        ListingCellViewModel(listing: Listing(startDate: Timestamp.init(date: Date()), endDate: Timestamp.init(date: Date().addingTimeInterval(28800)), childrenId: [], sitterRequirement: SitterRequirement.college.rawValue, distanceText: ""))
    }

    init(listing: Listing) {
        self.listing = listing

        $listing
            .compactMap { $0.id }
            .assign(to: \.id, on: self)
            .store(in: &cancellables)

        $listing
            .dropFirst()
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .sink { [weak self] task in
                self?.listingRepository.updateListing(listing)
            }
            .store(in: &cancellables)
    
        // Now get Firestore data
        if let id = listing.userId {
            self.loadData(id: id)
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
        // Family data
        if let userId = listing.userId {
            listenerRegistration = database.collection(usersPath).document(userId).addSnapshotListener { (snapshot, error) in
                if let error = error {
                    print("Error listening to Firestore user at document id: \(error)")
                }
                if let snapshot = snapshot {
                    self.firestoreUser = try? snapshot.data(as: FirestoreUser.self)
                }
            }
        }
        
        // Sitter data
        if listing.sitterId != "" {
            listenerRegistration = database.collection(usersPath).document(listing.sitterId).addSnapshotListener { (snapshot, error) in
                if let error = error {
                    print("Error listening to Firestore user at document id: \(error)")
                }
                if let snapshot = snapshot {
                    self.firestoreSitter = try? snapshot.data(as: FirestoreUser.self)
                }
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
        userChildren = []
        for childId in listing.childrenId {
            listenerRegistration = database.collection(childrenPath).document(childId).addSnapshotListener { (snapshot, error) in
                if let error = error {
                    print("Error listening to Firestore user address at document id: \(error)")
                }
                if let snapshot = snapshot, let child = try? snapshot.data(as: Child.self) {
                    self.userChildren?.append(child)
                }
            }
        }
        
        // Pet data
        userPets = []
        if let petArray = listing.petsId {
            for petId in petArray {
                listenerRegistration = database.collection(petsPath).document(petId).addSnapshotListener { (snapshot, error) in
                    if let error = error {
                        print("Error listening to Firestore user address at document id: \(error)")
                    }
                    if let snapshot = snapshot, let petId = try? snapshot.data(as: Pet.self) {
                        self.userPets?.append(petId)
                    }
                }
            }
        }
    }
    
}
