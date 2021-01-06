//
//  PostListingView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/6/20.
//

import SwiftUI
import Firebase
import MapKit

struct ListingLocation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct PostListingView: View {
    @ObservedObject var authenticationService: AuthenticationService
    @ObservedObject var listingCellVM: ListingCellViewModel
    @ObservedObject var viewRouter: ViewRouter
    
    @Binding var showingPostListing: Bool

    var onCommit: (Result<Listing, InputError>) -> Void = { _ in }

    @State var presentPartialSheet = false
    @State var child = Child()
    @State var pet = Pet()

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            let upcoming = listingCellVM.listing.endDate.dateValue() > Date()
            let family = authenticationService.firestoreUser?.accountType == "Family"
            let currentJob = authenticationService.user?.uid == listingCellVM.listing.sitterId

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

                    if let sitter = listingCellVM.firestoreSitter, authenticationService.user?.uid != listingCellVM.listing.sitterId {
                        Group {
                            Text("Sitter")
                                .customFont(.medium, category: .large)
                                .foregroundColor(Colors.headline)
                                .padding(.top, Sizes.Default)
                                .padding(.horizontal, Sizes.Default)

                            Header_HomeView(firestoreUser: sitter, viewRouter: ViewRouter())
                        }
                    } else if let user = listingCellVM.firestoreUser {
                        Group {
                            Text("Family")
                                .customFont(.medium, category: .large)
                                .foregroundColor(Colors.headline)
                                .padding(.top, Sizes.Default)
                                .padding(.horizontal, Sizes.Default)

                            Header_HomeView(firestoreUser: user, viewRouter: ViewRouter())
                        }
                    }

                    Group {
                        Text("Time")
                            .customFont(.medium, category: .large)
                            .foregroundColor(Colors.headline)
                            .padding(.top, Sizes.Default)
                            .padding(.horizontal, Sizes.Default)

                        DurationView(newListing: false, listingDate: .constant(listingCellVM.listing.startDate.dateValue()), startTime: .constant(listingCellVM.listing.startDate.dateValue()), endTime: .constant(listingCellVM.listing.endDate.dateValue()))
                    }

                    // Location
                    if family {
                        Address_ProfileView(authenticationService: authenticationService, activeSheet: .constant(.none))
                    } else {
                        LocationMapView(listingCellVM: listingCellVM)
                    }

                    Group {
                        Text("Children")
                            .customFont(.medium, category: .large)
                            .foregroundColor(Colors.headline)
                            .padding(.top, Sizes.Default)
                            .padding(.horizontal, Sizes.Default)

                        ChildrenView(authenticationService: authenticationService, listingCellVM: listingCellVM, addNew: false, selectedChild: $child)
                    }

                    if let pets = listingCellVM.userPets, !pets.isEmpty {
                        Group {
                            Text("Pets")
                                .customFont(.medium, category: .large)
                                .foregroundColor(Colors.headline)
                                .padding(.top, Sizes.Default)
                                .padding(.horizontal, Sizes.Default)

                            PetsView(authenticationService: authenticationService, listingCellVM: listingCellVM, addNew: false, selectedPet: $pet)
                        }
                    }

                    if upcoming {
                        if family {
                            ConfirmButton(title: "Delete this request", style: .lined) {
                                // Delete listing
                                onCommit(.success(self.listingCellVM.listing))
                            }
                                .padding(.top, Sizes.Default)
                                .padding(.horizontal, Sizes.Default)
                        } else {
                            if currentJob {
                                ConfirmButton(title: "Cancel job", style: .lined) {
                                    // Cancel job
                                    authenticationService.removeBookedListing(self.listingCellVM.listing)
                                    
                                    delayWithSeconds(Animation.animationOut) {
                                        self.showingPostListing.toggle()
                                        self.viewRouter.currentView = .profile
                                        self.viewRouter.currentView = .home
                                    }
                                }
                                    .padding(.top, Sizes.Default)
                                    .padding(.horizontal, Sizes.Default)
                                
                                Text("You will be required to reach out to the family to confirm cancelation.")
                                    .customFont(.medium, category: .small)
                                    .foregroundColor(Colors.subheadline)
                                    .padding(.horizontal, Sizes.Large)
                                    .multilineTextAlignment(.center)
                                
                            } else {
                                ConfirmButton(title: "Book job", style: .fill) {
                                    // Confirm sitter
                                    if checkUserInformation() {
                                        authenticationService.bookListing(listing: listingCellVM.listing)
                                        
                                        delayWithSeconds(Animation.animationOut) {
                                            self.showingPostListing.toggle()
                                            self.viewRouter.currentView = .profile
                                            self.viewRouter.currentView = .home
                                        }
                                    } else {
                                        self.presentPartialSheet.toggle()
                                    }
                                }
                                    .padding(.top, Sizes.Default)
                                    .padding(.horizontal, Sizes.Default)
                            }
                        }
                    }

                    Color.clear.padding(.bottom, Sizes.Big * 2)

                    Spacer()
                }
            }
            .sheet(isPresented: $presentPartialSheet) {
                AdditionalDetails(authenticationService: authenticationService, showSheet: $presentPartialSheet)
            }
        }
    }
    
    func checkUserInformation() -> Bool {
        if let user = authenticationService.firestoreUser {
            if user.name == "" || user.email == "" || user.phoneNumber == "" {
                return false
            } else {
                return true
            }
        } else {
            return false
        }
    }
}
