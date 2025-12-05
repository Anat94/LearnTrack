//
//  RegisterView.swift
//  LearnTrack
//
//  Écran d'inscription
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authService: AuthService
    
    @State private var prenom = ""
    @State private var nom = ""
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var isValid: Bool {
        !prenom.isEmpty && !nom.isEmpty && !email.isEmpty && !password.isEmpty
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                LT.SectionCard {
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Identité").font(.headline).foregroundColor(LT.ColorToken.textPrimary)
                        LTIconTextField(systemImage: "person", placeholder: "Prénom", text: $prenom)
                        LTIconTextField(systemImage: "person", placeholder: "Nom", text: $nom)
                    }
                }
                .padding(.horizontal)

                LT.SectionCard {
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Compte").font(.headline).foregroundColor(LT.ColorToken.textPrimary)
                        LTIconTextField(systemImage: "envelope", placeholder: "Email", text: $email, keyboard: .emailAddress, autocap: .none)
                        LTIconSecureField(systemImage: "lock", placeholder: "Mot de passe", text: $password)
                    }
                }
                .padding(.horizontal)

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(LT.ColorToken.danger)
                        .padding(.horizontal)
                }

                Button(action: handleRegister) {
                    if isLoading { ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white)) } else { Text("S'inscrire").fontWeight(.semibold) }
                }
                .buttonStyle(LT.PrimaryButtonStyle())
                .padding(.horizontal)
                .disabled(!isValid || isLoading)

                Spacer()
            }
            .padding(.top, 16)
            .ltScreen()
            .navigationTitle("Créer un compte")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { Button("Annuler") { dismiss() } }
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
    RegisterView()
        .environmentObject(AuthService.shared)
}
