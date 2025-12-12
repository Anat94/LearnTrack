//
//  ClientFormView.swift
//  LearnTrack
//
//  Formulaire de création/modification de client style Winamax
//

import SwiftUI

struct ClientFormView: View {
    @ObservedObject var viewModel: ClientViewModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
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
    
    var theme: AppTheme {
        colorScheme == .dark ? .dark : .light
    }
    
    var isEditing: Bool {
        clientToEdit != nil
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                WinamaxBackground()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        // Entreprise
                        FormSection(title: "Entreprise") {
                            FormField(label: "Raison sociale", text: $raisonSociale, placeholder: "Nom de l'entreprise")
                        }
                        
                        // Contact
                        FormSection(title: "Contact principal") {
                            FormField(label: "Nom du contact", text: $nomContact, placeholder: "Prénom Nom")
                            FormField(label: "Email", text: $email, placeholder: "contact@entreprise.com", keyboardType: .emailAddress)
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
                        
                        // Informations fiscales
                        FormSection(title: "Informations fiscales") {
                            FormField(label: "SIRET", text: $siret, placeholder: "12345678900001", keyboardType: .numberPad)
                            FormField(label: "N° TVA intracommunautaire", text: $numeroTva, placeholder: "FR12345678901")
                        }
                        
                        // Bouton
                        Button(action: saveClient) {
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
                        .disabled(raisonSociale.isEmpty || nomContact.isEmpty || isLoading)
                        .opacity((raisonSociale.isEmpty || nomContact.isEmpty) ? 0.6 : 1.0)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    }
                    .padding(.top, 20)
                }
            }
            .navigationTitle(isEditing ? "Modifier" : "Nouveau client")
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
                if let client = clientToEdit {
                    loadClientData(client)
                }
            }
            .alert("Erreur", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func loadClientData(_ client: Client) {
        raisonSociale = client.raisonSociale
        nomContact = client.nomContact
        email = client.email
        telephone = client.telephone
        rue = client.rue ?? ""
        codePostal = client.codePostal ?? ""
        ville = client.ville ?? ""
        siret = client.siret ?? ""
        numeroTva = client.numeroTva ?? ""
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

// Helper pour les sections de formulaire
struct FormSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content
    @Environment(\.colorScheme) var colorScheme
    
    var theme: AppTheme {
        colorScheme == .dark ? .dark : .light
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.winamaxHeadline())
                .foregroundColor(theme.textPrimary)
                .padding(.horizontal, 4)
            
            content
        }
        .winamaxCard()
        .padding(.horizontal, 20)
    }
}

// Helper pour les champs de formulaire
struct FormField: View {
    let label: String
    @Binding var text: String
    var placeholder: String = ""
    var keyboardType: UIKeyboardType = .default
    @Environment(\.colorScheme) var colorScheme
    
    var theme: AppTheme {
        colorScheme == .dark ? .dark : .light
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.winamaxCaption())
                .foregroundColor(theme.textPrimary)
                .fontWeight(.semibold)
            
            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .textInputAutocapitalization(keyboardType == .emailAddress ? .never : .words)
                .autocorrectionDisabled(keyboardType == .emailAddress)
                .winamaxTextField()
        }
    }
}

#Preview {
    ClientFormView(viewModel: ClientViewModel())
        .preferredColorScheme(.dark)
}
