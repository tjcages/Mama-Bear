//
//  SitterRequirementView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/7/20.
//

import SwiftUI

enum SitterRequirement: String {
    case highSchool = "High school"
    case college = "College"
    case postGrad = "Post Grad"
}

struct SitterRequirementView: View {
    let size: CGFloat = 12
    @State var showingMultiple: Bool = false
    @Binding var sitterRequirement: SitterRequirement

    var body: some View {
        ZStack(alignment: .top) {
            HStack {
                Spacer()

                VStack(spacing: Sizes.xSmall) {
                    Text(sitterRequirement.rawValue)
                        .customFont(.medium, category: .medium)
                        .foregroundColor(showingMultiple ? Colors.coral : Colors.headline)
                        .onTapGesture {
                            withAnimation(Animation.easeOut(duration: Animation.animationIn)) {
                                self.showingMultiple.toggle()
                            }
                    }

                    if showingMultiple {
                        Text(sitterRequirement == .highSchool ? "College" : "High School")
                            .customFont(.medium, category: .medium)
                            .foregroundColor(showingMultiple ? Colors.coral : Colors.headline)
                            .onTapGesture {
                                withAnimation(Animation.easeOut(duration: Animation.animationIn)) {
                                    if self.sitterRequirement == .highSchool { self.sitterRequirement = .college } else { self.sitterRequirement = .highSchool }
                                    self.showingMultiple.toggle()
                                }
                        }

                        Text((sitterRequirement == .highSchool || sitterRequirement == .college) ? "Post Grad" : "College")
                            .customFont(.medium, category: .medium)
                            .foregroundColor(showingMultiple ? Colors.coral : Colors.headline)
                            .onTapGesture {
                                withAnimation(Animation.easeOut(duration: Animation.animationIn)) {
                                    if self.sitterRequirement == .postGrad { self.sitterRequirement = .college } else { self.sitterRequirement = .postGrad }
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

            Text("Sitter rate")
                .customFont(.medium, category: .small)
                .foregroundColor(Colors.subheadline)
                .padding(.horizontal, Sizes.Spacer)
                .background(Colors.cellBackground)
                .padding(.leading, Sizes.Spacer)
                .offset(x: 0, y: -Sizes.Spacer - Sizes.Spacer / 2)
        }
            .padding([.leading, .top, .trailing], Sizes.Default)
            .padding(.bottom, Sizes.xSmall)
            .background(Colors.cellBackground)
            .cornerRadius(Sizes.Spacer)
            .shadow()
            .padding(.horizontal, Sizes.Default)
            .onTapGesture {
                withAnimation(Animation.easeOut(duration: Animation.animationIn)) {
                    self.showingMultiple.toggle()
                }
        }
    }
}
