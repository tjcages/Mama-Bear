//
//  RegisterView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/1/20.
//

import SwiftUI

enum AccountType: String {
    case nanny = "Nanny"
    case family = "Family"
}

struct RegisterView: View {
    var backPressed: () -> () = { }
    var account: AccountType = .nanny

    var body: some View {
        VStack {
            BackButton() {
                backPressed()
            }
                .padding(.bottom, Sizes.Default)

            Create_RegisterView(account: .nanny)
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
