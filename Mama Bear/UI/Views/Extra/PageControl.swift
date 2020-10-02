//
//  PageControl.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/1/20.
//

import SwiftUI

struct PageControl: View {
    var currentlySelectedId: Int

    var body: some View {
        HStack(spacing: Sizes.Spacer) {
            PageControlItem(selected: currentlySelectedId == 0)

            PageControlItem(selected: currentlySelectedId == 1)

            PageControlItem(selected: currentlySelectedId == 2)
        }
    }
}

struct PageControlItem: View {
    var selected: Bool

    var body: some View {
        RoundedRectangle(cornerRadius: selected ? 6 : Sizes.Spacer/2)
            .frame(width: selected ? Sizes.Large : Sizes.Spacer, height: selected ? 12 : Sizes.Spacer)
            .foregroundColor(selected ? Colors.coral : Colors.lightCoral)
    }
}
