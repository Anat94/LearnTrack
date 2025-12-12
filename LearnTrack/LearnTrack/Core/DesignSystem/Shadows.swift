//
//  Shadows.swift
//  LearnTrack
//
//  Design System - Système d'ombres
//

import SwiftUI

// MARK: - Shadow Definitions
struct LTShadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
    
    // MARK: Elevation Levels
    
    /// Ombre très subtile (hover state)
    static let xs = LTShadow(
        color: Color.black.opacity(0.04),
        radius: 2,
        x: 0,
        y: 1
    )
    
    /// Ombre légère (cards au repos)
    static let sm = LTShadow(
        color: Color.black.opacity(0.06),
        radius: 4,
        x: 0,
        y: 2
    )
    
    /// Ombre moyenne (cards surélevées)
    static let md = LTShadow(
        color: Color.black.opacity(0.08),
        radius: 8,
        x: 0,
        y: 4
    )
    
    /// Ombre prononcée (modals, dropdowns)
    static let lg = LTShadow(
        color: Color.black.opacity(0.10),
        radius: 16,
        x: 0,
        y: 8
    )
    
    /// Ombre forte (floating elements)
    static let xl = LTShadow(
        color: Color.black.opacity(0.12),
        radius: 24,
        x: 0,
        y: 12
    )
    
    /// Ombre maximale (popovers)
    static let xxl = LTShadow(
        color: Color.black.opacity(0.15),
        radius: 32,
        x: 0,
        y: 16
    )
    
    // MARK: Colored Shadows (Glow Effects)
    
    /// Glow emerald subtil (boutons hover)
    static let glowSubtle = LTShadow(
        color: Color.emerald500.opacity(0.25),
        radius: 8,
        x: 0,
        y: 4
    )
    
    /// Glow emerald moyen (boutons primary)
    static let glowMd = LTShadow(
        color: Color.emerald500.opacity(0.35),
        radius: 12,
        x: 0,
        y: 4
    )
    
    /// Glow emerald fort (focus, active)
    static let glowLg = LTShadow(
        color: Color.emerald500.opacity(0.45),
        radius: 20,
        x: 0,
        y: 6
    )
    
    /// Glow error
    static let glowError = LTShadow(
        color: Color.error.opacity(0.35),
        radius: 12,
        x: 0,
        y: 4
    )
    
    /// Glow warning
    static let glowWarning = LTShadow(
        color: Color.warning.opacity(0.35),
        radius: 12,
        x: 0,
        y: 4
    )
    
    // MARK: Inner Shadows
    
    static let innerSm = LTShadow(
        color: Color.black.opacity(0.06),
        radius: 2,
        x: 0,
        y: 1
    )
    
    static let innerMd = LTShadow(
        color: Color.black.opacity(0.08),
        radius: 4,
        x: 0,
        y: 2
    )
}

// MARK: - Shadow View Modifier
struct LTShadowModifier: ViewModifier {
    let shadow: LTShadow
    
    func body(content: Content) -> some View {
        content
            .shadow(
                color: shadow.color,
                radius: shadow.radius,
                x: shadow.x,
                y: shadow.y
            )
    }
}

extension View {
    /// Apply a LearnTrack shadow
    func ltShadow(_ shadow: LTShadow) -> some View {
        modifier(LTShadowModifier(shadow: shadow))
    }
    
    /// Card shadow (default)
    func ltCardShadow() -> some View {
        self
            .shadow(color: Color.black.opacity(0.04), radius: 2, x: 0, y: 1)
            .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 4)
    }
    
    /// Elevated card shadow
    func ltElevatedShadow() -> some View {
        self
            .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
            .shadow(color: Color.black.opacity(0.04), radius: 16, x: 0, y: 8)
    }
    
    /// Button glow effect
    func ltButtonGlow() -> some View {
        self.shadow(
            color: Color.emerald500.opacity(0.4),
            radius: 12,
            x: 0,
            y: 4
        )
    }
    
    /// Focus ring glow
    func ltFocusGlow() -> some View {
        self.shadow(
            color: Color.emerald500.opacity(0.5),
            radius: 0,
            x: 0,
            y: 0
        )
    }
}

// MARK: - Preview
#Preview("Shadows") {
    ScrollView {
        VStack(spacing: 32) {
            Text("Elevation Shadows")
                .font(.ltH2)
            
            HStack(spacing: 20) {
                shadowCard("xs", .xs)
                shadowCard("sm", .sm)
                shadowCard("md", .md)
            }
            
            HStack(spacing: 20) {
                shadowCard("lg", .lg)
                shadowCard("xl", .xl)
                shadowCard("xxl", .xxl)
            }
            
            Divider()
            
            Text("Glow Effects")
                .font(.ltH2)
            
            HStack(spacing: 20) {
                glowCard("Subtle", .glowSubtle)
                glowCard("Medium", .glowMd)
                glowCard("Large", .glowLg)
            }
            
            HStack(spacing: 20) {
                VStack {
                    RoundedRectangle(cornerRadius: LTRadius.lg)
                        .fill(Color.error)
                        .frame(width: 80, height: 80)
                        .ltShadow(.glowError)
                    Text("Error")
                        .font(.ltCaption)
                }
                
                VStack {
                    RoundedRectangle(cornerRadius: LTRadius.lg)
                        .fill(Color.warning)
                        .frame(width: 80, height: 80)
                        .ltShadow(.glowWarning)
                    Text("Warning")
                        .font(.ltCaption)
                }
            }
        }
        .padding(32)
    }
    .background(Color.slate100)
}

private func shadowCard(_ name: String, _ shadow: LTShadow) -> some View {
    VStack {
        RoundedRectangle(cornerRadius: LTRadius.lg)
            .fill(Color.white)
            .frame(width: 80, height: 80)
            .ltShadow(shadow)
        Text(name)
            .font(.ltCaption)
    }
}

private func glowCard(_ name: String, _ shadow: LTShadow) -> some View {
    VStack {
        RoundedRectangle(cornerRadius: LTRadius.lg)
            .fill(Color.emerald500)
            .frame(width: 80, height: 80)
            .ltShadow(shadow)
        Text(name)
            .font(.ltCaption)
    }
}
