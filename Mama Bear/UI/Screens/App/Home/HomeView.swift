//
//  HomeView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/5/20.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var authenticationService: AuthenticationService
    @ObservedObject var listingListVM: ListingListViewModel
    @ObservedObject var viewRouter: ViewRouter
    
    var ongoingListing: [ListingCellViewModel] {
        var listings: [ListingCellViewModel] = []
        for listingCellVM in listingListVM.listingCellViewModels {
            if listingCellVM.listing.endDate.dateValue() > Date() {
                if authenticationService.user?.uid == listingCellVM.firestoreSitter?.id {
                    // Nanny upcoming listings
                    listings.append(listingCellVM)
                }
            }
        }
        return listings
    }

    var listings: [ListingCellViewModel] {
        var listings: [ListingCellViewModel] = []
        for listingCellVM in listingListVM.listingCellViewModels {
            if listingCellVM.listing.endDate.dateValue() > Date() {
                if authenticationService.firestoreUser?.accountType ?? "Nanny" == "Family" && listingCellVM.listing.userId == authenticationService.user?.uid {
                    // Family upcoming listings
                    listings.append(listingCellVM)
                } else if authenticationService.firestoreUser?.accountType ?? "Family" == "Nanny" && listingCellVM.listing.sitterId == "" {
                    // Nanny available listings
                    listings.append(listingCellVM)
                }
            }
        }
        return listings
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: Sizes.xSmall) {
                Text("Home")
                    .customFont(.heavy, category: .extraLarge)
                    .foregroundColor(Colors.headline)
                    .padding(.top, Sizes.Large)
                    .padding([.bottom, .horizontal], Sizes.Default)

                if let user = authenticationService.firestoreUser {
                    Header_HomeView(firestoreUser: user, viewRouter: viewRouter)
                }
                
                if !ongoingListing.isEmpty {
                    // Only show upcoming listings for Nanny
                    VStack(alignment: .leading) {
                        Text("Upcoming listings")
                            .customFont(.medium, category: .large)
                            .foregroundColor(Colors.headline)
                            .padding(.top, Sizes.Default)
                            .padding(.bottom, Sizes.Spacer)
                            .padding(.horizontal, Sizes.Default)

                        ForEach(ongoingListing) { listingCellViewModel in
                            Upcoming_HomeView(authenticationService: authenticationService, listingListVM: listingListVM, listingCellVM: listingCellViewModel, viewRouter: viewRouter)
                                .padding(.bottom, Sizes.Default)
                        }
                    }
                }

                if !listings.isEmpty {
                    if authenticationService.firestoreUser?.accountType ?? "Nanny" == "Family" {
                        // Only show families listings
                        VStack(alignment: .leading) {
                            Text("Upcoming listings")
                                .customFont(.medium, category: .large)
                                .foregroundColor(Colors.headline)
                                .padding(.top, Sizes.Default)
                                .padding(.bottom, Sizes.Spacer)
                                .padding(.horizontal, Sizes.Default)

                            ForEach(listings) { listingCellViewModel in
                                Upcoming_HomeView(authenticationService: authenticationService, listingListVM: listingListVM, listingCellVM: listingCellViewModel, viewRouter: viewRouter)
                                    .padding(.bottom, Sizes.Default)
                            }
                        }
                    } else {
                        // Show all listings
                        VStack(alignment: .leading) {
                            Text("Job board")
                                .customFont(.medium, category: .large)
                                .foregroundColor(Colors.headline)
                                .padding(.top, Sizes.Default)
                                .padding(.bottom, Sizes.Spacer)
                                .padding(.horizontal, Sizes.Default)

                            ForEach(listings) { listingCellViewModel in
                                Listings_HomeView(authenticationService: authenticationService, listingListVM: listingListVM, listingCellVM: listingCellViewModel, viewRouter: viewRouter)
                                    .padding(.bottom, Sizes.Default)
                            }
                        }
                    }
                } else {
                    Image("nannyHomeGraphic")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.horizontal, Sizes.Big)
                        .padding(.top, !listings.isEmpty ? 0 : Sizes.Big)

                    Text(authenticationService.firestoreUser?.accountType ?? "Nanny" == "Family" ? "No upcoming listings.\nAdd a listing to view here." : "No upcoming jobs.")
                        .customFont(.medium, category: .medium)
                        .foregroundColor(Colors.subheadline)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }

                Color.clear.padding(.bottom, Sizes.Big * 2)

                Spacer()
            }
        }
    }
}
