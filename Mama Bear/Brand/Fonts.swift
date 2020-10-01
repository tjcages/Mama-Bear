//
//  SwiftUIView.swift
//  Gather
//
//  Created by Tyler Cagle on 9/28/20.
//

import SwiftUI

enum Avenir: String {
    case black = "Avenir-Black"
    case heavy = "Avenir-Heavy"
    case medium = "Avenir-Medium"
    case regular = "Avenir-Regular"
}

extension ContentSizeCategory {
    var size: CGFloat {
        switch self {
        case .extraSmall:
            return 14
        case .small:
            return 16
        case .medium:
            return 20
        case .large:
            return 24
        case .extraLarge:
            return 32
        default:
            return 16
        }
    }
}

extension View {
    func customFont(_ font: Avenir, category: ContentSizeCategory) -> some View {
        return self.customFont(font.rawValue, category: category)
    }
    func customFont(_ name: String, category: ContentSizeCategory) -> some View {
        return self.font(.custom(name, size: category.size))
    }
    func uiFont(_ font: Avenir, category: ContentSizeCategory) -> some UIFont {
        if let font = UIFont(name: font.rawValue, size: category.size) {
            return font
        } else {
            let font = UIFont.systemFont(ofSize: category.size)
            return font
        }
    }
}
