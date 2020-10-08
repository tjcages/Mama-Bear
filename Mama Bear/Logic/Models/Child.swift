//
//  Child.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/7/20.
//

import SwiftUI

enum Gender: String {
    case male = "Male"
    case female = "Female"
    case unknown = "Other"
}

enum Age {
    case baby
    case toddler
    case teenager
}

struct Child: Equatable, Identifiable {
    let id = UUID()
    let name: String
    let age: Age
    let gender: Gender
    
    init(name: String, age: Age, gender: Gender) {
        self.name = name
        self.age = age
        self.gender = gender
    }
    
    init() {
        self.name = ""
        self.age = .baby
        self.gender = .female
    }
}
