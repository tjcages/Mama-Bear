//
//  CreateAccountView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/1/20.
//

import SwiftUI

enum AccountType: String {
    case nanny = "Nanny"
    case family = "Family"
}

struct CreateAccount {
    let title: String
    let subtitle: String
    let color: Color
    let image: String
    let type: AccountType
}

struct CreateAccountView: View {
    @Binding var accountType: AccountType
    
    var backPressed: () -> () = { }
    var accountPressed: () -> () = { }

    var accounts: [CreateAccount] = [
        CreateAccount(title: "Parent account", subtitle: "Find the best babysitter", color: Colors.lightCoral.opacity(0.5), image: "parentGraphic", type: .family),
        CreateAccount(title: "Nanny account", subtitle: "Get jobs near you", color: Colors.lightBlue, image: "nannyGraphic", type: .nanny)
    ]

    var body: some View {
        VStack(alignment: .center, spacing: Sizes.Spacer) {
            Text("Choose your account type. \nAre you a parent or nanny?")
                .customFont(.medium, category: .medium)
                .foregroundColor(Colors.subheadline)

            Spacer()

            ForEach(accounts, id: \.title) { account in
                AccountSelectionView(account)
                    .onTapGesture {
                        accountType = account.type
                        accountPressed()
                }
            }

            Spacer()

            HStack(spacing: Sizes.Spacer) {
                Image(systemName: "chevron.left")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: Sizes.Small, height: Sizes.Small)
                    .foregroundColor(Colors.subheadline)

                Text("Back to login")
                    .customFont(.heavy, category: .small)
                    .foregroundColor(Colors.subheadline)
            }
                .padding(.vertical, Sizes.Default)
                .contentShape(Rectangle())
                .onTapGesture {
                    backPressed()
            }

            Spacer()
        }
            .onTapGesture {
                UIApplication.shared.endEditing()
        }
    }
}

struct AccountSelectionView: View {
    var account: CreateAccount

    init(_ account: CreateAccount) {
        self.account = account
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(account.title)
                    .customFont(.medium, category: .medium)
                    .foregroundColor(Colors.headline)

                Text(account.subtitle)
                    .customFont(.medium, category: .small)
                    .foregroundColor(Colors.subheadline)
            }
            
            Spacer()

            // Account graphic
            Image(account.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: Sizes.Big * 2, height: Sizes.Big * 1.5)
                .padding(.leading, Sizes.xSmall)
        }
            .padding(.vertical, Sizes.Large)
            .padding(.horizontal, Sizes.Default)
            .frame(maxWidth: .infinity)
            .background(account.color)
            .cornerRadius(Sizes.xSmall)
            .padding(.horizontal, Sizes.xSmall)
    }
}
