//
//  Header_HomeView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/8/20.
//

import SwiftUI

struct Header_HomeView: View {
    @ObservedObject var authenticationService: AuthenticationService
    
    var body: some View {
        HStack {
            // Profile image
            ZStack(alignment: .topTrailing) {
                // Profile picture
                if authenticationService.firestoreUser?.photoURL == nil || authenticationService.firestoreUser?.photoURL == "" {
                    Image(systemName: "person")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: Sizes.Small, height: Sizes.Small)
                        .padding((Sizes.xLarge - Sizes.Small) / 2)
                        .background(Colors.subheadline.opacity(0.3))
                        .cornerRadius(Sizes.xLarge / 2)
                } else if let imageUrl = authenticationService.firestoreUser?.photoURL {
                    AsyncImage(url: URL(string: imageUrl)!) {
                        Text("•")
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

            // Name
            VStack(alignment: .leading) {
                Text(authenticationService.firestoreUser?.name ?? "")
                    .customFont(.medium, category: .medium)
                    .foregroundColor(Colors.headline)

                Text(authenticationService.firestoreUser?.accountType ?? "Unknown")
                    .customFont(.medium, category: .small)
                    .foregroundColor(Colors.subheadline)
            }
                .padding(.leading, Sizes.Spacer)

            Spacer()

            Image(systemName: "plus")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: Sizes.xSmall, height: Sizes.xSmall)
                .foregroundColor(Colors.headline)
                .padding(Sizes.xSmall)
                .background(
                    Colors.subheadline
                        .opacity(0.1)
                        .cornerRadius(Sizes.xLarge / 2)
                )
        }
            .padding(Sizes.Default)
            .background(Colors.cellBackground)
            .cornerRadius(Sizes.Spacer)
            .shadow()
            .padding(.horizontal, Sizes.Default)
    }
}
