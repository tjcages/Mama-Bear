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

    @State var address: Bool = true

    var userFields: [TextViewCase] = [.email, .phone]

    var body: some View {
        VStack(alignment: .leading, spacing: Sizes.Spacer) {
            Group {
                Text("Basic information")
                    .customFont(.heavy, category: .large)
                    .foregroundColor(Colors.headline)
                    .padding(.bottom, Sizes.Spacer)

                BrandTextView(.constant(authenticationService.user?.displayName ?? "No name"), item: .name)

                ForEach(userFields, id: \.rawValue) { field in
                    BrandTextView(.constant(field == .email ? authenticationService.user?.email ?? "No email": format(with: "+X (XXX) XXX-XXXX", phone: authenticationService.user?.phoneNumber ?? "No phone number")), item: field)
                }
            }
                .padding(.bottom, Sizes.xSmall)
                .padding(.horizontal, Sizes.Default)

            if address {
                // NEED TO IMPLEMENT VIEWMODEL
                Address_ProfileView(activeSheet: $activeSheet.didSet { _ in
                    activeSheet = .third
                })
            } else {
                AccountSelectionView(CreateAccount(title: "Address", subtitle: "Add a home address", color: Colors.subheadline.opacity(0.1), image: "onboardingGraphic-3", type: .unknown))
                    .onTapGesture {
                        activeSheet = .third
                }
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
