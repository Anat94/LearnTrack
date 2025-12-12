//
//  Typography.swift
//  LearnTrack
//
//  Design System - Typographie
//

import SwiftUI

// MARK: - Font Sizes
enum LTFontSize {
    static let xs: CGFloat = 11
    static let sm: CGFloat = 13
    static let base: CGFloat = 15
    static let md: CGFloat = 16
    static let lg: CGFloat = 18
    static let xl: CGFloat = 20
    static let xxl: CGFloat = 24
    static let xxxl: CGFloat = 30
    static let display: CGFloat = 36
    static let hero: CGFloat = 48
}

// MARK: - Custom Fonts
extension Font {
    
    // MARK: Display / Hero
    static let ltHero = Font.system(size: LTFontSize.hero, weight: .bold, design: .rounded)
    static let ltDisplay = Font.system(size: LTFontSize.display, weight: .bold, design: .rounded)
    
    // MARK: Headings
    static let ltH1 = Font.system(size: LTFontSize.xxxl, weight: .bold, design: .rounded)
    static let ltH2 = Font.system(size: LTFontSize.xxl, weight: .bold, design: .rounded)
    static let ltH3 = Font.system(size: LTFontSize.xl, weight: .semibold, design: .rounded)
    static let ltH4 = Font.system(size: LTFontSize.lg, weight: .semibold, design: .rounded)
    
    // MARK: Body
    static let ltBody = Font.system(size: LTFontSize.base, weight: .regular)
    static let ltBodyMedium = Font.system(size: LTFontSize.base, weight: .medium)
    static let ltBodySemibold = Font.system(size: LTFontSize.base, weight: .semibold)
    static let ltBodyLarge = Font.system(size: LTFontSize.md, weight: .regular)
    
    // MARK: Labels
    static let ltLabel = Font.system(size: LTFontSize.sm, weight: .medium)
    static let ltLabelLarge = Font.system(size: LTFontSize.base, weight: .medium)
    
    // MARK: Captions
    static let ltCaption = Font.system(size: LTFontSize.sm, weight: .regular)
    static let ltCaptionMedium = Font.system(size: LTFontSize.sm, weight: .medium)
    static let ltCaptionBold = Font.system(size: LTFontSize.sm, weight: .semibold)
    
    // MARK: Small / Micro
    static let ltSmall = Font.system(size: LTFontSize.xs, weight: .regular)
    static let ltSmallMedium = Font.system(size: LTFontSize.xs, weight: .medium)
    
    // MARK: Buttons
    static let ltButtonLarge = Font.system(size: LTFontSize.md, weight: .semibold)
    static let ltButtonMedium = Font.system(size: LTFontSize.base, weight: .semibold)
    static let ltButtonSmall = Font.system(size: LTFontSize.sm, weight: .semibold)
    
    // MARK: Numbers / Monospace
    static let ltMono = Font.system(size: LTFontSize.base, weight: .medium, design: .monospaced)
    static let ltMonoLarge = Font.system(size: LTFontSize.xl, weight: .bold, design: .monospaced)
}

// MARK: - Text Styles View Modifier
struct LTTextStyle: ViewModifier {
    let font: Font
    let color: Color
    let lineSpacing: CGFloat
    
    init(font: Font, color: Color = .ltText, lineSpacing: CGFloat = 2) {
        self.font = font
        self.color = color
        self.lineSpacing = lineSpacing
    }
    
    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundColor(color)
            .lineSpacing(lineSpacing)
    }
}

extension View {
    func ltTextStyle(_ font: Font, color: Color = .ltText) -> some View {
        modifier(LTTextStyle(font: font, color: color))
    }
}

// MARK: - Preview
#Preview("Typography") {
    ScrollView {
        VStack(alignment: .leading, spacing: 24) {
            Group {
                Text("Hero - 48pt Bold")
                    .font(.ltHero)
                
                Text("Display - 36pt Bold")
                    .font(.ltDisplay)
                
                Text("H1 - 30pt Bold Rounded")
                    .font(.ltH1)
                
                Text("H2 - 24pt Bold Rounded")
                    .font(.ltH2)
                
                Text("H3 - 20pt Semibold")
                    .font(.ltH3)
                
                Text("H4 - 18pt Semibold")
                    .font(.ltH4)
            }
            
            Divider()
            
            Group {
                Text("Body - 15pt Regular")
                    .font(.ltBody)
                
                Text("Body Medium - 15pt Medium")
                    .font(.ltBodyMedium)
                
                Text("Body Large - 16pt Regular")
                    .font(.ltBodyLarge)
                
                Text("Label - 13pt Medium")
                    .font(.ltLabel)
                
                Text("Caption - 13pt Regular")
                    .font(.ltCaption)
                
                Text("Small - 11pt Regular")
                    .font(.ltSmall)
            }
            
            Divider()
            
            Group {
                Text("Button Large")
                    .font(.ltButtonLarge)
                
                Text("1,234.56")
                    .font(.ltMonoLarge)
                    .foregroundColor(.emerald500)
            }
        }
        .padding()
        .foregroundColor(.ltText)
    }
}
