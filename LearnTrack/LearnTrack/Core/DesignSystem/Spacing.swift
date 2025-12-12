//
//  Spacing.swift
//  LearnTrack
//
//  Design System - Système d'espacement et rayons
//

import SwiftUI

// MARK: - Spacing Constants
enum LTSpacing {
    static let xxs: CGFloat = 2
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 20
    static let xxl: CGFloat = 24
    static let xxxl: CGFloat = 32
    static let huge: CGFloat = 40
    static let massive: CGFloat = 48
}

// MARK: - Border Radius
enum LTRadius {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 6
    static let md: CGFloat = 8
    static let lg: CGFloat = 12
    static let xl: CGFloat = 16
    static let xxl: CGFloat = 20
    static let xxxl: CGFloat = 24
    static let full: CGFloat = 9999
}

// MARK: - Icon Sizes
enum LTIconSize {
    static let xs: CGFloat = 12
    static let sm: CGFloat = 16
    static let md: CGFloat = 20
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 40
    static let xxxl: CGFloat = 48
}

// MARK: - Component Heights
enum LTHeight {
    static let buttonSmall: CGFloat = 32
    static let buttonMedium: CGFloat = 40
    static let buttonLarge: CGFloat = 48
    static let buttonXL: CGFloat = 56
    
    static let inputSmall: CGFloat = 40
    static let inputMedium: CGFloat = 48
    static let inputLarge: CGFloat = 56
    
    static let tabBarItem: CGFloat = 44
    static let tabBar: CGFloat = 60
    static let navBar: CGFloat = 44
    
    static let avatarSmall: CGFloat = 40
    static let avatarMedium: CGFloat = 48
    static let avatarLarge: CGFloat = 64
    static let avatarXL: CGFloat = 80
}

// MARK: - Spacing View Modifiers
extension View {
    func ltCardPadding() -> some View {
        self.padding(LTSpacing.lg)
    }
    
    func ltSectionPadding() -> some View {
        self.padding(.horizontal, LTSpacing.lg)
            .padding(.vertical, LTSpacing.md)
    }
    
    func ltScreenPadding() -> some View {
        self.padding(.horizontal, LTSpacing.lg)
    }
}
