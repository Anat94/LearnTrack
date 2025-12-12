//
//  FormateurFormView.swift
//  LearnTrack
//
//  Formulaire formateur - Design SaaS compact
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
    
    var isEditing: Bool { formateurToEdit != nil }
    
    var body: some View {
        NavigationView {
            ZStack {
                LTGradientBackground()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: LTSpacing.md) {
                        // Identité
                        LTFormSection(title: "Identité") {
                            LTFormField(label: "Prénom", text: $prenom, placeholder: "Prénom")
                            LTFormField(label: "Nom", text: $nom, placeholder: "Nom")
                        }
                        
                        // Contact
                        LTFormSection(title: "Contact") {
                            LTFormField(label: "Email", text: $email, placeholder: "email@domaine.com", keyboardType: .emailAddress)
                            LTFormField(label: "Téléphone", text: $telephone, placeholder: "0123456789", keyboardType: .phonePad)
                        }
                        
                        // Infos professionnelles
                        LTFormSection(title: "Informations professionnelles") {
                            LTFormField(label: "Spécialité", text: $specialite, placeholder: "Ex: Swift, iOS")
                            LTFormField(label: "Taux horaire (€)", text: $tauxHoraire, placeholder: "50.00", keyboardType: .decimalPad)
                            LTFormToggle(label: "Formateur externe", isOn: $exterieur, icon: "person.badge.key.fill")
                        }
                        
                        // Société (si externe)
                        if exterieur {
                            LTFormSection(title: "Société") {
                                LTFormField(label: "Nom de la société", text: $societe, placeholder: "Nom de l'entreprise")
                                LTFormField(label: "SIRET", text: $siret, placeholder: "12345678900001", keyboardType: .numberPad)
                                LTFormField(label: "NDA", text: $nda, placeholder: "Numéro NDA")
                            }
                            .transition(.opacity.combined(with: .move(edge: .top)))
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
                            isDisabled: prenom.isEmpty || nom.isEmpty
                        ) {
                            saveFormateur()
                        }
                        .padding(.top, LTSpacing.md)
                    }
                    .padding(.horizontal, LTSpacing.lg)
                    .padding(.top, LTSpacing.md)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle(isEditing ? "Modifier" : "Nouveau formateur")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Annuler") { dismiss() }
                        .foregroundColor(.ltText)
                        .font(.ltBody)
                }
            }
            .onAppear {
                if let f = formateurToEdit { loadData(f) }
            }
            .alert("Erreur", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func loadData(_ f: Formateur) {
        prenom = f.prenom
        nom = f.nom
        email = f.email
        telephone = f.telephone
        specialite = f.specialite
        tauxHoraire = "\(f.tauxHoraire)"
        exterieur = f.exterieur
        societe = f.societe ?? ""
        siret = f.siret ?? ""
        nda = f.nda ?? ""
        rue = f.rue ?? ""
        codePostal = f.codePostal ?? ""
        ville = f.ville ?? ""
    }
    
    private func saveFormateur() {
        isLoading = true
        
        guard let tauxValue = Decimal(string: tauxHoraire) else {
            errorMessage = "Veuillez saisir un taux horaire valide"
            showError = true
            isLoading = false
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
    FormateurFormView(viewModel: FormateurViewModel())
        .preferredColorScheme(.dark)
}
