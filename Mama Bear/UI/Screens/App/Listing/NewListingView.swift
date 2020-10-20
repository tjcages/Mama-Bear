//
//  NewListingView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/5/20.
//

import SwiftUI

struct NewListingView: View {
    @ObservedObject var authenticationService: AuthenticationService

    @State var activeSheet: ActiveSheet = .first
    @State var showSheet: Bool = false

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: Sizes.xSmall) {
                Text("Request a babysitter")
                    .customFont(.heavy, category: .extraLarge)
                    .foregroundColor(Colors.headline)
                    .padding(.top, Sizes.Large)
                    .padding(.horizontal, Sizes.Default)

                Text("Time")
                    .customFont(.medium, category: .large)
                    .foregroundColor(Colors.headline)
                    .padding(.top, Sizes.Default)
                    .padding(.horizontal, Sizes.Default)

                DurationView(newListing: true, activeSheet: $activeSheet.didSet { _ in
                    showSheet.toggle()
                })

                // Address view
                if authenticationService.userAddress != nil {
                    Address_ProfileView(authenticationService: authenticationService, activeSheet: $activeSheet.didSet { _ in
                        showSheet.toggle()
                    })
                } else {
                    AccountSelectionView(CreateAccount(title: "Address", subtitle: "Add a home address", color: Colors.cellBackground, image: "onboardingGraphic_3", type: .unknown))
                        .shadow()
                        .onTapGesture {
                            activeSheet = .third
                            showSheet.toggle()
                        }
                        .padding(Sizes.Spacer)
                }

                Spacer()

                ConfirmButton(title: "Next", style: .fill) {
                    activeSheet = .first
                    showSheet.toggle()
                }
                    .padding(.horizontal, Sizes.Default)

                Color.clear.padding(.bottom, Sizes.Big * 2)
            }
        }
            .sheet(isPresented: $showSheet) {
                if activeSheet == .first {
                    Details_NewListingView(authenticationService: authenticationService, showSheet: $showSheet)
                } else if activeSheet == .third {
                    NewAddress_ProfileView(authenticationService: authenticationService, showSheet: $showSheet)
                }
        }
    }
}
