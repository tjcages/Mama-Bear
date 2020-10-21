//
//  AppView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/5/20.
//

import SwiftUI

class ViewRouter: ObservableObject {
    @Published var currentView: TabBarViews = .home
    @Published var accountType: AccountType = .family
}

struct AppView: View {
    @ObservedObject var authenticationService: AuthenticationService
    @ObservedObject var viewRouter: ViewRouter
    @ObservedObject var listingListVM: ListingListViewModel
    
    @ObservedObject var faqVM = FAQViewModel()

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                HomeView(authenticationService: authenticationService, listingListVM: listingListVM, viewRouter: viewRouter)
                    .opacity(viewRouter.currentView == .home ? 1 : 0)
                
                NotificationView()
                    .opacity(viewRouter.currentView == .notification ? 1 : 0)
                
                NewListingView(authenticationService: authenticationService, listingCellVM: ListingCellViewModel.newListing()) { result in
                    if case .success(let listing) = result {
                        self.listingListVM.addListing(listing: listing)
                        viewRouter.currentView = .home
                    }
                }
                    .opacity(viewRouter.currentView == .newListing ? 1 : 0)
                
                HelpView(faqVM: faqVM)
                    .opacity(viewRouter.currentView == .help ? 1 : 0)
                
                ProfileView(authenticationService: authenticationService, listingListVM: listingListVM, viewRouter: viewRouter)
                    .opacity(viewRouter.currentView == .profile ? 1 : 0)

                TabBarView(viewRouter: viewRouter, geometry: geometry)
            }
                .edgesIgnoringSafeArea(.bottom)
        }
    }
}
