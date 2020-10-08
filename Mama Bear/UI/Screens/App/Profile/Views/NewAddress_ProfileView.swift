//
//  Address_ProfileView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/7/20.
//

import SwiftUI

struct NewAddress_ProfileView: View {
    @Binding var showSheet: Bool
    var addressFields: [TextViewCase] = [.streetAddress, .city, .state, .zip, .country]

    var body: some View {
        VStack(alignment: .leading) {
            BackButton() {
                showSheet.toggle()
            }

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    Group {
                        Text("New home address")
                            .customFont(.heavy, category: .extraLarge)
                            .foregroundColor(Colors.headline)
                            .padding(.top, Sizes.Large)
                            .padding(.bottom, Sizes.Large)

                        ForEach(addressFields, id: \.rawValue) { field in
                            BrandTextView(item: field)
                        }
                    }
                        .padding(.bottom, Sizes.xSmall)
                        .padding(.horizontal, Sizes.Default)
                }

                Group {
                    ConfirmButton(title: "Save", style: .fill) {
                        // Save address
                    }

                    ConfirmButton(title: "Cancel", style: .lined) {
                        showSheet.toggle()
                    }
                }
                    .padding(.bottom, Sizes.Spacer)
                    .padding(.horizontal, Sizes.Default)

                Spacer()
            }
        }
            .background(Colors.cellBackground.edgesIgnoringSafeArea(.all))
    }
}

struct NewAddress_ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NewAddress_ProfileView(showSheet: .constant(true))
    }
}
