//
//  AgeView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/7/20.
//

import SwiftUI

struct AgeView: View {
    let size: CGFloat = 12
    @State var showingMultiple: Bool = false
    @State var age: Int = 8

    var ageRange: [Int] = {
        var array: [Int] = []
        for i in 1 ..< 100 {
            array.append(i)
        }
        return array
    }()

    var body: some View {
        ZStack(alignment: .topLeading) {
            HStack {
                Spacer()

                if showingMultiple {
                    Picker("Number of people", selection: $age) {
                        ForEach(ageRange, id: \.self) { value in
                            Text("\(value)")
                        }
                    }
                        .modifier(ColorInvert())
                        .frame(width: UIScreen.main.bounds.width - Sizes.Big * 2, height: Sizes.Big * 3)
                        .onTapGesture {
                            withAnimation(Animation.easeOut(duration: Animation.animationIn)) {
                                self.showingMultiple.toggle()
                            }
                    }
                } else {
                    Text("\(age)")
                        .customFont(.medium, category: .medium)
                        .foregroundColor(showingMultiple ? Colors.coral : Colors.headline)
                        .onTapGesture {
                            withAnimation(Animation.easeOut(duration: Animation.animationIn)) {
                                self.showingMultiple.toggle()
                            }
                    }
                }

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

            Text("Age")
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
            .onTapGesture {
                UIApplication.shared.endEditing()

                withAnimation(Animation.easeOut(duration: Animation.animationIn)) {
                    self.showingMultiple.toggle()
                }
        }
    }
}

struct AgeView_Previews: PreviewProvider {
    static var previews: some View {
        AgeView()
    }
}
