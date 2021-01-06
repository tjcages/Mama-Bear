//
//  Listings_HomeView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/21/20.
//

import SwiftUI
import Foundation
import MapKit

struct Listings_HomeView: View {
    @ObservedObject var authenticationService: AuthenticationService
    @ObservedObject var listingListVM: ListingListViewModel
    @ObservedObject var listingCellVM: ListingCellViewModel
    @ObservedObject var viewRouter: ViewRouter
    @ObservedObject var locationManager = LocationManager()

    @State var locations: [ListingLocation] = []
    @State var showingPostListing = false

    init(authenticationService: AuthenticationService, listingListVM: ListingListViewModel, listingCellVM: ListingCellViewModel, viewRouter: ViewRouter) {
        self.authenticationService = authenticationService
        self.listingListVM = listingListVM
        self.listingCellVM = listingCellVM
        self.viewRouter = viewRouter

        if let address = listingCellVM.userAddress {
            getLocation(userAddress: address)
        }
    }

    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }

    var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
    
    func getUserName(fullName: String) -> String {
        var name = fullName
        let fullNameArr = fullName.components(separatedBy: " ")
        let firstName: String = fullNameArr[0]
        let lastName: String = fullNameArr.count > 1 ? fullNameArr[1] : ""
        if let firstInitial = lastName.first {
            name = "\(firstName) \(firstInitial)"
        } else {
            name = "\(firstName)"
        }
        return name
    }

    var body: some View {
        VStack(alignment: .leading) {
            // Family details
            HStack {
                VStack(alignment: .leading) {
                    Text(getUserName(fullName: listingCellVM.firestoreUser?.name ?? ""))
                        .customFont(.medium, category: .medium)
                        .foregroundColor(Colors.headline)

                    Text(listingCellVM.listing.distanceText)
                        .customFont(.medium, category: .small)
                        .foregroundColor(Colors.subheadline)
                }

                Spacer()

                Button(action: {
                    showingPostListing.toggle()
                }, label: {
                        Text("See details")
                            .customFont(.heavy, category: .small)
                            .foregroundColor(.white)
                            .padding(Sizes.xSmall)
                            .background(Colors.lightCoral)
                            .cornerRadius(Sizes.Spacer)
                    }
                )
            }

            // Divider
            Rectangle()
                .foregroundColor(Colors.subheadline.opacity(0.3))
                .frame(height: 1)
                .padding(.vertical, Sizes.xSmall)

            // Date
            HStack {
                Image(systemName: "calendar")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: Sizes.xSmall, height: Sizes.xSmall)
                    .foregroundColor(Colors.coral)

                if let createdDate = listingCellVM.listing.startDate.dateValue() {
                    Text("\(createdDate, formatter: dateFormatter)")
                        .customFont(.heavy, category: .small)
                        .foregroundColor(Colors.coral)
                }
            }
                .padding(Sizes.Spacer)
                .padding(.horizontal, Sizes.Spacer / 2)
                .background(Colors.coral.opacity(0.2))
                .cornerRadius(Sizes.Spacer)
                .padding(.bottom, Sizes.Spacer)

            // Duration
            HStack(alignment: .center) {
                Image(systemName: "clock")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: Sizes.xSmall, height: Sizes.xSmall)
                    .foregroundColor(Colors.subheadline)

                if let createdDate = listingCellVM.listing.startDate.dateValue() {
                    Text("\(createdDate, formatter: timeFormatter)")
                        .customFont(.medium, category: .small)
                        .foregroundColor(Colors.subheadline)
                        .fixedSize(horizontal: true, vertical: false)
                }

                Image(systemName: "arrow.right")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: Sizes.xSmall, height: Sizes.xSmall)
                    .foregroundColor(Colors.subheadline)

                if let createdDate = listingCellVM.listing.endDate.dateValue() {
                    Text("\(createdDate, formatter: timeFormatter)")
                        .customFont(.medium, category: .small)
                        .foregroundColor(Colors.subheadline)
                        .fixedSize(horizontal: true, vertical: false)
                }
            }

            // Divider
            Rectangle()
                .foregroundColor(Colors.subheadline.opacity(0.3))
                .frame(height: 1)
                .padding(.vertical, Sizes.xSmall)

            HStack {
                // Children
                if let children = listingCellVM.userChildren, !children.isEmpty {
                    HStack {
                        ForEach(children) { child in
                            Image(child.gender == Gender.male.rawValue ? (child.ageCategory == .baby ? "babyIcon" : (child.ageCategory == .toddler ? "toddlerIcon" : "teenagerIcon")) : (child.ageCategory == .baby ? "babyIcon" : (child.ageCategory == .toddler ? "toddlerFemaleIcon" : "teenagerFemaleIcon")))
                                .renderingMode(.template)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: Sizes.Small, height: Sizes.Small)
                                .foregroundColor(Colors.blue)
                        }

                        Text("\(children.count)")
                            .customFont(.heavy, category: .small)
                            .foregroundColor(Colors.blue)
                    }
                        .padding(Sizes.Spacer)
                        .padding(.horizontal, Sizes.Spacer / 2)
                        .background(Colors.blue.opacity(0.2))
                        .cornerRadius(Sizes.Spacer)
                        .padding(.top, Sizes.Spacer)
                }

                // Pets
                if let pets = listingCellVM.userPets, !pets.isEmpty {
                    HStack {
                        ForEach(pets) { pet in
                            Image(pet.type == Animal.dog.rawValue ? "dogIcon" : "catIcon")
                                .renderingMode(.template)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: Sizes.Small, height: Sizes.Small)
                                .foregroundColor(Colors.sienna)
                        }

                        Text("Pets at home")
                            .customFont(.heavy, category: .small)
                            .foregroundColor(Colors.sienna)
                    }
                        .padding(Sizes.Spacer)
                        .padding(.horizontal, Sizes.Spacer / 2)
                        .background(Colors.sienna.opacity(0.2))
                        .cornerRadius(Sizes.Spacer)
                        .padding(.top, Sizes.Spacer)
                }

                Spacer()
            }
        }
            .padding(Sizes.Default)
            .background(Colors.cellBackground)
            .cornerRadius(Sizes.Spacer)
            .shadow()
            .padding(.horizontal, Sizes.Default)
            .sheet(isPresented: $showingPostListing) {
                PostListingView(authenticationService: authenticationService, listingCellVM: listingCellVM, viewRouter: viewRouter, showingPostListing: $showingPostListing) { result in
                    if case .success(let listing) = result {
                        listingListVM.removeListing(listing)
                        showingPostListing.toggle()
                    }
                }
        }
    }

    func getLocation(userAddress: Address) {
        let geocoder = CLGeocoder()
        let address = "\(userAddress.street), \(userAddress.city) \(userAddress.state) \(userAddress.zip)"

        geocoder.geocodeAddressString(address) {
            placemarks, error in
            let placemark = placemarks?.first
            if let lat = placemark?.location?.coordinate.latitude, let lon = placemark?.location?.coordinate.longitude {
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                
                listingCellVM.listing.addressLat = lat
                listingCellVM.listing.addressLong = lon

                if let from = locationManager.lastLocation?.coordinate {
                    let to = coordinate
                    let fromLocation = CLLocation(latitude: from.latitude, longitude: from.longitude)
                    let toLocation = CLLocation(latitude: to.latitude, longitude: to.longitude)
                    let meters = fromLocation.distance(from: toLocation)
                    let miles = meters / 1609.34
                    let string = String(format: "%.2f", miles) + " mi away"
                    listingCellVM.listing.distanceText = string
                }
            }
        }
    }
}
