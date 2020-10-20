//
//  FAQViewModel.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/6/20.
//

import SwiftUI
import Combine
import Resolver

class FAQViewModel: ObservableObject {
    @Published var faqRepository: BaseFAQRepository = Resolver.resolve()
    @Published var faq: [FAQ] = []
    
    private var cancellables = Set<AnyCancellable>()

    init() {
        faqRepository.$faq.map { faq in
            faq
        }
            .assign(to: \.faq, on: self)
            .store(in: &cancellables)
    }
    
    func updateOpen(question: FAQ) {
        if let index = self.faq.firstIndex(of: question) {
            self.faq[index].open.toggle()
        }
    }
}
