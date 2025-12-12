//
//  Spacing.swift
//  LearnTrack
//
//  Design System - Système d'espacement et rayons
//

import SwiftUI

// MARK: - Spacing Constants
enum LTSpacing {
    /// 2pt
    static let xxs: CGFloat = 2
    /// 4pt
    static let xs: CGFloat = 4
    /// 8pt
    static let sm: CGFloat = 8
    /// 12pt
    static let md: CGFloat = 12
    /// 16pt
    static let lg: CGFloat = 16
    /// 20pt
    static let xl: CGFloat = 20
    /// 24pt
    static let xxl: CGFloat = 24
    /// 32pt
    static let xxxl: CGFloat = 32
    /// 40pt
    static let huge: CGFloat = 40
    /// 48pt
    static let massive: CGFloat = 48
    /// 64pt
    static let giant: CGFloat = 64
}

// MARK: - Border Radius
enum LTRadius {
    /// 4pt - Très petit (badges, tags)
    static let xs: CGFloat = 4
    /// 6pt - Petit
    static let sm: CGFloat = 6
    /// 8pt - Medium-petit
    static let md: CGFloat = 8
    /// 12pt - Medium (boutons, inputs)
    static let lg: CGFloat = 12
    /// 16pt - Large (cards)
    static let xl: CGFloat = 16
    /// 20pt - Extra large
    static let xxl: CGFloat = 20
    /// 24pt - XXL
    static let xxxl: CGFloat = 24
    /// 9999pt - Pill/Capsule
    static let full: CGFloat = 9999
}

// MARK: - Icon Sizes
enum LTIconSize {
    /// 12pt
    static let xs: CGFloat = 12
    /// 16pt
    static let sm: CGFloat = 16
    /// 20pt
    static let md: CGFloat = 20
    /// 24pt
    static let lg: CGFloat = 24
    /// 32pt
    static let xl: CGFloat = 32
    /// 40pt
    static let xxl: CGFloat = 40
    /// 48pt
    static let xxxl: CGFloat = 48
    /// 64pt
    static let huge: CGFloat = 64
}

// MARK: - Component Heights
enum LTHeight {
    /// 32pt - Small button
    static let buttonSmall: CGFloat = 32
    /// 40pt - Medium button
    static let buttonMedium: CGFloat = 40
    /// 48pt - Large button
    static let buttonLarge: CGFloat = 48
    /// 56pt - XL button
    static let buttonXL: CGFloat = 56
    
    /// 40pt - Small input
    static let inputSmall: CGFloat = 40
    /// 48pt - Medium input
    static let inputMedium: CGFloat = 48
    /// 56pt - Large input
    static let inputLarge: CGFloat = 56
    
    /// 44pt - Tab bar item
    static let tabBarItem: CGFloat = 44
    /// 60pt - Tab bar
    static let tabBar: CGFloat = 60
    
    /// 44pt - Navigation bar
    static let navBar: CGFloat = 44
    
    /// 40pt - Avatar small
    static let avatarSmall: CGFloat = 40
    /// 48pt - Avatar medium
    static let avatarMedium: CGFloat = 48
    /// 64pt - Avatar large
    static let avatarLarge: CGFloat = 64
    /// 80pt - Avatar XL
    static let avatarXL: CGFloat = 80
}

// MARK: - Spacing View Modifiers
extension View {
    /// Standard card padding
    func ltCardPadding() -> some View {
        self.padding(LTSpacing.lg)
    }
    
    /// Standard section padding
    func ltSectionPadding() -> some View {
        self.padding(.horizontal, LTSpacing.lg)
            .padding(.vertical, LTSpacing.md)
    }
    
    /// Screen edge padding
    func ltScreenPadding() -> some View {
        self.padding(.horizontal, LTSpacing.lg)
    }
}

// MARK: - Preview
#Preview("Spacing System") {
    ScrollView {
        VStack(alignment: .leading, spacing: 24) {
            Text("Spacing")
                .font(.ltH2)
            
            VStack(alignment: .leading, spacing: 8) {
                spacingRow("xxs", LTSpacing.xxs)
                spacingRow("xs", LTSpacing.xs)
                spacingRow("sm", LTSpacing.sm)
                spacingRow("md", LTSpacing.md)
                spacingRow("lg", LTSpacing.lg)
                spacingRow("xl", LTSpacing.xl)
                spacingRow("xxl", LTSpacing.xxl)
                spacingRow("xxxl", LTSpacing.xxxl)
            }
            
            Divider()
            
            Text("Border Radius")
                .font(.ltH2)
            
            HStack(spacing: 16) {
                radiusDemo("xs", LTRadius.xs)
                radiusDemo("sm", LTRadius.sm)
                radiusDemo("md", LTRadius.md)
                radiusDemo("lg", LTRadius.lg)
                radiusDemo("xl", LTRadius.xl)
            }
            
            RoundedRectangle(cornerRadius: LTRadius.full)
                .fill(Color.emerald500)
                .frame(width: 120, height: 40)
                .overlay(
                    Text("full (pill)")
                        .font(.ltSmall)
                        .foregroundColor(.white)
                )
        }
        .padding()
    }
}

private func spacingRow(_ name: String, _ value: CGFloat) -> some View {
    HStack {
        Text("\(name) (\(Int(value))pt)")
            .font(.ltCaption)
            .frame(width: 80, alignment: .leading)
        
        Rectangle()
            .fill(Color.emerald500)
            .frame(width: value * 4, height: 20)
    }
}

private func radiusDemo(_ name: String, _ radius: CGFloat) -> some View {
    VStack(spacing: 4) {
        RoundedRectangle(cornerRadius: radius)
            .fill(Color.emerald500)
            .frame(width: 50, height: 50)
        Text(name)
            .font(.ltSmall)
    }
}
