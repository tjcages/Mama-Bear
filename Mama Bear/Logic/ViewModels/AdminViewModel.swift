//
//  AdminViewModel.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 11/17/20.
//

import SwiftUI
import Combine
import Resolver

class AdminViewModel: ObservableObject {
    @Published var adminRepository: BaseFAQRepository = Resolver.resolve()
    @Published var admin: [Admin] = []
    
    private var cancellables = Set<AnyCancellable>()

    init() {
        adminRepository.$admin.map { admin in
            admin
        }
            .assign(to: \.admin, on: self)
            .store(in: &cancellables)
    }
}
