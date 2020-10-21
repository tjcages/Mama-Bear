//
//  Upcoming_HomeView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/21/20.
//

import SwiftUI
import Firebase

struct Upcoming_HomeView: View {
    @ObservedObject var authenticationService: AuthenticationService
    @ObservedObject var listingListVM: ListingListViewModel
    @ObservedObject var listingCellVM: ListingCellViewModel

    @State var showingPostListing = false

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

    var body: some View {
        VStack(alignment: .leading) {
            Text("Upcoming listing")
                .customFont(.medium, category: .large)
                .foregroundColor(Colors.headline)
                .padding(.top, Sizes.Default)
                .padding(.bottom, Sizes.Spacer)

            VStack(alignment: .leading) {
                // Nanny details
                if listingCellVM.listing.sitterId != "" {
                    HStack {
                        // Profile image
                        ZStack(alignment: .topTrailing) {
                            // Profile picture
                            if listingCellVM.firestoreSitter?.photoURL == nil || listingCellVM.firestoreSitter?.photoURL == "" {
                                Image(systemName: "person")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: Sizes.Small, height: Sizes.Small)
                                    .padding((Sizes.xLarge - Sizes.Small) / 2)
                                    .background(Colors.subheadline.opacity(0.3))
                                    .cornerRadius(Sizes.xLarge / 2)
                            } else if let imageUrl = listingCellVM.firestoreSitter?.photoURL {
                                AsyncImage(url: URL(string: imageUrl)!) {
                                    Rectangle()
                                        .frame(width: Sizes.xLarge, height: Sizes.xLarge)
                                        .foregroundColor(Colors.subheadline.opacity(0.3))
                                        .cornerRadius(Sizes.xLarge / 2)
                                }
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: Sizes.xLarge, height: Sizes.xLarge)
                                    .cornerRadius(Sizes.xLarge / 2)
                            }

                            // Status symbol
                            Circle()
                                .frame(width: Sizes.Spacer, height: Sizes.Spacer)
                                .foregroundColor(Colors.green)
                                .overlay(
                                    RoundedRectangle(cornerRadius: Sizes.Spacer)
                                        .stroke(Colors.white, lineWidth: 1)
                                )
                                .padding([.top, .trailing], Sizes.Spacer / 2)
                        }

                        VStack(alignment: .leading) {
                            HStack {
                                Text(listingCellVM.firestoreSitter?.name ?? "")
                                    .customFont(.medium, category: .medium)
                                    .foregroundColor(Colors.headline)

                                Spacer()

                                Button(action: {
                                    showingPostListing.toggle()
                                }, label: {
                                        Text("Details")
                                            .customFont(.heavy, category: .small)
                                            .foregroundColor(Colors.coral)
                                            .fixedSize(horizontal: true, vertical: false)
                                    })
                            }

                            Text(listingCellVM.firestoreSitter?.phoneNumber ?? "Sitter")
                                .customFont(.medium, category: .small)
                                .foregroundColor(Colors.subheadline)
                        }
                            .padding(.leading, Sizes.Spacer)
                    }
                } else {
                    HStack {
                        Text("No sitter")
                            .customFont(.medium, category: .medium)
                            .foregroundColor(Colors.subheadline)

                        Spacer()

                        Button(action: {
                            showingPostListing.toggle()
                        }, label: {
                                Text("Details")
                                    .customFont(.heavy, category: .small)
                                    .foregroundColor(Colors.coral)
                                    .fixedSize(horizontal: true, vertical: false)
                            })
                    }
                }

                // Divider
                Rectangle()
                    .foregroundColor(Colors.subheadline.opacity(0.3))
                    .frame(height: 1)
                    .padding(.vertical, Sizes.xSmall)

                // Listing condensed details
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

                // Address
                HStack {
                    VStack(alignment: .leading) {
                        Text(listingCellVM.userAddress?.street ?? "")
                            .customFont(.medium, category: .small)
                            .foregroundColor(Colors.headline)

                        Text("\(listingCellVM.userAddress?.city ?? ""), \(listingCellVM.userAddress?.state ?? "") \(listingCellVM.userAddress?.zip ?? "")")
                            .customFont(.medium, category: .small)
                            .foregroundColor(Colors.subheadline)
                    }

                    Spacer()

                    // Account graphic
                    Image(systemName: "location.north")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: Sizes.xSmall, height: Sizes.xSmall)
                        .foregroundColor(Colors.coral)
                        .padding(Sizes.xSmall)
                        .background(Colors.subheadline.opacity(0.1))
                        .cornerRadius(Sizes.Big / 2)
                }
                    .padding(.bottom, Sizes.Spacer)

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

                        Text(loadChildrenNames(children: children))
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

                        Text(loadPetsNames(pets: pets))
                            .customFont(.heavy, category: .small)
                            .foregroundColor(Colors.sienna)
                    }
                        .padding(Sizes.Spacer)
                        .padding(.horizontal, Sizes.Spacer / 2)
                        .background(Colors.sienna.opacity(0.2))
                        .cornerRadius(Sizes.Spacer)
                        .padding(.top, Sizes.Spacer)
                }
            }
                .padding(Sizes.Default)
                .background(Colors.cellBackground)
                .cornerRadius(Sizes.Spacer)
                .shadow()
        }
            .padding(.horizontal, Sizes.Default)
            .sheet(isPresented: $showingPostListing) {
                PostListingView(authenticationService: authenticationService, listingCellVM: listingCellVM, showingPostListing: $showingPostListing) { result in
                    if case .success(let listing) = result {
                        listingListVM.removeListing(listing)
                        showingPostListing.toggle()
                    }
                }
        }
    }

    func loadChildrenNames(children: [Child]?) -> String {
        if let children = children {
            var groupedNames = ""
            for child in children {
                groupedNames += child.name
                if child != children.last {
                    groupedNames += ", "
                }
            }
            return groupedNames
        }
        return ""
    }

    func loadPetsNames(pets: [Pet]?) -> String {
        if let pets = pets {
            var groupedNames = ""
            for pet in pets {
                groupedNames += pet.name
                if pet != pets.last {
                    groupedNames += ", "
                }
            }
            return groupedNames
        }
        return ""
    }
}
