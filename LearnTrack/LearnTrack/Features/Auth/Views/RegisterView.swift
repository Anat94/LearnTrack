//
//  RegisterView.swift
//  LearnTrack
//
//  Écran d'inscription - Design Emerald Premium
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authService: AuthService
    
    @State private var prenom = ""
    @State private var nom = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    // Animation states
    @State private var formOpacity: Double = 0
    @State private var formOffset: CGFloat = 20
    
    var isValid: Bool {
        !prenom.isEmpty && !nom.isEmpty && !email.isEmpty && !password.isEmpty && password == confirmPassword
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                backgroundGradient
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: LTSpacing.xl) {
                        // Header
                        headerSection
                        
                        // Form
                        formSection
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, LTSpacing.xl)
                    .padding(.top, LTSpacing.xl)
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
        .overlay(
            // Decorative circles
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Color.emerald500.opacity(0.2), Color.clear],
                            center: .center,
                            startRadius: 0,
                            endRadius: 150
                        )
                    )
                    .frame(width: 300, height: 300)
                    .offset(x: 100, y: -50)
                    .blur(radius: 40)
            }
        )
    }
    
    // MARK: - Header
    private var headerSection: some View {
        VStack(spacing: LTSpacing.md) {
            // Icon
            ZStack {
                Circle()
                    .fill(Color.emerald500.opacity(0.2))
                    .frame(width: 80, height: 80)
                
                Image(systemName: "person.badge.plus")
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundColor(.emerald400)
            }
            
            Text("Créer un compte")
                .font(.ltH1)
                .foregroundColor(.white)
            
            Text("Rejoignez LearnTrack pour gérer vos formations")
                .font(.ltBody)
                .foregroundColor(.slate400)
                .multilineTextAlignment(.center)
        }
    }
    
    // MARK: - Form
    private var formSection: some View {
        VStack(spacing: LTSpacing.lg) {
            // Identity section
            VStack(alignment: .leading, spacing: LTSpacing.md) {
                Text("Identité")
                    .font(.ltLabel)
                    .foregroundColor(.slate300)
                
                HStack(spacing: LTSpacing.md) {
                    darkTextField(
                        icon: "person",
                        placeholder: "Prénom",
                        text: $prenom
                    )
                    
                    darkTextField(
                        icon: "person",
                        placeholder: "Nom",
                        text: $nom
                    )
                }
            }
            
            // Account section
            VStack(alignment: .leading, spacing: LTSpacing.md) {
                Text("Compte")
                    .font(.ltLabel)
                    .foregroundColor(.slate300)
                
                darkTextField(
                    icon: "envelope",
                    placeholder: "Email",
                    text: $email,
                    keyboardType: .emailAddress
                )
                
                darkSecureField(
                    icon: "lock",
                    placeholder: "Mot de passe",
                    text: $password
                )
                
                darkSecureField(
                    icon: "lock.shield",
                    placeholder: "Confirmer le mot de passe",
                    text: $confirmPassword
                )
                
                // Password match indicator
                if !password.isEmpty && !confirmPassword.isEmpty {
                    HStack(spacing: LTSpacing.xs) {
                        Image(systemName: password == confirmPassword ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .font(.system(size: LTIconSize.sm))
                        Text(password == confirmPassword ? "Les mots de passe correspondent" : "Les mots de passe ne correspondent pas")
                            .font(.ltCaption)
                    }
                    .foregroundColor(password == confirmPassword ? .emerald400 : .error)
                }
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
            
            // Register button
            Button(action: handleRegister) {
                HStack(spacing: LTSpacing.sm) {
                    if isLoading {
                        LTSpinner(size: 20, lineWidth: 2, color: .white)
                    } else {
                        Text("Créer mon compte")
                            .font(.ltButtonLarge)
                        Image(systemName: "arrow.right")
                            .font(.system(size: LTIconSize.md, weight: .semibold))
                    }
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: LTHeight.buttonXL)
                .background(
                    LinearGradient(
                        colors: isValid ? [.emerald500, .emerald600] : [.slate600, .slate700],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: LTRadius.lg))
                .shadow(color: isValid ? .emerald500.opacity(0.4) : .clear, radius: 15, y: 8)
            }
            .disabled(!isValid || isLoading)
            .scaleEffect(isLoading ? 0.98 : 1.0)
            .animation(.ltSpringSubtle, value: isLoading)
            
            // Login link
            HStack(spacing: LTSpacing.xs) {
                Text("Déjà un compte ?")
                    .font(.ltBody)
                    .foregroundColor(.slate400)
                
                Button(action: { dismiss() }) {
                    Text("Se connecter")
                        .font(.ltBodySemibold)
                        .foregroundColor(.emerald400)
                }
            }
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
        .offset(y: formOffset)
        .opacity(formOpacity)
    }
    
    // MARK: - Dark Text Field
    private func darkTextField(
        icon: String,
        placeholder: String,
        text: Binding<String>,
        keyboardType: UIKeyboardType = .default
    ) -> some View {
        HStack(spacing: LTSpacing.md) {
            Image(systemName: icon)
                .font(.system(size: LTIconSize.md))
                .foregroundColor(.emerald400)
            
            TextField("", text: text, prompt: Text(placeholder).foregroundColor(.slate500))
                .font(.ltBody)
                .foregroundColor(.white)
                .textInputAutocapitalization(.never)
                .keyboardType(keyboardType)
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
    
    // MARK: - Dark Secure Field
    private func darkSecureField(
        icon: String,
        placeholder: String,
        text: Binding<String>
    ) -> some View {
        HStack(spacing: LTSpacing.md) {
            Image(systemName: icon)
                .font(.system(size: LTIconSize.md))
                .foregroundColor(.emerald400)
            
            SecureField("", text: text, prompt: Text(placeholder).foregroundColor(.slate500))
                .font(.ltBody)
                .foregroundColor(.white)
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
    
    // MARK: - Helpers
    private func handleRegister() {
        errorMessage = nil
        isLoading = true
        
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        Task {
            do {
                try await authService.signUp(email: email, password: password, nom: nom, prenom: prenom)
                
                let notification = UINotificationFeedbackGenerator()
                notification.notificationOccurred(.success)
                
                dismiss()
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    isLoading = false
                    
                    let notification = UINotificationFeedbackGenerator()
                    notification.notificationOccurred(.error)
                }
            }
        }
    }
    
    private func animateEntrance() {
        withAnimation(.ltSpringSmooth.delay(0.2)) {
            formOffset = 0
            formOpacity = 1.0
        }
    }
}

#Preview {
    RegisterView()
        .environmentObject(AuthService.shared)
}
