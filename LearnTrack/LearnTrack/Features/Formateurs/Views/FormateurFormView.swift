//
//  FormateurFormView.swift
//  LearnTrack
//
//  Formulaire de création/modification de formateur
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
                        // Identité
                        FormSection(title: "Identité") {
                            FormField(label: "Prénom", text: $prenom, placeholder: "Prénom")
                            FormField(label: "Nom", text: $nom, placeholder: "Nom")
                        }
                        
                        // Contact
                        FormSection(title: "Contact") {
                            FormField(label: "Email", text: $email, placeholder: "email@domaine.com", keyboardType: .emailAddress)
                            FormField(label: "Téléphone", text: $telephone, placeholder: "01 23 45 67 89", keyboardType: .phonePad)
                        }
                        
                        // Informations professionnelles
                        FormSection(title: "Informations professionnelles") {
                            FormField(label: "Spécialité", text: $specialite, placeholder: "Ex: Swift, iOS")
                            FormField(label: "Taux horaire (€)", text: $tauxHoraire, placeholder: "50.00", keyboardType: .decimalPad)
                            
                            Toggle(isOn: $exterieur) {
                                HStack(spacing: 12) {
                                    Image(systemName: "person.badge.key.fill")
                                        .foregroundColor(theme.primaryGreen)
                                    Text("Formateur externe")
                                        .font(.winamaxBody())
                                        .foregroundColor(theme.textPrimary)
                                }
                            }
                            .tint(theme.primaryGreen)
                            .padding(.top, 8)
                        }
                        
                        // Société (si externe)
                        if exterieur {
                            FormSection(title: "Société") {
                                FormField(label: "Nom de la société", text: $societe, placeholder: "Nom de l'entreprise")
                                FormField(label: "SIRET", text: $siret, placeholder: "12345678900001", keyboardType: .numberPad)
                                FormField(label: "NDA", text: $nda, placeholder: "Numéro NDA")
                            }
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
                        Button(action: saveFormateur) {
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
                        .disabled(prenom.isEmpty || nom.isEmpty || isLoading)
                        .opacity((prenom.isEmpty || nom.isEmpty) ? 0.6 : 1.0)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    }
                    .padding(.top, 20)
                }
            }
            .navigationTitle(isEditing ? "Modifier" : "Nouveau formateur")
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
}
