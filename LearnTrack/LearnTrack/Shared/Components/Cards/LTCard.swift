//
//  LTCard.swift
//  LearnTrack
//
//  Cartes avec effet 3D Press - Design Premium
//

import SwiftUI

// MARK: - Card Variants
enum LTCardVariant {
    case `default`
    case outlined
    case elevated
    case interactive
    case accent
    case glass
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
    @State private var pressLocation: CGPoint = .zero
    
    var body: some View {
        Group {
            if let action = action {
                Button(action: {
                    triggerHaptic()
                    action()
                }) {
                    cardContent
                }
                .buttonStyle(Card3DButtonStyle(isPressed: $isPressed, pressLocation: $pressLocation))
            } else {
                cardContent
            }
        }
    }
    
    private var cardContent: some View {
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
        case .interactive:
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(isPressed ? Color.emerald500.opacity(0.5) : Color.ltBorderSubtle, lineWidth: 1)
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
    
    private func triggerHaptic() {
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }
}

// MARK: - 3D Button Style
struct Card3DButtonStyle: ButtonStyle {
    @Binding var isPressed: Bool
    @Binding var pressLocation: CGPoint
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .rotation3DEffect(
                .degrees(configuration.isPressed ? rotationAngle.x : 0),
                axis: (x: 1, y: 0, z: 0),
                perspective: 0.5
            )
            .rotation3DEffect(
                .degrees(configuration.isPressed ? rotationAngle.y : 0),
                axis: (x: 0, y: 1, z: 0),
                perspective: 0.5
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .brightness(configuration.isPressed ? 0.02 : 0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
            .onChange(of: configuration.isPressed) { _, newValue in
                isPressed = newValue
            }
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        pressLocation = value.location
                    }
            )
    }
    
    private var rotationAngle: (x: Double, y: Double) {
        // Subtle 3D tilt based on press location
        (x: 3, y: -3)
    }
}

// MARK: - Interactive Card (Simplified)
struct LTInteractiveCard<Content: View>: View {
    let action: () -> Void
    @ViewBuilder let content: Content
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            action()
        }) {
            content
                .padding(LTSpacing.lg)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(isPressed ? Color.ltCardHover : Color.ltCard)
                .clipShape(RoundedRectangle(cornerRadius: LTRadius.xl))
                .overlay(
                    RoundedRectangle(cornerRadius: LTRadius.xl)
                        .stroke(isPressed ? Color.emerald500.opacity(0.3) : Color.ltBorderSubtle, lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
                .scaleEffect(isPressed ? 0.98 : 1.0)
                .rotation3DEffect(
                    .degrees(isPressed ? 2 : 0),
                    axis: (x: 1, y: 0, z: 0),
                    perspective: 0.5
                )
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        isPressed = false
                    }
                }
        )
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
        LTInteractiveCard(action: action) {
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
#Preview {
    ScrollView {
        VStack(spacing: 16) {
            LTCard { Text("Default Card").font(.ltH4) }
            LTCard(variant: .glass) { Text("Glass Card").font(.ltH4) }
            LTCard(variant: .accent) { Text("Accent Card").font(.ltH4) }
            
            LTInteractiveCard(action: {}) {
                Text("Interactive - Tap me!")
                    .font(.ltH4)
            }
            
            LTPersonCard(
                name: "Jean Dupont",
                subtitle: "Formateur Swift",
                initials: "JD",
                badge: "Externe",
                badgeColor: .warning,
                action: {}
            )
        }
        .padding()
    }
    .background(Color.ltBackground)
    .preferredColorScheme(.dark)
}
