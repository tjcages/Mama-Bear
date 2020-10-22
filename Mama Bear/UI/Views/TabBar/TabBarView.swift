//
//  TabBarView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/5/20.
//

import Foundation
import SwiftUI
import Combine

enum TabBarViews {
    case home
    case notification
    case newListing
    case help
    case profile
}

struct TabBarView: View {
    @ObservedObject var authenticationService: AuthenticationService
    @ObservedObject var viewRouter: ViewRouter
    @State var geometry: GeometryProxy

    static var animationDuration = Animation.animationQuick

    var size: CGFloat = Sizes.Default
    var padding: CGFloat = 12

    var body: some View {
        let family = authenticationService.firestoreUser?.accountType == "Family"
        
        VStack {
            HStack {
                // Home
                Image(systemName: "list.bullet.below.rectangle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size, height: size)
                    .padding(padding)
                    .foregroundColor(viewRouter.currentView == .home ? Colors.white : Colors.subheadline)
                    .background(
                        Rectangle()
                            .foregroundColor(viewRouter.currentView == .home ? Colors.coral : Color.clear)
                            .cornerRadius(Sizes.xSmall)
                            .shadow()
                    )
                    .onTapGesture {
                        withAnimation(Animation.easeOut(duration: TabBarView.animationDuration)) {
                            self.viewRouter.currentView = .home
                        }
                }

                Spacer()

                // User messages
                Image(systemName: "bell")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size, height: size)
                    .padding(padding)
                    .foregroundColor(viewRouter.currentView == .notification ? Colors.white : Colors.subheadline)
                    .background(
                        Rectangle()
                            .foregroundColor(viewRouter.currentView == .notification ? Colors.coral : Color.clear)
                            .cornerRadius(Sizes.xSmall)
                            .shadow()
                    )
                    .onTapGesture {
                        withAnimation(Animation.easeOut(duration: TabBarView.animationDuration)) {
                            self.viewRouter.currentView = .notification
                        }
                }

                Spacer()

                if family {
                    // Add new listing
                    Image(systemName: "plus")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: Sizes.Default, height: Sizes.Default)
                        .foregroundColor(viewRouter.currentView == .newListing ? Colors.white : Colors.subheadline)
                        .padding(Sizes.Small)
                        .background(viewRouter.currentView == .newListing ? Colors.coral : Colors.background)
                        .cornerRadius(Sizes.Large)
                        .shadow()
                        .offset(y: -Sizes.xSmall)
                        .onTapGesture {
                            withAnimation(Animation.easeOut(duration: TabBarView.animationDuration)) {
                                self.viewRouter.currentView = .newListing
                            }
                    }

                    Spacer()
                }

                // Get help/feedback
                Image(systemName: "questionmark.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size, height: size)
                    .padding(padding)
                    .foregroundColor(viewRouter.currentView == .help ? Colors.white : Colors.subheadline)
                    .background(
                        Rectangle()
                            .foregroundColor(viewRouter.currentView == .help ? Colors.coral : Color.clear)
                            .cornerRadius(Sizes.xSmall)
                            .shadow()
                    )
                    .onTapGesture {
                        withAnimation(Animation.easeOut(duration: TabBarView.animationDuration)) {
                            self.viewRouter.currentView = .help
                        }
                }

                Spacer()

                // User profile
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size, height: size)
                    .padding(padding)
                    .foregroundColor(viewRouter.currentView == .profile ? Colors.white : Colors.subheadline)
                    .background(
                        Rectangle()
                            .foregroundColor(viewRouter.currentView == .profile ? Colors.coral : Color.clear)
                            .cornerRadius(Sizes.xSmall)
                            .shadow()
                    )
                    .onTapGesture {
                        withAnimation(Animation.easeOut(duration: TabBarView.animationDuration)) {
                            self.viewRouter.currentView = .profile
                        }
                }
            }
                .padding(.horizontal, family ? Sizes.Default : Sizes.xLarge)
                .frame(width: geometry.size.width, height: geometry.size.height / 10)

            Rectangle()
                .foregroundColor(.clear)
                .frame(width: geometry.size.width, height: Sizes.Spacer)
        }
            .background(
                Rectangle()
                    .clipShape(
                        TabBarShape(width: geometry.size.width, height: geometry.size.height, hump: family)
                    )
                    .foregroundColor(Colors.cellBackground)
                    .offset(y: -Sizes.xSmall)
                    .shadow()
            )
            .onTapGesture {
                UIApplication.shared.endEditing()
        }
    }
}
