//
//  Address_ProfileView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/7/20.
//

import SwiftUI

struct Address_ProfileView: View {
    @ObservedObject var authenticationService: AuthenticationService
    @Binding var activeSheet: ActiveSheet

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .bottom) {
                Text("Address")
                    .customFont(.medium, category: .large)
                    .foregroundColor(Colors.headline)
                    .padding(.top, Sizes.Default)

                Spacer()

                if activeSheet != .none {
                    Button(action: {
                        activeSheet = .third
                    }, label: {
                            Text("Edit")
                                .customFont(.heavy, category: .small)
                                .foregroundColor(Colors.coral)
                        }
                    )
                }
            }
                .padding(.horizontal, Sizes.Default)
                .padding(.bottom, Sizes.Spacer)

            HStack {
                VStack(alignment: .leading) {
                    Text(authenticationService.userAddress?.street ?? "")
                        .customFont(.medium, category: .medium)
                        .foregroundColor(Colors.headline)

                    Text("\(authenticationService.userAddress?.city ?? ""), \(authenticationService.userAddress?.state ?? "") \(authenticationService.userAddress?.zip ?? "")")
                        .customFont(.medium, category: .small)
                        .foregroundColor(Colors.subheadline)

                    Text("United States")
                        .customFont(.medium, category: .small)
                        .foregroundColor(Colors.subheadline)
                }

                Spacer()

                // Account graphic
                Image(systemName: "location.north")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: Sizes.Default, height: Sizes.Default)
                    .foregroundColor(Colors.coral)
                    .padding(Sizes.xSmall)
                    .background(Colors.subheadline.opacity(0.1))
                    .cornerRadius(Sizes.Big / 2)
            }
                .padding(.all, Sizes.Default)
                .frame(maxWidth: .infinity)
                .background(Colors.cellBackground)
                .cornerRadius(Sizes.xSmall)
                .shadow()
                .padding(.horizontal, Sizes.Default)
        }
    }
}
