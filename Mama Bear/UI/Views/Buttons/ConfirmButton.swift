//
//  ConfirmButton.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/1/20.
//

import SwiftUI

enum ButtonStyle {
    case fill
    case lined
}

struct ConfirmButton: View {
    var title: String
    var style: ButtonStyle
    var buttonPressed: () -> () = { }

    var body: some View {
        let fill = style == .fill
        Button(action: {
            buttonPressed()
            UIApplication.shared.endEditing()
        }, label: {
                Text(title)
                    .customFont(.heavy, category: .medium)
                    .foregroundColor(fill ? Colors.white : Colors.headline)
                    .padding(.vertical, Sizes.Small)
                    .frame(maxWidth: .infinity)
                    .background(fill ? Colors.lightCoral : Color.clear)
                    .cornerRadius(Sizes.xSmall)
                    .overlay(
                        RoundedRectangle(cornerRadius: Sizes.xSmall)
                            .stroke(Colors.subheadline.opacity(0.4), lineWidth: !fill ? 1 : 0)
                    )
            })
    }
}
