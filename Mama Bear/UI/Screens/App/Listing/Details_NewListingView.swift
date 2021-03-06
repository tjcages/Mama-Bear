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
    @ObservedObject var adminPrices = AdminViewModel()

    @Binding var showSheet: Bool
    @State var duration: Double
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

                    ChildrenView(authenticationService: authenticationService, listingCellVM: listingCellVM, addNew: true, selectedChild: $child.didSet { _ in
                        activeSheet = .first
                        presentPartialSheet.toggle()
                    })

                    Text("Pets")
                        .customFont(.medium, category: .large)
                        .foregroundColor(Colors.headline)
                        .padding(.top, Sizes.Default)
                        .padding(.horizontal, Sizes.Default)

                    PetsView(authenticationService: authenticationService, listingCellVM: listingCellVM, addNew: true, selectedPet: $pet.didSet { _ in
                        activeSheet = .second
                        presentPartialSheet.toggle()
                    })

                    // Sitter requirements
                    Group {
                        Text("Sitter requirement")
                            .customFont(.medium, category: .large)
                            .foregroundColor(Colors.headline)
                            .padding(.top, Sizes.Default)
                            .padding(.horizontal, Sizes.Default)

                        SitterRequirementView(adminPrices: adminPrices, sitterRequirement: $sitterRequirement)
                        
                        HStack {
                            Text("Total:")
                                .customFont(.medium, category: .large)
                                .foregroundColor(Colors.headline)
                            
                            Spacer()
                            
                            Text(String(format: "$%.2f", getPrice(requirement: sitterRequirement)))
                                .customFont(.medium, category: .large)
                                .foregroundColor(Colors.darkCoral)
                        }
                        .padding(.top, Sizes.Default)
                        .padding(.horizontal, Sizes.Default)
                    }
                    
                    Group {
                        ConfirmButton(title: "Post listing", style: .fill) {
                            // Post listing
                            setListingData()
                            
                            if checkUserInformation() {
                                onCommit(.success(self.listingCellVM.listing))
                                
                                showSheet.toggle()
                            } else {
                                activeSheet = .third
                                presentPartialSheet.toggle()
                            }
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
                } else if activeSheet == .third {
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
    
    func getPrice(requirement: SitterRequirement) -> Double {
        if let admin = adminPrices.admin.first {
            switch requirement {
            case .highSchool:
                return Double(admin.highSchool) * duration
            case .college:
                return Double(admin.college) * duration
            case .postGrad:
                return Double(admin.postGrad) * duration
            }
        } else {
            return 0
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
