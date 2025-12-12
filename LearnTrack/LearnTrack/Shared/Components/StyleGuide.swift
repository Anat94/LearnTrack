//
//  StyleGuide.swift
//  LearnTrack
//
//  Palette et styles visuels personnalisés pour un look plus affirmé.
//

import SwiftUI

struct BrandBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.06, green: 0.08, blue: 0.16),
                    Color(red: 0.07, green: 0.11, blue: 0.24),
                    Color(red: 0.10, green: 0.17, blue: 0.32)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Halo coloré dans les coins pour casser la symétrie classique.
            RadialGradient(
                colors: [
                    Color(red: 0.64, green: 0.80, blue: 1.0).opacity(0.6),
                    .clear
                ],
                center: .topLeading,
                startRadius: 20,
                endRadius: 420
            )
            
            RadialGradient(
                colors: [
                    Color(red: 0.78, green: 0.52, blue: 1.0).opacity(0.5),
                    .clear
                ],
                center: .bottomTrailing,
                startRadius: 10,
                endRadius: 360
            )
        }
        .ignoresSafeArea()
    }
}

private struct GlassCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.08),
                        Color.white.opacity(0.04)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(Color.white.opacity(0.12), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .shadow(color: Color.black.opacity(0.32), radius: 20, x: 0, y: 12)
    }
}

extension View {
    func glassCard() -> some View {
        modifier(GlassCardModifier())
    }
    
    func neonBordered(radius: CGFloat = 14) -> some View {
        overlay(
            RoundedRectangle(cornerRadius: radius, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [Color.brandCyan.opacity(0.9), Color.brandPink.opacity(0.9)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.1
                )
        )
    }
}

extension Color {
    static let brandCyan = Color(red: 0.23, green: 0.82, blue: 0.99)
    static let brandPink = Color(red: 0.93, green: 0.53, blue: 0.98)
    static let brandIndigo = Color(red: 0.37, green: 0.47, blue: 0.97)
    static let brandMidnight = Color(red: 0.07, green: 0.09, blue: 0.15)
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: [.brandCyan, .brandIndigo, .brandPink],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(14)
            .shadow(color: Color.brandCyan.opacity(0.35), radius: 14, x: 0, y: 8)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
    }
}

