//
//  StyleGuide.swift
//  LearnTrack
//
//  Système de design inspiré de Winamax - Dark/Light mode distincts
//

import SwiftUI

// MARK: - Environment pour le thème
class ThemeManager: ObservableObject {
    @Published var isDarkMode: Bool = false
    
    var currentTheme: AppTheme {
        isDarkMode ? .dark : .light
    }
}

enum AppTheme {
    case light
    case dark
    
    // MARK: - Couleurs Winamax
    var primaryGreen: Color {
        switch self {
        case .light: return Color(red: 0.0, green: 0.85, blue: 0.65) // #00D9A5
        case .dark: return Color(red: 0.0, green: 0.95, blue: 0.75) // Plus lumineux en dark
        }
    }
    
    var accentOrange: Color {
        switch self {
        case .light: return Color(red: 1.0, green: 0.4, blue: 0.0) // #FF6600
        case .dark: return Color(red: 1.0, green: 0.5, blue: 0.1)
        }
    }
    
    var background: Color {
        switch self {
        case .light: return Color(red: 0.98, green: 0.98, blue: 0.99) // Presque blanc
        case .dark: return Color(red: 0.03, green: 0.03, blue: 0.06) // Noir très profond avec teinte bleue
        }
    }
    
    var cardBackground: Color {
        switch self {
        case .light: return .white
        case .dark: return Color(red: 0.1, green: 0.1, blue: 0.14) // Plus sombre avec teinte bleue
        }
    }
    
    var textPrimary: Color {
        switch self {
        case .light: return Color(red: 0.1, green: 0.1, blue: 0.15)
        case .dark: return .white
        }
    }
    
    var textSecondary: Color {
        switch self {
        case .light: return Color(red: 0.4, green: 0.4, blue: 0.45)
        case .dark: return Color(red: 0.7, green: 0.7, blue: 0.75)
        }
    }
    
    var borderColor: Color {
        switch self {
        case .light: return Color(red: 0.9, green: 0.9, blue: 0.92)
        case .dark: return Color(red: 0.25, green: 0.25, blue: 0.3)
        }
    }
    
    var shadowColor: Color {
        switch self {
        case .light: return Color.black.opacity(0.08)
        case .dark: return Color.black.opacity(0.4)
        }
    }
}

// MARK: - Background Winamax
struct WinamaxBackground: View {
    @Environment(\.colorScheme) var colorScheme
    var theme: AppTheme {
        colorScheme == .dark ? .dark : .light
    }
    
    var body: some View {
        ZStack {
            // Fond de base
            theme.background
                .ignoresSafeArea()
            
            // Motifs géométriques subtils (light mode)
            if theme == .light {
                GeometryReader { geo in
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [theme.primaryGreen.opacity(0.15), .clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: geo.size.width * 1.2, height: geo.size.width * 1.2)
                        .offset(x: -geo.size.width * 0.3, y: -geo.size.width * 0.2)
                    
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [theme.accentOrange.opacity(0.1), .clear],
                                startPoint: .bottomTrailing,
                                endPoint: .topLeading
                            )
                        )
                        .frame(width: geo.size.width * 0.8, height: geo.size.width * 0.8)
                        .offset(x: geo.size.width * 0.5, y: geo.size.height * 0.7)
                }
            } else {
                // Effets lumineux en dark mode - Plus dynamiques et colorés
                GeometryReader { geo in
                    // Gradient vert cyan en haut à gauche
                    RadialGradient(
                        colors: [
                            theme.primaryGreen.opacity(0.25),
                            theme.primaryGreen.opacity(0.1),
                            .clear
                        ],
                        center: .topLeading,
                        startRadius: 20,
                        endRadius: 500
                    )
                    
                    // Gradient orange en bas à droite
                    RadialGradient(
                        colors: [
                            theme.accentOrange.opacity(0.2),
                            theme.accentOrange.opacity(0.08),
                            .clear
                        ],
                        center: .bottomTrailing,
                        startRadius: 30,
                        endRadius: 450
                    )
                    
                    // Gradient bleu/violet subtil au centre
                    RadialGradient(
                        colors: [
                            Color(red: 0.3, green: 0.4, blue: 0.9).opacity(0.15),
                            .clear
                        ],
                        center: .center,
                        startRadius: 100,
                        endRadius: 600
                    )
                    
                    // Motifs géométriques subtils
                    ForEach(0..<3) { i in
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        theme.primaryGreen.opacity(0.08),
                                        .clear
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: CGFloat(200 + i * 150), height: CGFloat(200 + i * 150))
                            .offset(
                                x: geo.size.width * (0.2 + CGFloat(i) * 0.3),
                                y: geo.size.height * (0.1 + CGFloat(i) * 0.2)
                            )
                            .blur(radius: 30)
                    }
                }
            }
        }
    }
}

// MARK: - Carte Winamax
struct WinamaxCard<Content: View>: View {
    @Environment(\.colorScheme) var colorScheme
    let content: Content
    var padding: CGFloat = 16
    var cornerRadius: CGFloat = 16
    
    init(padding: CGFloat = 16, cornerRadius: CGFloat = 16, @ViewBuilder content: () -> Content) {
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.content = content()
    }
    
    var theme: AppTheme {
        colorScheme == .dark ? .dark : .light
    }
    
    var body: some View {
        content
            .padding(padding)
            .background(theme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(theme.borderColor, lineWidth: 1)
            )
            .shadow(
                color: theme.shadowColor,
                radius: colorScheme == .dark ? 20 : 12,
                x: 0,
                y: colorScheme == .dark ? 8 : 4
            )
    }
}

// MARK: - Bouton Primary Winamax
struct WinamaxPrimaryButton: ButtonStyle {
    @Environment(\.colorScheme) var colorScheme
    
    var theme: AppTheme {
        colorScheme == .dark ? .dark : .light
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: [theme.primaryGreen, theme.primaryGreen.opacity(0.85)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .shadow(
                color: theme.primaryGreen.opacity(0.4),
                radius: configuration.isPressed ? 8 : 16,
                x: 0,
                y: configuration.isPressed ? 4 : 8
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

// MARK: - Bouton Secondary
struct WinamaxSecondaryButton: ButtonStyle {
    @Environment(\.colorScheme) var colorScheme
    
    var theme: AppTheme {
        colorScheme == .dark ? .dark : .light
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .semibold, design: .rounded))
            .foregroundColor(theme.textPrimary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(theme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(theme.borderColor, lineWidth: 2)
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

// MARK: - Bouton Danger
struct WinamaxDangerButton: ButtonStyle {
    @Environment(\.colorScheme) var colorScheme
    
    var theme: AppTheme {
        colorScheme == .dark ? .dark : .light
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: [Color.red, Color.red.opacity(0.85)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .shadow(
                color: Color.red.opacity(0.3),
                radius: configuration.isPressed ? 8 : 16,
                x: 0,
                y: configuration.isPressed ? 4 : 8
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

// MARK: - Badge Winamax
struct WinamaxBadge: View {
    @Environment(\.colorScheme) var colorScheme
    let text: String
    var color: Color? = nil
    
    var theme: AppTheme {
        colorScheme == .dark ? .dark : .light
    }
    
    var badgeColor: Color {
        color ?? theme.primaryGreen
    }
    
    var body: some View {
        Text(text)
            .font(.system(size: 12, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                LinearGradient(
                    colors: [badgeColor, badgeColor.opacity(0.8)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(Capsule(style: .continuous))
            .shadow(color: badgeColor.opacity(0.3), radius: 6, y: 3)
    }
}

// MARK: - Champ de texte Winamax
struct WinamaxTextField: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    var theme: AppTheme {
        colorScheme == .dark ? .dark : .light
    }
    
    func body(content: Content) -> some View {
        content
            .padding(14)
            .background(theme.cardBackground)
            .foregroundColor(theme.textPrimary)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(theme.borderColor, lineWidth: 1.5)
            )
    }
}

extension View {
    func winamaxTextField() -> some View {
        modifier(WinamaxTextField())
    }
}

// MARK: - Extension pour accès facile au thème
extension View {
    @ViewBuilder
    func winamaxCard(padding: CGFloat = 16, cornerRadius: CGFloat = 16) -> some View {
        WinamaxCard(padding: padding, cornerRadius: cornerRadius) {
            self
        }
    }
}

// MARK: - Typographie Winamax
extension Font {
    static func winamaxTitle() -> Font {
        .system(size: 28, weight: .bold, design: .rounded)
    }
    
    static func winamaxHeadline() -> Font {
        .system(size: 18, weight: .bold, design: .rounded)
    }
    
    static func winamaxBody() -> Font {
        .system(size: 16, weight: .medium, design: .rounded)
    }
    
    static func winamaxCaption() -> Font {
        .system(size: 14, weight: .medium, design: .rounded)
    }
}
