//
//  Shadows.swift
//  LearnTrack
//
//  Design System - Système d'ombres et effets glow
//

import SwiftUI

// MARK: - Shadow Presets
struct LTShadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
    
    // Standard shadows
    static let none = LTShadow(color: .clear, radius: 0, x: 0, y: 0)
    static let sm = LTShadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    static let md = LTShadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
    static let lg = LTShadow(color: .black.opacity(0.1), radius: 16, x: 0, y: 8)
    static let xl = LTShadow(color: .black.opacity(0.12), radius: 24, x: 0, y: 12)
    
    // Card shadows
    static let card = LTShadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
    static let cardHover = LTShadow(color: .black.opacity(0.12), radius: 12, x: 0, y: 6)
    static let elevated = LTShadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
    
    // Glow effects
    static let glowSubtle = LTShadow(color: .emerald500.opacity(0.3), radius: 12, x: 0, y: 4)
    static let glowMedium = LTShadow(color: .emerald500.opacity(0.4), radius: 16, x: 0, y: 6)
    static let glowStrong = LTShadow(color: .emerald500.opacity(0.5), radius: 24, x: 0, y: 8)
    
    // Focus
    static let focus = LTShadow(color: .emerald500.opacity(0.4), radius: 8, x: 0, y: 0)
}

// MARK: - Shadow Modifier
struct LTShadowModifier: ViewModifier {
    let shadow: LTShadow
    
    func body(content: Content) -> some View {
        content.shadow(
            color: shadow.color,
            radius: shadow.radius,
            x: shadow.x,
            y: shadow.y
        )
    }
}

extension View {
    func ltShadow(_ shadow: LTShadow) -> some View {
        modifier(LTShadowModifier(shadow: shadow))
    }
    
    func ltCardShadow() -> some View {
        ltShadow(.card)
    }
    
    func ltElevatedShadow() -> some View {
        ltShadow(.elevated)
    }
    
    func ltGlow() -> some View {
        ltShadow(.glowMedium)
    }
}
