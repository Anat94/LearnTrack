//
//  ClientFormView.swift
//  LearnTrack
//
//  Formulaire de création/modification de client
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
            ScrollView {
                VStack(spacing: 16) {
                    LT.SectionCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Entreprise").font(.headline)
                            TextField("Raison sociale", text: $raisonSociale).textFieldStyle(LTTextFieldStyle())
                        }
                    }
                    LT.SectionCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Contact principal").font(.headline)
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
                    LT.SectionCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Informations fiscales").font(.headline)
                            TextField("SIRET", text: $siret).keyboardType(.numberPad).textFieldStyle(LTTextFieldStyle())
                            TextField("N° TVA intracommunautaire", text: $numeroTva).textFieldStyle(LTTextFieldStyle())
                        }
                    }
                    
                    if let errorMessage = errorMessage, showError {
                        Text(errorMessage).foregroundColor(LT.ColorToken.danger).font(.caption)
                    }
                    
                    Button(isEditing ? "Enregistrer" : "Créer") { saveClient() }
                        .buttonStyle(LT.PrimaryButtonStyle())
                }
                .padding()
                .ltScreen()
            }
            .navigationTitle(isEditing ? "Modifier" : "Nouveau client")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Annuler") {
                        dismiss()
                    }
                }
                // Primary action button integrated in content
            }
            .onAppear {
                if let client = clientToEdit {
                    loadClientData(client)
                }
            }
            .alert("Erreur", isPresented: $showError) { Button("OK", role: .cancel) { } } message: { Text(errorMessage) }
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

#Preview {
    ClientFormView(viewModel: ClientViewModel())
}
