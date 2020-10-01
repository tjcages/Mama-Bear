//
//  SendButton.swift
//  Gather
//
//  Created by Tyler Cagle on 9/29/20.
//

import SwiftUI

struct SendButton: View {
    @Binding var addTask: Bool

    let buttonColor = Colors.sienna
    let size = Sizes.xLarge - Sizes.Spacer

    var body: some View {
        Image(systemName: "arrow.up.circle.fill")
            .resizable()
            .frame(width: size, height: size)
            .foregroundColor(buttonColor)
            .background(
                Color.white
                    .padding(Sizes.Spacer / 2)
                    .cornerRadius(Sizes.Large)
            )
            .padding(Sizes.xSmall)
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(Animation.interactiveSpring()) {
                    self.addTask.toggle()
                }
        }
    }
}

struct SendButton_Previews: PreviewProvider {
    static var previews: some View {
        SendButton(addTask: .constant(false))
    }
}
