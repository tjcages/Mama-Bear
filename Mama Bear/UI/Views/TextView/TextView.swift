//
//  TextView.swift
//  Gather
//
//  Created by Tyler Cagle on 9/29/20.
//

import SwiftUI
import UIKit

struct PlaceholderTextField: View {
    var placeholder: Text
    var font: Avenir
    var size: ContentSizeCategory
    var tag: Int

    @Binding var becomeFirstResponder: Bool

    @Binding var text: String
    var commit: () -> () = { }
    var ended: () -> () = { }

    @State private var dynamicHeight: CGFloat = 100

    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty { placeholder.customFont(font, category: size).foregroundColor(Colors.subheadline) }
            TextView(text: $text, font: uiFont(font, category: size), calculatedHeight: $dynamicHeight, becomeFirstResponder: $becomeFirstResponder, onDone: commit, onEnded: ended)
                .frame(minHeight: dynamicHeight, maxHeight: dynamicHeight)
        }
    }
}

struct TextView: UIViewRepresentable {
    @Binding var text: String
    var font: UIFont

    @Binding var calculatedHeight: CGFloat
    @Binding var becomeFirstResponder: Bool

    var onDone: (() -> Void)?
    var onEnded: (() -> Void)?

    func makeCoordinator() -> Coordinator {
        Coordinator(self, onDone: onDone, onEnded: onEnded)
    }

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator

        textView.textColor = UIColor(Colors.headline)
        textView.isEditable = true
        textView.font = font
        textView.isSelectable = true
        textView.isUserInteractionEnabled = true
        textView.isScrollEnabled = false
        textView.backgroundColor = UIColor.clear
        textView.textContainer.lineFragmentPadding = 0

        if nil != onDone {
            textView.returnKeyType = .default
        }

        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.text != self.text {
            uiView.text = self.text
        }

        if becomeFirstResponder {
            uiView.becomeFirstResponder()
            DispatchQueue.main.async {
                self.becomeFirstResponder = false
            }
        }

        TextView.recalculateHeight(view: uiView, result: $calculatedHeight)
    }

    fileprivate static func recalculateHeight(view: UIView, result: Binding<CGFloat>) {
        let newSize = view.sizeThatFits(CGSize(width: view.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        if result.wrappedValue != newSize.height {
            DispatchQueue.main.async {
                result.wrappedValue = newSize.height // !! must be called asynchronously
            }
        }
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: TextView

        var onDone: (() -> Void)?
        var onEnded: (() -> Void)?

        init(_ uiTextView: TextView, onDone: (() -> Void)? = nil, onEnded: (() -> Void)? = nil) {
            self.parent = uiTextView
            self.onDone = onDone
            self.onEnded = onEnded
        }

        func textViewDidChange(_ textView: UITextView) {
            self.parent.text = textView.text
        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if let onDone = self.onDone, text == "\n" {
                textView.resignFirstResponder()
                onDone()
                return false
            }
            return true
        }

        func textViewDidEndEditing(_ textView: UITextView) {
            if let onEnded = self.onEnded {
                onEnded()
            }
        }
    }
}
