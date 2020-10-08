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
    @ObservedObject var viewRouter: ViewRouter
    @ObservedObject var faq = FAQViewModel()

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                HomeView()
                    .opacity(viewRouter.currentView == .home ? 1 : 0)
                
                NotificationView()
                    .opacity(viewRouter.currentView == .notification ? 1 : 0)
                
                NewListingView()
                    .opacity(viewRouter.currentView == .newListing ? 1 : 0)
                
                HelpView(faq: faq)
                    .opacity(viewRouter.currentView == .help ? 1 : 0)
                
                ProfileView(viewRouter: viewRouter)
                    .opacity(viewRouter.currentView == .profile ? 1 : 0)

                TabBarView(viewRouter: viewRouter, geometry: geometry)
            }
                .edgesIgnoringSafeArea(.bottom)
        }
    }
}
