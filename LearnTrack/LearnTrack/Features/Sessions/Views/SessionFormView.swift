//
//  SessionFormView.swift
//  LearnTrack
//
//  Formulaire de création/modification de session - Design Emerald
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
    
    @State private var selectedModaliteIndex = 0
    
    var isEditing: Bool {
        sessionToEdit != nil
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.ltBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: LTSpacing.lg) {
                        // General info
                        generalInfoSection
                        
                        // Modalité et lieu
                        modaliteSection
                        
                        // Intervenants
                        intervenantsSection
                        
                        // Tarifs
                        tarifsSection
                        
                        // Référence
                        referenceSection
                        
                        // Error message
                        if showError && !errorMessage.isEmpty {
                            errorBanner
                        }
                        
                        // Submit button
                        submitButton
                        
                        Spacer(minLength: 40)
                    }
                    .padding(LTSpacing.lg)
                }
            }
            .navigationTitle(isEditing ? "Modifier" : "Nouvelle session")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Annuler") {
                        dismiss()
                    }
                    .foregroundColor(.emerald500)
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
    
    // MARK: - General Info Section
    private var generalInfoSection: some View {
        LTFormSection(title: "Informations générales", icon: "info.circle.fill") {
            VStack(spacing: LTSpacing.md) {
                LTTextField(
                    label: "Module de formation",
                    placeholder: "Ex: Swift & SwiftUI Avancé",
                    text: $module
                )
                
                // Date picker styled
                VStack(alignment: .leading, spacing: LTSpacing.sm) {
                    Text("Date")
                        .font(.ltLabel)
                        .foregroundColor(.ltTextSecondary)
                    
                    DatePicker("", selection: $date, displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .labelsHidden()
                        .tint(.emerald500)
                }
                
                HStack(spacing: LTSpacing.md) {
                    LTTextField(
                        label: "Début",
                        placeholder: "09:00",
                        text: $debut,
                        keyboardType: .numbersAndPunctuation
                    )
                    
                    LTTextField(
                        label: "Fin",
                        placeholder: "17:00",
                        text: $fin,
                        keyboardType: .numbersAndPunctuation
                    )
                }
            }
        }
    }
    
    // MARK: - Modalité Section
    private var modaliteSection: some View {
        LTFormSection(title: "Modalité & Lieu", icon: "location.circle.fill") {
            VStack(spacing: LTSpacing.md) {
                LTSegmentedControl(
                    selectedIndex: $selectedModaliteIndex,
                    items: ["Présentiel", "Distanciel"]
                )
                .onChange(of: selectedModaliteIndex) { _, newValue in
                    modalite = newValue == 0 ? .presentiel : .distanciel
                }
                
                LTTextField(
                    label: modalite == .presentiel ? "Adresse" : "Lien visio",
                    placeholder: modalite == .presentiel ? "123 rue de la Formation, Paris" : "https://meet.google.com/...",
                    text: $lieu,
                    icon: modalite == .presentiel ? "mappin" : "video"
                )
            }
        }
    }
    
    // MARK: - Intervenants Section
    private var intervenantsSection: some View {
        LTFormSection(title: "Intervenants", icon: "person.3.fill") {
            VStack(spacing: LTSpacing.md) {
                // Formateur picker
                NavigationLink(destination: FormateurPickerViewNew(
                    formateurs: formateurViewModel.formateurs,
                    selectedId: $selectedFormateurId
                )) {
                    PickerRow(
                        label: "Formateur",
                        value: selectedFormateurId.flatMap { id in
                            formateurViewModel.formateurs.first { $0.id == id }?.nomComplet
                        } ?? "Sélectionner",
                        icon: "person.fill"
                    )
                }
                .buttonStyle(PlainButtonStyle())
                
                // Client picker
                NavigationLink(destination: ClientPickerViewNew(
                    clients: clientViewModel.clients,
                    selectedId: $selectedClientId
                )) {
                    PickerRow(
                        label: "Client",
                        value: selectedClientId.flatMap { id in
                            clientViewModel.clients.first { $0.id == id }?.raisonSociale
                        } ?? "Sélectionner",
                        icon: "building.2.fill"
                    )
                }
                .buttonStyle(PlainButtonStyle())
                
                // École picker
                NavigationLink(destination: EcolePickerViewNew(
                    ecoles: ecoleViewModel.ecoles,
                    selectedId: $selectedEcoleId
                )) {
                    PickerRow(
                        label: "École",
                        value: selectedEcoleId.flatMap { id in
                            ecoleViewModel.ecoles.first { $0.id == id }?.nom
                        } ?? "Sélectionner",
                        icon: "graduationcap.fill"
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    // MARK: - Tarifs Section
    private var tarifsSection: some View {
        LTFormSection(title: "Tarifs", icon: "eurosign.circle.fill") {
            VStack(spacing: LTSpacing.md) {
                LTTextField(
                    label: "Tarif client (€)",
                    placeholder: "1200",
                    text: $tarifClient,
                    icon: "eurosign",
                    keyboardType: .decimalPad
                )
                
                LTTextField(
                    label: "Tarif sous-traitant (€)",
                    placeholder: "800",
                    text: $tarifSousTraitant,
                    icon: "eurosign",
                    keyboardType: .decimalPad
                )
                
                LTTextField(
                    label: "Frais à rembourser (€)",
                    placeholder: "50",
                    text: $fraisRembourser,
                    icon: "eurosign",
                    keyboardType: .decimalPad
                )
            }
        }
    }
    
    // MARK: - Reference Section
    private var referenceSection: some View {
        LTFormSection(title: "Référence", icon: "doc.text.fill") {
            LTTextField(
                label: "Référence contrat (optionnel)",
                placeholder: "REF-2025-001",
                text: $refContrat,
                icon: "number"
            )
        }
    }
    
    // MARK: - Error Banner
    private var errorBanner: some View {
        HStack(spacing: LTSpacing.sm) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: LTIconSize.md))
            Text(errorMessage)
                .font(.ltCaption)
        }
        .foregroundColor(.error)
        .padding(LTSpacing.md)
        .frame(maxWidth: .infinity)
        .background(Color.error.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: LTRadius.md))
    }
    
    // MARK: - Submit Button
    private var submitButton: some View {
        LTButton(
            isEditing ? "Enregistrer les modifications" : "Créer la session",
            variant: .primary,
            icon: isEditing ? "checkmark" : "plus",
            isFullWidth: true,
            isLoading: isLoading
        ) {
            saveSession()
        }
        .padding(.top, LTSpacing.md)
    }
    
    // MARK: - Helpers
    private func loadSessionData(_ session: Session) {
        module = session.module
        date = session.date
        debut = session.debut
        fin = session.fin
        modalite = session.modalite
        selectedModaliteIndex = session.modalite == .presentiel ? 0 : 1
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
        
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        guard let tarifClientValue = Decimal(string: tarifClient),
              let tarifSTValue = Decimal(string: tarifSousTraitant),
              let fraisValue = Decimal(string: fraisRembourser) else {
            errorMessage = "Veuillez saisir des montants valides"
            showError = true
            isLoading = false
            
            let notification = UINotificationFeedbackGenerator()
            notification.notificationOccurred(.error)
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
                
                let notification = UINotificationFeedbackGenerator()
                notification.notificationOccurred(.success)
                
                dismiss()
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    showError = true
                    isLoading = false
                    
                    let notification = UINotificationFeedbackGenerator()
                    notification.notificationOccurred(.error)
                }
            }
        }
    }
}

// MARK: - Form Section Component
struct LTFormSection<Content: View>: View {
    let title: String
    let icon: String
    @ViewBuilder let content: Content
    
    var body: some View {
        LTCard {
            VStack(alignment: .leading, spacing: LTSpacing.lg) {
                HStack(spacing: LTSpacing.sm) {
                    Image(systemName: icon)
                        .font(.system(size: LTIconSize.md, weight: .semibold))
                        .foregroundColor(.emerald500)
                    
                    Text(title)
                        .font(.ltH4)
                        .foregroundColor(.ltText)
                }
                
                content
            }
        }
    }
}

// MARK: - Picker Row
private struct PickerRow: View {
    let label: String
    let value: String
    let icon: String
    
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: LTSpacing.md) {
            Image(systemName: icon)
                .font(.system(size: LTIconSize.md))
                .foregroundColor(.emerald500)
                .frame(width: 24)
            
            Text(label)
                .font(.ltBody)
                .foregroundColor(.ltText)
            
            Spacer()
            
            Text(value)
                .font(.ltBodyMedium)
                .foregroundColor(value == "Sélectionner" ? .ltTextTertiary : .ltText)
            
            Image(systemName: "chevron.right")
                .font(.system(size: LTIconSize.sm))
                .foregroundColor(.ltTextTertiary)
        }
        .padding(LTSpacing.md)
        .background(Color.ltBackgroundSecondary)
        .clipShape(RoundedRectangle(cornerRadius: LTRadius.md))
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.ltSpringSubtle, value: isPressed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}

// MARK: - Picker Views (Redesigned)
struct FormateurPickerViewNew: View {
    let formateurs: [Formateur]
    @Binding var selectedId: Int64?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.ltBackground
                .ignoresSafeArea()
            
            ScrollView {
                LazyVStack(spacing: LTSpacing.sm) {
                    ForEach(formateurs) { formateur in
                        Button(action: {
                            selectedId = formateur.id
                            let impact = UIImpactFeedbackGenerator(style: .light)
                            impact.impactOccurred()
                            dismiss()
                        }) {
                            HStack(spacing: LTSpacing.md) {
                                LTAvatar(
                                    initials: formateur.initiales,
                                    size: .small,
                                    color: formateur.exterieur ? .warning : .emerald500
                                )
                                
                                VStack(alignment: .leading, spacing: LTSpacing.xxs) {
                                    Text(formateur.nomComplet)
                                        .font(.ltBodyMedium)
                                        .foregroundColor(.ltText)
                                    Text(formateur.specialite)
                                        .font(.ltCaption)
                                        .foregroundColor(.ltTextSecondary)
                                }
                                
                                Spacer()
                                
                                if selectedId == formateur.id {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: LTIconSize.lg))
                                        .foregroundColor(.emerald500)
                                }
                            }
                            .padding(LTSpacing.md)
                            .background(selectedId == formateur.id ? Color.emerald50 : Color.ltCard)
                            .clipShape(RoundedRectangle(cornerRadius: LTRadius.lg))
                            .overlay(
                                RoundedRectangle(cornerRadius: LTRadius.lg)
                                    .stroke(
                                        selectedId == formateur.id ? Color.emerald500 : Color.ltBorderSubtle,
                                        lineWidth: selectedId == formateur.id ? 2 : 1
                                    )
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

struct ClientPickerViewNew: View {
    let clients: [Client]
    @Binding var selectedId: Int64?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.ltBackground
                .ignoresSafeArea()
            
            ScrollView {
                LazyVStack(spacing: LTSpacing.sm) {
                    ForEach(clients) { client in
                        Button(action: {
                            selectedId = client.id
                            let impact = UIImpactFeedbackGenerator(style: .light)
                            impact.impactOccurred()
                            dismiss()
                        }) {
                            HStack(spacing: LTSpacing.md) {
                                LTAvatar(
                                    initials: client.initiales,
                                    size: .small,
                                    color: .info
                                )
                                
                                VStack(alignment: .leading, spacing: LTSpacing.xxs) {
                                    Text(client.raisonSociale)
                                        .font(.ltBodyMedium)
                                        .foregroundColor(.ltText)
                                    Text(client.villeDisplay)
                                        .font(.ltCaption)
                                        .foregroundColor(.ltTextSecondary)
                                }
                                
                                Spacer()
                                
                                if selectedId == client.id {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: LTIconSize.lg))
                                        .foregroundColor(.emerald500)
                                }
                            }
                            .padding(LTSpacing.md)
                            .background(selectedId == client.id ? Color.emerald50 : Color.ltCard)
                            .clipShape(RoundedRectangle(cornerRadius: LTRadius.lg))
                            .overlay(
                                RoundedRectangle(cornerRadius: LTRadius.lg)
                                    .stroke(
                                        selectedId == client.id ? Color.emerald500 : Color.ltBorderSubtle,
                                        lineWidth: selectedId == client.id ? 2 : 1
                                    )
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

struct EcolePickerViewNew: View {
    let ecoles: [Ecole]
    @Binding var selectedId: Int64?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.ltBackground
                .ignoresSafeArea()
            
            ScrollView {
                LazyVStack(spacing: LTSpacing.sm) {
                    ForEach(ecoles) { ecole in
                        Button(action: {
                            selectedId = ecole.id
                            let impact = UIImpactFeedbackGenerator(style: .light)
                            impact.impactOccurred()
                            dismiss()
                        }) {
                            HStack(spacing: LTSpacing.md) {
                                ZStack {
                                    Circle()
                                        .fill(Color.emerald100)
                                        .frame(width: LTHeight.avatarSmall, height: LTHeight.avatarSmall)
                                    
                                    Image(systemName: "graduationcap.fill")
                                        .font(.system(size: LTIconSize.md))
                                        .foregroundColor(.emerald600)
                                }
                                
                                VStack(alignment: .leading, spacing: LTSpacing.xxs) {
                                    Text(ecole.nom)
                                        .font(.ltBodyMedium)
                                        .foregroundColor(.ltText)
                                    if let ville = ecole.ville {
                                        Text(ville)
                                            .font(.ltCaption)
                                            .foregroundColor(.ltTextSecondary)
                                    }
                                }
                                
                                Spacer()
                                
                                if selectedId == ecole.id {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: LTIconSize.lg))
                                        .foregroundColor(.emerald500)
                                }
                            }
                            .padding(LTSpacing.md)
                            .background(selectedId == ecole.id ? Color.emerald50 : Color.ltCard)
                            .clipShape(RoundedRectangle(cornerRadius: LTRadius.lg))
                            .overlay(
                                RoundedRectangle(cornerRadius: LTRadius.lg)
                                    .stroke(
                                        selectedId == ecole.id ? Color.emerald500 : Color.ltBorderSubtle,
                                        lineWidth: selectedId == ecole.id ? 2 : 1
                                    )
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
}
