//
//  LTCard.swift
//  LearnTrack
//
//  Composant carte custom avec ombres et bordures
//

import SwiftUI

// MARK: - Card Variants
enum LTCardVariant {
    case `default`      // White/Dark background with shadow
    case outlined       // Border only, no shadow
    case elevated       // More pronounced shadow
    case interactive    // With hover/press effects
    case accent         // Emerald accent border
}

// MARK: - LTCard View
struct LTCard<Content: View>: View {
    let variant: LTCardVariant
    let padding: CGFloat
    let cornerRadius: CGFloat
    let action: (() -> Void)?
    @ViewBuilder let content: Content
    
    init(
        variant: LTCardVariant = .default,
        padding: CGFloat = LTSpacing.lg,
        cornerRadius: CGFloat = LTRadius.xl,
        action: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.variant = variant
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.action = action
        self.content = content()
    }
    
    @State private var isPressed = false
    @State private var isHovered = false
    
    var body: some View {
        Group {
            if let action = action {
                Button(action: {
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                    action()
                }) {
                    cardContent
                }
                .buttonStyle(PlainButtonStyle())
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in isPressed = true }
                        .onEnded { _ in isPressed = false }
                )
            } else {
                cardContent
            }
        }
    }
    
    private var cardContent: some View {
        content
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(borderOverlay)
            .modifier(ShadowModifier(variant: variant))
            .scaleEffect(isPressed && action != nil ? 0.98 : 1.0)
            .animation(.ltSpringSubtle, value: isPressed)
    }
    
    private var backgroundColor: Color {
        switch variant {
        case .outlined:
            return Color.clear
        default:
            return isPressed ? .ltCardHover : .ltCard
        }
    }
    
    @ViewBuilder
    private var borderOverlay: some View {
        switch variant {
        case .outlined:
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(Color.ltBorder, lineWidth: 1)
        case .accent:
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(
                    LinearGradient(
                        colors: [.emerald400, .emerald600],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
        case .interactive:
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(
                    isPressed ? Color.emerald500 : Color.ltBorderSubtle,
                    lineWidth: isPressed ? 2 : 1
                )
        default:
            EmptyView()
        }
    }
    
    private struct ShadowModifier: ViewModifier {
        let variant: LTCardVariant
        
        @ViewBuilder
        func body(content: Content) -> some View {
            switch variant {
            case .default:
                content.ltCardShadow()
            case .elevated:
                content.ltElevatedShadow()
            case .outlined:
                content
            case .interactive:
                content.ltCardShadow()
            case .accent:
                content.ltShadow(.glowSubtle)
            }
        }
    }
}

// MARK: - Session Card (Specialized)
struct LTSessionCard: View {
    let title: String
    let date: String
    let time: String
    let location: String
    let badge: String
    let badgeType: BadgeType
    let formateur: String?
    let action: () -> Void
    
    enum BadgeType {
        case presentiel
        case distanciel
        
        var color: Color {
            switch self {
            case .presentiel: return .emerald500
            case .distanciel: return .info
            }
        }
        
        var icon: String {
            switch self {
            case .presentiel: return "person.2.fill"
            case .distanciel: return "video.fill"
            }
        }
    }
    
    var body: some View {
        LTCard(variant: .interactive, action: action) {
            VStack(alignment: .leading, spacing: LTSpacing.md) {
                // Header avec titre et badge
                HStack(alignment: .top) {
                    Text(title)
                        .font(.ltH4)
                        .foregroundColor(.ltText)
                        .lineLimit(2)
                    
                    Spacer()
                    
                    LTBadge(
                        text: badge,
                        icon: badgeType.icon,
                        color: badgeType.color
                    )
                }
                
                // Date et heure
                HStack(spacing: LTSpacing.lg) {
                    LTIconLabel(icon: "calendar", text: date)
                    LTIconLabel(icon: "clock", text: time)
                }
                
                // Formateur (si présent)
                if let formateur = formateur {
                    LTIconLabel(icon: "person.fill", text: formateur)
                }
                
                // Lieu (si présentiel)
                if badgeType == .presentiel {
                    LTIconLabel(icon: "mappin.circle.fill", text: location)
                        .foregroundColor(.ltTextTertiary)
                }
            }
        }
    }
}

// MARK: - Person Card (Formateur/Client)
struct LTPersonCard: View {
    let name: String
    let subtitle: String
    let initials: String
    let badge: String?
    let badgeColor: Color
    let action: () -> Void
    
    init(
        name: String,
        subtitle: String,
        initials: String,
        badge: String? = nil,
        badgeColor: Color = .emerald500,
        action: @escaping () -> Void
    ) {
        self.name = name
        self.subtitle = subtitle
        self.initials = initials
        self.badge = badge
        self.badgeColor = badgeColor
        self.action = action
    }
    
    var body: some View {
        LTCard(variant: .interactive, padding: LTSpacing.md, action: action) {
            HStack(spacing: LTSpacing.md) {
                // Avatar
                LTAvatar(initials: initials, size: .medium, color: badgeColor)
                
                // Info
                VStack(alignment: .leading, spacing: LTSpacing.xs) {
                    Text(name)
                        .font(.ltBodySemibold)
                        .foregroundColor(.ltText)
                    
                    Text(subtitle)
                        .font(.ltCaption)
                        .foregroundColor(.ltTextSecondary)
                    
                    if let badge = badge {
                        LTBadge(text: badge, color: badgeColor, size: .small)
                    }
                }
                
                Spacer()
                
                // Chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: LTIconSize.sm, weight: .semibold))
                    .foregroundColor(.ltTextTertiary)
            }
        }
    }
}

// MARK: - Icon Label
struct LTIconLabel: View {
    let icon: String
    let text: String
    var color: Color = .ltTextSecondary
    
    var body: some View {
        HStack(spacing: LTSpacing.xs) {
            Image(systemName: icon)
                .font(.system(size: LTIconSize.sm))
            Text(text)
                .font(.ltCaption)
        }
        .foregroundColor(color)
    }
}

// MARK: - Preview
#Preview("Cards") {
    ScrollView {
        VStack(spacing: 24) {
            Text("Card Variants")
                .font(.ltH2)
            
            LTCard {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Default Card")
                        .font(.ltH4)
                    Text("This is a default card with shadow")
                        .font(.ltBody)
                        .foregroundColor(.ltTextSecondary)
                }
            }
            
            LTCard(variant: .outlined) {
                Text("Outlined Card")
                    .font(.ltH4)
            }
            
            LTCard(variant: .elevated) {
                Text("Elevated Card")
                    .font(.ltH4)
            }
            
            LTCard(variant: .accent) {
                Text("Accent Card")
                    .font(.ltH4)
            }
            
            LTCard(variant: .interactive, action: { }) {
                Text("Interactive Card - Tap me!")
                    .font(.ltH4)
            }
            
            Divider()
            
            Text("Session Card")
                .font(.ltH2)
            
            LTSessionCard(
                title: "Swift & SwiftUI Avancé",
                date: "15 janvier 2025",
                time: "09:00 - 17:00",
                location: "Paris - WeWork La Défense",
                badge: "Présentiel",
                badgeType: .presentiel,
                formateur: "Jean Dupont",
                action: { }
            )
            
            LTSessionCard(
                title: "React Native Fondamentaux",
                date: "20 janvier 2025",
                time: "14:00 - 18:00",
                location: "En ligne",
                badge: "Distanciel",
                badgeType: .distanciel,
                formateur: "Marie Martin",
                action: { }
            )
            
            Divider()
            
            Text("Person Cards")
                .font(.ltH2)
            
            LTPersonCard(
                name: "Jean Dupont",
                subtitle: "Swift, iOS, SwiftUI",
                initials: "JD",
                badge: "Interne",
                badgeColor: .emerald500,
                action: { }
            )
            
            LTPersonCard(
                name: "Marie Martin",
                subtitle: "React, TypeScript",
                initials: "MM",
                badge: "Externe",
                badgeColor: .warning,
                action: { }
            )
        }
        .padding()
    }
    .background(Color.ltBackground)
}
