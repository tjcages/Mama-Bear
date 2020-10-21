//
//  Details_NewListingView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/7/20.
//

import SwiftUI

struct Details_NewListingView: View {
    @ObservedObject var authenticationService: AuthenticationService
    @ObservedObject var listingCellVM: ListingCellViewModel

    @Binding var showSheet: Bool
    var onCommit: (Result<Listing, InputError>) -> Void = { _ in }

    @State var presentPartialSheet: Bool = false

    @State var activeSheet: ActiveSheet = .first

    @State var child = Child()
    @State var pet = Pet()
    @State var sitterRequirement: SitterRequirement = .highSchool

    var body: some View {
        VStack(alignment: .leading) {
            BackButton() {
                showSheet.toggle()
            }

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: Sizes.xSmall) {
                    Text("Additional details")
                        .customFont(.heavy, category: .extraLarge)
                        .foregroundColor(Colors.headline)
                        .padding(.top, Sizes.Large)
                        .padding(.horizontal, Sizes.Default)

                    Text("Children")
                        .customFont(.medium, category: .large)
                        .foregroundColor(Colors.headline)
                        .padding(.top, Sizes.Default)
                        .padding(.horizontal, Sizes.Default)

                    ChildrenView(authenticationService: authenticationService, selectedChild: $child.didSet { _ in
                        activeSheet = .first
                        presentPartialSheet.toggle()
                    })

                    Text("Pets")
                        .customFont(.medium, category: .large)
                        .foregroundColor(Colors.headline)
                        .padding(.top, Sizes.Default)
                        .padding(.horizontal, Sizes.Default)

                    PetsView(authenticationService: authenticationService, selectedPet: $pet.didSet { _ in
                        activeSheet = .second
                        presentPartialSheet.toggle()
                    })

                    // Sitter requirements
                    Text("Sitter requirement")
                        .customFont(.medium, category: .large)
                        .foregroundColor(Colors.headline)
                        .padding(.top, Sizes.Default)
                        .padding(.horizontal, Sizes.Default)

                    SitterRequirementView(sitterRequirement: $sitterRequirement)

                    Spacer()

                    Group {
                        ConfirmButton(title: "Post listing", style: .fill) {
                            // Post listing
                            setListingData()
                            
                            onCommit(.success(self.listingCellVM.listing))
                            
                            showSheet.toggle()
                        }
                            .padding(.top, Sizes.Default)
                            .disabled(authenticationService.userChildren?.isEmpty ?? true)
                            .opacity(authenticationService.userChildren?.isEmpty ?? true ? 0.3 : 1)

                        ConfirmButton(title: "Cancel", style: .lined) {
                            // Cancel posting listing
                            showSheet.toggle()
                        }
                    }
                        .padding(.horizontal, Sizes.Default)

                    Spacer()
                }
            }
        }
            .sheet(isPresented: $presentPartialSheet) {
                if activeSheet == .first {
                    AddChildView(authenticationService: authenticationService, showSheet: $presentPartialSheet, child: child)
                } else if activeSheet == .second {
                    AddPetView(authenticationService: authenticationService, showSheet: $presentPartialSheet, pet: pet)
                }
        }
    }
    
    func setListingData() {
        listingCellVM.listing.userId = authenticationService.user?.uid
        listingCellVM.listing.childrenId = authenticationService.userChildren?.compactMap { child -> String? in
            child.id
        } ?? []
        listingCellVM.listing.petsId = authenticationService.userPets?.compactMap { pet -> String? in
            pet.id
        } ?? []
        listingCellVM.listing.sitterRequirement = sitterRequirement.rawValue
    }
}
