//
//  LTToast.swift
//  LearnTrack
//
//  Composant Toast notification - Design Emerald
//

import SwiftUI

// MARK: - Toast Type
enum LTToastType {
    case success
    case error
    case warning
    case info
    
    var icon: String {
        switch self {
        case .success: return "checkmark.circle.fill"
        case .error: return "xmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .info: return "info.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .success: return .emerald500
        case .error: return .error
        case .warning: return .warning
        case .info: return .info
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .success: return .emerald500.opacity(0.15)
        case .error: return Color.error.opacity(0.15)
        case .warning: return Color.warning.opacity(0.15)
        case .info: return Color.info.opacity(0.15)
        }
    }
}

// MARK: - Toast Model
struct LTToastData: Identifiable, Equatable {
    let id = UUID()
    let type: LTToastType
    let title: String
    let message: String?
    let duration: Double
    
    init(type: LTToastType, title: String, message: String? = nil, duration: Double = 3.0) {
        self.type = type
        self.title = title
        self.message = message
        self.duration = duration
    }
    
    static func == (lhs: LTToastData, rhs: LTToastData) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Toast View
struct LTToast: View {
    let toast: LTToastData
    let onDismiss: () -> Void
    
    @State private var isShowing = false
    
    var body: some View {
        HStack(spacing: LTSpacing.md) {
            // Icon
            ZStack {
                Circle()
                    .fill(toast.type.backgroundColor)
                    .frame(width: 40, height: 40)
                
                Image(systemName: toast.type.icon)
                    .font(.system(size: LTIconSize.lg, weight: .semibold))
                    .foregroundColor(toast.type.color)
            }
            
            // Content
            VStack(alignment: .leading, spacing: LTSpacing.xxs) {
                Text(toast.title)
                    .font(.ltBodySemibold)
                    .foregroundColor(.ltText)
                
                if let message = toast.message {
                    Text(message)
                        .font(.ltCaption)
                        .foregroundColor(.ltTextSecondary)
                        .lineLimit(2)
                }
            }
            
            Spacer(minLength: LTSpacing.sm)
            
            // Dismiss button
            Button(action: {
                dismissToast()
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: LTIconSize.sm, weight: .semibold))
                    .foregroundColor(.ltTextTertiary)
                    .frame(width: 24, height: 24)
            }
        }
        .padding(LTSpacing.md)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: LTRadius.xl)
                .fill(Color.ltCard)
                .shadow(color: Color.black.opacity(0.15), radius: 20, y: 10)
        )
        .overlay(
            RoundedRectangle(cornerRadius: LTRadius.xl)
                .stroke(toast.type.color.opacity(0.3), lineWidth: 1)
        )
        .padding(.horizontal, LTSpacing.lg)
        .offset(y: isShowing ? 0 : -100)
        .opacity(isShowing ? 1 : 0)
        .animation(.ltSpringSmooth, value: isShowing)
        .onAppear {
            showToast()
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.height < -20 {
                        dismissToast()
                    }
                }
        )
    }
    
    private func showToast() {
        withAnimation {
            isShowing = true
        }
        
        // Haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
        
        // Auto dismiss
        DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration) {
            dismissToast()
        }
    }
    
    private func dismissToast() {
        withAnimation(.ltSpringSmooth) {
            isShowing = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            onDismiss()
        }
    }
}

// MARK: - Toast Manager
@MainActor
class LTToastManager: ObservableObject {
    static let shared = LTToastManager()
    
    @Published var toasts: [LTToastData] = []
    
    private init() {}
    
    func show(_ toast: LTToastData) {
        toasts.append(toast)
    }
    
    func success(_ title: String, message: String? = nil) {
        show(LTToastData(type: .success, title: title, message: message))
    }
    
    func error(_ title: String, message: String? = nil) {
        show(LTToastData(type: .error, title: title, message: message))
    }
    
    func warning(_ title: String, message: String? = nil) {
        show(LTToastData(type: .warning, title: title, message: message))
    }
    
    func info(_ title: String, message: String? = nil) {
        show(LTToastData(type: .info, title: title, message: message))
    }
    
    func dismiss(_ toast: LTToastData) {
        toasts.removeAll { $0.id == toast.id }
    }
}

// MARK: - Toast Container View
struct LTToastContainer: View {
    @ObservedObject var manager = LTToastManager.shared
    
    var body: some View {
        VStack(spacing: LTSpacing.sm) {
            ForEach(manager.toasts) { toast in
                LTToast(toast: toast) {
                    manager.dismiss(toast)
                }
            }
        }
        .padding(.top, LTSpacing.xl)
    }
}

// MARK: - View Modifier for Toast
struct LTToastModifier: ViewModifier {
    @ObservedObject var manager = LTToastManager.shared
    
    func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            content
            
            if !manager.toasts.isEmpty {
                LTToastContainer()
            }
        }
    }
}

extension View {
    func ltToasts() -> some View {
        modifier(LTToastModifier())
    }
}

// MARK: - Compact Toast
struct LTCompactToast: View {
    let icon: String
    let message: String
    let color: Color
    
    @State private var isShowing = false
    
    var body: some View {
        HStack(spacing: LTSpacing.sm) {
            Image(systemName: icon)
                .font(.system(size: LTIconSize.md, weight: .semibold))
                .foregroundColor(color)
            
            Text(message)
                .font(.ltBodyMedium)
                .foregroundColor(.ltText)
        }
        .padding(.horizontal, LTSpacing.lg)
        .padding(.vertical, LTSpacing.md)
        .background(
            Capsule()
                .fill(Color.ltCard)
                .shadow(color: Color.black.opacity(0.1), radius: 10, y: 5)
        )
        .scaleEffect(isShowing ? 1 : 0.8)
        .opacity(isShowing ? 1 : 0)
        .onAppear {
            withAnimation(.ltSpringBouncy) {
                isShowing = true
            }
        }
    }
}

// MARK: - Action Toast
struct LTActionToast: View {
    let type: LTToastType
    let title: String
    let actionTitle: String
    let action: () -> Void
    let onDismiss: () -> Void
    
    @State private var isShowing = false
    
    var body: some View {
        HStack(spacing: LTSpacing.md) {
            // Icon
            Image(systemName: type.icon)
                .font(.system(size: LTIconSize.lg, weight: .semibold))
                .foregroundColor(type.color)
            
            // Title
            Text(title)
                .font(.ltBodyMedium)
                .foregroundColor(.ltText)
            
            Spacer()
            
            // Action button
            Button(action: {
                action()
                dismissToast()
            }) {
                Text(actionTitle)
                    .font(.ltCaptionMedium)
                    .foregroundColor(type.color)
                    .padding(.horizontal, LTSpacing.md)
                    .padding(.vertical, LTSpacing.sm)
                    .background(type.color.opacity(0.15))
                    .clipShape(Capsule())
            }
            
            // Close
            Button(action: {
                dismissToast()
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: LTIconSize.sm, weight: .semibold))
                    .foregroundColor(.ltTextTertiary)
            }
        }
        .padding(LTSpacing.md)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: LTRadius.xl)
                .fill(Color.ltCard)
                .shadow(color: Color.black.opacity(0.15), radius: 20, y: 10)
        )
        .overlay(
            RoundedRectangle(cornerRadius: LTRadius.xl)
                .stroke(type.color.opacity(0.3), lineWidth: 1)
        )
        .padding(.horizontal, LTSpacing.lg)
        .offset(y: isShowing ? 0 : 100)
        .opacity(isShowing ? 1 : 0)
        .animation(.ltSpringSmooth, value: isShowing)
        .onAppear {
            withAnimation {
                isShowing = true
            }
        }
    }
    
    private func dismissToast() {
        withAnimation(.ltSpringSmooth) {
            isShowing = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            onDismiss()
        }
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        Color.ltBackground
            .ignoresSafeArea()
        
        VStack(spacing: LTSpacing.xl) {
            LTToast(
                toast: LTToastData(type: .success, title: "Session créée", message: "La session a été ajoutée avec succès"),
                onDismiss: {}
            )
            
            LTToast(
                toast: LTToastData(type: .error, title: "Erreur de connexion", message: "Impossible de se connecter au serveur"),
                onDismiss: {}
            )
            
            LTToast(
                toast: LTToastData(type: .warning, title: "Attention", message: "Cette action est irréversible"),
                onDismiss: {}
            )
            
            LTToast(
                toast: LTToastData(type: .info, title: "Information", message: "Nouvelle mise à jour disponible"),
                onDismiss: {}
            )
            
            LTCompactToast(icon: "checkmark", message: "Sauvegardé", color: .emerald500)
        }
        .padding()
    }
}
