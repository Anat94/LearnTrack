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
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    LT.SectionCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Établissement").font(.headline)
                            TextField("Nom de l'école", text: $nom).textFieldStyle(LTTextFieldStyle())
                        }
                    }
                    LT.SectionCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Contact").font(.headline)
                            TextField("Nom du contact", text: $nomContact).textFieldStyle(LTTextFieldStyle())
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
                            Text("Adresse").font(.headline)
                            TextField("Rue", text: $rue).textFieldStyle(LTTextFieldStyle())
                            TextField("Code postal", text: $codePostal).keyboardType(.numberPad).textFieldStyle(LTTextFieldStyle())
                            TextField("Ville", text: $ville).textFieldStyle(LTTextFieldStyle())
                        }
                    }
                    if let errorMessage = errorMessage, showError { Text(errorMessage).foregroundColor(LT.ColorToken.danger).font(.caption) }
                    Button(isEditing ? "Enregistrer" : "Créer") { saveEcole() }.buttonStyle(LT.PrimaryButtonStyle())
                }
                .padding()
                .ltScreen()
            }
            .navigationTitle(isEditing ? "Modifier" : "Nouvelle école")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Annuler") {
                        dismiss()
                    }
                }
                // Primary action integrated in content
            }
            .onAppear {
                if let ecole = ecoleToEdit {
                    loadEcoleData(ecole)
                }
            }
            .alert("Erreur", isPresented: $showError) { Button("OK", role: .cancel) { } } message: { Text(errorMessage) }
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
