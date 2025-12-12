//
//  RegisterView.swift
//  LearnTrack
//
//  Écran d'inscription style Winamax
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var authService: AuthService
    
    @State private var prenom = ""
    @State private var nom = ""
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var theme: AppTheme {
        colorScheme == .dark ? .dark : .light
    }
    
    var isValid: Bool {
        !prenom.isEmpty && !nom.isEmpty && !email.isEmpty && !password.isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                WinamaxBackground()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        // En-tête
                        VStack(spacing: 8) {
                            Text("Créer un compte")
                                .font(.winamaxTitle())
                                .foregroundColor(theme.textPrimary)
                            
                            Text("Rejoignez LearnTrack")
                                .font(.winamaxCaption())
                                .foregroundColor(theme.textSecondary)
                        }
                        .padding(.top, 20)
                        
                        // Formulaire
                        VStack(spacing: 20) {
                            // Prénom
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Prénom")
                                    .font(.winamaxCaption())
                                    .foregroundColor(theme.textPrimary)
                                    .fontWeight(.semibold)
                                
                                TextField("Prénom", text: $prenom)
                                    .winamaxTextField()
                            }
                            
                            // Nom
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Nom")
                                    .font(.winamaxCaption())
                                    .foregroundColor(theme.textPrimary)
                                    .fontWeight(.semibold)
                                
                                TextField("Nom", text: $nom)
                                    .winamaxTextField()
                            }
                            
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
                            
                            // Bouton d'inscription
                            Button(action: handleRegister) {
                                HStack {
                                    if isLoading {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    } else {
                                        Text("S'inscrire")
                                    }
                                }
                            }
                            .buttonStyle(WinamaxPrimaryButton())
                            .disabled(!isValid || isLoading)
                            .opacity(isValid ? 1.0 : 0.6)
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 24)
                        .winamaxCard()
                        .padding(.horizontal, 24)
                        
                        Spacer(minLength: 40)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Annuler") {
                        dismiss()
                    }
                    .foregroundColor(theme.textPrimary)
                    .font(.winamaxBody())
                }
            }
        }
    }
    
    private func handleRegister() {
        errorMessage = nil
        isLoading = true
        Task {
            do {
                try await authService.signUp(email: email, password: password, nom: nom, prenom: prenom)
                dismiss()
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    isLoading = false
                }
            }
        }
    }
}

#Preview {
    Group {
        RegisterView()
            .environmentObject(AuthService.shared)
            .preferredColorScheme(.light)
        
        RegisterView()
            .environmentObject(AuthService.shared)
            .preferredColorScheme(.dark)
    }
}
