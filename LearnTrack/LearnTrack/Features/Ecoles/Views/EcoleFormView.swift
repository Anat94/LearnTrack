//
//  EcoleFormView.swift
//  LearnTrack
//
//  Formulaire de création/modification d'école - Design Emerald
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
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.ltBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: LTSpacing.lg) {
                        // School info
                        schoolSection
                        
                        // Contact
                        contactSection
                        
                        // Address
                        addressSection
                        
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
            .navigationTitle(isEditing ? "Modifier" : "Nouvelle école")
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
    
    // MARK: - School Section
    private var schoolSection: some View {
        LTFormSection(title: "Établissement", icon: "graduationcap.fill") {
            LTTextField(
                label: "Nom de l'école",
                placeholder: "École Supérieure de Formation",
                text: $nom,
                icon: "building.columns"
            )
        }
    }
    
    // MARK: - Contact Section
    private var contactSection: some View {
        LTFormSection(title: "Contact", icon: "person.fill") {
            VStack(spacing: LTSpacing.md) {
                LTTextField(
                    label: "Nom du responsable",
                    placeholder: "Pierre Durand",
                    text: $nomContact,
                    icon: "person"
                )
                
                LTTextField(
                    label: "Email",
                    placeholder: "contact@ecole.fr",
                    text: $email,
                    icon: "envelope",
                    keyboardType: .emailAddress,
                    autocapitalization: .never
                )
                
                LTTextField(
                    label: "Téléphone",
                    placeholder: "01 45 67 89 01",
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
                    placeholder: "45 avenue des Sciences",
                    text: $rue,
                    icon: "house"
                )
                
                HStack(spacing: LTSpacing.md) {
                    LTTextField(
                        label: "Code postal",
                        placeholder: "75013",
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
            isEditing ? "Enregistrer les modifications" : "Créer l'école",
            variant: .primary,
            icon: isEditing ? "checkmark" : "plus",
            isFullWidth: true,
            isLoading: isLoading
        ) {
            saveEcole()
        }
        .padding(.top, LTSpacing.md)
    }
    
    // MARK: - Helpers
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
        
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
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
    EcoleFormView(viewModel: EcoleViewModel())
}
