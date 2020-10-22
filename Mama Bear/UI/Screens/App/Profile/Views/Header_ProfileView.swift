//
//  Profile_HeaderView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/5/20.
//

import SwiftUI
import Firebase

struct Header_ProfileView: View {
    @ObservedObject var authenticationService: AuthenticationService
    @ObservedObject var viewRouter: ViewRouter
    
    @Binding var activeSheet: ActiveSheet

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd.yyyy"
        return formatter
    }()

    var body: some View {
        VStack {
            Spacer()

            Rectangle()
                .foregroundColor(.clear)
                .frame(height: Global.statusBarHeight)
            
            HStack {
                Spacer()

                VStack(spacing: Sizes.Spacer) {
                    ZStack(alignment: .top) {
                        // Profile picture
                        if authenticationService.firestoreUser?.photoURL == nil || authenticationService.firestoreUser?.photoURL == "" {
                            Image(systemName: "person")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: Sizes.Large, height: Sizes.Large)
                                .padding((120 - Sizes.Large) / 2)
                                .background(Colors.subheadline.opacity(0.3))
                                .cornerRadius(60)
                        } else if let imageUrl = authenticationService.firestoreUser?.photoURL {
                            AsyncImage(url: URL(string: imageUrl)!) {
                                Rectangle()
                                    .frame(width: 120, height: 120)
                                    .foregroundColor(Colors.subheadline.opacity(0.3))
                                    .cornerRadius(60)
                            }
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 120, height: 120)
                                .cornerRadius(60)
                        }

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
                                .onTapGesture {
                                    self.activeSheet = .fourth
                            }
                        }
                    }
                        .frame(maxWidth: 120)
                        .padding(.bottom, Sizes.Spacer)

                    HStack(spacing: Sizes.xSmall) {
                        Text(authenticationService.firestoreUser?.name ?? "No name")
                            .customFont(.medium, category: .large)
                            .foregroundColor(Colors.headline)

                        Text(authenticationService.firestoreUser?.accountType ?? "Nanny")
                            .customFont(.medium, category: .small)
                            .foregroundColor(Colors.cellBackground)
                            .fixedSize(horizontal: true, vertical: false)
                            .padding(.vertical, 6)
                            .padding(.horizontal, Sizes.xSmall)
                            .background(Colors.blue)
                            .cornerRadius(Sizes.Spacer)
                    }
                    if let createdDate = authenticationService.firestoreUser?.createdTime?.dateValue() {
                        Text("Since \(createdDate, formatter: Self.dateFormatter)")
                            .customFont(.medium, category: .small)
                            .foregroundColor(Colors.subheadline)
                    }
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
