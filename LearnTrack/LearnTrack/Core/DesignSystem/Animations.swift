//
//  Animations.swift
//  LearnTrack
//
//  Design System - Animations réutilisables
//

import SwiftUI

// MARK: - Animation Presets
extension Animation {
    
    // MARK: Standard
    
    /// Animation rapide pour micro-interactions (0.15s)
    static let ltFast = Animation.easeOut(duration: 0.15)
    
    /// Animation normale (0.25s)
    static let ltNormal = Animation.easeInOut(duration: 0.25)
    
    /// Animation lente pour transitions (0.35s)
    static let ltSlow = Animation.easeInOut(duration: 0.35)
    
    // MARK: Spring
    
    /// Spring bouncy pour boutons
    static let ltSpringBouncy = Animation.spring(response: 0.35, dampingFraction: 0.6)
    
    /// Spring smooth pour transitions
    static let ltSpringSmooth = Animation.spring(response: 0.4, dampingFraction: 0.8)
    
    /// Spring snappy pour tab bar
    static let ltSpringSnappy = Animation.spring(response: 0.3, dampingFraction: 0.7)
    
    /// Spring subtle pour hover
    static let ltSpringSubtle = Animation.spring(response: 0.25, dampingFraction: 0.85)
    
    // MARK: Special
    
    /// Pulse animation
    static let ltPulse = Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)
    
    /// Shake animation
    static let ltShake = Animation.spring(response: 0.2, dampingFraction: 0.3)
}

// MARK: - Animation Values
enum LTAnimationDuration {
    static let instant: Double = 0.1
    static let fast: Double = 0.15
    static let normal: Double = 0.25
    static let slow: Double = 0.35
    static let verySlow: Double = 0.5
}

// MARK: - Transition Presets
extension AnyTransition {
    
    /// Slide up + fade
    static let ltSlideUp = AnyTransition.asymmetric(
        insertion: .move(edge: .bottom).combined(with: .opacity),
        removal: .move(edge: .bottom).combined(with: .opacity)
    )
    
    /// Slide from trailing
    static let ltSlideTrailing = AnyTransition.asymmetric(
        insertion: .move(edge: .trailing).combined(with: .opacity),
        removal: .move(edge: .leading).combined(with: .opacity)
    )
    
    /// Scale + fade
    static let ltScale = AnyTransition.asymmetric(
        insertion: .scale(scale: 0.9).combined(with: .opacity),
        removal: .scale(scale: 0.9).combined(with: .opacity)
    )
    
    /// Scale from small
    static let ltPopIn = AnyTransition.asymmetric(
        insertion: .scale(scale: 0.5).combined(with: .opacity),
        removal: .scale(scale: 0.8).combined(with: .opacity)
    )
    
    /// Blur + fade (for modals)
    static let ltBlur = AnyTransition.opacity.combined(with: .scale(scale: 1.05))
}

// MARK: - Animated View Modifiers

/// Scale on press effect
struct LTScaleOnPress: ViewModifier {
    @State private var isPressed = false
    let scale: CGFloat
    
    init(scale: CGFloat = 0.96) {
        self.scale = scale
    }
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? scale : 1.0)
            .animation(.ltSpringSubtle, value: isPressed)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in isPressed = true }
                    .onEnded { _ in isPressed = false }
            )
    }
}

/// Shimmer loading effect
struct LTShimmerEffect: ViewModifier {
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0),
                            Color.white.opacity(0.5),
                            Color.white.opacity(0)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geometry.size.width * 2)
                    .offset(x: -geometry.size.width + (geometry.size.width * 2 * phase))
                }
            )
            .mask(content)
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
    }
}

/// Pulse glow effect
struct LTPulseGlow: ViewModifier {
    @State private var isPulsing = false
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .shadow(
                color: color.opacity(isPulsing ? 0.6 : 0.2),
                radius: isPulsing ? 16 : 8,
                x: 0,
                y: isPulsing ? 8 : 4
            )
            .onAppear {
                withAnimation(.ltPulse) {
                    isPulsing = true
                }
            }
    }
}

/// Staggered list animation
struct LTStaggeredAnimation: ViewModifier {
    let index: Int
    @State private var isVisible = false
    
    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 20)
            .onAppear {
                withAnimation(.ltSpringSmooth.delay(Double(index) * 0.05)) {
                    isVisible = true
                }
            }
    }
}

// MARK: - View Extension
extension View {
    
    /// Add scale effect on press
    func ltScaleOnPress(scale: CGFloat = 0.96) -> some View {
        modifier(LTScaleOnPress(scale: scale))
    }
    
    /// Add shimmer loading effect
    func ltShimmer() -> some View {
        modifier(LTShimmerEffect())
    }
    
    /// Add pulse glow effect
    func ltPulseGlow(color: Color = .emerald500) -> some View {
        modifier(LTPulseGlow(color: color))
    }
    
    /// Add staggered animation for list items
    func ltStaggered(index: Int) -> some View {
        modifier(LTStaggeredAnimation(index: index))
    }
    
    /// Animate on appear with spring
    func ltAnimateOnAppear() -> some View {
        self
            .transition(.ltScale)
            .animation(.ltSpringSmooth, value: UUID())
    }
}

// MARK: - Preview
#Preview("Animations") {
    ScrollView {
        VStack(spacing: 32) {
            Text("Scale on Press")
                .font(.ltH3)
            
            RoundedRectangle(cornerRadius: LTRadius.lg)
                .fill(Color.emerald500)
                .frame(width: 200, height: 50)
                .overlay(
                    Text("Tap me")
                        .foregroundColor(.white)
                        .font(.ltButtonMedium)
                )
                .ltScaleOnPress()
            
            Divider()
            
            Text("Shimmer Effect")
                .font(.ltH3)
            
            RoundedRectangle(cornerRadius: LTRadius.lg)
                .fill(Color.slate200)
                .frame(width: 200, height: 50)
                .ltShimmer()
            
            Divider()
            
            Text("Pulse Glow")
                .font(.ltH3)
            
            RoundedRectangle(cornerRadius: LTRadius.lg)
                .fill(Color.emerald500)
                .frame(width: 200, height: 50)
                .ltPulseGlow()
            
            Divider()
            
            Text("Staggered List")
                .font(.ltH3)
            
            VStack(spacing: 8) {
                ForEach(0..<5) { index in
                    RoundedRectangle(cornerRadius: LTRadius.md)
                        .fill(Color.emerald500.opacity(1 - Double(index) * 0.15))
                        .frame(height: 40)
                        .ltStaggered(index: index)
                }
            }
            .padding(.horizontal)
        }
        .padding()
    }
}
