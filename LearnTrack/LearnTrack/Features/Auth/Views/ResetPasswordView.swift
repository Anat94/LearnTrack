//
//  ResetPasswordView.swift
//  LearnTrack
//
//  Écran de réinitialisation du mot de passe
//

import SwiftUI

struct ResetPasswordView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authService: AuthService
    
    @State private var email = ""
    @State private var isLoading = false
    @State private var showSuccess = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Icône
                ZStack {
                    Circle().fill(LT.ColorToken.primary.opacity(0.2)).frame(width: 120, height: 120)
                    Image(systemName: "envelope.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)
                        .foregroundColor(LT.ColorToken.primary)
                }
                .padding(.top, 40)
                
                Text("Réinitialiser le mot de passe")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Entrez votre adresse email pour recevoir un lien de réinitialisation")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Champ email
                LT.SectionCard {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Email", systemImage: "envelope")
                            .font(.subheadline)
                            .foregroundColor(LT.ColorToken.textSecondary)
                        TextField("votre@email.com", text: $email)
                            .textFieldStyle(CustomTextFieldStyle())
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled()
                    }
                }
                .padding(.horizontal)
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }
                
                if showSuccess {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("Email envoyé ! Vérifiez votre boîte de réception.")
                            .font(.subheadline)
                    }
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                
                // Bouton
                Button(action: handleReset) {
                    HStack {
                        if isLoading {
                            ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Envoyer le lien").fontWeight(.semibold)
                        }
                    }
                }
                .buttonStyle(LT.PrimaryButtonStyle())
                .disabled(isLoading || email.isEmpty)
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationBarItems(leading: Button("Annuler") { dismiss() })
            .ltScreen()
        }
    }
    
    private func handleReset() {
        errorMessage = nil
        isLoading = true
        
        Task {
            do {
                try await authService.resetPassword(email: email)
                await MainActor.run {
                    isLoading = false
                    showSuccess = true
                    
                    // Fermer après 2 secondes
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        dismiss()
                    }
                }
            } catch {
                await MainActor.run {
                    errorMessage = "Erreur lors de l'envoi de l'email"
                    isLoading = false
                }
            }
        }
    }
}

#Preview {
    ResetPasswordView()
        .environmentObject(AuthService.shared)
}
