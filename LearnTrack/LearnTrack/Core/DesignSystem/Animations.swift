//
//  Animations.swift
//  LearnTrack
//
//  Design System - Animations et transitions premium
//

import SwiftUI

// MARK: - Animation Presets
extension Animation {
    static let ltFast = Animation.easeOut(duration: 0.15)
    static let ltNormal = Animation.easeOut(duration: 0.25)
    static let ltSlow = Animation.easeOut(duration: 0.4)
    
    static let ltSpringSubtle = Animation.spring(response: 0.3, dampingFraction: 0.8)
    static let ltSpringSmooth = Animation.spring(response: 0.4, dampingFraction: 0.75)
    static let ltSpringBouncy = Animation.spring(response: 0.5, dampingFraction: 0.65)
    static let ltSpringSnappy = Animation.spring(response: 0.25, dampingFraction: 0.85)
    
    // Page transitions
    static let ltPageTransition = Animation.spring(response: 0.4, dampingFraction: 0.78)
    static let ltPopIn = Animation.spring(response: 0.35, dampingFraction: 0.7)
}

// MARK: - Transition Presets
extension AnyTransition {
    static let ltSlideUp = AnyTransition.asymmetric(
        insertion: .move(edge: .bottom).combined(with: .opacity),
        removal: .move(edge: .bottom).combined(with: .opacity)
    )
    
    static let ltFade = AnyTransition.opacity.animation(.ltNormal)
    
    static let ltScale = AnyTransition.scale(scale: 0.95).combined(with: .opacity)
    
    static let ltPopIn = AnyTransition.asymmetric(
        insertion: .scale(scale: 0.9).combined(with: .opacity),
        removal: .scale(scale: 1.05).combined(with: .opacity)
    )
    
    static let ltSlideFromRight = AnyTransition.asymmetric(
        insertion: .move(edge: .trailing).combined(with: .opacity),
        removal: .move(edge: .leading).combined(with: .opacity)
    )
}

// MARK: - Scale on Press Modifier
struct LTScaleOnPress: ViewModifier {
    @State private var isPressed = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? 0.96 : 1.0)
            .animation(.ltSpringSubtle, value: isPressed)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in isPressed = true }
                    .onEnded { _ in isPressed = false }
            )
    }
}

extension View {
    func ltScaleOnPress() -> some View {
        modifier(LTScaleOnPress())
    }
}

// MARK: - Shimmer Effect
struct LTShimmerEffect: ViewModifier {
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    colors: [
                        .clear,
                        .white.opacity(0.3),
                        .clear
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .offset(x: phase)
                .mask(content)
            )
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    phase = 200
                }
            }
    }
}

extension View {
    func ltShimmer() -> some View {
        modifier(LTShimmerEffect())
    }
}

// MARK: - Staggered List Animation
struct LTStaggeredList: ViewModifier {
    let index: Int
    let baseDelay: Double
    @State private var isVisible = false
    
    init(index: Int, baseDelay: Double = 0.05) {
        self.index = index
        self.baseDelay = baseDelay
    }
    
    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 20)
            .scaleEffect(isVisible ? 1 : 0.95)
            .onAppear {
                withAnimation(.ltPopIn.delay(Double(index) * baseDelay)) {
                    isVisible = true
                }
            }
    }
}

extension View {
    func ltStaggered(index: Int, delay: Double = 0.05) -> some View {
        modifier(LTStaggeredList(index: index, baseDelay: delay))
    }
}

// MARK: - Bounce on Tap
struct LTBounceOnTap: ViewModifier {
    @State private var isBouncing = false
    let action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isBouncing ? 0.92 : 1.0)
            .animation(.ltSpringBouncy, value: isBouncing)
            .onTapGesture {
                isBouncing = true
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isBouncing = false
                    action()
                }
            }
    }
}

extension View {
    func ltBounceOnTap(action: @escaping () -> Void) -> some View {
        modifier(LTBounceOnTap(action: action))
    }
}

// MARK: - Pulse Glow Effect
struct LTPulseGlow: ViewModifier {
    @State private var isPulsing = false
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .shadow(color: color.opacity(isPulsing ? 0.6 : 0.3), radius: isPulsing ? 15 : 8, y: 4)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    isPulsing = true
                }
            }
    }
}

extension View {
    func ltPulseGlow(color: Color = .emerald500) -> some View {
        modifier(LTPulseGlow(color: color))
    }
}

