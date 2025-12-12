//
//  LoginView.swift
//  LearnTrack
//
//  Écran de connexion style Winamax
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authService: AuthService
    @Environment(\.colorScheme) var colorScheme
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showResetPassword = false
    @State private var showRegister = false
    
    var theme: AppTheme {
        colorScheme == .dark ? .dark : .light
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                WinamaxBackground()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 32) {
                        Spacer(minLength: 40)
                        
                        VStack(spacing: 16) {
                            AppLogo(size: 120)
                            
                            VStack(spacing: 8) {
                                Text("LearnTrack")
                                    .font(.winamaxTitle())
                                    .foregroundColor(theme.textPrimary)
                                
                                Text("Gestion de formations")
                                    .font(.winamaxCaption())
                                    .foregroundColor(theme.textSecondary)
                            }
                        }
                        .padding(.top, 20)
                        
                        // Formulaire
                        VStack(spacing: 20) {
                            // Email
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Email")
                                    .font(.winamaxCaption())
                                    .foregroundColor(theme.textPrimary)
                                    .fontWeight(.semibold)
                                
                                TextField("nom@domaine.com", text: $email)
                                    .keyboardType(.emailAddress)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                                    .winamaxTextField()
                            }
                            
                            // Mot de passe
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Mot de passe")
                                    .font(.winamaxCaption())
                                    .foregroundColor(theme.textPrimary)
                                    .fontWeight(.semibold)
                                
                                SecureField("••••••••", text: $password)
                                    .winamaxTextField()
                            }
                            
                            // Message d'erreur
                            if let errorMessage = errorMessage {
                                HStack(spacing: 8) {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundColor(.red)
                                    Text(errorMessage)
                                        .font(.winamaxCaption())
                                        .foregroundColor(.red)
                                }
                                .padding(12)
                                .background(Color.red.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            
                            // Bouton de connexion
                            Button(action: handleLogin) {
                                HStack {
                                    if isLoading {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    } else {
                                        Text("Se connecter")
                                    }
                                }
                            }
                            .buttonStyle(WinamaxPrimaryButton())
                            .disabled(isLoading || email.isEmpty || password.isEmpty)
                            .opacity((email.isEmpty || password.isEmpty) ? 0.6 : 1.0)
                            
                            // Actions secondaires
                            HStack(spacing: 20) {
                                Button("Mot de passe oublié ?") {
                                    showResetPassword = true
                                }
                                .font(.winamaxCaption())
                                .foregroundColor(theme.primaryGreen)
                                
                                Spacer()
                                
                                Button("Créer un compte") {
                                    showRegister = true
                                }
                                .font(.winamaxCaption())
                                .foregroundColor(theme.accentOrange)
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 24)
                        .winamaxCard()
                        .padding(.horizontal, 24)
                        
                        Spacer(minLength: 40)
                    }
                }
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

#Preview {
    Group {
        LoginView()
            .environmentObject(AuthService.shared)
            .preferredColorScheme(.light)
        
        LoginView()
            .environmentObject(AuthService.shared)
            .preferredColorScheme(.dark)
    }
}
