//
//  FormateurFormView.swift
//  LearnTrack
//
//  Formulaire de création/modification de formateur - Design Emerald
//

import SwiftUI

struct FormateurFormView: View {
    @ObservedObject var viewModel: FormateurViewModel
    @Environment(\.dismiss) var dismiss
    
    var formateurToEdit: Formateur?
    
    @State private var prenom = ""
    @State private var nom = ""
    @State private var email = ""
    @State private var telephone = ""
    @State private var specialite = ""
    @State private var tauxHoraire = ""
    @State private var exterieur = false
    @State private var societe = ""
    @State private var siret = ""
    @State private var nda = ""
    @State private var rue = ""
    @State private var codePostal = ""
    @State private var ville = ""
    
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    var isEditing: Bool {
        formateurToEdit != nil
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.ltBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: LTSpacing.lg) {
                        // Identity
                        identitySection
                        
                        // Contact
                        contactSection
                        
                        // Professional info
                        professionalSection
                        
                        // Company (if external)
                        if exterieur {
                            companySection
                        }
                        
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
            .navigationTitle(isEditing ? "Modifier" : "Nouveau formateur")
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
                if let formateur = formateurToEdit {
                    loadFormateurData(formateur)
                }
            }
            .alert("Erreur", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    // MARK: - Identity Section
    private var identitySection: some View {
        LTFormSection(title: "Identité", icon: "person.fill") {
            HStack(spacing: LTSpacing.md) {
                LTTextField(
                    label: "Prénom",
                    placeholder: "Jean",
                    text: $prenom
                )
                
                LTTextField(
                    label: "Nom",
                    placeholder: "Dupont",
                    text: $nom
                )
            }
        }
    }
    
    // MARK: - Contact Section
    private var contactSection: some View {
        LTFormSection(title: "Contact", icon: "phone.fill") {
            VStack(spacing: LTSpacing.md) {
                LTTextField(
                    label: "Email",
                    placeholder: "jean.dupont@email.com",
                    text: $email,
                    icon: "envelope",
                    keyboardType: .emailAddress,
                    autocapitalization: .never
                )
                
                LTTextField(
                    label: "Téléphone",
                    placeholder: "06 12 34 56 78",
                    text: $telephone,
                    icon: "phone",
                    keyboardType: .phonePad
                )
            }
        }
    }
    
    // MARK: - Professional Section
    private var professionalSection: some View {
        LTFormSection(title: "Informations professionnelles", icon: "briefcase.fill") {
            VStack(spacing: LTSpacing.md) {
                LTTextField(
                    label: "Spécialité",
                    placeholder: "Swift, iOS, SwiftUI",
                    text: $specialite,
                    icon: "star"
                )
                
                LTTextField(
                    label: "Taux horaire (€)",
                    placeholder: "50",
                    text: $tauxHoraire,
                    icon: "eurosign",
                    keyboardType: .decimalPad
                )
                
                // External toggle
                HStack {
                    HStack(spacing: LTSpacing.md) {
                        ZStack {
                            Circle()
                                .fill(exterieur ? Color.warning.opacity(0.15) : Color.emerald500.opacity(0.15))
                                .frame(width: 36, height: 36)
                            
                            Image(systemName: exterieur ? "building.2.fill" : "person.badge.shield.checkmark.fill")
                                .font(.system(size: LTIconSize.md))
                                .foregroundColor(exterieur ? .warning : .emerald500)
                        }
                        
                        VStack(alignment: .leading, spacing: LTSpacing.xxs) {
                            Text("Formateur externe")
                                .font(.ltBodyMedium)
                                .foregroundColor(.ltText)
                            Text(exterieur ? "Sous-traitant" : "Employé interne")
                                .font(.ltCaption)
                                .foregroundColor(.ltTextSecondary)
                        }
                    }
                    
                    Spacer()
                    
                    Toggle("", isOn: $exterieur)
                        .tint(.emerald500)
                }
                .padding(LTSpacing.md)
                .background(Color.ltBackgroundSecondary)
                .clipShape(RoundedRectangle(cornerRadius: LTRadius.md))
            }
        }
        .animation(.ltSpringSmooth, value: exterieur)
    }
    
    // MARK: - Company Section
    private var companySection: some View {
        LTFormSection(title: "Société", icon: "building.2.fill") {
            VStack(spacing: LTSpacing.md) {
                LTTextField(
                    label: "Nom de la société",
                    placeholder: "Ma Société SARL",
                    text: $societe,
                    icon: "building"
                )
                
                LTTextField(
                    label: "SIRET",
                    placeholder: "123 456 789 00001",
                    text: $siret,
                    icon: "number"
                )
                
                LTTextField(
                    label: "NDA",
                    placeholder: "Numéro de déclaration d'activité",
                    text: $nda,
                    icon: "doc.text"
                )
            }
        }
        .transition(.opacity.combined(with: .move(edge: .top)))
    }
    
    // MARK: - Address Section
    private var addressSection: some View {
        LTFormSection(title: "Adresse", icon: "mappin.circle.fill") {
            VStack(spacing: LTSpacing.md) {
                LTTextField(
                    label: "Rue",
                    placeholder: "123 rue de la Formation",
                    text: $rue,
                    icon: "house"
                )
                
                HStack(spacing: LTSpacing.md) {
                    LTTextField(
                        label: "Code postal",
                        placeholder: "75001",
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
            isEditing ? "Enregistrer les modifications" : "Créer le formateur",
            variant: .primary,
            icon: isEditing ? "checkmark" : "plus",
            isFullWidth: true,
            isLoading: isLoading
        ) {
            saveFormateur()
        }
        .padding(.top, LTSpacing.md)
    }
    
    // MARK: - Helpers
    private func loadFormateurData(_ formateur: Formateur) {
        prenom = formateur.prenom
        nom = formateur.nom
        email = formateur.email
        telephone = formateur.telephone
        specialite = formateur.specialite
        tauxHoraire = "\(formateur.tauxHoraire)"
        exterieur = formateur.exterieur
        societe = formateur.societe ?? ""
        siret = formateur.siret ?? ""
        nda = formateur.nda ?? ""
        rue = formateur.rue ?? ""
        codePostal = formateur.codePostal ?? ""
        ville = formateur.ville ?? ""
    }
    
    private func saveFormateur() {
        isLoading = true
        
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        guard let tauxValue = Decimal(string: tauxHoraire) else {
            errorMessage = "Veuillez saisir un taux horaire valide"
            showError = true
            isLoading = false
            
            let notification = UINotificationFeedbackGenerator()
            notification.notificationOccurred(.error)
            return
        }
        
        let formateur = Formateur(
            id: formateurToEdit?.id,
            prenom: prenom,
            nom: nom,
            email: email,
            telephone: telephone,
            specialite: specialite,
            tauxHoraire: tauxValue,
            exterieur: exterieur,
            societe: societe.isEmpty ? nil : societe,
            siret: siret.isEmpty ? nil : siret,
            nda: nda.isEmpty ? nil : nda,
            rue: rue.isEmpty ? nil : rue,
            codePostal: codePostal.isEmpty ? nil : codePostal,
            ville: ville.isEmpty ? nil : ville
        )
        
        Task {
            do {
                if isEditing {
                    try await viewModel.updateFormateur(formateur)
                } else {
                    try await viewModel.createFormateur(formateur)
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
    FormateurFormView(viewModel: FormateurViewModel())
}
