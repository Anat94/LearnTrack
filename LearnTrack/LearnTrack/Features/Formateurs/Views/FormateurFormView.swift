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
            ScrollView {
                VStack(spacing: 16) {
                    LT.SectionCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Identité").font(.headline)
                            TextField("Prénom", text: $prenom).textFieldStyle(LTTextFieldStyle())
                            TextField("Nom", text: $nom).textFieldStyle(LTTextFieldStyle())
                        }
                    }
                    LT.SectionCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Contact").font(.headline)
                            TextField("Email", text: $email)
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .textFieldStyle(LTTextFieldStyle())
                            TextField("Téléphone", text: $telephone)
                                .keyboardType(.phonePad)
                                .textFieldStyle(LTTextFieldStyle())
                        }
                    }
                    LT.SectionCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Informations professionnelles").font(.headline)
                            TextField("Spécialité", text: $specialite).textFieldStyle(LTTextFieldStyle())
                            TextField("Taux horaire (€)", text: $tauxHoraire).keyboardType(.decimalPad).textFieldStyle(LTTextFieldStyle())
                            Toggle("Formateur externe", isOn: $exterieur)
                        }
                    }
                    if exterieur {
                        LT.SectionCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Société").font(.headline)
                                TextField("Nom de la société", text: $societe).textFieldStyle(LTTextFieldStyle())
                                TextField("SIRET", text: $siret).textFieldStyle(LTTextFieldStyle())
                                TextField("NDA", text: $nda).textFieldStyle(LTTextFieldStyle())
                            }
                        }
                    }
                    LT.SectionCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Adresse").font(.headline)
                            TextField("Rue", text: $rue).textFieldStyle(LTTextFieldStyle())
                            TextField("Code postal", text: $codePostal).keyboardType(.numberPad).textFieldStyle(LTTextFieldStyle())
                            TextField("Ville", text: $ville).textFieldStyle(LTTextFieldStyle())
                        }
                    }
                    if showError && !errorMessage.isEmpty { Text(errorMessage).foregroundColor(LT.ColorToken.danger).font(.caption) }
                    Button(isEditing ? "Enregistrer" : "Créer") { saveFormateur() }.buttonStyle(LT.PrimaryButtonStyle())
                }
                .padding()
                .ltScreen()
            }
            .navigationTitle(isEditing ? "Modifier" : "Nouveau formateur")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Annuler") {
                        dismiss()
                    }
                }
                // Primary button integrated in content
            }
            .onAppear {
                if let formateur = formateurToEdit {
                    loadFormateurData(formateur)
                }
            }
            .alert("Erreur", isPresented: $showError) { Button("OK", role: .cancel) { } } message: { Text(errorMessage) }
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
