//
//  LTButton.swift
//  LearnTrack
//
//  Composant bouton custom - Zéro iOS natif
//

import SwiftUI

// MARK: - Button Variants
enum LTButtonVariant {
    case primary      // Emerald background, white text
    case secondary    // Emerald border, emerald text
    case ghost        // No background, emerald text
    case destructive  // Red background
    case subtle       // Light emerald background
}

// MARK: - Button Sizes
enum LTButtonSize {
    case small
    case medium
    case large
    case xl
    
    var height: CGFloat {
        switch self {
        case .small: return LTHeight.buttonSmall
        case .medium: return LTHeight.buttonMedium
        case .large: return LTHeight.buttonLarge
        case .xl: return LTHeight.buttonXL
        }
    }
    
    var font: Font {
        switch self {
        case .small: return .ltButtonSmall
        case .medium: return .ltButtonMedium
        case .large: return .ltButtonLarge
        case .xl: return .ltButtonLarge
        }
    }
    
    var iconSize: CGFloat {
        switch self {
        case .small: return LTIconSize.sm
        case .medium: return LTIconSize.md
        case .large: return LTIconSize.lg
        case .xl: return LTIconSize.lg
        }
    }
    
    var horizontalPadding: CGFloat {
        switch self {
        case .small: return LTSpacing.md
        case .medium: return LTSpacing.lg
        case .large: return LTSpacing.xl
        case .xl: return LTSpacing.xxl
        }
    }
    
    var cornerRadius: CGFloat {
        switch self {
        case .small: return LTRadius.md
        case .medium: return LTRadius.lg
        case .large: return LTRadius.lg
        case .xl: return LTRadius.xl
        }
    }
}

// MARK: - LTButton View
struct LTButton: View {
    let title: String
    let variant: LTButtonVariant
    let size: LTButtonSize
    let icon: String?
    let iconPosition: IconPosition
    let isFullWidth: Bool
    let isLoading: Bool
    let isDisabled: Bool
    let action: () -> Void
    
    enum IconPosition {
        case leading
        case trailing
    }
    
    init(
        _ title: String,
        variant: LTButtonVariant = .primary,
        size: LTButtonSize = .medium,
        icon: String? = nil,
        iconPosition: IconPosition = .leading,
        isFullWidth: Bool = false,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.variant = variant
        self.size = size
        self.icon = icon
        self.iconPosition = iconPosition
        self.isFullWidth = isFullWidth
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.action = action
    }
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            if !isLoading && !isDisabled {
                // Haptic feedback
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
                action()
            }
        }) {
            HStack(spacing: LTSpacing.sm) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: foregroundColor))
                        .scaleEffect(0.9)
                } else {
                    if let icon = icon, iconPosition == .leading {
                        Image(systemName: icon)
                            .font(.system(size: size.iconSize, weight: .semibold))
                    }
                    
                    Text(title)
                        .font(size.font)
                    
                    if let icon = icon, iconPosition == .trailing {
                        Image(systemName: icon)
                            .font(.system(size: size.iconSize, weight: .semibold))
                    }
                }
            }
            .foregroundColor(foregroundColor)
            .frame(height: size.height)
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .padding(.horizontal, size.horizontalPadding)
            .background(backgroundView)
            .clipShape(RoundedRectangle(cornerRadius: size.cornerRadius))
            .overlay(borderOverlay)
            .scaleEffect(isPressed ? 0.97 : 1.0)
            .animation(.ltSpringSubtle, value: isPressed)
            .opacity(isDisabled ? 0.5 : 1.0)
        }
        .disabled(isDisabled || isLoading)
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in if !isDisabled { isPressed = true } }
                .onEnded { _ in isPressed = false }
        )
        // Glow effect for primary button
        .if(variant == .primary && !isDisabled) { view in
            view.ltShadow(.glowSubtle)
        }
    }
    
    // MARK: - Style Properties
    
    private var foregroundColor: Color {
        switch variant {
        case .primary:
            return .white
        case .secondary:
            return .emerald600
        case .ghost:
            return .emerald600
        case .destructive:
            return .white
        case .subtle:
            return .emerald700
        }
    }
    
    @ViewBuilder
    private var backgroundView: some View {
        switch variant {
        case .primary:
            LinearGradient(
                colors: [.emerald500, .emerald600],
                startPoint: .top,
                endPoint: .bottom
            )
        case .secondary:
            Color.clear
        case .ghost:
            Color.clear
        case .destructive:
            LinearGradient(
                colors: [.error, .destructive],
                startPoint: .top,
                endPoint: .bottom
            )
        case .subtle:
            Color.emerald50
        }
    }
    
    @ViewBuilder
    private var borderOverlay: some View {
        switch variant {
        case .secondary:
            RoundedRectangle(cornerRadius: size.cornerRadius)
                .stroke(Color.emerald500, lineWidth: 1.5)
        case .ghost:
            EmptyView()
        default:
            EmptyView()
        }
    }
}

// MARK: - Icon Button
struct LTIconButton: View {
    let icon: String
    let variant: LTButtonVariant
    let size: LTButtonSize
    let isDisabled: Bool
    let action: () -> Void
    
    init(
        icon: String,
        variant: LTButtonVariant = .ghost,
        size: LTButtonSize = .medium,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.variant = variant
        self.size = size
        self.isDisabled = isDisabled
        self.action = action
    }
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            if !isDisabled {
                let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                impactFeedback.impactOccurred()
                action()
            }
        }) {
            Image(systemName: icon)
                .font(.system(size: size.iconSize, weight: .semibold))
                .foregroundColor(foregroundColor)
                .frame(width: size.height, height: size.height)
                .background(backgroundView)
                .clipShape(RoundedRectangle(cornerRadius: size.cornerRadius))
                .scaleEffect(isPressed ? 0.92 : 1.0)
                .animation(.ltSpringSubtle, value: isPressed)
                .opacity(isDisabled ? 0.5 : 1.0)
        }
        .disabled(isDisabled)
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in if !isDisabled { isPressed = true } }
                .onEnded { _ in isPressed = false }
        )
    }
    
    private var foregroundColor: Color {
        switch variant {
        case .primary: return .white
        case .secondary: return .emerald600
        case .ghost: return .emerald600
        case .destructive: return .white
        case .subtle: return .emerald700
        }
    }
    
    @ViewBuilder
    private var backgroundView: some View {
        switch variant {
        case .primary:
            Color.emerald500
        case .secondary:
            Color.clear.overlay(
                RoundedRectangle(cornerRadius: size.cornerRadius)
                    .stroke(Color.emerald500, lineWidth: 1.5)
            )
        case .ghost:
            Color.clear
        case .destructive:
            Color.error
        case .subtle:
            Color.emerald50
        }
    }
}

// MARK: - Preview
#Preview("LTButton") {
    ScrollView {
        VStack(spacing: 24) {
            Text("Primary Buttons")
                .font(.ltH3)
            
            VStack(spacing: 12) {
                LTButton("Primary Button", variant: .primary) { }
                LTButton("With Icon", variant: .primary, icon: "plus") { }
                LTButton("Loading", variant: .primary, isLoading: true) { }
                LTButton("Disabled", variant: .primary, isDisabled: true) { }
                LTButton("Full Width", variant: .primary, isFullWidth: true) { }
            }
            
            Divider()
            
            Text("Secondary & Ghost")
                .font(.ltH3)
            
            HStack(spacing: 12) {
                LTButton("Secondary", variant: .secondary) { }
                LTButton("Ghost", variant: .ghost) { }
            }
            
            Divider()
            
            Text("Destructive & Subtle")
                .font(.ltH3)
            
            HStack(spacing: 12) {
                LTButton("Delete", variant: .destructive, icon: "trash") { }
                LTButton("Subtle", variant: .subtle) { }
            }
            
            Divider()
            
            Text("Sizes")
                .font(.ltH3)
            
            VStack(spacing: 8) {
                LTButton("Small", size: .small) { }
                LTButton("Medium", size: .medium) { }
                LTButton("Large", size: .large) { }
                LTButton("XL", size: .xl) { }
            }
            
            Divider()
            
            Text("Icon Buttons")
                .font(.ltH3)
            
            HStack(spacing: 16) {
                LTIconButton(icon: "plus", variant: .primary) { }
                LTIconButton(icon: "pencil", variant: .secondary) { }
                LTIconButton(icon: "heart.fill", variant: .ghost) { }
                LTIconButton(icon: "trash", variant: .destructive) { }
                LTIconButton(icon: "square.and.arrow.up", variant: .subtle) { }
            }
        }
        .padding()
    }
    .background(Color.ltBackground)
}
