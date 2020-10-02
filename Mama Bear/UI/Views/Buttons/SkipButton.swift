//
//  SkipButton.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/1/20.
//

import SwiftUI

struct SkipButton: View {
    var buttonPressed: () -> () = { }
    
    var body: some View {
        HStack(spacing: Sizes.Spacer) {
            Text("Skip")
                .customFont(.heavy, category: .small)
                .foregroundColor(Colors.subheadline)
            
            Image(systemName: "arrow.right")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: Sizes.Small, height: Sizes.Small)
                .foregroundColor(Colors.subheadline)
        }
        .padding(.top, Global.statusBarHeight)
        .padding(.vertical, Sizes.Default)
        .contentShape(Rectangle())
        .onTapGesture {
            buttonPressed()
        }
    }
}

struct SkipButton_Previews: PreviewProvider {
    static var previews: some View {
        SkipButton()
    }
}
