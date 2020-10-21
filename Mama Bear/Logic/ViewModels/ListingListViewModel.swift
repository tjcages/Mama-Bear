//
//  TaskListViewModel.swift
//  Gather
//
//  Created by Tyler Cagle on 9/28/20.
//

import Foundation
import Combine
import Resolver

class ListingListViewModel: ObservableObject {
    @Published var listingRepository: ListingRepository = Resolver.resolve()
    @Published var listingCellViewModels = [ListingCellViewModel]()

    private var cancellables = Set<AnyCancellable>()

    init() {
        listingRepository.$listings.map { listings in
            listings.map { listing in
                ListingCellViewModel(listing: listing)
            }
        }
            .assign(to: \.listingCellViewModels, on: self)
            .store(in: &cancellables)
    }

    func removeListing(_ listing: Listing) {
        // Remove from repo
        listingRepository.removeListing(listing)
    }

    func addListing(listing: Listing) {
        listingRepository.addListing(listing)
    }
}
