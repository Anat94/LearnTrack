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
            Form {
                Section("Identité") {
                    TextField("Prénom", text: $prenom)
                    TextField("Nom", text: $nom)
                }
                
                Section("Compte") {
                    TextField("Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                    SecureField("Mot de passe", text: $password)
                }
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
            .navigationTitle("Créer un compte")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Annuler") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: handleRegister) {
                        if isLoading { ProgressView() } else { Text("S'inscrire") }
                    }
                    .disabled(!isValid || isLoading)
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
    RegisterView()
        .environmentObject(AuthService.shared)
}

