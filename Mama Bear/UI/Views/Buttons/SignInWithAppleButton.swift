//
//  SignInWithAppleButton.swift
//  Gather
//
//  Created by Tyler Cagle on 9/28/20.
//

import SwiftUI
import AuthenticationServices

// Implementation courtesy of https://stackoverflow.com/a/56852456/281221
struct SignInWithAppleButton: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        Group {
            if colorScheme == .light {
                SignInWithAppleButtonInternational(colorScheme: .light)
            } else {
                SignInWithAppleButtonInternational(colorScheme: .dark)
            }
        }
    }
}

fileprivate struct SignInWithAppleButtonInternational: UIViewRepresentable {
    var colorScheme: ColorScheme
    
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        switch colorScheme {
        case .light:
            return ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        case .dark:
            return ASAuthorizationAppleIDButton(type: .signIn, style: .white)
        @unknown default:
            return ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        }
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
        //
    }
}

struct SignInWithAppleButton_Previews: PreviewProvider {
    static var previews: some View {
        SignInWithAppleButton()
    }
}
