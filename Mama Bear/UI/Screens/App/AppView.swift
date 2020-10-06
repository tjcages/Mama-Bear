//
//  AppView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/5/20.
//

import SwiftUI

class ViewRouter: ObservableObject {
    @Published var currentView: TabBarViews = .notification
    @Published var accountType: AccountType = .family
}

struct AppView: View {
    @ObservedObject var viewRouter: ViewRouter
    @ObservedObject var faq = FAQViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                VStack {
                    if viewRouter.currentView == .home {
                        HomeView()
                    } else if viewRouter.currentView == .notification {
                        NotificationView()
                    } else if viewRouter.currentView == .newListing {
                        NewListingView()
                    } else if viewRouter.currentView == .help {
                        HelpView(faq: faq)
                    } else if viewRouter.currentView == .profile {
                        ProfileView(viewRouter: viewRouter)
                    }
                }

                TabBarView(viewRouter: viewRouter, geometry: geometry)
            }
                .edgesIgnoringSafeArea(.bottom)
                .onTapGesture {
                    UIApplication.shared.endEditing()
            }
        }
    }
}
