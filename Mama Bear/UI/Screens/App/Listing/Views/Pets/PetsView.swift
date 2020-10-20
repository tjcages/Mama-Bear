//
//  PetsView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/6/20.
//

import SwiftUI

struct PetsView: View {
    @ObservedObject var authenticationService: AuthenticationService

    @Binding var selectedPet: Pet

    var body: some View {
        VStack {
            Pet_WrappedHStack(authenticationService: authenticationService, selectedPet: $selectedPet)
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
    @Binding var selectedPet: Pet

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
                // Add pet sheet
                selectedPet = pet
        }
    }
}

struct Pet_WrappedHStack: View {
    @ObservedObject var authenticationService: AuthenticationService

    @Binding var selectedPet: Pet

    private var pets: [Pet] {
        if let pets = authenticationService.userPets {
            return pets
        }
        return []
    }

    @State private var totalHeight
        = CGFloat.zero // << variant for ScrollView/List
    //    = CGFloat.infinity   // << variant for VStack

    var body: some View {
        VStack {
            GeometryReader { geometry in
                self.generateContent(in: geometry)
            }
        }
            .frame(height: totalHeight)// << variant for ScrollView/List
        //.frame(maxHeight: totalHeight) // << variant for VStack
    }

    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(self.pets) { pet in
                self.item(for: pet)
//                    .padding([.vertical], 4)
                .alignmentGuide(.leading, computeValue: { d in
                    if (abs(width - d.width) > g.size.width)
                    {
                        width = 0
                        height -= d.height
                    }
                    let result = width
                    width -= d.width
                    return result
                })
                    .alignmentGuide(.top, computeValue: { d in
                        let result = height
                        return result
                    })
            }
            self.item(for: Pet())
                .alignmentGuide(.leading, computeValue: { d in
                    if (abs(width - d.width) > g.size.width)
                    {
                        width = 0
                        height -= d.height
                    }
                    let result = width
                    width = 0 // Last item
                    return result
                })
                .alignmentGuide(.top, computeValue: { d in
                    let result = height
                    height = 0 // Last item
                    return result
                })
        }.background(viewHeightReader($totalHeight))
    }

    private func item(for pet: Pet) -> some View {
        return IndividualPetView(pet: pet, selectedPet: $selectedPet)
    }

    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        return GeometryReader { geometry -> Color in
            let rect = geometry.frame(in: .local)
            DispatchQueue.main.async {
                binding.wrappedValue = rect.size.height
            }
            return .clear
        }
    }
}
