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
    case verifyPassword
    case firstName
    case lastName
    case name
    case phone
    case streetAddress
    case city
    case state
    case zip
    case country
}

struct TextViewItems {
    let title: String
    let image: String
}

struct BrandTextView: View {
    @Binding var text: String
    
    private var verified: Bool {
        if text.contains("@") && text.contains(".") {
            return true
        } else {
            return false
        }
    }
    
    @State private var secured = true
    
    var item: TextViewItems
    var itemCase: TextViewCase

    private var cases: [TextViewItems] = [
        TextViewItems(title: "Your email", image: "PersonIcon"),
        TextViewItems(title: "Password", image: "LockIcon"),
        TextViewItems(title: "Verify Password", image: "LockIcon"),
        TextViewItems(title: "First name", image: ""),
        TextViewItems(title: "Last name", image: ""),
        TextViewItems(title: "Name", image: ""),
        TextViewItems(title: "Phone number", image: "PhoneIcon"),
        TextViewItems(title: "Street address", image: ""),
        TextViewItems(title: "City", image: ""),
        TextViewItems(title: "State", image: ""),
        TextViewItems(title: "Zip code", image: ""),
        TextViewItems(title: "Country", image: "")
    ]

    init(item: TextViewCase, _ text: Binding<String>) {
        self._text = text
        self.itemCase = item
        self.item = cases[item.rawValue]
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            HStack(spacing: Sizes.xSmall) {
                if item.image != "" {
                    Image(item.image)
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Colors.subheadline)
                        .frame(width: Sizes.Small, height: Sizes.Small)
                        .foregroundColor(!text.isEmpty ? Colors.headline : Colors.subheadline)
                }

                CustomTextField(placeholder: Text("Enter \(item.title.lowercased())"), text: $text, itemCase: itemCase, secured: secured) { text in
                    // onChanged
                } commit: {
                    // on Commit
                }

                if itemCase == .email && verified {
                    Image(systemName: "checkmark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: Sizes.Small, height: Sizes.Small)
                        .foregroundColor(Colors.green)
                } else if itemCase == .password {
                    Image(!secured ? "EyeIcon" : "EyeIconSlash")
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Colors.subheadline)
                        .frame(width: Sizes.Small, height: Sizes.Small)
                        .foregroundColor(Colors.subheadline)
                        .onTapGesture {
                            secured.toggle()
                        }
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
                .background(Colors.cellBackground)
                .padding(.leading, Sizes.Spacer)
                .offset(x: 0, y: -Sizes.Spacer - Sizes.Spacer/2)
        }
    }
}

struct CustomTextField: View {
    var placeholder: Text
    @Binding var text: String
    var itemCase: TextViewCase
    var secured: Bool
    var editingChanged: (Bool) -> () = { _ in }
    var commit: () -> () = { }

    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                placeholder
                    .customFont(.medium, category: .medium)
                    .foregroundColor(Colors.subheadline)
            }
            Group {
                if itemCase == .password && secured {
                    SecureField("", text: $text, onCommit: commit)
                } else {
                    TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
                }
            }
                .customFont(.medium, category: .medium)
                .foregroundColor(Colors.headline)
                .multilineTextAlignment(.leading)
                .lineLimit(1)
                .keyboardType(itemCase == .email ? .emailAddress : (itemCase == .phone ? .phonePad : .default))
                .autocapitalization(itemCase == .email ? .none : .words)
        }
    }
}
