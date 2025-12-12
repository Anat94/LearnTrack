//
//  LTCard.swift
//  LearnTrack
//
//  Cartes avec effets visuels - Design Premium
//

import SwiftUI

// MARK: - Card Variants
enum LTCardVariant {
    case `default`
    case outlined
    case elevated
    case accent
    case glass
}

// MARK: - LTCard View (Static)
struct LTCard<Content: View>: View {
    let variant: LTCardVariant
    let padding: CGFloat
    let cornerRadius: CGFloat
    @ViewBuilder let content: Content
    
    init(
        variant: LTCardVariant = .default,
        padding: CGFloat = LTSpacing.lg,
        cornerRadius: CGFloat = LTRadius.xl,
        @ViewBuilder content: () -> Content
    ) {
        self.variant = variant
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(borderOverlay)
            .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: shadowY)
    }
    
    // MARK: - Background
    @ViewBuilder
    private var cardBackground: some View {
        switch variant {
        case .glass:
            ZStack {
                Color.slate800.opacity(0.5)
                Rectangle().fill(.ultraThinMaterial)
            }
        case .outlined:
            Color.clear
        default:
            Color.ltCard
        }
    }
    
    // MARK: - Border
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
        case .glass:
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(
                    LinearGradient(
                        colors: [.white.opacity(0.2), .white.opacity(0.05)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        default:
            EmptyView()
        }
    }
    
    // MARK: - Shadow
    private var shadowColor: Color {
        switch variant {
        case .elevated: return .black.opacity(0.15)
        case .accent: return .emerald500.opacity(0.2)
        case .glass: return .black.opacity(0.2)
        default: return .black.opacity(0.08)
        }
    }
    
    private var shadowRadius: CGFloat {
        switch variant {
        case .elevated: return 20
        case .accent: return 16
        case .glass: return 24
        default: return 8
        }
    }
    
    private var shadowY: CGFloat {
        switch variant {
        case .elevated: return 10
        case .accent: return 8
        case .glass: return 12
        default: return 4
        }
    }
}

// MARK: - List Card Style (For NavigationLink)
struct LTListCardStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(LTSpacing.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(configuration.isPressed ? Color.ltCardHover : Color.ltCard)
            .clipShape(RoundedRectangle(cornerRadius: LTRadius.xl))
            .overlay(
                RoundedRectangle(cornerRadius: LTRadius.xl)
                    .stroke(
                        configuration.isPressed ? Color.emerald500.opacity(0.4) : Color.ltBorderSubtle,
                        lineWidth: 1
                    )
            )
            .shadow(
                color: configuration.isPressed ? .emerald500.opacity(0.1) : .black.opacity(0.08),
                radius: configuration.isPressed ? 12 : 8,
                y: configuration.isPressed ? 2 : 4
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

extension View {
    func ltListCardStyle() -> some View {
        self.buttonStyle(LTListCardStyle())
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

// MARK: - Person Card Content (For use inside NavigationLink)
struct LTPersonCardContent: View {
    let name: String
    let subtitle: String
    let initials: String
    let badge: String?
    let badgeColor: Color
    
    init(
        name: String,
        subtitle: String,
        initials: String,
        badge: String? = nil,
        badgeColor: Color = .emerald500
    ) {
        self.name = name
        self.subtitle = subtitle
        self.initials = initials
        self.badge = badge
        self.badgeColor = badgeColor
    }
    
    var body: some View {
        HStack(spacing: LTSpacing.md) {
            LTAvatar(initials: initials, size: .medium, color: badgeColor)
            
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
            
            Image(systemName: "chevron.right")
                .font(.system(size: LTIconSize.sm, weight: .semibold))
                .foregroundColor(.ltTextTertiary)
        }
    }
}

// MARK: - Session Card Content
struct LTSessionCardContent: View {
    let title: String
    let date: String
    let time: String
    let formateur: String?
    let client: String?
    let isPresentiel: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: LTSpacing.md) {
            HStack(alignment: .top) {
                Text(title)
                    .font(.ltH4)
                    .foregroundColor(.ltText)
                    .lineLimit(2)
                
                Spacer()
                
                LTModaliteBadge(isPresentiel: isPresentiel)
            }
            
            HStack(spacing: LTSpacing.lg) {
                LTIconLabel(icon: "calendar", text: date)
                LTIconLabel(icon: "clock", text: time)
            }
            
            if let formateur = formateur {
                LTIconLabel(icon: "person.fill", text: formateur)
            }
            
            if let client = client {
                LTIconLabel(icon: "building.2.fill", text: client, color: .ltTextTertiary)
            }
        }
    }
}

// MARK: - Ecole Card Content
struct LTEcoleCardContent: View {
    let name: String
    let ville: String?
    
    var body: some View {
        HStack(spacing: LTSpacing.md) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.emerald500.opacity(0.2), .emerald600.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: LTHeight.avatarMedium, height: LTHeight.avatarMedium)
                
                Image(systemName: "graduationcap.fill")
                    .font(.system(size: LTIconSize.lg))
                    .foregroundColor(.emerald500)
            }
            
            VStack(alignment: .leading, spacing: LTSpacing.xs) {
                Text(name)
                    .font(.ltBodySemibold)
                    .foregroundColor(.ltText)
                
                if let ville = ville, !ville.isEmpty {
                    Text(ville)
                        .font(.ltCaption)
                        .foregroundColor(.ltTextSecondary)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: LTIconSize.sm, weight: .semibold))
                .foregroundColor(.ltTextTertiary)
        }
    }
}

// MARK: - Preview
#Preview {
    ScrollView {
        VStack(spacing: 16) {
            LTCard { Text("Default Card").font(.ltH4).foregroundColor(.ltText) }
            LTCard(variant: .glass) { Text("Glass Card").font(.ltH4).foregroundColor(.ltText) }
            LTCard(variant: .accent) { Text("Accent Card").font(.ltH4).foregroundColor(.ltText) }
            
            NavigationLink(destination: Text("Detail")) {
                LTPersonCardContent(
                    name: "Jean Dupont",
                    subtitle: "Formateur Swift",
                    initials: "JD",
                    badge: "Externe",
                    badgeColor: .warning
                )
            }
            .ltListCardStyle()
        }
        .padding()
    }
    .background(Color.ltBackground)
    .preferredColorScheme(.dark)
}
