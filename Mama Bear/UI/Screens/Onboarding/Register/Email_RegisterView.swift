//
//  Email_RegisterView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/2/20.
//

import SwiftUI

struct Email_RegisterView: View {
    @Binding var email: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Let's be in touch")
                .customFont(.heavy, category: .extraLarge)
                .foregroundColor(Colors.headline)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, Sizes.xSmall)

            Text("Tell us what is your email address. We promise to not send you any spam.")
                .customFont(.medium, category: .medium)
                .foregroundColor(Colors.subheadline)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, Sizes.Large)

            BrandTextView(item: .email, $email)

            Rectangle()
                .foregroundColor(.clear)
                .contentShape(Rectangle())
        }
            .padding(.horizontal, Sizes.Default)
    }
}
