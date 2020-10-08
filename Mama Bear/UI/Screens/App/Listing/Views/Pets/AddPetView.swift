//
//  AddPetView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/8/20.
//

import SwiftUI

struct AddPetView: View {
    @Binding var showSheet: Bool

    var body: some View {
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
                            BrandTextView(item: .firstName)

                            AnimalView()

                            GenderView()
                        }
                            .padding(.top, Sizes.Default)

                        Spacer()

                        Group {
                            ConfirmButton(title: "Save", style: .fill) {
                                // Save address
                            }

                            ConfirmButton(title: "Cancel", style: .lined) {
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
    }
}

struct AddPetView_Previews: PreviewProvider {
    static var previews: some View {
        AddPetView(showSheet: .constant(true))
    }
}
