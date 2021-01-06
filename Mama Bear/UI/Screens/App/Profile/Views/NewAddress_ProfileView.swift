//
//  Address_ProfileView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/7/20.
//

import SwiftUI
import MapKit

struct NewAddress_ProfileView: View {
    @ObservedObject var authenticationService: AuthenticationService

    @Binding var showSheet: Bool

    @State var addressText = ""
    @State var cityText = ""
    @State var stateText = ""
    @State var zipText = ""
    
    @State var showSuggestions = false
    
    @State var searchResults = [AutocompleteAddress]()

    var addressFields: [TextViewCase] = [.streetAddress, .city, .state, .zip]

    var body: some View {
        let newAddress = authenticationService.userAddress == nil
        
        VStack(alignment: .leading, spacing: 0) {
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
                        BrandTextView(item: .streetAddress, $addressText.didSet(execute: { text in
                            showSuggestions = true
                            getNearbyAddresses()
                        }))
                        if showSuggestions {
                            List {
                                ForEach(self.searchResults, id: \.self) { address in
                                    Button(action: {
                                        addressText = address.street
                                        cityText = address.city
                                        stateText = address.state
                                        zipText = address.zip
                                        showSuggestions = false
                                    }, label: {
                                        Text("\(address.street), \(address.city) \(address.state)")
                                            .customFont(.medium, category: .medium)
                                            .foregroundColor(Colors.headline)
                                            .padding(.vertical, Sizes.Spacer)
                                    })
                                }
                            }
                            .background(Color.red)
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                            .offset(y: -Sizes.Small)
                        }
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
    
    private func getNearbyAddresses() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = addressText
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            if let response = response {
                let mapItems = response.mapItems
                self.searchResults = mapItems.map {
                    AutocompleteAddress(placemark: $0.placemark)
                }
            }
        }
    }
}
