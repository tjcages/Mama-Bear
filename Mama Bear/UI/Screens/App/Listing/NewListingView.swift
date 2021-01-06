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
    @State var startTime = Date().addingTimeInterval(86400) // Advancing 24 hours
    @State var endingTime = Date().addingTimeInterval(115200) // Advancing 32 hours

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

                DurationView(newListing: true, listingDate: $listingDate, startTime: $startTime, endTime: $endingTime)

                // Address view
                Address_NewListingView(authenticationService: authenticationService, activeSheet: $activeSheet.didSet { _ in
                        showSheet.toggle()
                    }
                )

                Spacer()

                ConfirmButton(title: "Next", style: .fill) {
                    setListingData()
                    
                    activeSheet = .first
                    
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
                    Details_NewListingView(authenticationService: authenticationService, listingCellVM: listingCellVM, showSheet: $showSheet, duration: getDuration()) { result in
                        onCommit(result)
                    }
                } else if activeSheet == .third {
                    NewAddress_ProfileView(authenticationService: authenticationService, showSheet: $showSheet)
                }
        }
    }
    
    func getDuration() -> Double {
        let diffComponents = Calendar.current.dateComponents([.hour, .minute], from: startTime, to: endingTime)
        let hours = diffComponents.hour ?? 8
        let minutes = diffComponents.minute ?? 0
        let roundedMin = (Double(minutes) / 15.0).rounded() * 15 // Round to the nearest 15 minutes
        let totalHours = roundedMin / 60 + Double(hours)
        
        return totalHours
    }
    
    func setListingData() {
        let calendar = Calendar.current

        var startComponents: DateComponents? = calendar.dateComponents([.minute, .hour], from: startTime)
        var endComponents: DateComponents? = calendar.dateComponents([.minute, .hour], from: endingTime)
        let listingComponents: DateComponents? = calendar.dateComponents([.day, .month, .year], from: listingDate)

        startComponents?.day = listingComponents?.day
        startComponents?.month = listingComponents?.month
        startComponents?.year = listingComponents?.year
        
        endComponents?.day = listingComponents?.day
        endComponents?.month = listingComponents?.month
        endComponents?.year = listingComponents?.year

        startTime = calendar.date(from: startComponents!) ?? startTime
        endingTime = calendar.date(from: endComponents!) ?? endingTime
        
        let difference = startTime.distance(to: endingTime)
        if difference <= 0 {
            endingTime = endingTime.addingTimeInterval(86400) // Advancing 24 hours
        }
        
        listingCellVM.listing.startDate = Timestamp.init(date: startTime)
        listingCellVM.listing.endDate = Timestamp.init(date: endingTime)
    }
}
