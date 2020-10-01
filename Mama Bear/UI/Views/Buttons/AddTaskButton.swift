//
//  AddTaskButton.swift
//  Gather
//
//  Created by Tyler Cagle on 9/28/20.
//

import SwiftUI

struct AddTaskButton: View {
    @EnvironmentObject var partialSheetManager: PartialSheetManager
    
    @Binding var addTask: Bool
    
    let buttonColor = Colors.sienna

    var body: some View {
        Button(action: {
            withAnimation(Animation.interactiveSpring()) {
                self.addTask.toggle()
                self.partialSheetManager.showPartialSheet({
                        self.addTask.toggle()
                    }) {
                         NewItemView()
                    }
            }
        }) {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: Sizes.xLarge, height: Sizes.xLarge)
                .accentColor(buttonColor)
                .background(Colors.backgroundInvert.padding(Sizes.Spacer))
                .cornerRadius(Sizes.Default)
                .padding(Sizes.Spacer)
                .background(buttonColor)
                .cornerRadius(Sizes.xLarge)
                .shadow()
                .rotationEffect(addTask ? Angle.degrees(45) : Angle.degrees(0))
        }
    }
}
