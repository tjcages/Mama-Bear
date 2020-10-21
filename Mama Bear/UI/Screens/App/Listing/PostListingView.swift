//
//  PostListingView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/6/20.
//

import SwiftUI
import Firebase

struct PostListingView: View {
    @ObservedObject var authenticationService: AuthenticationService
    @ObservedObject var listingCellVM: ListingCellViewModel

    @Binding var showingPostListing: Bool

    var onCommit: (Result<Listing, InputError>) -> Void = { _ in }

    @State var child = Child()
    @State var pet = Pet()

    var body: some View {
        VStack(alignment: .leading) {
            let upcoming = listingCellVM.listing.endDate.dateValue() > Date()

            BackButton() {
                showingPostListing.toggle()
            }

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: Sizes.xSmall) {
                    Text(upcoming ? "Upcoming listing" : "Listing details")
                        .customFont(.heavy, category: .extraLarge)
                        .foregroundColor(Colors.headline)
                        .padding(.top, Sizes.Large)
                        .padding(.horizontal, Sizes.Default)

                    if let sitter = listingCellVM.firestoreSitter {
                        Group {
                            Text("Sitter")
                                .customFont(.medium, category: .large)
                                .foregroundColor(Colors.headline)
                                .padding(.top, Sizes.Default)
                                .padding(.horizontal, Sizes.Default)

                            Header_HomeView(firestoreUser: sitter, viewRouter: ViewRouter())
                        }
                    }

                    Group {
                        Text("Time")
                            .customFont(.medium, category: .large)
                            .foregroundColor(Colors.headline)
                            .padding(.top, Sizes.Default)
                            .padding(.horizontal, Sizes.Default)

                        DurationView(newListing: false, startDate: .constant(listingCellVM.listing.startDate.dateValue()), endDate: .constant(listingCellVM.listing.endDate.dateValue()))
                    }

                    Address_ProfileView(authenticationService: authenticationService, activeSheet: .constant(.none))

                    Group {
                        Text("Children")
                            .customFont(.medium, category: .large)
                            .foregroundColor(Colors.headline)
                            .padding(.top, Sizes.Default)
                            .padding(.horizontal, Sizes.Default)

                        ChildrenView(authenticationService: authenticationService, selectedChild: $child)
                    }

                    Group {
                        Text("Pets")
                            .customFont(.medium, category: .large)
                            .foregroundColor(Colors.headline)
                            .padding(.top, Sizes.Default)
                            .padding(.horizontal, Sizes.Default)

                        PetsView(authenticationService: authenticationService, selectedPet: $pet)
                    }

                    if upcoming {
                        ConfirmButton(title: "Delete this request", style: .lined) {
                            // Delete listing
                            onCommit(.success(self.listingCellVM.listing))
                        }
                            .padding(.top, Sizes.Default)
                            .padding(.horizontal, Sizes.Default)
                    }

                    Color.clear.padding(.bottom, Sizes.Big * 2)

                    Spacer()
                }
            }
        }
    }
}
