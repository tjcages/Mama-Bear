//
//  FAQViewModel.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/6/20.
//

import SwiftUI

class FAQViewModel: ObservableObject {
    @Published var questions: [FAQ]
    let description = "Vestibulum at vestibulum augue. Mauris pharetra orci ut suscipit bibendum. Suspendisse vehicula pellentesque gravida. Nunc eu accumsan felis. Fusce ultricies nibh eu ex lobortis, eu tincidun. faucibus. A pellentesque gravida."

    init() {
        // Create some test events
        self.questions = [
            FAQ(title: "How can I rate a nanny?", description: self.description),
            FAQ(title: "Why is my account deactivated?", description: self.description),
            FAQ(title: "How to add a payment method", description: self.description),
            FAQ(title: "How do I book a listing?", description: self.description),
        ]
    }
    
    func updateOpen(question: FAQ) {
        if let index = self.questions.firstIndex(of: question) {
            self.questions[index].open.toggle()
        }
    }
}
