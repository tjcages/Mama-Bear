//
//  Pet.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/7/20.
//

import SwiftUI

enum Animal: String {
    case cat = "Cat"
    case dog = "Dog"
}

struct Pet: Equatable, Identifiable {
    let id = UUID()
    let name: String
    let type: Animal
    let gender: Gender
    
    init(name: String, type: Animal, gender: Gender) {
        self.name = name
        self.type = type
        self.gender = gender
    }
    
    init() {
        self.name = ""
        self.type = .dog
        self.gender = .female
    }
}
