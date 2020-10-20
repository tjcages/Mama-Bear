//
//  GenderView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/7/20.
//

import SwiftUI

struct GenderView: View {
    let size: CGFloat = 12
    @State var showingMultiple: Bool = false
    @Binding var gender: Gender

    var body: some View {
        ZStack(alignment: .topLeading) {
            HStack {
                Spacer()

                VStack(spacing: Sizes.xSmall) {
                    Text(gender.rawValue)
                        .customFont(.medium, category: .medium)
                        .foregroundColor(showingMultiple ? Colors.coral : Colors.headline)
                        .onTapGesture {
                            withAnimation(Animation.easeOut(duration: Animation.animationIn)) {
                                self.showingMultiple.toggle()
                            }
                    }

                    if showingMultiple {
                        Text(gender == .male ? "Female" : "Male")
                            .customFont(.medium, category: .medium)
                            .foregroundColor(showingMultiple ? Colors.coral : Colors.headline)
                            .onTapGesture {
                                withAnimation(Animation.easeOut(duration: Animation.animationIn)) {
                                    if self.gender == .male { self.gender = .female } else { self.gender = .male }
                                    self.showingMultiple.toggle()
                                }
                        }

                        Text((gender == .male || gender == .female) ? "Other" : "Female")
                            .customFont(.medium, category: .medium)
                            .foregroundColor(showingMultiple ? Colors.coral : Colors.headline)
                            .onTapGesture {
                                withAnimation(Animation.easeOut(duration: Animation.animationIn)) {
                                    if self.gender == .unknown { self.gender = .female } else { self.gender = .unknown }
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
            }
                .padding(Sizes.xSmall)
                .padding(.trailing, Sizes.Spacer)
                .overlay(
                    RoundedRectangle(cornerRadius: Sizes.Spacer)
                        .stroke(Colors.subheadline.opacity(0.4), lineWidth: 1)
                )
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(Animation.easeOut(duration: Animation.animationIn)) {
                        self.showingMultiple.toggle()
                    }
            }

            Text("Gender")
                .customFont(.medium, category: .small)
                .foregroundColor(Colors.subheadline)
                .padding(.horizontal, Sizes.Spacer)
                .background(Colors.cellBackground)
                .padding(.leading, Sizes.Spacer)
                .offset(x: 0, y: -Sizes.Spacer - Sizes.Spacer / 2)
        }
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(Animation.easeOut(duration: Animation.animationIn)) {
                    self.showingMultiple.toggle()
                }
            }
            .responsiveKeyboard()
    }
}
