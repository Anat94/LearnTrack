//
//  ViewExtensions.swift
//  LearnTrack
//
//  Extensions View utilitaires pour le Design System Emerald
//

import SwiftUI

// MARK: - Conditional Modifier
extension View {
    /// Applies a modifier conditionally
    @ViewBuilder
    func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    /// Applies a modifier conditionally with an else branch
    @ViewBuilder
    func `if`<TrueContent: View, FalseContent: View>(
        _ condition: Bool,
        if ifTransform: (Self) -> TrueContent,
        else elseTransform: (Self) -> FalseContent
    ) -> some View {
        if condition {
            ifTransform(self)
        } else {
            elseTransform(self)
        }
    }
}

// MARK: - Hide Keyboard
extension UIApplication {
    func hideKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// MARK: - Screen Modifiers
extension View {
    /// Standard screen background
    func ltScreen() -> some View {
        self
            .background(Color.ltBackground)
    }
    
    /// Card padding preset
    func ltCardPadding() -> some View {
        self.padding(LTSpacing.lg)
    }
    
    /// Section padding preset
    func ltSectionPadding() -> some View {
        self.padding(.horizontal, LTSpacing.lg)
    }
    
    /// Full screen padding preset
    func ltScreenPadding() -> some View {
        self.padding(LTSpacing.xl)
    }
}

// MARK: - Staggered Animation
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

// MARK: - Share Sheet
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

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
