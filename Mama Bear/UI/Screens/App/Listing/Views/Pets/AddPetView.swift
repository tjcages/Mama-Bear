//
//  AddPetView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/8/20.
//

import SwiftUI

struct AddPetView: View {
    @ObservedObject var authenticationService: AuthenticationService

    @Binding var showSheet: Bool

    var pet: Pet

    @State var petName: String = ""
    @State var animal: Animal = .dog
    @State var gender: Gender = .male

    var body: some View {
        let newPet = self.pet.name == ""

        VStack(alignment: .leading) {
            BackButton() {
                showSheet.toggle()
            }

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: Sizes.Default) {
                    Text("Add a pet")
                        .customFont(.heavy, category: .extraLarge)
                        .foregroundColor(Colors.headline)
                        .padding(.top, Sizes.Large)
                        .padding(.horizontal, Sizes.Default)

                    VStack(spacing: Sizes.Default) {
                        Group {
                            BrandTextView(item: .firstName, $petName)

                            AnimalView(animal: $animal)

                            GenderView(gender: $gender)
                        }
                            .padding(.top, Sizes.Default)

                        Spacer()

                        Group {
                            ConfirmButton(title: "Save", style: .fill) {
                                // Save pet
                                var pet = Pet(name: petName, type: animal, gender: gender)
                                if !newPet { pet.id = self.pet.id }
                                authenticationService.addPetToFirestore(pet: pet)

                                showSheet.toggle()
                            }
                            
                            ConfirmButton(title: newPet ? "Cancel" : "Delete", style: .lined) {
                                if !newPet {
                                    authenticationService.removePet(pet)
                                }
                                showSheet.toggle()
                            }
                        }
                            .padding(.bottom, Sizes.Spacer)
                    }
                        .padding(.horizontal, Sizes.Default)
                }
            }
        }
            .background(Colors.cellBackground.edgesIgnoringSafeArea(.all))
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
            .onAppear {
                petName = pet.name
                animal = Animal(rawValue: pet.type) ?? .dog
                gender = Gender(rawValue: pet.gender) ?? .unknown
        }
    }
}
