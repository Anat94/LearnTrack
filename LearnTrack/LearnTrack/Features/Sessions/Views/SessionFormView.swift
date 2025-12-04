//
//  SessionFormView.swift
//  LearnTrack
//
//  Formulaire de création/modification de session
//

import SwiftUI

struct SessionFormView: View {
    @ObservedObject var viewModel: SessionViewModel
    @Environment(\.dismiss) var dismiss
    
    var sessionToEdit: Session?
    
    @State private var module = ""
    @State private var date = Date()
    @State private var debut = "09:00"
    @State private var fin = "17:00"
    @State private var modalite: Session.Modalite = .presentiel
    @State private var lieu = ""
    @State private var tarifClient = ""
    @State private var tarifSousTraitant = ""
    @State private var fraisRembourser = ""
    @State private var refContrat = ""
    
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    @StateObject private var formateurViewModel = FormateurViewModel()
    @StateObject private var clientViewModel = ClientViewModel()
    @StateObject private var ecoleViewModel = EcoleViewModel()
    
    @State private var selectedFormateurId: Int64?
    @State private var selectedClientId: Int64?
    @State private var selectedEcoleId: Int64?
    
    var isEditing: Bool {
        sessionToEdit != nil
    }
    
    var body: some View {
        NavigationView {
            Form {
                // Module
                Section("Informations générales") {
                    TextField("Module de formation", text: $module)
                        .autocorrectionDisabled()
                    
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    
                    HStack {
                        Text("Début")
                        Spacer()
                        TextField("09:00", text: $debut)
                            .keyboardType(.numbersAndPunctuation)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                    }
                    
                    HStack {
                        Text("Fin")
                        Spacer()
                        TextField("17:00", text: $fin)
                            .keyboardType(.numbersAndPunctuation)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                    }
                }
                
                // Modalité et lieu
                Section("Modalité") {
                    Picker("Type", selection: $modalite) {
                        ForEach(Session.Modalite.allCases, id: \.self) { mode in
                            Text(mode.label).tag(mode)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    TextField(modalite == .presentiel ? "Adresse" : "Lien visio", text: $lieu)
                        .autocorrectionDisabled()
                }
                
                // Intervenants
                Section("Intervenants") {
                    NavigationLink(destination: FormateurPickerView(
                        formateurs: formateurViewModel.formateurs,
                        selectedId: $selectedFormateurId
                    )) {
                        HStack {
                            Text("Formateur")
                            Spacer()
                            if let id = selectedFormateurId,
                               let formateur = formateurViewModel.formateurs.first(where: { $0.id == id }) {
                                Text(formateur.nomComplet)
                                    .foregroundColor(.secondary)
                            } else {
                                Text("Sélectionner")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    NavigationLink(destination: ClientPickerView(
                        clients: clientViewModel.clients,
                        selectedId: $selectedClientId
                    )) {
                        HStack {
                            Text("Client")
                            Spacer()
                            if let id = selectedClientId,
                               let client = clientViewModel.clients.first(where: { $0.id == id }) {
                                Text(client.raisonSociale)
                                    .foregroundColor(.secondary)
                            } else {
                                Text("Sélectionner")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    NavigationLink(destination: EcolePickerView(
                        ecoles: ecoleViewModel.ecoles,
                        selectedId: $selectedEcoleId
                    )) {
                        HStack {
                            Text("École")
                            Spacer()
                            if let id = selectedEcoleId,
                               let ecole = ecoleViewModel.ecoles.first(where: { $0.id == id }) {
                                Text(ecole.nom)
                                    .foregroundColor(.secondary)
                            } else {
                                Text("Sélectionner")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                
                // Tarifs
                Section("Tarifs (€)") {
                    TextField("Tarif client", text: $tarifClient)
                        .keyboardType(.decimalPad)
                    
                    TextField("Tarif sous-traitant", text: $tarifSousTraitant)
                        .keyboardType(.decimalPad)
                    
                    TextField("Frais à rembourser", text: $fraisRembourser)
                        .keyboardType(.decimalPad)
                }
                
                // Référence
                Section("Référence") {
                    TextField("Référence contrat (optionnel)", text: $refContrat)
                        .autocorrectionDisabled()
                }
            }
            .navigationTitle(isEditing ? "Modifier" : "Nouvelle session")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Annuler") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(isEditing ? "Enregistrer" : "Créer") {
                        saveSession()
                    }
                    .disabled(module.isEmpty || isLoading)
                }
            }
            .task {
                await formateurViewModel.fetchFormateurs()
                await clientViewModel.fetchClients()
                await ecoleViewModel.fetchEcoles()
                
                if let session = sessionToEdit {
                    loadSessionData(session)
                }
            }
            .alert("Erreur", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func loadSessionData(_ session: Session) {
        module = session.module
        date = session.date
        debut = session.debut
        fin = session.fin
        modalite = session.modalite
        lieu = session.lieu
        tarifClient = "\(session.tarifClient)"
        tarifSousTraitant = "\(session.tarifSousTraitant)"
        fraisRembourser = "\(session.fraisRembourser)"
        refContrat = session.refContrat ?? ""
        selectedFormateurId = session.formateurId
        selectedClientId = session.clientId
        selectedEcoleId = session.ecoleId
    }
    
    private func saveSession() {
        isLoading = true
        
        guard let tarifClientValue = Decimal(string: tarifClient),
              let tarifSTValue = Decimal(string: tarifSousTraitant),
              let fraisValue = Decimal(string: fraisRembourser) else {
            errorMessage = "Veuillez saisir des montants valides"
            showError = true
            isLoading = false
            return
        }
        
        let session = Session(
            id: sessionToEdit?.id,
            module: module,
            date: date,
            debut: debut,
            fin: fin,
            modalite: modalite,
            lieu: lieu,
            tarifClient: tarifClientValue,
            tarifSousTraitant: tarifSTValue,
            fraisRembourser: fraisValue,
            refContrat: refContrat.isEmpty ? nil : refContrat,
            ecoleId: selectedEcoleId,
            clientId: selectedClientId,
            formateurId: selectedFormateurId
        )
        
        Task {
            do {
                if isEditing {
                    try await viewModel.updateSession(session)
                } else {
                    try await viewModel.createSession(session)
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

// Pickers pour la sélection
struct FormateurPickerView: View {
    let formateurs: [Formateur]
    @Binding var selectedId: Int64?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        List(formateurs) { formateur in
            Button(action: {
                selectedId = formateur.id
                dismiss()
            }) {
                HStack {
                    Text(formateur.nomComplet)
                    Spacer()
                    if selectedId == formateur.id {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                }
            }
            .foregroundColor(.primary)
        }
        .navigationTitle("Sélectionner un formateur")
    }
}

struct ClientPickerView: View {
    let clients: [Client]
    @Binding var selectedId: Int64?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        List(clients) { client in
            Button(action: {
                selectedId = client.id
                dismiss()
            }) {
                HStack {
                    Text(client.raisonSociale)
                    Spacer()
                    if selectedId == client.id {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                }
            }
            .foregroundColor(.primary)
        }
        .navigationTitle("Sélectionner un client")
    }
}

struct EcolePickerView: View {
    let ecoles: [Ecole]
    @Binding var selectedId: Int64?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        List(ecoles) { ecole in
            Button(action: {
                selectedId = ecole.id
                dismiss()
            }) {
                HStack {
                    Text(ecole.nom)
                    Spacer()
                    if selectedId == ecole.id {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                }
            }
            .foregroundColor(.primary)
        }
        .navigationTitle("Sélectionner une école")
    }
}

#Preview {
    SessionFormView(viewModel: SessionViewModel())
}
