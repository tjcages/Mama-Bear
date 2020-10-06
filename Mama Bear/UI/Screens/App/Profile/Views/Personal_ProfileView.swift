//
//  Profile_PersonalView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/5/20.
//

import SwiftUI

struct Personal_ProfileView: View {
    @State var address = false
    var nameFields: [TextViewCase] = [.firstName, .lastName]
    var userFields: [TextViewCase] = [.email, .phone]
    var addressFields: [TextViewCase] = [.streetAddress, .city, .state, .zip, .country]

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
                Group {
                    Text("Home address")
                        .customFont(.heavy, category: .large)
                        .foregroundColor(Colors.headline)
                        .padding(.vertical, Sizes.Spacer)

                    ForEach(addressFields, id: \.rawValue) { field in
                        BrandTextView(item: field)
                    }
                }
                    .padding(.bottom, Sizes.xSmall)
                    .padding(.horizontal, Sizes.Default)

                Group {
                    ConfirmButton(title: "Save", style: .fill) {
                        // Save address
                    }

                    ConfirmButton(title: "Cancel", style: .lined) {
                        withAnimation(Animation.easeOut(duration: Animation.animationIn)) {
                            self.address.toggle()
                        }
                    }
                }
                    .padding(.bottom, Sizes.Spacer)
                    .padding(.horizontal, Sizes.Default)

            } else {
                AccountSelectionView(CreateAccount(title: "Address", subtitle: "Add a home address", color: Colors.subheadline.opacity(0.1)))
                    .onTapGesture {
                        withAnimation(Animation.easeOut(duration: Animation.animationIn)) {
                            self.address.toggle()
                        }
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

struct Profile_PersonalView_Previews: PreviewProvider {
    static var previews: some View {
        Personal_ProfileView()
    }
}
