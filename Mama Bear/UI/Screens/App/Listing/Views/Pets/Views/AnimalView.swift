//
//  AnimalView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/8/20.
//

import SwiftUI

struct AnimalView: View {
    let size: CGFloat = 12
    @State var showingMultiple: Bool = false
    @State var animal: Animal = .dog

    var body: some View {
        ZStack(alignment: .topLeading) {
            HStack {
                Spacer()

                VStack(spacing: Sizes.xSmall) {
                    Text(animal.rawValue)
                        .customFont(.medium, category: .medium)
                        .foregroundColor(showingMultiple ? Colors.coral : Colors.headline)
                        .onTapGesture {
                            withAnimation(Animation.easeOut(duration: Animation.animationIn)) {
                                self.showingMultiple.toggle()
                            }
                    }

                    if showingMultiple {
                        Text(animal == .dog ? "Cat" : "Dog")
                            .customFont(.medium, category: .medium)
                            .foregroundColor(showingMultiple ? Colors.coral : Colors.headline)
                            .onTapGesture {
                                withAnimation(Animation.easeOut(duration: Animation.animationIn)) {
                                    if self.animal == .dog { self.animal = .cat } else { self.animal = .dog }
                                    self.showingMultiple.toggle()
                                }
                        }
                    }
                }
                    .padding(.leading, Sizes.Default)

                Spacer()

                // Options arrows
                VStack(alignment: .center, spacing: Sizes.Spacer / 2) {
                    Image(systemName: "chevron.up")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: size, height: size)
                        .foregroundColor(Colors.headline)

                    Image(systemName: "chevron.down")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: size, height: size)
                        .foregroundColor(Colors.headline)
                }
                    .opacity(showingMultiple ? 0 : 1)
            }
                .padding(Sizes.xSmall)
                .padding(.trailing, Sizes.Spacer)
                .overlay(
                    RoundedRectangle(cornerRadius: Sizes.Spacer)
                        .stroke(Colors.subheadline.opacity(0.4), lineWidth: 1)
                )
                .contentShape(Rectangle())
                .onTapGesture {
                    // Handle sitter requirement sheet
            }

            Text("Type of pet")
                .customFont(.medium, category: .small)
                .foregroundColor(Colors.subheadline)
                .padding(.horizontal, Sizes.Spacer)
                .background(Colors.cellBackground)
                .padding(.leading, Sizes.Spacer)
                .offset(x: 0, y: -Sizes.Spacer - Sizes.Spacer / 2)
        }
            .onTapGesture {
                withAnimation(Animation.easeOut(duration: Animation.animationIn)) {
                    self.showingMultiple.toggle()
                }
        }
    }
}

struct AnimalView_Previews: PreviewProvider {
    static var previews: some View {
        AnimalView()
    }
}
