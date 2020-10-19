//
//  SwiftUIView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/1/20.
//

import SwiftUI

struct OnboardingSingleView: View {
    @State var content: Onboarding

    var body: some View {
        VStack {
            // Area for image later
            Image(content.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(Sizes.Big)
                .padding(.top, Sizes.Big)

            Group {
                Group {
                    Text(content.title)
                        .customFont(.heavy, category: .extraLarge)
                        .foregroundColor(Colors.headline)
                        .multilineTextAlignment(.center)
                        .padding(.top, Sizes.Large)
                        .padding(.bottom, Sizes.xSmall)

                    Text(content.subtitle)
                        .customFont(.medium, category: .medium)
                        .foregroundColor(Colors.subheadline)
                        .padding(.bottom, Sizes.Large)
                }

                // Not visible – just for spacing
                HStack {
                    PageControl(currentlySelectedId: content.id)

                    Spacer()

                    NextButton(title: "")
                }
                    .padding(.top, Sizes.Large)
                    .padding(.bottom, Sizes.Default)
                    .opacity(0)
            }
                .padding(.horizontal, Sizes.xLarge)
        }
    }
}
