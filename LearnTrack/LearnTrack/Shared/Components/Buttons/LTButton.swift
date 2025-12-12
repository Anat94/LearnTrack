//
//  LTButton.swift
//  LearnTrack
//
//  Composant bouton custom - Design Emerald
//

import SwiftUI

// MARK: - Button Variants
enum LTButtonVariant {
    case primary
    case secondary
    case ghost
    case destructive
    case subtle
}

// MARK: - Button Sizes
enum LTButtonSize {
    case small, medium, large, xl
    
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
        case .large, .xl: return .ltButtonLarge
        }
    }
    
    var iconSize: CGFloat {
        switch self {
        case .small: return LTIconSize.sm
        case .medium: return LTIconSize.md
        case .large, .xl: return LTIconSize.lg
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
        case .medium, .large: return LTRadius.lg
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
    let isFullWidth: Bool
    let isLoading: Bool
    let isDisabled: Bool
    let action: () -> Void
    
    init(
        _ title: String,
        variant: LTButtonVariant = .primary,
        size: LTButtonSize = .medium,
        icon: String? = nil,
        isFullWidth: Bool = false,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.variant = variant
        self.size = size
        self.icon = icon
        self.isFullWidth = isFullWidth
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.action = action
    }
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            if !isLoading && !isDisabled {
                let impact = UIImpactFeedbackGenerator(style: .medium)
                impact.impactOccurred()
                action()
            }
        }) {
            HStack(spacing: LTSpacing.sm) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: foregroundColor))
                        .scaleEffect(0.9)
                } else {
                    if let icon = icon {
                        Image(systemName: icon)
                            .font(.system(size: size.iconSize, weight: .semibold))
                    }
                    Text(title)
                        .font(size.font)
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
        .shadow(
            color: variant == .primary && !isDisabled ? .emerald500.opacity(0.3) : .clear,
            radius: 12,
            y: 4
        )
    }
    
    private var foregroundColor: Color {
        switch variant {
        case .primary, .destructive: return .white
        case .secondary, .ghost: return .emerald600
        case .subtle: return .emerald700
        }
    }
    
    @ViewBuilder
    private var backgroundView: some View {
        switch variant {
        case .primary:
            LinearGradient(colors: [.emerald500, .emerald600], startPoint: .top, endPoint: .bottom)
        case .secondary, .ghost:
            Color.clear
        case .destructive:
            LinearGradient(colors: [.error, .destructive], startPoint: .top, endPoint: .bottom)
        case .subtle:
            Color.emerald50
        }
    }
    
    @ViewBuilder
    private var borderOverlay: some View {
        if variant == .secondary {
            RoundedRectangle(cornerRadius: size.cornerRadius)
                .stroke(Color.emerald500, lineWidth: 1.5)
        }
    }
}

// MARK: - Icon Button
struct LTIconButton: View {
    let icon: String
    let variant: LTButtonVariant
    let size: LTButtonSize
    let action: () -> Void
    
    init(
        icon: String,
        variant: LTButtonVariant = .ghost,
        size: LTButtonSize = .medium,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.variant = variant
        self.size = size
        self.action = action
    }
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            action()
        }) {
            Image(systemName: icon)
                .font(.system(size: size.iconSize, weight: .semibold))
                .foregroundColor(variant == .primary ? .white : .emerald600)
                .frame(width: size.height, height: size.height)
                .background(variant == .primary ? Color.emerald500 : Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: size.cornerRadius))
                .scaleEffect(isPressed ? 0.92 : 1.0)
                .animation(.ltSpringSubtle, value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}

#Preview {
    VStack(spacing: 16) {
        LTButton("Primary", variant: .primary, icon: "plus") { }
        LTButton("Secondary", variant: .secondary) { }
        LTButton("Ghost", variant: .ghost) { }
        LTButton("Destructive", variant: .destructive, icon: "trash") { }
        LTButton("Full Width", variant: .primary, isFullWidth: true) { }
    }
    .padding()
    .background(Color.ltBackground)
}
