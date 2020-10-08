//
//  PetsView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/6/20.
//

import SwiftUI

struct PetsView: View {
    @Binding var activeSheet: ActiveSheet

    var body: some View {
        VStack {
            Pet_WrappedHStack(pets: [
                Pet(name: "Gracie", type: .cat, gender: .female),
                Pet(name: "Riley", type: .dog, gender: .male),
                Pet()
                ], activeSheet: $activeSheet
            )
        }
            .padding([.leading, .top, .trailing], Sizes.Default)
            .padding(.bottom, Sizes.xSmall)
            .background(Colors.cellBackground)
            .cornerRadius(Sizes.Spacer)
            .shadow()
            .padding(.horizontal, Sizes.Default)
    }
}

struct IndividualPetView: View {
    var pet: Pet
    @Binding var activeSheet: ActiveSheet

    var body: some View {
        let addNew = pet.name == ""
        HStack {
            Image(systemName: addNew ? "plus.circle" : "person.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: Sizes.Small, height: Sizes.Small)
                .foregroundColor(Colors.coral)

            Text(addNew ? "Add a pet" : pet.name)
                .customFont(.medium, category: .small)
                .foregroundColor(addNew ? Colors.subheadline : Colors.coral)
        }
            .padding(.vertical, 12)
            .padding(.horizontal, Sizes.xSmall)
            .background(addNew ? Colors.subheadline.opacity(0.1) : Colors.extraLightCoral)
            .cornerRadius(Sizes.Spacer)
            .padding([.bottom, .trailing], Sizes.Spacer)
            .onTapGesture {
                if addNew {
                    // Add pet sheet
                    activeSheet = .second
                }
        }
    }
}
