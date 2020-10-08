//
//  NewListingView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/5/20.
//

import SwiftUI

struct NewListingView: View {
    @State var activeSheet: ActiveSheet = .first
    @State var showSheet: Bool = false

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: Sizes.xSmall) {
                Text("Request a babysitter")
                    .customFont(.heavy, category: .extraLarge)
                    .foregroundColor(Colors.headline)
                    .padding(.top, Sizes.Large)
                    .padding(.horizontal, Sizes.Default)

                Text("Time")
                    .customFont(.medium, category: .large)
                    .foregroundColor(Colors.headline)
                    .padding(.top, Sizes.Default)
                    .padding(.horizontal, Sizes.Default)

                DurationView(newListing: true, activeSheet: $activeSheet.didSet { _ in
                    showSheet.toggle()
                })

                // Address view
                Address_ProfileView(activeSheet: $activeSheet.didSet { _ in
                    showSheet.toggle()
                })

                Spacer()

                ConfirmButton(title: "Next", style: .fill) {
                    activeSheet = .first
                    showSheet.toggle()
                }
                    .padding(.horizontal, Sizes.Default)

                Color.clear.padding(.bottom, Sizes.Big * 2)
            }
        }
            .sheet(isPresented: $showSheet) {
                if activeSheet == .first {
                    Details_NewListingView(showSheet: $showSheet)
                } else if activeSheet == .third {
                    NewAddress_ProfileView(showSheet: $showSheet)
                }
        }
    }
}

struct NewListingView_Previews: PreviewProvider {
    static var previews: some View {
        NewListingView()
    }
}
