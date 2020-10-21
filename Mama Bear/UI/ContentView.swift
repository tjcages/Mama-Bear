//
//  ContentView.swift
//  Gather
//
//  Created by Tyler Cagle on 9/27/20.
//

import SwiftUI
import Resolver
import Firebase

struct ContentView: View {
    @ObservedObject var authenticationService: AuthenticationService

    @ObservedObject var listingListVM = ListingListViewModel()
    @ObservedObject var viewRouter = ViewRouter()

    @State private var loadingComplete = false

    var body: some View {
        ZStack {
            if authenticationService.userLoggedIn {
                AppView(authenticationService: authenticationService, viewRouter: viewRouter, listingListVM: listingListVM)
            } else {
                OnboardingView(authenticationService: authenticationService)
            }

            Rectangle()
                .foregroundColor(Colors.background)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
                .opacity(loadingComplete ? 0 : 1)
        }
            .onAppear {
                delayWithSeconds(1) {
                    withAnimation(Animation.easeOut(duration: Animation.animationIn)) {
                        self.loadingComplete = true
                    }
                }
        }
    }
}
