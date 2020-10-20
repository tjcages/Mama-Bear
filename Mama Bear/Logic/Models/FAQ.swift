//
//  FAQ.swift
//  Mama Bear
//
//  Created by Tyler Cagle on 10/6/20.
//

import SwiftUI

struct FAQ: Equatable, Decodable {
    let title: String
    let description: String
    var open: Bool = false
}
