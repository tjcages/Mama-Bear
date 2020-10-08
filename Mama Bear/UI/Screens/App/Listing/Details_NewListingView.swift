//
//  Details_NewListingView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/7/20.
//

import SwiftUI

struct Details_NewListingView: View {
    @Binding var showSheet: Bool
    @State var presentPartialSheet: Bool = false
    
    @State var activeSheet: ActiveSheet = .first

    var body: some View {
        VStack(alignment: .leading) {
            BackButton() {
                showSheet.toggle()
            }

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: Sizes.xSmall) {
                    Text("Additional details")
                        .customFont(.heavy, category: .extraLarge)
                        .foregroundColor(Colors.headline)
                        .padding(.top, Sizes.Large)
                        .padding(.horizontal, Sizes.Default)

                    Text("Children")
                        .customFont(.medium, category: .large)
                        .foregroundColor(Colors.headline)
                        .padding(.top, Sizes.Default)
                        .padding(.horizontal, Sizes.Default)

                    ChildrenView(activeSheet: $activeSheet.didSet { _ in
                        presentPartialSheet.toggle()
                    })

                    Text("Pets")
                        .customFont(.medium, category: .large)
                        .foregroundColor(Colors.headline)
                        .padding(.top, Sizes.Default)
                        .padding(.horizontal, Sizes.Default)

                    PetsView(activeSheet: $activeSheet.didSet { _ in
                        presentPartialSheet.toggle()
                    })

                    // Sitter requirements
                    Text("Sitter requirement")
                        .customFont(.medium, category: .large)
                        .foregroundColor(Colors.headline)
                        .padding(.top, Sizes.Default)
                        .padding(.horizontal, Sizes.Default)

                    SitterRequirementView()

                    Spacer()

                    Group {
                        ConfirmButton(title: "Post listing", style: .fill) {
                            // Edit listing
                        }
                            .padding(.top, Sizes.Default)

                        ConfirmButton(title: "Cancel", style: .lined) {
                            // Delete listing
                            showSheet.toggle()
                        }
                    }
                        .padding(.horizontal, Sizes.Default)

                    Spacer()
                }
            }
        }
            .sheet(isPresented: $presentPartialSheet) {
                if activeSheet == .first {
                    AddChildView(showSheet: $presentPartialSheet)
                } else if activeSheet == .second {
                    AddPetView(showSheet: $presentPartialSheet)
                }
        }
    }
}

struct Details_NewListingView_Previews: PreviewProvider {
    static var previews: some View {
        Details_NewListingView(showSheet: .constant(true))
    }
}
