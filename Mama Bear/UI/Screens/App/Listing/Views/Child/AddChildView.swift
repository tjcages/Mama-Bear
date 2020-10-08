//
//  AddChildView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/7/20.
//

import SwiftUI

struct AddChildView: View {
    @Binding var showSheet: Bool

    var body: some View {
        VStack(alignment: .leading) {
            BackButton() {
                showSheet.toggle()
            }

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: Sizes.Default) {
                    Text("Add a child")
                        .customFont(.heavy, category: .extraLarge)
                        .foregroundColor(Colors.headline)
                        .padding(.top, Sizes.Large)
                        .padding(.horizontal, Sizes.Default)

                    VStack(spacing: Sizes.Default) {
                        Group {
                            BrandTextView(item: .firstName)

                            AgeView()

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

struct AddChildView_Previews: PreviewProvider {
    static var previews: some View {
        AddChildView(showSheet: .constant(true))
    }
}
