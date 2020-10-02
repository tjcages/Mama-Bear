//
//  Phone_RegisterView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/2/20.
//

import SwiftUI

struct Phone_RegisterView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Link your phone number")
                .customFont(.heavy, category: .extraLarge)
                .foregroundColor(Colors.headline)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, Sizes.xSmall)

            Text("By continuing you will receive single SMS for verification purposes. Message and data rates may apply.")
                .customFont(.medium, category: .medium)
                .foregroundColor(Colors.subheadline)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, Sizes.Large)

            BrandTextView(item: .phone)

            Rectangle()
                .foregroundColor(.clear)
                .contentShape(Rectangle())
        }
            .padding(.horizontal, Sizes.Default)
    }
}

struct Phone_RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        Phone_RegisterView()
    }
}
