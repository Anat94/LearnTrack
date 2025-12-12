//
//  ViewExtensions.swift
//  LearnTrack
//
//  Extensions View supplémentaires pour le Design System Emerald
//  Note: ShareSheet est dans Shared/Components/ShareSheet.swift
//  Note: Les extensions if/hideKeyboard sont dans Extensions.swift
//

import SwiftUI

// MARK: - Safe Area Insets
extension View {
    func readSafeArea(_ safeArea: Binding<EdgeInsets>) -> some View {
        background(
            GeometryReader { geometry in
                Color.clear
                    .onAppear {
                        safeArea.wrappedValue = geometry.safeAreaInsets
                    }
            }
        )
    }
}

// MARK: - Corner Radius for Specific Corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// MARK: - Haptic Feedback Shortcuts
extension View {
    func hapticOnTap(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) -> some View {
        self.simultaneousGesture(
            TapGesture().onEnded { _ in
                let impact = UIImpactFeedbackGenerator(style: style)
                impact.impactOccurred()
            }
        )
    }
}

// MARK: - Staggered Animation Helper
extension View {
    /// Applies staggered entrance animation for list items
    func ltStaggered(index: Int, baseDelay: Double = 0.03) -> some View {
        self
            .opacity(1)
            .animation(
                .ltSpringSmooth.delay(Double(index) * baseDelay),
                value: true
            )
    }
}
