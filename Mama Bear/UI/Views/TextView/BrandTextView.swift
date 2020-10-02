//
//  BrandTextView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/1/20.
//

import SwiftUI

enum TextViewCase: Int {
    case email
    case password
    case firstName
    case lastName
    case phone
}

struct TextViewItems {
    let title: String
    let image: String
}

struct BrandTextView: View {
    var item: TextViewItems
    var itemCase: TextViewCase

    @State private var text: String = ""

    private var cases: [TextViewItems] = [
        TextViewItems(title: "Your email", image: "person"),
        TextViewItems(title: "Password", image: "lock"),
        TextViewItems(title: "First name", image: ""),
        TextViewItems(title: "Last name", image: ""),
        TextViewItems(title: "Phone number", image: "phone")
    ]

    init(item: TextViewCase) {
        self.itemCase = item
        self.item = cases[item.rawValue]
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            HStack(spacing: Sizes.xSmall) {
                if item.image != "" {
                    Image(systemName: item.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: Sizes.Small, height: Sizes.Small)
                        .foregroundColor(!text.isEmpty ? Colors.headline : Colors.subheadline)
                }

                CustomTextField(placeholder: Text("Enter \(item.title.lowercased())"), text: $text) { _ in
                    // on Changed
                } commit: {
                    // on Commit
                }

                if itemCase == .email {
                    Image(systemName: "checkmark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: Sizes.Small, height: Sizes.Small)
                        .foregroundColor(Colors.green)
                } else if itemCase == .password {
                    Image(systemName: "eye.slash")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: Sizes.Small, height: Sizes.Small)
                        .foregroundColor(Colors.subheadline)
                }
            }
                .padding(Sizes.xSmall)
                .padding(.trailing, Sizes.Spacer)
                .overlay(
                    RoundedRectangle(cornerRadius: Sizes.Spacer)
                        .stroke(Colors.subheadline.opacity(0.4), lineWidth: 1)
                )

            Text(item.title)
                .customFont(.medium, category: .small)
                .foregroundColor(Colors.subheadline)
                .padding(.horizontal, Sizes.Spacer)
                .background(Colors.background)
                .padding(.leading, Sizes.Spacer)
                .offset(x: 0, y: -Sizes.Spacer - Sizes.Spacer/2)
        }
    }
}

struct CustomTextField: View {
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool) -> () = { _ in }
    var commit: () -> () = { }

    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                placeholder
                    .customFont(.medium, category: .medium)
                    .foregroundColor(Colors.subheadline)
            }
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
                .customFont(.medium, category: .medium)
                .foregroundColor(Colors.headline)
                .multilineTextAlignment(.leading)
                .lineLimit(1)
        }
    }
}
