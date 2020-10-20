//
//  Create_RegisterView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/1/20.
//

import SwiftUI

struct Name_RegisterView: View {
    @Binding var firstName: String
    @Binding var lastName: String
    
    var account: AccountType

    var body: some View {
        VStack(alignment: .leading) {
            Text("Create your \n\(account.rawValue) account")
                .customFont(.heavy, category: .extraLarge)
                .foregroundColor(Colors.headline)
                .padding(.bottom, Sizes.xSmall)
                .fixedSize(horizontal: false, vertical: true)

            Text("We are very happy you want to join us! Ok, so first, let us know you better.")
                .customFont(.medium, category: .medium)
                .foregroundColor(Colors.subheadline)
                .padding(.bottom, Sizes.Large)
                .fixedSize(horizontal: false, vertical: true)

            BrandTextView(item: .firstName, $firstName)
                .padding(.bottom, Sizes.xSmall)

            BrandTextView(item: .lastName, $lastName)

            Rectangle()
                .foregroundColor(.clear)
                .contentShape(Rectangle())
        }
            .padding(.horizontal, Sizes.Default)
    }
}
