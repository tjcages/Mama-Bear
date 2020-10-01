//
//  Global.swift
//  Gather
//
//  Created by Tyler Cagle on 9/28/20.
//

import SwiftUI

struct Global {
    
    // MARK: -Frame
    static let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
    static let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    static let bottomSafeAreaInset = window?.safeAreaInsets.bottom ?? 0
    
}

// MARK: -Animations
extension Animation {
    static let animationQuick: Double = 0.1
    static let animationIn: Double = 0.3
    static let animationOut: Double = 0.5
}
