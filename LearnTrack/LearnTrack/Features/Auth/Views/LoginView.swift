//
//  LoginView.swift
//  LearnTrack
//
//  Écran de connexion - Design Emerald Premium
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authService: AuthService
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showResetPassword = false
    @State private var showRegister = false
    
    // Animation states
    @State private var logoScale: CGFloat = 0.8
    @State private var logoOpacity: Double = 0
    @State private var formOffset: CGFloat = 30
    @State private var formOpacity: Double = 0
    
    var body: some View {
        ZStack {
            // Background gradient
            backgroundGradient
            
            // Decorative elements
            decorativeCircles
            
            // Content
            ScrollView(showsIndicators: false) {
                VStack(spacing: LTSpacing.xxxl) {
                    Spacer(minLength: 60)
                    
                    // Logo et titre
                    logoSection
                    
                    Spacer(minLength: 20)
                    
                    // Formulaire
                    formSection
                    
                    Spacer(minLength: 40)
                }
                .padding(.horizontal, LTSpacing.xl)
            }
        }
        .ignoresSafeArea()
        .sheet(isPresented: $showResetPassword) {
            ResetPasswordView()
        }
        .sheet(isPresented: $showRegister) {
            RegisterView()
                .environmentObject(authService)
        }
        .onAppear {
            animateEntrance()
        }
    }
    
    // MARK: - Background
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                Color.emerald950,
                Color.slate900,
                Color.slate950
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    private var decorativeCircles: some View {
        ZStack {
            // Top right glow
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color.emerald500.opacity(0.3), Color.clear],
                        center: .center,
                        startRadius: 0,
                        endRadius: 200
                    )
                )
                .frame(width: 400, height: 400)
                .offset(x: 150, y: -100)
                .blur(radius: 60)
            
            // Bottom left glow
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color.emerald600.opacity(0.2), Color.clear],
                        center: .center,
                        startRadius: 0,
                        endRadius: 250
                    )
                )
                .frame(width: 500, height: 500)
                .offset(x: -200, y: 400)
                .blur(radius: 80)
        }
    }
    
    // MARK: - Logo Section
    private var logoSection: some View {
        VStack(spacing: LTSpacing.lg) {
            // Logo icon with glow
            ZStack {
                // Glow effect
                Circle()
                    .fill(Color.emerald500.opacity(0.3))
                    .frame(width: 130, height: 130)
                    .blur(radius: 30)
                
                // Icon background
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
                        Image(systemName: "book.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.white)
                    )
                    .shadow(color: .emerald500.opacity(0.5), radius: 20, y: 10)
            }
            .scaleEffect(logoScale)
            .opacity(logoOpacity)
            
            VStack(spacing: LTSpacing.sm) {
                Text("LearnTrack")
                    .font(.ltDisplay)
                    .foregroundColor(.white)
                
                Text("Gestion de formations")
                    .font(.ltBody)
                    .foregroundColor(.slate400)
            }
            .opacity(logoOpacity)
        }
    }
    
    // MARK: - Form Section
    private var formSection: some View {
        VStack(spacing: LTSpacing.xl) {
            // Form card with glass effect
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
                
                // Password field
                VStack(alignment: .leading, spacing: LTSpacing.sm) {
                    Text("Mot de passe")
                        .font(.ltLabel)
                        .foregroundColor(.slate300)
                    
                    HStack(spacing: LTSpacing.md) {
                        Image(systemName: "lock.fill")
                            .font(.system(size: LTIconSize.md))
                            .foregroundColor(.emerald400)
                        
                        SecureField("", text: $password, prompt: Text("••••••••").foregroundColor(.slate500))
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
                
                // Error message
                if let errorMessage = errorMessage {
                    HStack(spacing: LTSpacing.sm) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: LTIconSize.sm))
                        Text(errorMessage)
                            .font(.ltCaption)
                    }
                    .foregroundColor(.error)
                    .padding(.horizontal, LTSpacing.md)
                    .padding(.vertical, LTSpacing.sm)
                    .background(Color.error.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: LTRadius.md))
                }
                
                // Login button
                Button(action: handleLogin) {
                    HStack(spacing: LTSpacing.sm) {
                        if isLoading {
                            LTSpinner(size: 20, lineWidth: 2, color: .white)
                        } else {
                            Text("Se connecter")
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
                            colors: canLogin ? [.emerald500, .emerald600] : [.slate600, .slate700],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: LTRadius.lg))
                    .shadow(color: canLogin ? .emerald500.opacity(0.4) : .clear, radius: 15, y: 8)
                }
                .disabled(isLoading || !canLogin)
                .scaleEffect(isLoading ? 0.98 : 1.0)
                .animation(.ltSpringSubtle, value: isLoading)
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
            
            // Links
            VStack(spacing: LTSpacing.md) {
                Button(action: { showResetPassword = true }) {
                    Text("Mot de passe oublié ?")
                        .font(.ltBodyMedium)
                        .foregroundColor(.emerald400)
                }
                
                HStack(spacing: LTSpacing.xs) {
                    Text("Pas encore de compte ?")
                        .font(.ltBody)
                        .foregroundColor(.slate400)
                    
                    Button(action: { showRegister = true }) {
                        Text("S'inscrire")
                            .font(.ltBodySemibold)
                            .foregroundColor(.emerald400)
                    }
                }
            }
            .opacity(formOpacity)
        }
    }
    
    // MARK: - Helpers
    private var canLogin: Bool {
        !email.isEmpty && !password.isEmpty
    }
    
    private func handleLogin() {
        errorMessage = nil
        isLoading = true
        
        // Haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        Task {
            do {
                try await authService.signIn(email: email, password: password)
            } catch {
                await MainActor.run {
                    errorMessage = "Email ou mot de passe incorrect"
                    isLoading = false
                    
                    // Error haptic
                    let notification = UINotificationFeedbackGenerator()
                    notification.notificationOccurred(.error)
                }
            }
        }
    }
    
    private func animateEntrance() {
        withAnimation(.ltSpringSmooth.delay(0.1)) {
            logoScale = 1.0
            logoOpacity = 1.0
        }
        
        withAnimation(.ltSpringSmooth.delay(0.3)) {
            formOffset = 0
            formOpacity = 1.0
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthService.shared)
}
