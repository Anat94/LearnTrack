//
//  ViewExtensions.swift
//  LearnTrack
//
//  Extensions View pour le Design System Emerald
//

import SwiftUI

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

// MARK: - Haptic Feedback
extension View {
    func hapticOnTap(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) -> some View {
        self.simultaneousGesture(
            TapGesture().onEnded { _ in
                UIImpactFeedbackGenerator(style: style).impactOccurred()
            }
        )
    }
}

// MARK: - Safe Area Reader
extension View {
    func readSafeArea(_ safeArea: Binding<EdgeInsets>) -> some View {
        background(
            GeometryReader { geometry in
                Color.clear.onAppear { safeArea.wrappedValue = geometry.safeAreaInsets }
            }
        )
    }
}
