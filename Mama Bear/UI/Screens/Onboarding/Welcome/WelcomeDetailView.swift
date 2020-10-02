//
//  WelcomeDetailView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/1/20.
//

import SwiftUI

struct WelcomeDetailView: View {
    var registerPressed: () -> () = { }
    
    var body: some View {
        VStack(alignment: .center, spacing: Sizes.Spacer) {
            BrandTextView(item: .email)
                .padding(.bottom, Sizes.Spacer)

            BrandTextView(item: .password)

            HStack {
                Spacer()

                Text("Forgot password?")
                    .customFont(.medium, category: .small)
                    .foregroundColor(Colors.subheadline)
            }
                .padding(.bottom, Sizes.xSmall)

            ConfirmButton(title: "Login now", style: .fill) {
                // Handle login
            }
                .padding(.vertical, Sizes.Spacer)

            Text("New user?")
                .customFont(.medium, category: .small)
                .foregroundColor(Colors.subheadline)

            ConfirmButton(title: "Register", style: .lined) {
                registerPressed()
            }

            HStack {
                Rectangle()
                    .foregroundColor(Colors.subheadline.opacity(0.4))
                    .frame(height: 1)

                Text("Or login with")
                    .customFont(.medium, category: .small)
                    .foregroundColor(Colors.subheadline)
                    .padding(.horizontal, Sizes.Spacer)

                Rectangle()
                    .foregroundColor(Colors.subheadline.opacity(0.4))
                    .frame(height: 1)
            }
                .padding(.top, Sizes.xSmall)

            SocialLoginView()
                .padding(.top, Sizes.xSmall)

            Spacer()
        }
            .padding(.all, Sizes.Large)
            .onTapGesture {
                UIApplication.shared.endEditing()
        }
    }
}

struct WelcomeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeDetailView()
    }
}
