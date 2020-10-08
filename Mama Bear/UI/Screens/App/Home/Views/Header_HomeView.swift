//
//  Header_HomeView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/8/20.
//

import SwiftUI

struct Header_HomeView: View {
    var body: some View {
        HStack {
            // Profile image
            ZStack(alignment: .topTrailing) {
                // Profile picture
                Image("")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: Sizes.xLarge, height: Sizes.xLarge)
                    .background(Color.red) // DELETE JUST FOR TESTING
                    .cornerRadius(Sizes.xLarge / 2)

                // Status symbol
                Circle()
                    .frame(width: Sizes.Spacer, height: Sizes.Spacer)
                    .foregroundColor(Colors.green)
                    .overlay(
                        RoundedRectangle(cornerRadius: Sizes.Spacer)
                            .stroke(Colors.white, lineWidth: 1)
                    )
                    .padding([.top, .trailing], Sizes.Spacer/2)
            }
            
            // Name
            VStack(alignment: .leading) {
                Text("Julia Black")
                    .customFont(.medium, category: .medium)
                    .foregroundColor(Colors.headline)

                Text("Parent")
                    .customFont(.medium, category: .small)
                    .foregroundColor(Colors.subheadline)
            }
            .padding(.leading, Sizes.Spacer)
            
            Spacer()
            
            Image(systemName: "gear")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: Sizes.Default, height: Sizes.Default)
                .foregroundColor(Colors.headline)
        }
        .padding(Sizes.Default)
        .background(Colors.cellBackground)
        .cornerRadius(Sizes.Spacer)
        .shadow()
        .padding(.horizontal, Sizes.Default)
    }
}

struct Header_HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Header_HomeView()
    }
}
