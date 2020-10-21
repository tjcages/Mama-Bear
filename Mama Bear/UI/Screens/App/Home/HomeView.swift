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
    
    var listings: [ListingCellViewModel] {
        var listings: [ListingCellViewModel] = []
        for listingCellVM in listingListVM.listingCellViewModels {
            if listingCellVM.listing.endDate.dateValue() > Date() {
                listings.append(listingCellVM)
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
                        .padding(.bottom, !listings.isEmpty ? 0 : Sizes.Big)
                }

                if !listings.isEmpty {
                    ForEach(listings) { listingCellViewModel in
                        Upcoming_HomeView(authenticationService: authenticationService, listingListVM: listingListVM, listingCellVM: listingCellViewModel)
                            .padding(.bottom, Sizes.Default)
                    }
                } else {
                    Image("nannyHomeGraphic")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.horizontal, Sizes.Big)

                    Text("No upcoming listings.\nAdd a listing to view here.")
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
