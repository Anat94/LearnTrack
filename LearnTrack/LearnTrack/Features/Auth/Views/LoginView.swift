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
    
    var body: some View {
        NavigationView {
            ZStack {
                // Gradient de fond
                LinearGradient(
                    colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.4)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Spacer()
                    
                    // Logo et titre
                    VStack(spacing: 16) {
                        Image(systemName: "book.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.white)
                        
                        Text("LearnTrack")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Gestion de formations")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    Spacer()
                    
                    // Formulaire de connexion
                    VStack(spacing: 20) {
                        // Email
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Email", systemImage: "envelope")
                                .foregroundColor(.white)
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
                                .foregroundColor(.white)
                                .font(.subheadline)
                            
                            SecureField("", text: $password)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                        
                        // Message d'erreur
                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .font(.caption)
                                .foregroundColor(.red)
                                .padding(.horizontal)
                        }
                        
                        // Bouton de connexion
                        Button(action: handleLogin) {
                            HStack {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                } else {
                                    Text("Se connecter")
                                        .fontWeight(.semibold)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.white)
                            .foregroundColor(.blue)
                            .cornerRadius(12)
                        }
                        .disabled(isLoading || email.isEmpty || password.isEmpty)
                        .opacity((email.isEmpty || password.isEmpty) ? 0.6 : 1.0)
                        
                        // Mot de passe oublié
                        Button("Mot de passe oublié ?") {
                            showResetPassword = true
                        }
                        .font(.subheadline)
                        .foregroundColor(.white)
                    }
                    .padding(.horizontal, 32)
                    
                    Spacer()
                }
                .padding(.vertical, 40)
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showResetPassword) {
                ResetPasswordView()
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
            .background(Color.white.opacity(0.9))
            .cornerRadius(10)
            .foregroundColor(.black)
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthService.shared)
}
