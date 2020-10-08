//
//  ColorInvert.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/7/20.
//

import SwiftUI

struct ColorInvert: ViewModifier {
    @Environment(\.colorScheme) var colorScheme

    func body(content: Content) -> some View {
        if colorScheme == .dark {
            return AnyView(content
                    .colorMultiply(Colors.coral)
            )
        } else {
            return AnyView(content
                    .colorInvert()
                    .colorMultiply(Colors.coral)
            )
        }
    }
}
