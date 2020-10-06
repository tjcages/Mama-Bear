//
//  PetsView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/6/20.
//

import SwiftUI

struct PetsView: View {
    var body: some View {
        VStack {
            WrappedHStack(tags: ["First kid", "Second kid"], item: AnyView(IndividualPetView()))
        }
            .padding([.leading, .top, .trailing], Sizes.Default)
            .padding(.bottom, Sizes.xSmall)
            .background(Colors.white)
            .cornerRadius(Sizes.Spacer)
            .shadow()
            .padding(.horizontal, Sizes.Default)
    }
}

struct IndividualPetView: View {
    var body: some View {
        HStack {
            Image(systemName: "person.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: Sizes.Small, height: Sizes.Small)
                .foregroundColor(Colors.coral)

            Text("2 cats")
                .customFont(.medium, category: .small)
                .foregroundColor(Colors.coral)
        }
            .padding(.vertical, 12)
            .padding(.horizontal, Sizes.xSmall)
            .background(Colors.extraLightCoral)
            .cornerRadius(Sizes.Spacer)
            .padding([.bottom, .trailing], Sizes.Spacer)
    }
}

struct PetsView_Previews: PreviewProvider {
    static var previews: some View {
        PetsView()
    }
}
