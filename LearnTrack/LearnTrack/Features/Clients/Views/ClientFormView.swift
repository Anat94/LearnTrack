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
            Form {
                Section("Entreprise") {
                    TextField("Raison sociale", text: $raisonSociale)
                }
                
                Section("Contact principal") {
                    TextField("Nom du contact", text: $nomContact)
                    
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    
                    TextField("Téléphone", text: $telephone)
                        .keyboardType(.phonePad)
                }
                
                Section("Adresse") {
                    TextField("Rue", text: $rue)
                    TextField("Code postal", text: $codePostal)
                        .keyboardType(.numberPad)
                    TextField("Ville", text: $ville)
                }
                
                Section("Informations fiscales") {
                    TextField("SIRET", text: $siret)
                        .keyboardType(.numberPad)
                    TextField("N° TVA intracommunautaire", text: $numeroTva)
                }
            }
            .navigationTitle(isEditing ? "Modifier" : "Nouveau client")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Annuler") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(isEditing ? "Enregistrer" : "Créer") {
                        saveClient()
                    }
                    .disabled(raisonSociale.isEmpty || nomContact.isEmpty || isLoading)
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

#Preview {
    ClientFormView(viewModel: ClientViewModel())
}
