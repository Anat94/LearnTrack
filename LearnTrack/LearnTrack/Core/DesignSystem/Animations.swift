//
//  Animations.swift
//  LearnTrack
//
//  Design System - Animations et transitions
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
}

// MARK: - Transition Presets
extension AnyTransition {
    static let ltSlideUp = AnyTransition.asymmetric(
        insertion: .move(edge: .bottom).combined(with: .opacity),
        removal: .move(edge: .bottom).combined(with: .opacity)
    )
    
    static let ltFade = AnyTransition.opacity.animation(.ltNormal)
    
    static let ltScale = AnyTransition.scale(scale: 0.95).combined(with: .opacity)
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
