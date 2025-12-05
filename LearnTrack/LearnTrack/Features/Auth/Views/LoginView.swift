//
//  LoginView.swift
//  LearnTrack
//
//  Écran de connexion
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
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [LT.ColorToken.primary.opacity(0.35), LT.ColorToken.secondary.opacity(0.35)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 28) {
                    Spacer()
                    
                    // Logo et titre
                    VStack(spacing: 14) {
                        ZStack {
                            Circle()
                                .fill(LT.ColorToken.surface.opacity(0.15))
                                .frame(width: 120, height: 120)
                            Image(systemName: "graduationcap.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 64, height: 64)
                                .foregroundColor(.white)
                        }
                        Text("LearnTrack")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Gestion de formations")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    
                    Spacer()
                    
                    // Formulaire de connexion
                    LT.SectionCard {
                        VStack(spacing: 18) {
                        // Email
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Email", systemImage: "envelope")
                                .foregroundColor(LT.ColorToken.textSecondary)
                                .font(.subheadline)
                            
                            TextField("", text: $email)
                                .textFieldStyle(CustomTextFieldStyle())
                                .textInputAutocapitalization(.never)
                                .keyboardType(.emailAddress)
                                .autocorrectionDisabled()
                        }
                        
                        // Mot de passe
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Mot de passe", systemImage: "lock")
                                .foregroundColor(LT.ColorToken.textSecondary)
                                .font(.subheadline)
                            
                            SecureField("", text: $password)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                        
                        // Message d'erreur
                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .font(.caption)
                                .foregroundColor(LT.ColorToken.danger)
                        }
                        
                        // Bouton de connexion
                        Button(action: handleLogin) {
                            HStack {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Text("Se connecter")
                                        .fontWeight(.semibold)
                                }
                            }
                        }
                        .buttonStyle(LT.PrimaryButtonStyle())
                        .disabled(isLoading || email.isEmpty || password.isEmpty)
                        .opacity((email.isEmpty || password.isEmpty) ? 0.6 : 1.0)
                        }
                        // Keep fields interactive at all times
                        
                        // Mot de passe oublié
                        HStack {
                            Button("Mot de passe oublié ?") { showResetPassword = true }
                                .font(.subheadline)
                                .foregroundColor(LT.ColorToken.secondary)
                            Spacer()
                            Button("Créer un compte") { showRegister = true }
                                .font(.subheadline).fontWeight(.semibold)
                                .foregroundColor(LT.ColorToken.primary)
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer()
                }
                .padding(.vertical, 40)
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showResetPassword) {
                ResetPasswordView()
            }
            .sheet(isPresented: $showRegister) {
                RegisterView()
                    .environmentObject(authService)
            }
        }
    }
    
    private func handleLogin() {
        errorMessage = nil
        isLoading = true
        
        Task {
            do {
                try await authService.signIn(email: email, password: password)
            } catch {
                await MainActor.run {
                    errorMessage = "Email ou mot de passe incorrect"
                    isLoading = false
                }
            }
        }
    }
}

// Style personnalisé pour les champs de texte
struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(LT.ColorToken.surface)
            .cornerRadius(LT.Metric.cornerM)
            .foregroundColor(LT.ColorToken.textPrimary)
            .overlay(
                RoundedRectangle(cornerRadius: LT.Metric.cornerM)
                    .stroke(LT.ColorToken.border.opacity(0.7), lineWidth: 1)
            )
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthService.shared)
}
