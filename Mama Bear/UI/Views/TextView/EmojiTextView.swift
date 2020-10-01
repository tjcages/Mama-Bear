//
//  EmojiTextView.swift
//  Gather
//
//  Created by Tyler Cagle on 9/30/20.
//

import SwiftUI

struct EmojiTextView: View {
    @Binding var emojiText: String

    var font: UIFont
    var onDone: () -> () = { }

    var body: some View {
        TextFieldWrapperView(text: self.$emojiText, font: font, onDone: onDone)
    }
}

struct TextFieldWrapperView: UIViewRepresentable {
    @Binding var text: String

    var font: UIFont
    var onDone: (() -> Void)?

    func makeCoordinator() -> TFCoordinator {
        TFCoordinator(self, onDone: onDone)
    }
}

extension TextFieldWrapperView {
    func makeUIView(context: UIViewRepresentableContext<TextFieldWrapperView>) -> UITextField {
        let textField = EmojiTextField()

        textField.delegate = context.coordinator
        textField.text = text
        textField.font = font
        textField.isUserInteractionEnabled = true
        textField.backgroundColor = .clear
        textField.tintColor = .clear
        textField.clipsToBounds = false
        textField.textAlignment = .center

        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        if let text = uiView.text, text.isEmpty && !uiView.isFirstResponder{
            print(text)
            
            uiView.becomeFirstResponder()
        }
    }
}

class TFCoordinator: NSObject, UITextFieldDelegate {
    var parent: TextFieldWrapperView

    var onDone: (() -> Void)?

    init(_ textField: TextFieldWrapperView, onDone: (() -> Void)? = nil) {
        self.parent = textField
        self.onDone = onDone
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")

        if (isBackSpace == -92), let onDone = self.onDone {
            textField.text = ""
            textField.resignFirstResponder()
            onDone()
        } else {
            textField.text = string
            textField.resignFirstResponder()
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if let onDone = self.onDone, let text = textField.text, text.isEmpty {
            onDone()
        }
    }

}

class EmojiTextField: UITextField {

    // required for iOS 13
    override var textInputContextIdentifier: String? { "" } // return non-nil to show the Emoji keyboard ¯\_(ツ)_/¯

    override var textInputMode: UITextInputMode? {
        for mode in UITextInputMode.activeInputModes {
            if mode.primaryLanguage == "emoji" {
                return mode
            }
        }
        return nil
    }
}

extension String {
    static var randomEmoji: String {
        let range = [UInt32](0x1F601...0x1F64F)
        let ascii = range[Int(drand48() * (Double(range.count)))]
        let emoji = UnicodeScalar(ascii)?.description
        return emoji!
    }
}
