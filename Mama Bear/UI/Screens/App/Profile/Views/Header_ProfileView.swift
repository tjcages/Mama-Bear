//
//  Profile_HeaderView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/5/20.
//

import SwiftUI

struct Header_ProfileView: View {
    @ObservedObject var authenticationService: AuthenticationService
    @ObservedObject var viewRouter: ViewRouter

    var body: some View {
        VStack {
            Spacer()

            Rectangle()
                .foregroundColor(.clear)
                .frame(height: Global.statusBarHeight)
            
            Text("Profile")
                .customFont(.heavy, category: .extraLarge)
                .foregroundColor(Colors.headline)
                .padding(.top, Sizes.xSmall)

            HStack {
                Spacer()

                VStack(spacing: Sizes.Spacer) {
                    ZStack(alignment: .top) {
                        // Profile picture
                        Image("")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 120, height: 120)
                            .background(Color.red) // DELETE JUST FOR TESTING
                        .cornerRadius(60)

                        HStack {
                            // Status symbol
                            Circle()
                                .frame(width: Sizes.xSmall, height: Sizes.xSmall)
                                .foregroundColor(Colors.green)
                                .overlay(
                                    RoundedRectangle(cornerRadius: Sizes.Spacer)
                                        .stroke(Colors.white, lineWidth: 2)
                                )

                            Spacer()

                            Image(systemName: "camera")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: Sizes.Small, height: Sizes.Small)
                                .padding(12)
                                .background(Colors.cellBackground)
                                .cornerRadius((Sizes.Default * 2) / 2)
                                .shadow()
                                .offset(x: Sizes.xSmall)
                        }
                    }
                        .frame(maxWidth: 120)
                        .padding(.bottom, Sizes.Spacer)

                    HStack(spacing: Sizes.xSmall) {
                        Text(authenticationService.user?.displayName ?? "No name")
                            .customFont(.medium, category: .large)
                            .foregroundColor(Colors.headline)

                        Text(viewRouter.accountType.rawValue)
                            .customFont(.medium, category: .small)
                            .foregroundColor(Colors.cellBackground)
                            .padding(.vertical, 6)
                            .padding(.horizontal, Sizes.xSmall)
                            .background(Colors.blue)
                            .cornerRadius(Sizes.Spacer)
                    }

                    Text("Since 06.02.2019")
                        .customFont(.medium, category: .small)
                        .foregroundColor(Colors.subheadline)
                }
                    .padding(Sizes.Default)

                Spacer()
            }
        }
            .padding(.bottom, Sizes.xSmall)
            .background(Colors.cellBackground)
            .cornerRadius(Sizes.Large)
            .shadow()
    }
}
