//
//  ClientFormView.swift
//  LearnTrack
//
//  Formulaire client - Design SaaS compact
//

import SwiftUI

struct ClientFormView: View {
    @ObservedObject var viewModel: ClientViewModel
    @Environment(\.dismiss) var dismiss
    
    var clientToEdit: Client?
    
    @State private var raisonSociale = ""
    @State private var nomContact = ""
    @State private var email = ""
    @State private var telephone = ""
    @State private var rue = ""
    @State private var codePostal = ""
    @State private var ville = ""
    @State private var siret = ""
    @State private var numeroTva = ""
    
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    var isEditing: Bool { clientToEdit != nil }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.ltBackground.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: LTSpacing.md) {
                        // Entreprise
                        LTFormSection(title: "Entreprise") {
                            LTFormField(label: "Raison sociale", text: $raisonSociale, placeholder: "Nom de l'entreprise")
                        }
                        
                        // Contact
                        LTFormSection(title: "Contact principal") {
                            LTFormField(label: "Nom du contact", text: $nomContact, placeholder: "Prénom Nom")
                            LTFormField(label: "Email", text: $email, placeholder: "contact@entreprise.com", keyboardType: .emailAddress)
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
                        
                        // Infos fiscales
                        LTFormSection(title: "Informations fiscales") {
                            LTFormField(label: "SIRET", text: $siret, placeholder: "12345678900001", keyboardType: .numberPad)
                            LTFormField(label: "N° TVA intracommunautaire", text: $numeroTva, placeholder: "FR12345678901")
                        }
                        
                        // Bouton
                        LTButton(
                            isEditing ? "Enregistrer" : "Créer",
                            variant: .primary,
                            icon: isEditing ? "checkmark" : "plus",
                            isFullWidth: true,
                            isLoading: isLoading,
                            isDisabled: raisonSociale.isEmpty || nomContact.isEmpty
                        ) {
                            saveClient()
                        }
                        .padding(.top, LTSpacing.md)
                    }
                    .padding(.horizontal, LTSpacing.lg)
                    .padding(.top, LTSpacing.md)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle(isEditing ? "Modifier" : "Nouveau client")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Annuler") { dismiss() }
                        .foregroundColor(.ltText)
                        .font(.ltBody)
                }
            }
            .onAppear {
                if let c = clientToEdit { loadData(c) }
            }
            .alert("Erreur", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func loadData(_ c: Client) {
        raisonSociale = c.raisonSociale
        nomContact = c.nomContact
        email = c.email
        telephone = c.telephone
        rue = c.rue ?? ""
        codePostal = c.codePostal ?? ""
        ville = c.ville ?? ""
        siret = c.siret ?? ""
        numeroTva = c.numeroTva ?? ""
    }
    
    private func saveClient() {
        isLoading = true
        
        let client = Client(
            id: clientToEdit?.id,
            raisonSociale: raisonSociale,
            rue: rue.isEmpty ? nil : rue,
            codePostal: codePostal.isEmpty ? nil : codePostal,
            ville: ville.isEmpty ? nil : ville,
            nomContact: nomContact,
            email: email,
            telephone: telephone,
            siret: siret.isEmpty ? nil : siret,
            numeroTva: numeroTva.isEmpty ? nil : numeroTva
        )
        
        Task {
            do {
                if isEditing {
                    try await viewModel.updateClient(client)
                } else {
                    try await viewModel.createClient(client)
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
    ClientFormView(viewModel: ClientViewModel())
        .preferredColorScheme(.dark)
}
