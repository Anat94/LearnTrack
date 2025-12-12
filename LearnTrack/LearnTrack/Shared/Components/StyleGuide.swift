//
//  StyleGuide.swift
//  LearnTrack
//
//  Système de design moderne inspiré de Winamax - Design premium
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
    
    // MARK: - Couleurs Winamax améliorées
    var primaryGreen: Color {
        switch self {
        case .light: return Color(red: 0.0, green: 0.85, blue: 0.65) // #00D9A5
        case .dark: return Color(red: 0.0, green: 0.98, blue: 0.78) // Plus lumineux et vibrant
        }
    }
    
    var accentOrange: Color {
        switch self {
        case .light: return Color(red: 1.0, green: 0.4, blue: 0.0) // #FF6600
        case .dark: return Color(red: 1.0, green: 0.55, blue: 0.15) // Plus chaud
        }
    }
    
    var background: Color {
        switch self {
        case .light: return Color(red: 0.98, green: 0.98, blue: 0.99)
        case .dark: return Color(red: 0.02, green: 0.02, blue: 0.05) // Encore plus profond
        }
    }
    
    var cardBackground: Color {
        switch self {
        case .light: return .white
        case .dark: return Color(red: 0.08, green: 0.08, blue: 0.12) // Plus sombre avec teinte bleue
        }
    }
    
    var textPrimary: Color {
        switch self {
        case .light: return Color(red: 0.08, green: 0.08, blue: 0.12)
        case .dark: return Color(red: 0.98, green: 0.98, blue: 0.99)
        }
    }
    
    var textSecondary: Color {
        switch self {
        case .light: return Color(red: 0.45, green: 0.45, blue: 0.5)
        case .dark: return Color(red: 0.65, green: 0.65, blue: 0.7)
        }
    }
    
    var borderColor: Color {
        switch self {
        case .light: return Color(red: 0.92, green: 0.92, blue: 0.94)
        case .dark: return Color(red: 0.2, green: 0.2, blue: 0.25)
        }
    }
    
    var shadowColor: Color {
        switch self {
        case .light: return Color.black.opacity(0.06)
        case .dark: return Color.black.opacity(0.5)
        }
    }
    
    var glassBackground: Color {
        switch self {
        case .light: return Color.white.opacity(0.7)
        case .dark: return Color(red: 0.12, green: 0.12, blue: 0.16).opacity(0.8)
        }
    }
}

// MARK: - Background Winamax amélioré
struct WinamaxBackground: View {
    @Environment(\.colorScheme) var colorScheme
    var theme: AppTheme {
        colorScheme == .dark ? .dark : .light
    }
    
    var body: some View {
        ZStack {
            // Fond de base avec gradient subtil
            LinearGradient(
                colors: theme == .light ?
                    [theme.background, Color(red: 0.96, green: 0.97, blue: 0.98)] :
                    [theme.background, Color(red: 0.04, green: 0.04, blue: 0.08)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Motifs géométriques améliorés (light mode)
            if theme == .light {
                GeometryReader { geo in
                    // Grand cercle vert avec blur
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    theme.primaryGreen.opacity(0.12),
                                    theme.primaryGreen.opacity(0.05),
                                    .clear
                                ],
                                center: .center,
                                startRadius: 50,
                                endRadius: 400
                            )
                        )
                        .frame(width: geo.size.width * 1.4, height: geo.size.width * 1.4)
                        .offset(x: -geo.size.width * 0.3, y: -geo.size.width * 0.2)
                        .blur(radius: 60)
                    
                    // Cercle orange
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    theme.accentOrange.opacity(0.08),
                                    theme.accentOrange.opacity(0.03),
                                    .clear
                                ],
                                center: .center,
                                startRadius: 40,
                                endRadius: 350
                            )
                        )
                        .frame(width: geo.size.width * 0.9, height: geo.size.width * 0.9)
                        .offset(x: geo.size.width * 0.5, y: geo.size.height * 0.7)
                        .blur(radius: 50)
                }
            } else {
                // Effets lumineux améliorés en dark mode
                GeometryReader { geo in
                    // Gradient vert cyan avec animation subtile
                    RadialGradient(
                        colors: [
                            theme.primaryGreen.opacity(0.3),
                            theme.primaryGreen.opacity(0.15),
                            theme.primaryGreen.opacity(0.05),
                            .clear
                        ],
                        center: .topLeading,
                        startRadius: 30,
                        endRadius: 600
                    )
                    .blur(radius: 40)
                    
                    // Gradient orange
                    RadialGradient(
                        colors: [
                            theme.accentOrange.opacity(0.25),
                            theme.accentOrange.opacity(0.12),
                            theme.accentOrange.opacity(0.05),
                            .clear
                        ],
                        center: .bottomTrailing,
                        startRadius: 40,
                        endRadius: 550
                    )
                    .blur(radius: 35)
                    
                    // Gradient bleu/violet plus prononcé
                    RadialGradient(
                        colors: [
                            Color(red: 0.35, green: 0.45, blue: 0.95).opacity(0.2),
                            Color(red: 0.3, green: 0.4, blue: 0.9).opacity(0.1),
                            .clear
                        ],
                        center: .center,
                        startRadius: 150,
                        endRadius: 700
                    )
                    .blur(radius: 50)
                    
                    // Motifs géométriques animés
                    ForEach(0..<4) { i in
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        theme.primaryGreen.opacity(0.1 - Double(i) * 0.02),
                                        .clear
                                    ],
                                    center: .center,
                                    startRadius: 20,
                                    endRadius: 200
                                )
                            )
                            .frame(width: CGFloat(180 + i * 120), height: CGFloat(180 + i * 120))
                            .offset(
                                x: geo.size.width * (0.15 + CGFloat(i) * 0.25),
                                y: geo.size.height * (0.08 + CGFloat(i) * 0.18)
                            )
                            .blur(radius: 40 + CGFloat(i) * 10)
                    }
                }
            }
        }
    }
}

// MARK: - Carte Winamax avec glassmorphism
struct WinamaxCard<Content: View>: View {
    @Environment(\.colorScheme) var colorScheme
    let content: Content
    var padding: CGFloat = 20
    var cornerRadius: CGFloat = 20
    var hasGlow: Bool = false
    var glowColor: Color? = nil
    
    init(
        padding: CGFloat = 20,
        cornerRadius: CGFloat = 20,
        hasGlow: Bool = false,
        glowColor: Color? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.hasGlow = hasGlow
        self.glowColor = glowColor
        self.content = content()
    }
    
    var theme: AppTheme {
        colorScheme == .dark ? .dark : .light
    }
    
    var body: some View {
        content
            .padding(padding)
            .background(
                ZStack {
                    // Fond principal
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(theme.cardBackground)
                    
                    // Effet glassmorphism en dark mode
                    if colorScheme == .dark {
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        theme.glassBackground,
                                        theme.cardBackground.opacity(0.6)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [
                                theme.borderColor.opacity(0.8),
                                theme.borderColor.opacity(0.4)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
            )
            .shadow(
                color: hasGlow ? (glowColor ?? theme.primaryGreen).opacity(0.3) : theme.shadowColor,
                radius: colorScheme == .dark ? 25 : 15,
                x: 0,
                y: colorScheme == .dark ? 10 : 5
            )
            .shadow(
                color: theme.shadowColor,
                radius: colorScheme == .dark ? 15 : 8,
                x: 0,
                y: colorScheme == .dark ? 5 : 2
            )
    }
}

// MARK: - Bouton Primary amélioré
struct WinamaxPrimaryButton: ButtonStyle {
    @Environment(\.colorScheme) var colorScheme
    
    var theme: AppTheme {
        colorScheme == .dark ? .dark : .light
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 17, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(
                ZStack {
                    // Gradient principal
                    LinearGradient(
                        colors: [
                            theme.primaryGreen,
                            theme.primaryGreen.opacity(0.9),
                            theme.primaryGreen.opacity(0.85)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    
                    // Overlay pour effet de profondeur
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.2),
                            .clear
                        ],
                        startPoint: .top,
                        endPoint: .center
                    )
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.3),
                                Color.white.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(
                color: theme.primaryGreen.opacity(0.5),
                radius: configuration.isPressed ? 12 : 20,
                x: 0,
                y: configuration.isPressed ? 6 : 10
            )
            .shadow(
                color: theme.primaryGreen.opacity(0.3),
                radius: configuration.isPressed ? 6 : 12,
                x: 0,
                y: configuration.isPressed ? 3 : 5
            )
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .brightness(configuration.isPressed ? -0.05 : 0)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

// MARK: - Bouton Secondary amélioré
struct WinamaxSecondaryButton: ButtonStyle {
    @Environment(\.colorScheme) var colorScheme
    
    var theme: AppTheme {
        colorScheme == .dark ? .dark : .light
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 17, weight: .semibold, design: .rounded))
            .foregroundColor(theme.textPrimary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                ZStack {
                    theme.cardBackground
                    
                    if colorScheme == .dark {
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.05),
                                .clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    }
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [
                                theme.borderColor,
                                theme.borderColor.opacity(0.6)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
            )
            .shadow(
                color: theme.shadowColor,
                radius: configuration.isPressed ? 4 : 10,
                x: 0,
                y: configuration.isPressed ? 2 : 5
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .brightness(configuration.isPressed ? -0.03 : 0)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

// MARK: - Bouton Danger amélioré
struct WinamaxDangerButton: ButtonStyle {
    @Environment(\.colorScheme) var colorScheme
    
    var theme: AppTheme {
        colorScheme == .dark ? .dark : .light
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 17, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(
                ZStack {
                    LinearGradient(
                        colors: [
                            Color(red: 1.0, green: 0.25, blue: 0.25),
                            Color(red: 0.9, green: 0.2, blue: 0.2),
                            Color(red: 0.85, green: 0.15, blue: 0.15)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.2),
                            .clear
                        ],
                        startPoint: .top,
                        endPoint: .center
                    )
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.3),
                                Color.white.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(
                color: Color.red.opacity(0.4),
                radius: configuration.isPressed ? 12 : 20,
                x: 0,
                y: configuration.isPressed ? 6 : 10
            )
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .brightness(configuration.isPressed ? -0.05 : 0)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

// MARK: - Badge Winamax amélioré
struct WinamaxBadge: View {
    @Environment(\.colorScheme) var colorScheme
    let text: String
    var color: Color? = nil
    var size: BadgeSize = .medium
    
    enum BadgeSize {
        case small, medium, large
        
        var fontSize: CGFloat {
            switch self {
            case .small: return 11
            case .medium: return 12
            case .large: return 14
            }
        }
        
        var horizontalPadding: CGFloat {
            switch self {
            case .small: return 10
            case .medium: return 12
            case .large: return 16
            }
        }
        
        var verticalPadding: CGFloat {
            switch self {
            case .small: return 5
            case .medium: return 6
            case .large: return 8
            }
        }
    }
    
    var theme: AppTheme {
        colorScheme == .dark ? .dark : .light
    }
    
    var badgeColor: Color {
        color ?? theme.primaryGreen
    }
    
    var body: some View {
        Text(text)
            .font(.system(size: size.fontSize, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            .padding(.horizontal, size.horizontalPadding)
            .padding(.vertical, size.verticalPadding)
            .background(
                ZStack {
                    LinearGradient(
                        colors: [
                            badgeColor,
                            badgeColor.opacity(0.85),
                            badgeColor.opacity(0.75)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.25),
                            .clear
                        ],
                        startPoint: .top,
                        endPoint: .center
                    )
                }
            )
            .clipShape(Capsule(style: .continuous))
            .overlay(
                Capsule(style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.4),
                                Color.white.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: badgeColor.opacity(0.4), radius: 8, y: 4)
            .shadow(color: badgeColor.opacity(0.2), radius: 4, y: 2)
    }
}

// MARK: - Champ de texte Winamax amélioré
struct WinamaxTextField: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    @FocusState private var isFocused: Bool
    
    var theme: AppTheme {
        colorScheme == .dark ? .dark : .light
    }
    
    func body(content: Content) -> some View {
        content
            .padding(16)
            .background(
                ZStack {
                    theme.cardBackground
                    
                    if colorScheme == .dark {
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.03),
                                .clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    }
                }
            )
            .foregroundColor(theme.textPrimary)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [
                                theme.borderColor,
                                theme.borderColor.opacity(0.7)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
            )
            .shadow(color: theme.shadowColor.opacity(0.5), radius: 4, y: 2)
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
    func winamaxCard(
        padding: CGFloat = 20,
        cornerRadius: CGFloat = 20,
        hasGlow: Bool = false,
        glowColor: Color? = nil
    ) -> some View {
        WinamaxCard(
            padding: padding,
            cornerRadius: cornerRadius,
            hasGlow: hasGlow,
            glowColor: glowColor
        ) {
            self
        }
    }
}

// MARK: - Typographie Winamax améliorée
extension Font {
    static func winamaxTitle() -> Font {
        .system(size: 32, weight: .bold, design: .rounded)
    }
    
    static func winamaxHeadline() -> Font {
        .system(size: 20, weight: .bold, design: .rounded)
    }
    
    static func winamaxBody() -> Font {
        .system(size: 17, weight: .medium, design: .rounded)
    }
    
    static func winamaxCaption() -> Font {
        .system(size: 15, weight: .medium, design: .rounded)
    }
    
    static func winamaxLargeTitle() -> Font {
        .system(size: 40, weight: .bold, design: .rounded)
    }
}
