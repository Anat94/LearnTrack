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
                BrandBackground()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 32) {
                        // Logo et titre
                        VStack(spacing: 12) {
                            Image(systemName: "book.closed.circle.fill")
                                .resizable()
                                .frame(width: 110, height: 110)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.brandCyan, .brandPink],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .shadow(color: .brandCyan.opacity(0.35), radius: 18, y: 12)
                            
                            VStack(spacing: 4) {
                                Text("LearnTrack")
                                    .font(.system(size: 38, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Text("Gestion de formations")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.75))
                            }
                        }
                        .padding(.top, 48)
                        
                        VStack(spacing: 20) {
                            // Email
                            VStack(alignment: .leading, spacing: 8) {
                                Label("Email", systemImage: "envelope")
                                    .foregroundColor(.white.opacity(0.85))
                                    .font(.subheadline)
                                
                                TextField("nom@domaine.com", text: $email)
                                    .keyboardType(.emailAddress)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                                    .padding(14)
                                    .background(Color.white.opacity(0.06))
                                    .neonBordered()
                                    .foregroundColor(.white)
                            }
                            
                            // Mot de passe
                            VStack(alignment: .leading, spacing: 8) {
                                Label("Mot de passe", systemImage: "lock")
                                    .foregroundColor(.white.opacity(0.85))
                                    .font(.subheadline)
                                
                                SecureField("••••••••", text: $password)
                                    .padding(14)
                                    .background(Color.white.opacity(0.06))
                                    .neonBordered()
                                    .foregroundColor(.white)
                            }
                            
                            // Message d'erreur
                            if let errorMessage = errorMessage {
                                Text(errorMessage)
                                    .font(.caption)
                                    .foregroundColor(.red.opacity(0.9))
                                    .padding(.top, 4)
                            }
                            
                            // Bouton de connexion
                            Button(action: handleLogin) {
                                HStack {
                                    if isLoading {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    } else {
                                        Image(systemName: "arrow.right.circle.fill")
                                        Text("Se connecter")
                                    }
                                }
                                .foregroundColor(.white)
                            }
                            .buttonStyle(PrimaryButtonStyle())
                            .disabled(isLoading || email.isEmpty || password.isEmpty)
                            .opacity((email.isEmpty || password.isEmpty) ? 0.6 : 1.0)
                            
                            HStack {
                                Button("Mot de passe oublié ?") {
                                    showResetPassword = true
                                }
                                
                                Spacer()
                                
                                Button("Créer un compte") {
                                    showRegister = true
                                }
                            }
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.9))
                        }
                        .padding(24)
                        .glassCard()
                        .padding(.horizontal, 24)
                        
                        Spacer(minLength: 24)
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
    LoginView()
        .environmentObject(AuthService.shared)
}
