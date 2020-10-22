//
//  Profile_PersonalView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/5/20.
//

import SwiftUI
import Firebase

struct Personal_ProfileView: View {
    @ObservedObject var authenticationService: AuthenticationService
    @Binding var activeSheet: ActiveSheet

    @State private var nameText: String = ""
    @State private var emailText: String = ""
    @State private var phoneNumberText: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: Sizes.Spacer) {
            Group {
                Text("Basic information")
                    .customFont(.heavy, category: .large)
                    .foregroundColor(Colors.headline)
                    .padding(.bottom, Sizes.Spacer)

                BrandTextView(item: .name, $nameText.didSet(execute: { update in
                    if var user = authenticationService.firestoreUser {
                        user.name = update
                        authenticationService.addUserToFirestore(user: user)
                    }
                }))

                BrandTextView(item: .email, $emailText.didSet(execute: { update in
                    if var user = authenticationService.firestoreUser {
                        user.email = update
                        authenticationService.addUserToFirestore(user: user)
                    }
                }))

                BrandTextView(item: .phone, $phoneNumberText.didSet(execute: { update in
                    if var user = authenticationService.firestoreUser {
                        user.phoneNumber = update
                        authenticationService.addUserToFirestore(user: user)
                    }
                }))
            }
                .padding(.bottom, Sizes.xSmall)
                .padding(.horizontal, Sizes.Default)

            if authenticationService.userAddress != nil {
                Address_ProfileView(authenticationService: authenticationService, activeSheet: $activeSheet.didSet { _ in
                    activeSheet = .third
                })
            } else {
                AccountSelectionView(CreateAccount(title: "Address", subtitle: "Add a home address", color: Colors.subheadline.opacity(0.1), image: "onboardingGraphic_3", type: .nanny))
                    .onTapGesture {
                        activeSheet = .third
                    }
                    .padding(.horizontal, Sizes.Spacer)
            }

            ConfirmButton(title: "Logout", style: .lined) {
                authenticationService.signOut()
            }
                .padding([.horizontal, .top], Sizes.Default)

            HStack {
                Spacer()

                Button(action: {
                    // Confirm deletion
                    // Deactivate account logic
                }, label: {
                        Text("Deactivate account")
                            .customFont(.heavy, category: .small)
                            .foregroundColor(Colors.coral)
                    })
                    .padding(.top, Sizes.Default)

                Spacer()
            }

            Spacer()
        }
            .onAppear {
                nameText = authenticationService.firestoreUser?.name ?? ""
                emailText = authenticationService.firestoreUser?.email ?? ""
                phoneNumberText = format(with: "+X (XXX) XXX-XXXX", phone: authenticationService.firestoreUser?.phoneNumber ?? "")
        }
    }

    func format(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex // numbers iterator

        // iterate over the mask characters until the iterator of numbers ends
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                // mask requires a number in this place, so take the next one
                result.append(numbers[index])

                // move numbers iterator to the next index
                index = numbers.index(after: index)

            } else {
                result.append(ch) // just append a mask character
            }
        }
        return result
    }
}
