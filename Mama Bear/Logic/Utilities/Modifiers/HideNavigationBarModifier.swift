//
//  HideNavigationBarModifier.swift
//  Gather
//
//  Created by Tyler Cagle on 9/28/20.
//

import SwiftUI

struct HideNavigationBarModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .navigationBarTitle("", displayMode: .automatic)
    }
}

extension View {
    func hideNavigationBar() -> some View {
        modifier(HideNavigationBarModifier())
    }
}
