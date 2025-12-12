//
//  Typography.swift
//  LearnTrack
//
//  Design System - Système typographique
//

import SwiftUI

// MARK: - Font Sizes
enum LTFontSize {
    static let xs: CGFloat = 11
    static let sm: CGFloat = 13
    static let base: CGFloat = 15
    static let lg: CGFloat = 17
    static let xl: CGFloat = 20
    static let xxl: CGFloat = 24
    static let xxxl: CGFloat = 30
    static let display: CGFloat = 36
}

// MARK: - Font Extensions
extension Font {
    // Headers
    static let ltH1 = Font.system(size: LTFontSize.xxxl, weight: .bold, design: .rounded)
    static let ltH2 = Font.system(size: LTFontSize.xxl, weight: .bold, design: .rounded)
    static let ltH3 = Font.system(size: LTFontSize.xl, weight: .semibold, design: .rounded)
    static let ltH4 = Font.system(size: LTFontSize.lg, weight: .semibold, design: .rounded)
    
    // Body
    static let ltBody = Font.system(size: LTFontSize.base, weight: .regular)
    static let ltBodyMedium = Font.system(size: LTFontSize.base, weight: .medium)
    static let ltBodySemibold = Font.system(size: LTFontSize.base, weight: .semibold)
    
    // Caption
    static let ltCaption = Font.system(size: LTFontSize.sm, weight: .regular)
    static let ltCaptionMedium = Font.system(size: LTFontSize.sm, weight: .medium)
    
    // Small
    static let ltSmall = Font.system(size: LTFontSize.xs, weight: .regular)
    static let ltSmallMedium = Font.system(size: LTFontSize.xs, weight: .medium)
    
    // Labels
    static let ltLabel = Font.system(size: LTFontSize.sm, weight: .semibold)
    
    // Buttons
    static let ltButtonSmall = Font.system(size: LTFontSize.sm, weight: .semibold)
    static let ltButtonMedium = Font.system(size: LTFontSize.base, weight: .semibold)
    static let ltButtonLarge = Font.system(size: LTFontSize.lg, weight: .semibold)
}

// MARK: - Text Style Modifier
struct LTTextStyle: ViewModifier {
    let font: Font
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundColor(color)
    }
}

extension View {
    func ltTextStyle(_ font: Font, color: Color = .ltText) -> some View {
        modifier(LTTextStyle(font: font, color: color))
    }
}
