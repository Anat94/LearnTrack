//
//  LTToast.swift
//  LearnTrack
//
//  Toast notifications - Design Emerald
//

import SwiftUI

// MARK: - Toast Type
enum LTToastType {
    case success, error, warning, info
    
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
}

// MARK: - Toast Data
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
    
    static func == (lhs: LTToastData, rhs: LTToastData) -> Bool { lhs.id == rhs.id }
}

// MARK: - Toast View
struct LTToast: View {
    let toast: LTToastData
    let onDismiss: () -> Void
    
    @State private var isShowing = false
    
    var body: some View {
        HStack(spacing: LTSpacing.md) {
            ZStack {
                Circle()
                    .fill(toast.type.color.opacity(0.15))
                    .frame(width: 40, height: 40)
                
                Image(systemName: toast.type.icon)
                    .font(.system(size: LTIconSize.lg, weight: .semibold))
                    .foregroundColor(toast.type.color)
            }
            
            VStack(alignment: .leading, spacing: LTSpacing.xxs) {
                Text(toast.title)
                    .font(.ltBodySemibold)
                    .foregroundColor(.ltText)
                
                if let message = toast.message {
                    Text(message)
                        .font(.ltCaption)
                        .foregroundColor(.ltTextSecondary)
                }
            }
            
            Spacer()
            
            Button(action: dismiss) {
                Image(systemName: "xmark")
                    .font(.system(size: LTIconSize.sm))
                    .foregroundColor(.ltTextTertiary)
            }
        }
        .padding(LTSpacing.md)
        .background(Color.ltCard)
        .clipShape(RoundedRectangle(cornerRadius: LTRadius.xl))
        .overlay(
            RoundedRectangle(cornerRadius: LTRadius.xl)
                .stroke(toast.type.color.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
        .padding(.horizontal, LTSpacing.lg)
        .offset(y: isShowing ? 0 : -100)
        .opacity(isShowing ? 1 : 0)
        .animation(.ltSpringSmooth, value: isShowing)
        .onAppear { show() }
        .gesture(
            DragGesture()
                .onEnded { if $0.translation.height < -20 { dismiss() } }
        )
    }
    
    private func show() {
        isShowing = true
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration) { dismiss() }
    }
    
    private func dismiss() {
        withAnimation { isShowing = false }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { onDismiss() }
    }
}

// MARK: - Toast Manager
@MainActor
class LTToastManager: ObservableObject {
    static let shared = LTToastManager()
    @Published var toasts: [LTToastData] = []
    
    func show(_ toast: LTToastData) { toasts.append(toast) }
    func success(_ title: String, message: String? = nil) { show(LTToastData(type: .success, title: title, message: message)) }
    func error(_ title: String, message: String? = nil) { show(LTToastData(type: .error, title: title, message: message)) }
    func warning(_ title: String, message: String? = nil) { show(LTToastData(type: .warning, title: title, message: message)) }
    func info(_ title: String, message: String? = nil) { show(LTToastData(type: .info, title: title, message: message)) }
    func dismiss(_ toast: LTToastData) { toasts.removeAll { $0.id == toast.id } }
}

// MARK: - Toast Container Modifier
struct LTToastModifier: ViewModifier {
    @ObservedObject var manager = LTToastManager.shared
    
    func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            content
            
            VStack(spacing: LTSpacing.sm) {
                ForEach(manager.toasts) { toast in
                    LTToast(toast: toast) { manager.dismiss(toast) }
                }
            }
            .padding(.top, LTSpacing.xl)
        }
    }
}

extension View {
    func ltToasts() -> some View { modifier(LTToastModifier()) }
}

#Preview {
    VStack(spacing: 16) {
        LTToast(toast: LTToastData(type: .success, title: "Succès", message: "Action effectuée"), onDismiss: {})
        LTToast(toast: LTToastData(type: .error, title: "Erreur", message: "Une erreur est survenue"), onDismiss: {})
    }
    .padding()
    .background(Color.ltBackground)
}
