//
//  eMailView.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/6/20.
//

import SwiftUI
import UIKit
import MessageUI

struct eMailView: UIViewControllerRepresentable {

    @State var message: String
    @Environment(\.presentationMode) var presentation
    @Binding var result: Result<MFMailComposeResult, Error>?

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {

        @Binding var presentation: PresentationMode
        @Binding var result: Result<MFMailComposeResult, Error>?

        init(presentation: Binding<PresentationMode>,
            result: Binding<Result<MFMailComposeResult, Error>?>) {
            _presentation = presentation
            _result = result
        }

        func mailComposeController(_ controller: MFMailComposeViewController,
            didFinishWith result: MFMailComposeResult,
            error: Error?) {
            defer {
                $presentation.wrappedValue.dismiss()
            }
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(presentation: presentation,
            result: $result)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<eMailView>) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setToRecipients(["rebeccapousma@gmail.com"])
        vc.setSubject("Contact Mama Bear Babysitting")
        vc.setMessageBody(message, isHTML: false)
        
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController,
        context: UIViewControllerRepresentableContext<eMailView>) {

    }
}

