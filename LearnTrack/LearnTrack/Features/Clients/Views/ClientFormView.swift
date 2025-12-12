//
//  ClientFormView.swift
//  LearnTrack
//
//  Formulaire de création/modification de client - Design Emerald
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
    
    var isEditing: Bool {
        clientToEdit != nil
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.ltBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: LTSpacing.lg) {
                        // Company
                        companySection
                        
                        // Contact
                        contactSection
                        
                        // Address
                        addressSection
                        
                        // Fiscal
                        fiscalSection
                        
                        // Error
                        if showError && !errorMessage.isEmpty {
                            errorBanner
                        }
                        
                        // Submit
                        submitButton
                        
                        Spacer(minLength: 40)
                    }
                    .padding(LTSpacing.lg)
                }
            }
            .navigationTitle(isEditing ? "Modifier" : "Nouveau client")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Annuler") {
                        dismiss()
                    }
                    .foregroundColor(.emerald500)
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
    
    // MARK: - Company Section
    private var companySection: some View {
        LTFormSection(title: "Entreprise", icon: "building.2.fill") {
            LTTextField(
                label: "Raison sociale",
                placeholder: "Acme Corporation",
                text: $raisonSociale,
                icon: "building"
            )
        }
    }
    
    // MARK: - Contact Section
    private var contactSection: some View {
        LTFormSection(title: "Contact principal", icon: "person.fill") {
            VStack(spacing: LTSpacing.md) {
                LTTextField(
                    label: "Nom du contact",
                    placeholder: "Marie Martin",
                    text: $nomContact,
                    icon: "person"
                )
                
                LTTextField(
                    label: "Email",
                    placeholder: "contact@acme.com",
                    text: $email,
                    icon: "envelope",
                    keyboardType: .emailAddress,
                    autocapitalization: .never
                )
                
                LTTextField(
                    label: "Téléphone",
                    placeholder: "01 23 45 67 89",
                    text: $telephone,
                    icon: "phone",
                    keyboardType: .phonePad
                )
            }
        }
    }
    
    // MARK: - Address Section
    private var addressSection: some View {
        LTFormSection(title: "Adresse", icon: "mappin.circle.fill") {
            VStack(spacing: LTSpacing.md) {
                LTTextField(
                    label: "Rue",
                    placeholder: "123 avenue des Champs-Élysées",
                    text: $rue,
                    icon: "house"
                )
                
                HStack(spacing: LTSpacing.md) {
                    LTTextField(
                        label: "Code postal",
                        placeholder: "75008",
                        text: $codePostal,
                        keyboardType: .numberPad
                    )
                    
                    LTTextField(
                        label: "Ville",
                        placeholder: "Paris",
                        text: $ville
                    )
                }
            }
        }
    }
    
    // MARK: - Fiscal Section
    private var fiscalSection: some View {
        LTFormSection(title: "Informations fiscales", icon: "doc.text.fill") {
            VStack(spacing: LTSpacing.md) {
                LTTextField(
                    label: "SIRET",
                    placeholder: "123 456 789 00001",
                    text: $siret,
                    icon: "number",
                    keyboardType: .numberPad
                )
                
                LTTextField(
                    label: "N° TVA intracommunautaire",
                    placeholder: "FR 12 345678901",
                    text: $numeroTva,
                    icon: "eurosign"
                )
            }
        }
    }
    
    // MARK: - Error Banner
    private var errorBanner: some View {
        HStack(spacing: LTSpacing.sm) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: LTIconSize.md))
            Text(errorMessage)
                .font(.ltCaption)
        }
        .foregroundColor(.error)
        .padding(LTSpacing.md)
        .frame(maxWidth: .infinity)
        .background(Color.error.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: LTRadius.md))
    }
    
    // MARK: - Submit Button
    private var submitButton: some View {
        LTButton(
            isEditing ? "Enregistrer les modifications" : "Créer le client",
            variant: .primary,
            icon: isEditing ? "checkmark" : "plus",
            isFullWidth: true,
            isLoading: isLoading
        ) {
            saveClient()
        }
        .padding(.top, LTSpacing.md)
    }
    
    // MARK: - Helpers
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
        
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
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
                
                let notification = UINotificationFeedbackGenerator()
                notification.notificationOccurred(.success)
                
                dismiss()
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    showError = true
                    isLoading = false
                    
                    let notification = UINotificationFeedbackGenerator()
                    notification.notificationOccurred(.error)
                }
            }
        }
    }
}

#Preview {
    ClientFormView(viewModel: ClientViewModel())
}
