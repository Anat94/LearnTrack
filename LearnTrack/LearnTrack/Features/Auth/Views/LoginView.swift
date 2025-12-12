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
    @State private var appearAnimation = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [.slate900, .slate950],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // Decorative circles
                Circle()
                    .fill(Color.emerald500.opacity(0.15))
                    .frame(width: 300, height: 300)
                    .blur(radius: 60)
                    .offset(x: -100, y: -200)
                
                Circle()
                    .fill(Color.emerald600.opacity(0.1))
                    .frame(width: 250, height: 250)
                    .blur(radius: 50)
                    .offset(x: 150, y: 300)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: LTSpacing.xxl) {
                        Spacer(minLength: 60)
                        
                        // Logo
                        logoSection
                            .opacity(appearAnimation ? 1 : 0)
                            .offset(y: appearAnimation ? 0 : -20)
                        
                        // Form
                        formSection
                            .opacity(appearAnimation ? 1 : 0)
                            .offset(y: appearAnimation ? 0 : 20)
                        
                        // Links
                        linksSection
                            .opacity(appearAnimation ? 1 : 0)
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, LTSpacing.lg)
                }
            }
            .sheet(isPresented: $showResetPassword) {
                ResetPasswordView()
            }
            .sheet(isPresented: $showRegister) {
                RegisterView()
            }
            .onAppear {
                withAnimation(.ltSpringSmooth.delay(0.2)) {
                    appearAnimation = true
                }
            }
        }
    }
    
    // MARK: - Logo Section
    private var logoSection: some View {
        VStack(spacing: LTSpacing.lg) {
            Image("image")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: LTRadius.xl))
                .shadow(color: .emerald500.opacity(0.4), radius: 20, y: 10)
            
            VStack(spacing: LTSpacing.sm) {
                Text("LearnTrack")
                    .font(.ltH1)
                    .foregroundColor(.white)
                
                Text("Gestion de formations")
                    .font(.ltCaption)
                    .foregroundColor(.slate400)
            }
        }
    }
    
    // MARK: - Form Section
    private var formSection: some View {
        VStack(spacing: LTSpacing.xl) {
            // Email field
            VStack(alignment: .leading, spacing: LTSpacing.sm) {
                Text("Email")
                    .font(.ltLabel)
                    .foregroundColor(.slate300)
                
                HStack(spacing: LTSpacing.md) {
                    Image(systemName: "envelope.fill")
                        .font(.system(size: LTIconSize.md))
                        .foregroundColor(.slate400)
                    
                    TextField("nom@domaine.com", text: $email)
                        .font(.ltBody)
                        .foregroundColor(.white)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }
                .padding(.horizontal, LTSpacing.lg)
                .frame(height: LTHeight.inputLarge)
                .background(Color.slate800.opacity(0.5))
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
                        .foregroundColor(.slate400)
                    
                    SecureField("••••••••", text: $password)
                        .font(.ltBody)
                        .foregroundColor(.white)
                }
                .padding(.horizontal, LTSpacing.lg)
                .frame(height: LTHeight.inputLarge)
                .background(Color.slate800.opacity(0.5))
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
                        .foregroundColor(.error)
                    Text(errorMessage)
                        .font(.ltCaption)
                        .foregroundColor(.error)
                }
                .padding(LTSpacing.md)
                .background(Color.error.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: LTRadius.md))
            }
            
            // Login button
            LTButton(
                "Se connecter",
                variant: .primary,
                size: .large,
                icon: "arrow.right",
                isFullWidth: true,
                isLoading: isLoading
            ) {
                login()
            }
        }
        .padding(LTSpacing.xl)
        .background(
            RoundedRectangle(cornerRadius: LTRadius.xxl)
                .fill(Color.slate900.opacity(0.8))
                .overlay(
                    RoundedRectangle(cornerRadius: LTRadius.xxl)
                        .stroke(
                            LinearGradient(
                                colors: [.white.opacity(0.1), .clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
    }
    
    // MARK: - Links Section
    private var linksSection: some View {
        VStack(spacing: LTSpacing.lg) {
            Button(action: { showResetPassword = true }) {
                Text("Mot de passe oublié ?")
                    .font(.ltCaptionMedium)
                    .foregroundColor(.emerald400)
            }
            
            HStack(spacing: LTSpacing.xs) {
                Text("Pas encore de compte ?")
                    .font(.ltCaption)
                    .foregroundColor(.slate400)
                
                Button(action: { showRegister = true }) {
                    Text("S'inscrire")
                        .font(.ltCaptionMedium)
                        .foregroundColor(.emerald400)
                }
            }
        }
    }
    
    // MARK: - Login
    private func login() {
        errorMessage = nil
        
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Veuillez remplir tous les champs"
            return
        }
        
        isLoading = true
        
        Task {
            do {
                try await authService.signIn(email: email, password: password)
            } catch {
                errorMessage = "Email ou mot de passe incorrect"
            }
            isLoading = false
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthService.shared)
        .preferredColorScheme(.dark)
}
