//
//  RegisterView.swift
//  LearnTrack
//
//  Écran d'inscription - Design SaaS compact
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
            ZStack {
                // Background
                LinearGradient(
                    colors: [.slate900, .slate950],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: LTSpacing.xl) {
                        // Header
                        VStack(spacing: LTSpacing.sm) {
                            Text("Créer un compte")
                                .font(.ltH1)
                                .foregroundColor(.ltText)
                            
                            Text("Rejoignez LearnTrack")
                                .font(.ltCaption)
                                .foregroundColor(.ltTextSecondary)
                        }
                        .padding(.top, LTSpacing.xl)
                        
                        // Formulaire
                        LTCard {
                            VStack(spacing: LTSpacing.md) {
                                LTFormField(label: "Prénom", text: $prenom, placeholder: "Prénom")
                                LTFormField(label: "Nom", text: $nom, placeholder: "Nom")
                                LTFormField(label: "Email", text: $email, placeholder: "nom@domaine.com", keyboardType: .emailAddress)
                                LTFormField(label: "Mot de passe", text: $password, placeholder: "••••••••", isSecure: true)
                                
                                // Message d'erreur
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
                                
                                // Bouton
                                LTButton(
                                    "S'inscrire",
                                    variant: .primary,
                                    icon: "person.badge.plus",
                                    isFullWidth: true,
                                    isLoading: isLoading,
                                    isDisabled: !isValid
                                ) {
                                    handleRegister()
                                }
                                .padding(.top, LTSpacing.sm)
                            }
                        }
                        .padding(.horizontal, LTSpacing.lg)
                        
                        Spacer(minLength: 40)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Annuler") { dismiss() }
                        .foregroundColor(.ltText)
                        .font(.ltBody)
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
        .preferredColorScheme(.dark)
}
