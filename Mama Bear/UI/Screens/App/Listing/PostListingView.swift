//
//  PostListingView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/6/20.
//

import SwiftUI

struct PostListingView: View {
    @Binding var showingPostListing: Bool
    @Binding var currentListing: Bool
    @State var showSheet: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            BackButton() {
                showingPostListing.toggle()
            }

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: Sizes.xSmall) {
                    Text("Request details")
                        .customFont(.heavy, category: .extraLarge)
                        .foregroundColor(Colors.headline)
                        .padding(.top, Sizes.Large)
                        .padding(.horizontal, Sizes.Default)

                    Text("Time")
                        .customFont(.medium, category: .large)
                        .foregroundColor(Colors.headline)
                        .padding(.top, Sizes.Default)
                        .padding(.horizontal, Sizes.Default)

                    DurationView(newListing: false, activeSheet: .constant(.second))

                    Text("Children")
                        .customFont(.medium, category: .large)
                        .foregroundColor(Colors.headline)
                        .padding(.top, Sizes.Default)
                        .padding(.horizontal, Sizes.Default)

                    ChildrenView(activeSheet: .constant(.first))

                    Text("Pets")
                        .customFont(.medium, category: .large)
                        .foregroundColor(Colors.headline)
                        .padding(.top, Sizes.Default)
                        .padding(.horizontal, Sizes.Default)

                    PetsView(activeSheet: .constant(.second))

                    if currentListing {
                        Group {
                            ConfirmButton(title: "Edit listing", style: .fill) {
                                // Edit listing
                            }
                                .padding(.top, Sizes.Default)

                            ConfirmButton(title: "Delete this request", style: .lined) {
                                // Delete listing
                                currentListing.toggle()
                            }
                        }
                            .padding(.horizontal, Sizes.Default)
                    }

                    Spacer()
                }
            }
        }
    }
}

struct PostListingView_Previews: PreviewProvider {
    static var previews: some View {
        PostListingView(showingPostListing: .constant(true), currentListing: .constant(true))
    }
}
