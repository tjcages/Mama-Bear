//
//  Profile_PersonalView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/5/20.
//

import SwiftUI

struct Personal_ProfileView: View {
    @Binding var activeSheet: ActiveSheet

    @State var address: Bool = true

    var nameFields: [TextViewCase] = [.firstName, .lastName]
    var userFields: [TextViewCase] = [.email, .phone]

    var body: some View {
        VStack(alignment: .leading, spacing: Sizes.Spacer) {
            Group {
                Text("Basic information")
                    .customFont(.heavy, category: .large)
                    .foregroundColor(Colors.headline)
                    .padding(.bottom, Sizes.Spacer)

                HStack(spacing: Sizes.xSmall) {
                    ForEach(nameFields, id: \.rawValue) { field in
                        BrandTextView(item: field)
                    }
                }

                ForEach(userFields, id: \.rawValue) { field in
                    BrandTextView(item: field)
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
                AccountSelectionView(CreateAccount(title: "Address", subtitle: "Add a home address", color: Colors.subheadline.opacity(0.1)))
                    .onTapGesture {
                        activeSheet = .third
                }
            }

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
}
