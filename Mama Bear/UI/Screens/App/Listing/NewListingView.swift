//
//  NewListingView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/5/20.
//

import SwiftUI
import Firebase

struct NewListingView: View {
    @ObservedObject var authenticationService: AuthenticationService
    @ObservedObject var listingCellVM: ListingCellViewModel
    
    var onCommit: (Result<Listing, InputError>) -> Void = { _ in }
    
    @State var activeSheet: ActiveSheet = .first
    @State var showSheet: Bool = false
    
    @State var listingDate = Date()
    @State var endingTime = Date().addingTimeInterval(28800)

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

                DurationView(newListing: true, startDate: $listingDate, endDate: $endingTime)

                // Address view
                Address_NewListingView(authenticationService: authenticationService, activeSheet: $activeSheet.didSet { _ in
                        showSheet.toggle()
                    }
                )

                Spacer()

                ConfirmButton(title: "Next", style: .fill) {
                    activeSheet = .first
                    
                    setListingData()
                    
                    showSheet.toggle()
                }
                    .padding(.horizontal, Sizes.Default)
                    .disabled(authenticationService.userAddress == nil)
                    .opacity(authenticationService.userAddress == nil ? 0.5 : 1)

                Color.clear.padding(.bottom, Sizes.Big * 2)
            }
        }
            .sheet(isPresented: $showSheet) {
                if activeSheet == .first {
                    Details_NewListingView(authenticationService: authenticationService, listingCellVM: listingCellVM, showSheet: $showSheet) { result in
                        onCommit(result)
                    }
                } else if activeSheet == .third {
                    NewAddress_ProfileView(authenticationService: authenticationService, showSheet: $showSheet)
                }
        }
    }
    
    func setListingData() {
        listingCellVM.listing.startDate = Timestamp.init(date: listingDate)
        listingCellVM.listing.endDate = Timestamp.init(date: endingTime)
    }
}
