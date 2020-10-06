//
//  BrandSegmentedPickerView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/5/20.
//

import SwiftUI

struct BrandSegmentedPickerView: View {
    @Binding var selectedIndex: Int
    @State var frames = Array<CGRect>(repeating: .zero, count: 2)

    @State var titles: [String]

    var body: some View {
        HStack(spacing: Sizes.xSmall) {
            ForEach(self.titles.indices, id: \.self) { index in
                Button(action: { self.selectedIndex = index }) {
                    HStack {
                        Spacer()

                        Text(self.titles[index])
                            .customFont(.heavy, category: .small)
                            .foregroundColor(self.selectedIndex == index ? Colors.white : Colors.subheadline)

                        Spacer()
                    }
                }
                    .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
                    .background(
                        GeometryReader { geo in
                            Color.clear.onAppear { self.setFrame(index: index, frame: geo.frame(in: .global)) }
                        }
                    )
            }
        }
            .background(
                RoundedRectangle(cornerRadius: Sizes.Spacer)
                    .foregroundColor(Colors.coral)
                    .frame(width: self.frames[self.selectedIndex].width,
                        height: self.frames[self.selectedIndex].height, alignment: .topLeading)
                    .offset(x: self.frames[self.selectedIndex].minX - self.frames[0].minX)
                , alignment: .leading
            )
            .animation(Animation.easeOut(duration: Animation.animationQuick))
            .padding(Sizes.Spacer / 2)
            .overlay(
                RoundedRectangle(cornerRadius: Sizes.Spacer)
                    .stroke(Colors.subheadline.opacity(0.6), lineWidth: 1)
            )
    }

    func setFrame(index: Int, frame: CGRect) {
        self.frames[index] = frame
    }
}

