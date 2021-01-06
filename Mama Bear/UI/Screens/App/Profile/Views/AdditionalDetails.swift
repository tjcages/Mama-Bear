//
//  AdditionalDetails.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 1/5/21.
//

import SwiftUI

struct AdditionalDetails: View {
    @ObservedObject var authenticationService: AuthenticationService
    
    @Binding var showSheet: Bool
    
    @State private var showName = true
    @State private var showEmail = true
    @State private var showPhone = true
    
    @State var nameText = ""
    @State var phoneText = ""
    @State var emailText = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            BackButton() {
                showSheet.toggle()
            }

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    Text("Add a few details first")
                        .customFont(.heavy, category: .extraLarge)
                        .foregroundColor(Colors.headline)
                        .padding(.top, Sizes.Large)
                        .padding(.bottom, Sizes.Large)
                        .padding(.horizontal, Sizes.Default)

                    Group {
                        if showName {
                            BrandTextView(item: .name, $nameText.didSet(execute: { update in
                                if var user = authenticationService.firestoreUser {
                                    user.name = update
                                    authenticationService.addUserToFirestore(user: user)
                                }
                            }))
                        }
                        if showEmail {
                            BrandTextView(item: .email, $emailText.didSet(execute: { update in
                                if var user = authenticationService.firestoreUser {
                                    user.email = update
                                    authenticationService.addUserToFirestore(user: user)
                                }
                            }))
                        }
                        if showPhone {
                            BrandTextView(item: .phone, $phoneText.didSet(execute: { update in
                                if var user = authenticationService.firestoreUser {
                                    user.phoneNumber = update
                                    authenticationService.addUserToFirestore(user: user)
                                }
                            }))
                        }
                    }
                        .padding(.bottom, Sizes.xSmall)
                        .padding(.horizontal, Sizes.Default)
                }

                Group {
                    ConfirmButton(title: "Save", style: .fill) {
                        // Save address
                        showSheet.toggle()
                    }

                    ConfirmButton(title: "Cancel", style: .lined) {
                        showSheet.toggle()
                    }
                }
                    .padding(.bottom, Sizes.Spacer)
                    .padding(.horizontal, Sizes.Default)

                Spacer()
            }
        }
            .background(Colors.cellBackground.edgesIgnoringSafeArea(.all))
            .onAppear {
            // Check which fields are missing
                if let user = authenticationService.firestoreUser {
                    if user.name != "" {
                        showName = false
                    }
                    if user.email != "" {
                        showEmail = false
                    }
                    if user.phoneNumber != "" {
                        showPhone = false
                    }
                }
        }
    }
}
