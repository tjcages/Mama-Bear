//
//  Address_NewListingView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/22/20.
//

import SwiftUI

struct Address_NewListingView: View {
    @ObservedObject var authenticationService: AuthenticationService
    
    @Binding var activeSheet: ActiveSheet
    
    var body: some View {
        if authenticationService.userAddress != nil {
            Address_ProfileView(authenticationService: authenticationService, activeSheet: $activeSheet)
        } else {
            AccountSelectionView(CreateAccount(title: "Address", subtitle: "Add a home address", color: Colors.cellBackground, image: "onboardingGraphic_3", type: .nanny))
                .shadow()
                .onTapGesture {
                    activeSheet = .third
                }
                .padding(Sizes.Spacer)
        }
    }
}
