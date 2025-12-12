//
//  EcoleFormView.swift
//  LearnTrack
//
//  Formulaire école - Design SaaS compact
//

import SwiftUI

struct EcoleFormView: View {
    @ObservedObject var viewModel: EcoleViewModel
    @Environment(\.dismiss) var dismiss
    
    var ecoleToEdit: Ecole?
    
    @State private var nom = ""
    @State private var nomContact = ""
    @State private var email = ""
    @State private var telephone = ""
    @State private var rue = ""
    @State private var codePostal = ""
    @State private var ville = ""
    
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    var isEditing: Bool { ecoleToEdit != nil }
    
    var body: some View {
        NavigationView {
            ZStack {
                LTGradientBackground()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: LTSpacing.md) {
                        // Établissement
                        LTFormSection(title: "Établissement") {
                            LTFormField(label: "Nom de l'école", text: $nom, placeholder: "Nom de l'établissement")
                        }
                        
                        // Contact
                        LTFormSection(title: "Contact") {
                            LTFormField(label: "Nom du contact", text: $nomContact, placeholder: "Prénom Nom")
                            LTFormField(label: "Email", text: $email, placeholder: "contact@ecole.com", keyboardType: .emailAddress)
                            LTFormField(label: "Téléphone", text: $telephone, placeholder: "0123456789", keyboardType: .phonePad)
                        }
                        
                        // Adresse
                        LTFormSection(title: "Adresse") {
                            LTFormField(label: "Rue", text: $rue, placeholder: "123 rue de la Paix")
                            HStack(spacing: LTSpacing.md) {
                                LTFormField(label: "Code postal", text: $codePostal, placeholder: "75001", keyboardType: .numberPad)
                                LTFormField(label: "Ville", text: $ville, placeholder: "Paris")
                            }
                        }
                        
                        // Bouton
                        LTButton(
                            isEditing ? "Enregistrer" : "Créer",
                            variant: .primary,
                            icon: isEditing ? "checkmark" : "plus",
                            isFullWidth: true,
                            isLoading: isLoading,
                            isDisabled: nom.isEmpty || nomContact.isEmpty
                        ) {
                            saveEcole()
                        }
                        .padding(.top, LTSpacing.md)
                    }
                    .padding(.horizontal, LTSpacing.lg)
                    .padding(.top, LTSpacing.md)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle(isEditing ? "Modifier" : "Nouvelle école")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Annuler") { dismiss() }
                        .foregroundColor(.ltText)
                        .font(.ltBody)
                }
            }
            .onAppear {
                if let e = ecoleToEdit { loadData(e) }
            }
            .alert("Erreur", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func loadData(_ e: Ecole) {
        nom = e.nom
        nomContact = e.nomContact
        email = e.email
        telephone = e.telephone
        rue = e.rue ?? ""
        codePostal = e.codePostal ?? ""
        ville = e.ville ?? ""
    }
    
    private func saveEcole() {
        isLoading = true
        
        let ecole = Ecole(
            id: ecoleToEdit?.id,
            nom: nom,
            rue: rue.isEmpty ? nil : rue,
            codePostal: codePostal.isEmpty ? nil : codePostal,
            ville: ville.isEmpty ? nil : ville,
            nomContact: nomContact,
            email: email,
            telephone: telephone
        )
        
        Task {
            do {
                if isEditing {
                    try await viewModel.updateEcole(ecole)
                } else {
                    try await viewModel.createEcole(ecole)
                }
                dismiss()
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    showError = true
                    isLoading = false
                }
            }
        }
    }
}

#Preview {
    EcoleFormView(viewModel: EcoleViewModel())
        .preferredColorScheme(.dark)
}
