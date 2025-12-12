//
//  SessionFormView.swift
//  LearnTrack
//
//  Formulaire session - Design SaaS compact
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
    
    var isEditing: Bool { sessionToEdit != nil }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.ltBackground.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: LTSpacing.md) {
                        // Informations générales
                        LTFormSection(title: "Informations générales") {
                            LTFormField(label: "Module de formation", text: $module, placeholder: "Ex: Swift avancé")
                            
                            VStack(alignment: .leading, spacing: LTSpacing.xs) {
                                Text("Date")
                                    .font(.ltSmall)
                                    .foregroundColor(.ltTextSecondary)
                                DatePicker("", selection: $date, displayedComponents: .date)
                                    .datePickerStyle(.compact)
                                    .labelsHidden()
                                    .tint(.emerald500)
                            }
                            
                            HStack(spacing: LTSpacing.md) {
                                LTFormField(label: "Début", text: $debut, placeholder: "09:00")
                                LTFormField(label: "Fin", text: $fin, placeholder: "17:00")
                            }
                        }
                        
                        // Modalité
                        LTFormSection(title: "Modalité") {
                            Picker("Type", selection: $modalite) {
                                ForEach(Session.Modalite.allCases, id: \.self) { mode in
                                    Text(mode.label).tag(mode)
                                }
                            }
                            .pickerStyle(.segmented)
                            .tint(.emerald500)
                            
                            LTFormField(
                                label: modalite == .presentiel ? "Adresse" : "Lien visio",
                                text: $lieu,
                                placeholder: modalite == .presentiel ? "Adresse complète" : "URL de la visio"
                            )
                        }
                        
                        // Intervenants
                        LTFormSection(title: "Intervenants") {
                            NavigationLink(destination: LTFormateurPicker(
                                formateurs: formateurViewModel.formateurs,
                                selectedId: $selectedFormateurId
                            )) {
                                PickerRow(
                                    label: "Formateur",
                                    value: formateurViewModel.formateurs.first(where: { $0.id == selectedFormateurId })?.nomComplet
                                )
                            }
                            
                            NavigationLink(destination: LTClientPicker(
                                clients: clientViewModel.clients,
                                selectedId: $selectedClientId
                            )) {
                                PickerRow(
                                    label: "Client",
                                    value: clientViewModel.clients.first(where: { $0.id == selectedClientId })?.raisonSociale
                                )
                            }
                            
                            NavigationLink(destination: LTEcolePicker(
                                ecoles: ecoleViewModel.ecoles,
                                selectedId: $selectedEcoleId
                            )) {
                                PickerRow(
                                    label: "École",
                                    value: ecoleViewModel.ecoles.first(where: { $0.id == selectedEcoleId })?.nom
                                )
                            }
                        }
                        
                        // Tarifs
                        LTFormSection(title: "Tarifs (€)") {
                            LTFormField(label: "Tarif client", text: $tarifClient, placeholder: "0.00", keyboardType: .decimalPad)
                            LTFormField(label: "Tarif sous-traitant", text: $tarifSousTraitant, placeholder: "0.00", keyboardType: .decimalPad)
                            LTFormField(label: "Frais à rembourser", text: $fraisRembourser, placeholder: "0.00", keyboardType: .decimalPad)
                        }
                        
                        // Référence
                        LTFormSection(title: "Référence") {
                            LTFormField(label: "Référence contrat", text: $refContrat, placeholder: "Optionnel")
                        }
                        
                        // Bouton
                        LTButton(
                            isEditing ? "Enregistrer" : "Créer",
                            variant: .primary,
                            icon: isEditing ? "checkmark" : "plus",
                            isFullWidth: true,
                            isLoading: isLoading,
                            isDisabled: module.isEmpty
                        ) {
                            saveSession()
                        }
                        .padding(.top, LTSpacing.md)
                    }
                    .padding(.horizontal, LTSpacing.lg)
                    .padding(.top, LTSpacing.md)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle(isEditing ? "Modifier" : "Nouvelle session")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Annuler") { dismiss() }
                        .foregroundColor(.ltText)
                        .font(.ltBody)
                }
            }
            .task {
                await formateurViewModel.fetchFormateurs()
                await clientViewModel.fetchClients()
                await ecoleViewModel.fetchEcoles()
                
                if let s = sessionToEdit { loadData(s) }
            }
            .alert("Erreur", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func loadData(_ s: Session) {
        module = s.module
        date = s.date
        debut = s.debut
        fin = s.fin
        modalite = s.modalite
        lieu = s.lieu
        tarifClient = "\(s.tarifClient)"
        tarifSousTraitant = "\(s.tarifSousTraitant)"
        fraisRembourser = "\(s.fraisRembourser)"
        refContrat = s.refContrat ?? ""
        selectedFormateurId = s.formateurId
        selectedClientId = s.clientId
        selectedEcoleId = s.ecoleId
    }
    
    private func saveSession() {
        isLoading = true
        
        guard let tc = Decimal(string: tarifClient),
              let ts = Decimal(string: tarifSousTraitant),
              let fr = Decimal(string: fraisRembourser) else {
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
            tarifClient: tc,
            tarifSousTraitant: ts,
            fraisRembourser: fr,
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

// MARK: - Picker Row
struct PickerRow: View {
    let label: String
    let value: String?
    
    var body: some View {
        HStack {
            Text(label)
                .font(.ltBody)
                .foregroundColor(.ltText)
            
            Spacer()
            
            Text(value ?? "Sélectionner")
                .font(.ltCaption)
                .foregroundColor(.ltTextSecondary)
            
            Image(systemName: "chevron.right")
                .font(.system(size: LTIconSize.xs))
                .foregroundColor(.ltTextTertiary)
        }
        .padding(LTSpacing.md)
        .background(Color.ltBackgroundSecondary)
        .clipShape(RoundedRectangle(cornerRadius: LTRadius.md))
    }
}

// MARK: - Pickers
struct LTFormateurPicker: View {
    let formateurs: [Formateur]
    @Binding var selectedId: Int64?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.ltBackground.ignoresSafeArea()
            
            ScrollView {
                LazyVStack(spacing: LTSpacing.sm) {
                    ForEach(formateurs) { f in
                        Button(action: {
                            selectedId = f.id
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            dismiss()
                        }) {
                            HStack {
                                LTAvatar(initials: f.initiales, size: .small, color: .emerald500)
                                
                                VStack(alignment: .leading, spacing: LTSpacing.xxs) {
                                    Text(f.nomComplet)
                                        .font(.ltBodyMedium)
                                        .foregroundColor(.ltText)
                                    Text(f.specialite)
                                        .font(.ltSmall)
                                        .foregroundColor(.ltTextSecondary)
                                }
                                
                                Spacer()
                                
                                if selectedId == f.id {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.emerald500)
                                        .font(.system(size: LTIconSize.md))
                                }
                            }
                            .padding(LTSpacing.md)
                            .background(Color.ltCard)
                            .clipShape(RoundedRectangle(cornerRadius: LTRadius.lg))
                            .overlay(
                                RoundedRectangle(cornerRadius: LTRadius.lg)
                                    .stroke(selectedId == f.id ? Color.emerald500 : Color.ltBorderSubtle, lineWidth: selectedId == f.id ? 1.5 : 0.5)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(LTSpacing.lg)
            }
        }
        .navigationTitle("Sélectionner un formateur")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LTClientPicker: View {
    let clients: [Client]
    @Binding var selectedId: Int64?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.ltBackground.ignoresSafeArea()
            
            ScrollView {
                LazyVStack(spacing: LTSpacing.sm) {
                    ForEach(clients) { c in
                        Button(action: {
                            selectedId = c.id
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            dismiss()
                        }) {
                            HStack {
                                LTAvatar(initials: c.initiales, size: .small, color: .info)
                                
                                VStack(alignment: .leading, spacing: LTSpacing.xxs) {
                                    Text(c.raisonSociale)
                                        .font(.ltBodyMedium)
                                        .foregroundColor(.ltText)
                                    if !c.villeDisplay.isEmpty {
                                        Text(c.villeDisplay)
                                            .font(.ltSmall)
                                            .foregroundColor(.ltTextSecondary)
                                    }
                                }
                                
                                Spacer()
                                
                                if selectedId == c.id {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.emerald500)
                                        .font(.system(size: LTIconSize.md))
                                }
                            }
                            .padding(LTSpacing.md)
                            .background(Color.ltCard)
                            .clipShape(RoundedRectangle(cornerRadius: LTRadius.lg))
                            .overlay(
                                RoundedRectangle(cornerRadius: LTRadius.lg)
                                    .stroke(selectedId == c.id ? Color.emerald500 : Color.ltBorderSubtle, lineWidth: selectedId == c.id ? 1.5 : 0.5)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(LTSpacing.lg)
            }
        }
        .navigationTitle("Sélectionner un client")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LTEcolePicker: View {
    let ecoles: [Ecole]
    @Binding var selectedId: Int64?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.ltBackground.ignoresSafeArea()
            
            ScrollView {
                LazyVStack(spacing: LTSpacing.sm) {
                    ForEach(ecoles) { e in
                        Button(action: {
                            selectedId = e.id
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            dismiss()
                        }) {
                            HStack {
                                ZStack {
                                    Circle()
                                        .fill(Color.warning.opacity(0.15))
                                        .frame(width: LTHeight.avatarSmall, height: LTHeight.avatarSmall)
                                    Image(systemName: "graduationcap.fill")
                                        .font(.system(size: LTIconSize.sm))
                                        .foregroundColor(.warning)
                                }
                                
                                VStack(alignment: .leading, spacing: LTSpacing.xxs) {
                                    Text(e.nom)
                                        .font(.ltBodyMedium)
                                        .foregroundColor(.ltText)
                                    if !e.villeDisplay.isEmpty {
                                        Text(e.villeDisplay)
                                            .font(.ltSmall)
                                            .foregroundColor(.ltTextSecondary)
                                    }
                                }
                                
                                Spacer()
                                
                                if selectedId == e.id {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.emerald500)
                                        .font(.system(size: LTIconSize.md))
                                }
                            }
                            .padding(LTSpacing.md)
                            .background(Color.ltCard)
                            .clipShape(RoundedRectangle(cornerRadius: LTRadius.lg))
                            .overlay(
                                RoundedRectangle(cornerRadius: LTRadius.lg)
                                    .stroke(selectedId == e.id ? Color.emerald500 : Color.ltBorderSubtle, lineWidth: selectedId == e.id ? 1.5 : 0.5)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(LTSpacing.lg)
            }
        }
        .navigationTitle("Sélectionner une école")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SessionFormView(viewModel: SessionViewModel())
        .preferredColorScheme(.dark)
}
