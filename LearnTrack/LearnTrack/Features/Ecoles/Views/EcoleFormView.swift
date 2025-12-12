//
//  EcoleFormView.swift
//  LearnTrack
//
//  Formulaire de création/modification d'école
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
    
    var isEditing: Bool {
        ecoleToEdit != nil
    }
    
    @Environment(\.colorScheme) var colorScheme
    
    var theme: AppTheme {
        colorScheme == .dark ? .dark : .light
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                WinamaxBackground()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        // Établissement
                        FormSection(title: "Établissement") {
                            FormField(label: "Nom de l'école", text: $nom, placeholder: "Nom de l'établissement")
                        }
                        
                        // Contact
                        FormSection(title: "Contact") {
                            FormField(label: "Nom du contact", text: $nomContact, placeholder: "Prénom Nom")
                            FormField(label: "Email", text: $email, placeholder: "contact@ecole.com", keyboardType: .emailAddress)
                            FormField(label: "Téléphone", text: $telephone, placeholder: "01 23 45 67 89", keyboardType: .phonePad)
                        }
                        
                        // Adresse
                        FormSection(title: "Adresse") {
                            FormField(label: "Rue", text: $rue, placeholder: "123 rue de la Paix")
                            HStack(spacing: 12) {
                                FormField(label: "Code postal", text: $codePostal, placeholder: "75001", keyboardType: .numberPad)
                                FormField(label: "Ville", text: $ville, placeholder: "Paris")
                            }
                        }
                        
                        // Bouton
                        Button(action: saveEcole) {
                            HStack {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Text(isEditing ? "Enregistrer" : "Créer")
                                }
                            }
                        }
                        .buttonStyle(WinamaxPrimaryButton())
                        .disabled(nom.isEmpty || nomContact.isEmpty || isLoading)
                        .opacity((nom.isEmpty || nomContact.isEmpty) ? 0.6 : 1.0)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    }
                    .padding(.top, 20)
                }
            }
            .navigationTitle(isEditing ? "Modifier" : "Nouvelle école")
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
            .onAppear {
                if let ecole = ecoleToEdit {
                    loadEcoleData(ecole)
                }
            }
            .alert("Erreur", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func loadEcoleData(_ ecole: Ecole) {
        nom = ecole.nom
        nomContact = ecole.nomContact
        email = ecole.email
        telephone = ecole.telephone
        rue = ecole.rue ?? ""
        codePostal = ecole.codePostal ?? ""
        ville = ecole.ville ?? ""
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
}
