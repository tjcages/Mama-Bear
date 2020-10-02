//
//  Create_RegisterView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/1/20.
//

import SwiftUI

struct Create_RegisterView: View {
    @State var account: AccountType

    var body: some View {
        VStack(alignment: .leading) {
            Text("Create your \n\(account.rawValue) account")
                .customFont(.heavy, category: .extraLarge)
                .foregroundColor(Colors.headline)
                .padding(.bottom, Sizes.xSmall)

            Text("We are very happy you want to join us! Ok, so first, let us know you better.")
                .customFont(.medium, category: .medium)
                .foregroundColor(Colors.subheadline)
                .padding(.bottom, Sizes.Large)

            BrandTextView(item: .firstName)
                .padding(.bottom, Sizes.Spacer)

            BrandTextView(item: .lastName)

            Spacer()

            ConfirmButton(title: "Next", style: .fill) {
                // Next
            }
                .padding(.bottom, Sizes.Default)

            HStack {
                Rectangle()
                    .foregroundColor(Colors.subheadline.opacity(0.4))
                    .frame(height: 1)

                Text("Or login with")
                    .customFont(.medium, category: .small)
                    .foregroundColor(Colors.subheadline)
                    .padding(.horizontal, Sizes.Spacer)

                Rectangle()
                    .foregroundColor(Colors.subheadline.opacity(0.4))
                    .frame(height: 1)
            }
                .padding(.top, Sizes.xSmall)

            SocialLoginView()
                .padding(.top, Sizes.xSmall)
                .padding(.bottom, Sizes.Big)

        }
            .padding(.horizontal, Sizes.Default)
    }
}

struct Create_RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        Create_RegisterView(account: .family)
    }
}
