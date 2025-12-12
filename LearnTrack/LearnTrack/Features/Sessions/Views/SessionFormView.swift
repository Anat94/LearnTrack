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
                        // Informations générales
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Informations générales")
                                .font(.winamaxHeadline())
                                .foregroundColor(theme.textPrimary)
                                .padding(.horizontal, 4)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Module de formation")
                                    .font(.winamaxCaption())
                                    .foregroundColor(theme.textPrimary)
                                    .fontWeight(.semibold)
                                
                                TextField("Ex: Swift avancé", text: $module)
                                    .autocorrectionDisabled()
                                    .winamaxTextField()
                            }
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Date")
                                    .font(.winamaxCaption())
                                    .foregroundColor(theme.textPrimary)
                                    .fontWeight(.semibold)
                                
                                DatePicker("", selection: $date, displayedComponents: .date)
                                    .datePickerStyle(.compact)
                                    .labelsHidden()
                                    .padding(14)
                                    .background(theme.cardBackground)
                                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                                            .stroke(theme.borderColor, lineWidth: 1.5)
                                    )
                            }
                            
                            HStack(spacing: 12) {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Début")
                                        .font(.winamaxCaption())
                                        .foregroundColor(theme.textPrimary)
                                        .fontWeight(.semibold)
                                    
                                    TextField("09:00", text: $debut)
                                        .keyboardType(.numbersAndPunctuation)
                                        .winamaxTextField()
                                }
                                
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Fin")
                                        .font(.winamaxCaption())
                                        .foregroundColor(theme.textPrimary)
                                        .fontWeight(.semibold)
                                    
                                    TextField("17:00", text: $fin)
                                        .keyboardType(.numbersAndPunctuation)
                                        .winamaxTextField()
                                }
                            }
                        }
                        .winamaxCard()
                        .padding(.horizontal, 20)
                        
                        // Modalité
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Modalité")
                                .font(.winamaxHeadline())
                                .foregroundColor(theme.textPrimary)
                                .padding(.horizontal, 4)
                            
                            Picker("Type", selection: $modalite) {
                                ForEach(Session.Modalite.allCases, id: \.self) { mode in
                                    Text(mode.label).tag(mode)
                                }
                            }
                            .pickerStyle(.segmented)
                            .tint(theme.primaryGreen)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text(modalite == .presentiel ? "Adresse" : "Lien visio")
                                    .font(.winamaxCaption())
                                    .foregroundColor(theme.textPrimary)
                                    .fontWeight(.semibold)
                                
                                TextField(modalite == .presentiel ? "Adresse complète" : "URL de la visio", text: $lieu)
                                    .autocorrectionDisabled()
                                    .winamaxTextField()
                            }
                        }
                        .winamaxCard()
                        .padding(.horizontal, 20)
                        
                        // Intervenants
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Intervenants")
                                .font(.winamaxHeadline())
                                .foregroundColor(theme.textPrimary)
                                .padding(.horizontal, 4)
                            
                            VStack(spacing: 12) {
                                NavigationLink(destination: FormateurPickerView(
                                    formateurs: formateurViewModel.formateurs,
                                    selectedId: $selectedFormateurId
                                )) {
                                    HStack {
                                        Text("Formateur")
                                            .font(.winamaxBody())
                                            .foregroundColor(theme.textPrimary)
                                        
                                        Spacer()
                                        
                                        if let id = selectedFormateurId,
                                           let formateur = formateurViewModel.formateurs.first(where: { $0.id == id }) {
                                            Text(formateur.nomComplet)
                                                .font(.winamaxCaption())
                                                .foregroundColor(theme.textSecondary)
                                        } else {
                                            Text("Sélectionner")
                                                .font(.winamaxCaption())
                                                .foregroundColor(theme.textSecondary)
                                        }
                                        
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 12, weight: .semibold))
                                            .foregroundColor(theme.textSecondary)
                                    }
                                    .padding(14)
                                    .background(theme.cardBackground)
                                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                                            .stroke(theme.borderColor, lineWidth: 1.5)
                                    )
                                }
                                
                                NavigationLink(destination: ClientPickerView(
                                    clients: clientViewModel.clients,
                                    selectedId: $selectedClientId
                                )) {
                                    HStack {
                                        Text("Client")
                                            .font(.winamaxBody())
                                            .foregroundColor(theme.textPrimary)
                                        
                                        Spacer()
                                        
                                        if let id = selectedClientId,
                                           let client = clientViewModel.clients.first(where: { $0.id == id }) {
                                            Text(client.raisonSociale)
                                                .font(.winamaxCaption())
                                                .foregroundColor(theme.textSecondary)
                                        } else {
                                            Text("Sélectionner")
                                                .font(.winamaxCaption())
                                                .foregroundColor(theme.textSecondary)
                                        }
                                        
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 12, weight: .semibold))
                                            .foregroundColor(theme.textSecondary)
                                    }
                                    .padding(14)
                                    .background(theme.cardBackground)
                                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                                            .stroke(theme.borderColor, lineWidth: 1.5)
                                    )
                                }
                                
                                NavigationLink(destination: EcolePickerView(
                                    ecoles: ecoleViewModel.ecoles,
                                    selectedId: $selectedEcoleId
                                )) {
                                    HStack {
                                        Text("École")
                                            .font(.winamaxBody())
                                            .foregroundColor(theme.textPrimary)
                                        
                                        Spacer()
                                        
                                        if let id = selectedEcoleId,
                                           let ecole = ecoleViewModel.ecoles.first(where: { $0.id == id }) {
                                            Text(ecole.nom)
                                                .font(.winamaxCaption())
                                                .foregroundColor(theme.textSecondary)
                                        } else {
                                            Text("Sélectionner")
                                                .font(.winamaxCaption())
                                                .foregroundColor(theme.textSecondary)
                                        }
                                        
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 12, weight: .semibold))
                                            .foregroundColor(theme.textSecondary)
                                    }
                                    .padding(14)
                                    .background(theme.cardBackground)
                                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                                            .stroke(theme.borderColor, lineWidth: 1.5)
                                    )
                                }
                            }
                        }
                        .winamaxCard()
                        .padding(.horizontal, 20)
                        
                        // Tarifs
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Tarifs (€)")
                                .font(.winamaxHeadline())
                                .foregroundColor(theme.textPrimary)
                                .padding(.horizontal, 4)
                            
                            VStack(spacing: 12) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Tarif client")
                                        .font(.winamaxCaption())
                                        .foregroundColor(theme.textPrimary)
                                        .fontWeight(.semibold)
                                    
                                    TextField("0.00", text: $tarifClient)
                                        .keyboardType(.decimalPad)
                                        .winamaxTextField()
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Tarif sous-traitant")
                                        .font(.winamaxCaption())
                                        .foregroundColor(theme.textPrimary)
                                        .fontWeight(.semibold)
                                    
                                    TextField("0.00", text: $tarifSousTraitant)
                                        .keyboardType(.decimalPad)
                                        .winamaxTextField()
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Frais à rembourser")
                                        .font(.winamaxCaption())
                                        .foregroundColor(theme.textPrimary)
                                        .fontWeight(.semibold)
                                    
                                    TextField("0.00", text: $fraisRembourser)
                                        .keyboardType(.decimalPad)
                                        .winamaxTextField()
                                }
                            }
                        }
                        .winamaxCard()
                        .padding(.horizontal, 20)
                        
                        // Référence
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Référence")
                                .font(.winamaxHeadline())
                                .foregroundColor(theme.textPrimary)
                                .padding(.horizontal, 4)
                            
                            TextField("Référence contrat (optionnel)", text: $refContrat)
                                .autocorrectionDisabled()
                                .winamaxTextField()
                        }
                        .winamaxCard()
                        .padding(.horizontal, 20)
                        
                        // Bouton de sauvegarde
                        Button(action: saveSession) {
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
                        .disabled(module.isEmpty || isLoading)
                        .opacity(module.isEmpty ? 0.6 : 1.0)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    }
                    .padding(.top, 20)
                }
            }
            .navigationTitle(isEditing ? "Modifier" : "Nouvelle session")
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

// Pickers pour la sélection style Winamax
struct FormateurPickerView: View {
    let formateurs: [Formateur]
    @Binding var selectedId: Int64?
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    var theme: AppTheme {
        colorScheme == .dark ? .dark : .light
    }
    
    var body: some View {
        ZStack {
            WinamaxBackground()
            
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(formateurs) { formateur in
                        Button(action: {
                            selectedId = formateur.id
                            dismiss()
                        }) {
                            HStack {
                                Text(formateur.nomComplet)
                                    .font(.winamaxBody())
                                    .foregroundColor(theme.textPrimary)
                                
                                Spacer()
                                
                                if selectedId == formateur.id {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(theme.primaryGreen)
                                        .font(.system(size: 20))
                                }
                            }
                            .padding(16)
                            .winamaxCard()
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(20)
            }
        }
        .navigationTitle("Sélectionner un formateur")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ClientPickerView: View {
    let clients: [Client]
    @Binding var selectedId: Int64?
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    var theme: AppTheme {
        colorScheme == .dark ? .dark : .light
    }
    
    var body: some View {
        ZStack {
            WinamaxBackground()
            
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(clients) { client in
                        Button(action: {
                            selectedId = client.id
                            dismiss()
                        }) {
                            HStack {
                                Text(client.raisonSociale)
                                    .font(.winamaxBody())
                                    .foregroundColor(theme.textPrimary)
                                
                                Spacer()
                                
                                if selectedId == client.id {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(theme.primaryGreen)
                                        .font(.system(size: 20))
                                }
                            }
                            .padding(16)
                            .winamaxCard()
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(20)
            }
        }
        .navigationTitle("Sélectionner un client")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct EcolePickerView: View {
    let ecoles: [Ecole]
    @Binding var selectedId: Int64?
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    var theme: AppTheme {
        colorScheme == .dark ? .dark : .light
    }
    
    var body: some View {
        ZStack {
            WinamaxBackground()
            
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(ecoles) { ecole in
                        Button(action: {
                            selectedId = ecole.id
                            dismiss()
                        }) {
                            HStack {
                                Text(ecole.nom)
                                    .font(.winamaxBody())
                                    .foregroundColor(theme.textPrimary)
                                
                                Spacer()
                                
                                if selectedId == ecole.id {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(theme.primaryGreen)
                                        .font(.system(size: 20))
                                }
                            }
                            .padding(16)
                            .winamaxCard()
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(20)
            }
        }
        .navigationTitle("Sélectionner une école")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SessionFormView(viewModel: SessionViewModel())
}
