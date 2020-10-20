//
//  Details_NewListingView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/7/20.
//

import SwiftUI

struct Details_NewListingView: View {
    @ObservedObject var authenticationService: AuthenticationService
    
    @Binding var showSheet: Bool
    @State var presentPartialSheet: Bool = false
    
    @State var activeSheet: ActiveSheet = .first
    
    @State var child = Child()
    @State var pet = Pet()

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

                    SitterRequirementView()

                    Spacer()

                    Group {
                        ConfirmButton(title: "Post listing", style: .fill) {
                            // Edit listing
                        }
                            .padding(.top, Sizes.Default)

                        ConfirmButton(title: "Cancel", style: .lined) {
                            // Delete listing
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
}
