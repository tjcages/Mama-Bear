//
//  VerifyTextView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/2/20.
//

import SwiftUI


struct VerifyModel {
    struct Row: Identifiable {
        var textContent = " "
        let id = UUID()
    }

    var rows: [Row]
}

struct VerifyTextView: View {
    @Binding var model: VerifyModel
    @State var verifyCurrentIndex: Int = -1

    var body: some View {
        HStack {
            ForEach(model.rows.indices) { index in
                VerifyCell(row: self.$model.rows[index], index: index, currentIndex: $verifyCurrentIndex) {
                    // Next textfield
                    verifyCurrentIndex += 1

                    if verifyCurrentIndex == model.rows.count {
                        UIApplication.shared.endEditing()
                        verifyCurrentIndex = -1
                    }
                } backspace: {
                    // Backspace
                    verifyCurrentIndex -= 1
                }
                    .overlay(
                        RoundedRectangle(cornerRadius: Sizes.Spacer)
                            .stroke((index == verifyCurrentIndex) ? Colors.lightCoral : Colors.subheadline.opacity(0.4), lineWidth: 2)
                    )
                    .background(Colors.cellBackground)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        verifyCurrentIndex = index
                }
            }
        }
    }
}

struct VerifyCell: View {
    @Binding var row: VerifyModel.Row
    @State var index: Int
    @Binding var currentIndex: Int

    var onDone: () -> () = { }
    var backspace: () -> () = { }

    var body: some View {
        TextFieldWrapperView(text: $row.textContent, index: index, currentIndex: $currentIndex, font: selectFont(), onDone: onDone, backspace: backspace)
            .frame(width: (UIScreen.main.bounds.width - (Sizes.Default * 2) - (Sizes.Spacer * 5)) / 6, height: Sizes.Big)
    }

    func selectFont() -> UIFont {
        return uiFont(.medium, category: .large)
    }
}

struct TextFieldWrapperView: UIViewRepresentable {
    @Binding var text: String

    var index: Int
    @Binding var currentIndex: Int

    var font: UIFont
    var onDone: () -> () = { }
    var backspace: () -> () = { }

    func makeCoordinator() -> TFCoordinator {
        TFCoordinator(self, index: $currentIndex, onDone: { string in
            text = string
            onDone()
        }, backspace: backspace)
    }
}

extension TextFieldWrapperView {
    func makeUIView(context: UIViewRepresentableContext<TextFieldWrapperView>) -> UITextField {
        let textField = UITextField()

        textField.delegate = context.coordinator
        textField.text = text
        textField.font = font
        textField.isUserInteractionEnabled = true
        textField.backgroundColor = .clear
        textField.tintColor = .clear
        textField.clipsToBounds = false
        textField.textAlignment = .center
        textField.keyboardType = .numberPad

        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        if !uiView.isFirstResponder && index == currentIndex {
            uiView.becomeFirstResponder()
        }
    }
}

class TFCoordinator: NSObject, UITextFieldDelegate, CharacterFieldBackspaceDelegate {
    var parent: TextFieldWrapperView

    var onDone: ((_: String) -> Void)?
    var backspace: (() -> Void)?
    
    // Each cell will update this
    @Binding var selectedCellIndex: Int

    init(_ textField: TextFieldWrapperView, index: Binding<Int>, onDone: ((_: String) -> Void)? = nil, backspace: (() -> Void)? = nil) {
        self.parent = textField
        self._selectedCellIndex = index
        self.onDone = onDone
        self.backspace = backspace
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")

        if (isBackSpace == -92), let backspace = self.backspace {
            textField.text = " "
            backspace()
            if selectedCellIndex == 0 {
                UIApplication.shared.endEditing()
            }
        } else if let onDone = self.onDone {
            textField.text = string
            onDone(string)
        }
        return false
    }
    
    func charFieldWillDeleteBackward(_ textField: CharacterField) {
        if(textField.text == "" && selectedCellIndex > 0) {
            self.selectedCellIndex -= 1
        }
    }
    
}

protocol CharacterFieldBackspaceDelegate {
    /**
     - Parameter textField: A CharacterField instance
     */
    func charFieldWillDeleteBackward(_ textField: CharacterField)
}

class CharacterField: UITextField {
    public var willDeleteBackwardDelegate: CharacterFieldBackspaceDelegate?

    override func deleteBackward() {
        willDeleteBackwardDelegate?.charFieldWillDeleteBackward(self)
        super.deleteBackward()
    }

}
