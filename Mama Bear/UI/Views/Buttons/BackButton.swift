//
//  BackButton.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/1/20.
//

import SwiftUI

struct BackButton: View {
    var backPressed: () -> () = { }

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .bottom, spacing: Sizes.Spacer) {
                Image(systemName: "chevron.left")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: Sizes.Small, height: Sizes.Small)
                    .foregroundColor(Colors.subheadline)

                Text("Back")
                    .customFont(.heavy, category: .small)
                    .foregroundColor(Colors.subheadline)

                Spacer()
            }
                .padding(.leading, Sizes.xSmall)
                .onTapGesture {
                    backPressed()
            }
        }
        .padding(.top, Global.statusBarHeight)
    }
}

struct BackButton_Previews: PreviewProvider {
    static var previews: some View {
        BackButton()
    }
}
