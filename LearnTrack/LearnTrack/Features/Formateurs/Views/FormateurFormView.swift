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
    
    var body: some View {
        NavigationView {
            ZStack {
                BrandBackground()
                
                Form {
                    Section("Identité") {
                        TextField("Prénom", text: $prenom)
                        TextField("Nom", text: $nom)
                    }
                    
                    Section("Contact") {
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                        
                        TextField("Téléphone", text: $telephone)
                            .keyboardType(.phonePad)
                    }
                    
                    Section("Informations professionnelles") {
                        TextField("Spécialité", text: $specialite)
                        
                        TextField("Taux horaire (€)", text: $tauxHoraire)
                            .keyboardType(.decimalPad)
                        
                        Toggle("Formateur externe", isOn: $exterieur)
                    }
                    
                    if exterieur {
                        Section("Société") {
                            TextField("Nom de la société", text: $societe)
                            TextField("SIRET", text: $siret)
                            TextField("NDA", text: $nda)
                        }
                    }
                    
                    Section("Adresse") {
                        TextField("Rue", text: $rue)
                        TextField("Code postal", text: $codePostal)
                            .keyboardType(.numberPad)
                        TextField("Ville", text: $ville)
                    }
                }
                .scrollContentBackground(.hidden)
                .listRowBackground(Color.white.opacity(0.06))
                .tint(.brandCyan)
            }
            .navigationTitle(isEditing ? "Modifier" : "Nouveau formateur")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Annuler") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(isEditing ? "Enregistrer" : "Créer") {
                        saveFormateur()
                    }
                    .disabled(prenom.isEmpty || nom.isEmpty || isLoading)
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
