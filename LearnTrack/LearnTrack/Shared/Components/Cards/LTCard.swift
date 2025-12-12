//
//  LTCard.swift
//  LearnTrack
//
//  Composant carte custom - Design Emerald
//

import SwiftUI

// MARK: - Card Variants
enum LTCardVariant {
    case `default`
    case outlined
    case elevated
    case interactive
    case accent
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
            .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: shadowY)
            .scaleEffect(isPressed && action != nil ? 0.98 : 1.0)
            .animation(.ltSpringSubtle, value: isPressed)
    }
    
    private var backgroundColor: Color {
        variant == .outlined ? .clear : (isPressed ? .ltCardHover : .ltCard)
    }
    
    @ViewBuilder
    private var borderOverlay: some View {
        switch variant {
        case .outlined:
            RoundedRectangle(cornerRadius: cornerRadius).stroke(Color.ltBorder, lineWidth: 1)
        case .accent:
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(LinearGradient.emeraldGradient, lineWidth: 2)
        case .interactive:
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(isPressed ? Color.emerald500 : Color.ltBorderSubtle, lineWidth: isPressed ? 2 : 1)
        default:
            EmptyView()
        }
    }
    
    private var shadowColor: Color {
        switch variant {
        case .default, .interactive: return .black.opacity(0.08)
        case .elevated: return .black.opacity(0.12)
        case .accent: return .emerald500.opacity(0.15)
        case .outlined: return .clear
        }
    }
    
    private var shadowRadius: CGFloat {
        switch variant {
        case .default, .interactive: return 8
        case .elevated: return 16
        case .accent: return 12
        case .outlined: return 0
        }
    }
    
    private var shadowY: CGFloat {
        switch variant {
        case .default, .interactive: return 4
        case .elevated: return 8
        case .accent: return 6
        case .outlined: return 0
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

// MARK: - Person Card
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
}

#Preview {
    VStack(spacing: 16) {
        LTCard { Text("Default Card").font(.ltH4) }
        LTCard(variant: .outlined) { Text("Outlined").font(.ltH4) }
        LTCard(variant: .elevated) { Text("Elevated").font(.ltH4) }
        LTCard(variant: .accent) { Text("Accent").font(.ltH4) }
    }
    .padding()
    .background(Color.ltBackground)
}
