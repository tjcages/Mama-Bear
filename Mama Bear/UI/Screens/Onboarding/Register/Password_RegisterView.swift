//
//  Password_RegisterView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/5/20.
//

import SwiftUI

struct Password_RegisterView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Protect your account")
                .customFont(.heavy, category: .extraLarge)
                .foregroundColor(Colors.headline)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, Sizes.xSmall)

            BrandTextView(item: .password)

            Text("Password must contain at least, big letter, and at least one special character.")
                .customFont(.medium, category: .medium)
                .foregroundColor(Colors.subheadline)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, Sizes.Large)

            Rectangle()
                .foregroundColor(.clear)
                .contentShape(Rectangle())
        }
            .padding(.horizontal, Sizes.Default)
    }
}

struct Password_RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        Password_RegisterView()
    }
}
