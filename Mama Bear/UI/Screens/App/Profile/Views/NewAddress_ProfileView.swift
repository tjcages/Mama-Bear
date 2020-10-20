//
//  Address_ProfileView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/7/20.
//

import SwiftUI

struct NewAddress_ProfileView: View {
    @ObservedObject var authenticationService: AuthenticationService

    @Binding var showSheet: Bool

    @State var addressText: String = ""
    @State var cityText: String = ""
    @State var stateText: String = ""
    @State var zipText: String = ""

    var addressFields: [TextViewCase] = [.streetAddress, .city, .state, .zip]

    var body: some View {
        let newAddress = authenticationService.userAddress == nil
        
        VStack(alignment: .leading) {
            BackButton() {
                showSheet.toggle()
            }

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    Text("New home address")
                        .customFont(.heavy, category: .extraLarge)
                        .foregroundColor(Colors.headline)
                        .padding(.top, Sizes.Large)
                        .padding(.bottom, Sizes.Large)
                        .padding(.horizontal, Sizes.Default)

                    Group {
                        BrandTextView(item: .streetAddress, $addressText)
                        BrandTextView(item: .city, $cityText)
                        BrandTextView(item: .state, $stateText)
                        BrandTextView(item: .zip, $zipText)
                    }
                        .padding(.bottom, Sizes.xSmall)
                        .padding(.horizontal, Sizes.Default)
                }

                Group {
                    ConfirmButton(title: "Save", style: .fill) {
                        // Save address
                        let address = Address(street: addressText, city: cityText, state: stateText, zip: zipText, userId: authenticationService.user?.uid)
                        authenticationService.addAddressToFirestore(address: address)
                        showSheet.toggle()
                    }

                    ConfirmButton(title: newAddress ? "Cancel" : "Delete", style: .lined) {
                        if !newAddress, let address = authenticationService.userAddress {
                            authenticationService.removeAddress(address)
                        }
                        showSheet.toggle()
                    }
                }
                    .padding(.bottom, Sizes.Spacer)
                    .padding(.horizontal, Sizes.Default)

                Spacer()
            }
        }
            .background(Colors.cellBackground.edgesIgnoringSafeArea(.all))
            .onAppear {
                addressText = authenticationService.userAddress?.street ?? ""
                cityText = authenticationService.userAddress?.city ?? ""
                stateText = authenticationService.userAddress?.state ?? ""
                zipText = authenticationService.userAddress?.zip ?? ""
        }
    }
}
