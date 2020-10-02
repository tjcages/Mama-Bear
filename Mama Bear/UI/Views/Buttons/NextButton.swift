//
//  NextButton.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/1/20.
//

import SwiftUI

struct NextButton: View {
    var title: String
    var buttonPressed: () -> () = { }
    
    var body: some View {
        Button(action: { buttonPressed() }, label: {
            Text(title)
                .customFont(.heavy, category: .medium)
                .foregroundColor(Colors.white)
                .padding(.vertical, Sizes.Default)
                .frame(width: 172)
                .background(Colors.lightCoral)
                .cornerRadius(Sizes.xSmall)
        })
    }
}
