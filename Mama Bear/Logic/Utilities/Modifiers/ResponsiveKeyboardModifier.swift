//
//  ResponsiveKeyboardModifier.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/6/20.
//

import SwiftUI

struct ResponsiveKeyboardModifier: ViewModifier {
    @State private var offset: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .padding(.bottom, offset)
            .onAppear {
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notif in
                    let value = notif.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                    let height = value.height
                    let bottomInset = UIApplication.shared.windows.first?.safeAreaInsets.bottom
                    self.offset = height - (bottomInset ?? 0) + Sizes.Large
                }

                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { notif in
                    self.offset = 0
                }
            }
            .gesture(DragGesture().onChanged { _ in
                    UIApplication.shared.endEditing()
                })
            .onTapGesture {
                UIApplication.shared.endEditing()
        }
    }
}

extension View {
    func responsiveKeyboard() -> ModifiedContent<Self, ResponsiveKeyboardModifier> {
        return modifier(ResponsiveKeyboardModifier())
    }
}

