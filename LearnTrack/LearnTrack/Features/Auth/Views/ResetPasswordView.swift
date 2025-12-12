//
//  ResetPasswordView.swift
//  LearnTrack
//
//  Écran de réinitialisation du mot de passe - Design Emerald Premium
//

import SwiftUI

struct ResetPasswordView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authService: AuthService
    
    @State private var email = ""
    @State private var isLoading = false
    @State private var showSuccess = false
    @State private var errorMessage: String?
    
    // Animation states
    @State private var iconScale: CGFloat = 0.8
    @State private var iconOpacity: Double = 0
    @State private var contentOpacity: Double = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                backgroundGradient
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: LTSpacing.xxl) {
                        Spacer(minLength: 40)
                        
                        // Icon
                        iconSection
                        
                        // Content
                        contentSection
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, LTSpacing.xl)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: LTIconSize.md, weight: .semibold))
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
            }
            .onAppear {
                animateEntrance()
            }
        }
    }
    
    // MARK: - Background
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                Color.emerald900,
                Color.slate900,
                Color.slate950
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    // MARK: - Icon Section
    private var iconSection: some View {
        ZStack {
            // Glow
            Circle()
                .fill(Color.emerald500.opacity(0.2))
                .frame(width: 150, height: 150)
                .blur(radius: 30)
            
            // Background circle
            Circle()
                .fill(
                    LinearGradient(
                        colors: [.emerald400, .emerald600],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 100, height: 100)
                .overlay(
                    Image(systemName: "envelope.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.white)
                )
                .shadow(color: .emerald500.opacity(0.5), radius: 20, y: 10)
        }
        .scaleEffect(iconScale)
        .opacity(iconOpacity)
    }
    
    // MARK: - Content Section
    private var contentSection: some View {
        VStack(spacing: LTSpacing.xl) {
            // Title
            VStack(spacing: LTSpacing.sm) {
                Text("Mot de passe oublié ?")
                    .font(.ltH1)
                    .foregroundColor(.white)
                
                Text("Entrez votre adresse email pour recevoir un lien de réinitialisation")
                    .font(.ltBody)
                    .foregroundColor(.slate400)
                    .multilineTextAlignment(.center)
            }
            
            // Form card
            VStack(spacing: LTSpacing.lg) {
                // Email field
                VStack(alignment: .leading, spacing: LTSpacing.sm) {
                    Text("Email")
                        .font(.ltLabel)
                        .foregroundColor(.slate300)
                    
                    HStack(spacing: LTSpacing.md) {
                        Image(systemName: "envelope.fill")
                            .font(.system(size: LTIconSize.md))
                            .foregroundColor(.emerald400)
                        
                        TextField("", text: $email, prompt: Text("votre@email.com").foregroundColor(.slate500))
                            .font(.ltBody)
                            .foregroundColor(.white)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled()
                    }
                    .padding(.horizontal, LTSpacing.lg)
                    .frame(height: LTHeight.inputLarge)
                    .background(Color.slate800.opacity(0.6))
                    .clipShape(RoundedRectangle(cornerRadius: LTRadius.lg))
                    .overlay(
                        RoundedRectangle(cornerRadius: LTRadius.lg)
                            .stroke(Color.slate700, lineWidth: 1)
                    )
                }
                
                // Error message
                if let errorMessage = errorMessage {
                    HStack(spacing: LTSpacing.sm) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: LTIconSize.sm))
                        Text(errorMessage)
                            .font(.ltCaption)
                    }
                    .foregroundColor(.error)
                    .padding(LTSpacing.md)
                    .frame(maxWidth: .infinity)
                    .background(Color.error.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: LTRadius.md))
                }
                
                // Success message
                if showSuccess {
                    HStack(spacing: LTSpacing.sm) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: LTIconSize.lg))
                        
                        VStack(alignment: .leading, spacing: LTSpacing.xxs) {
                            Text("Email envoyé !")
                                .font(.ltBodySemibold)
                            Text("Vérifiez votre boîte de réception")
                                .font(.ltCaption)
                        }
                    }
                    .foregroundColor(.emerald400)
                    .padding(LTSpacing.lg)
                    .frame(maxWidth: .infinity)
                    .background(Color.emerald500.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: LTRadius.lg))
                    .transition(.scale.combined(with: .opacity))
                }
                
                // Submit button
                Button(action: handleReset) {
                    HStack(spacing: LTSpacing.sm) {
                        if isLoading {
                            LTSpinner(size: 20, lineWidth: 2, color: .white)
                        } else {
                            Image(systemName: "paperplane.fill")
                                .font(.system(size: LTIconSize.md, weight: .semibold))
                            Text("Envoyer le lien")
                                .font(.ltButtonLarge)
                        }
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: LTHeight.buttonXL)
                    .background(
                        LinearGradient(
                            colors: !email.isEmpty && !showSuccess ? [.emerald500, .emerald600] : [.slate600, .slate700],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: LTRadius.lg))
                    .shadow(color: !email.isEmpty && !showSuccess ? .emerald500.opacity(0.4) : .clear, radius: 15, y: 8)
                }
                .disabled(isLoading || email.isEmpty || showSuccess)
            }
            .padding(LTSpacing.xl)
            .background(
                RoundedRectangle(cornerRadius: LTRadius.xxl)
                    .fill(.ultraThinMaterial.opacity(0.3))
                    .background(
                        RoundedRectangle(cornerRadius: LTRadius.xxl)
                            .fill(Color.slate900.opacity(0.5))
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: LTRadius.xxl)
                    .stroke(
                        LinearGradient(
                            colors: [.slate700.opacity(0.5), .slate800.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            
            // Back to login
            Button(action: { dismiss() }) {
                HStack(spacing: LTSpacing.xs) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: LTIconSize.sm, weight: .semibold))
                    Text("Retour à la connexion")
                        .font(.ltBodyMedium)
                }
                .foregroundColor(.emerald400)
            }
        }
        .opacity(contentOpacity)
    }
    
    // MARK: - Helpers
    private func handleReset() {
        errorMessage = nil
        isLoading = true
        
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        Task {
            do {
                try await authService.resetPassword(email: email)
                await MainActor.run {
                    isLoading = false
                    withAnimation(.ltSpringSmooth) {
                        showSuccess = true
                    }
                    
                    let notification = UINotificationFeedbackGenerator()
                    notification.notificationOccurred(.success)
                    
                    // Close after delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        dismiss()
                    }
                }
            } catch {
                await MainActor.run {
                    errorMessage = "Erreur lors de l'envoi de l'email"
                    isLoading = false
                    
                    let notification = UINotificationFeedbackGenerator()
                    notification.notificationOccurred(.error)
                }
            }
        }
    }
    
    private func animateEntrance() {
        withAnimation(.ltSpringSmooth.delay(0.1)) {
            iconScale = 1.0
            iconOpacity = 1.0
        }
        
        withAnimation(.ltSpringSmooth.delay(0.3)) {
            contentOpacity = 1.0
        }
    }
}

#Preview {
    ResetPasswordView()
        .environmentObject(AuthService.shared)
}
