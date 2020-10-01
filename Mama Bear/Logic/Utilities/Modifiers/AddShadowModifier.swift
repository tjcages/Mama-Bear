//
//  Extensions.swift
//  Gather
//
//  Created by Tyler Cagle on 9/29/20.
//

import SwiftUI

struct AddShadowModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 3, y: 6)
    }
}

extension View {
    func shadow() -> some View {
        modifier(AddShadowModifier())
    }
}
