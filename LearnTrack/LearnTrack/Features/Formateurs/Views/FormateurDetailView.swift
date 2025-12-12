//
//  FormateurDetailView.swift
//  LearnTrack
//
//  Détail d'un formateur - Design Emerald
//

import SwiftUI

struct FormateurDetailView: View {
    @State var formateur: Formateur
    @StateObject private var viewModel = FormateurViewModel()
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authService: AuthService
    
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    @State private var sessions: [Session] = []
    
    private var badgeColor: Color {
        formateur.exterieur ? .warning : .emerald500
    }
    
    var body: some View {
        ZStack {
            Color.ltBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: LTSpacing.lg) {
                    // Header card
                    headerCard
                    
                    // Quick actions
                    quickActionsSection
                    
                    // Contact info
                    contactSection
                    
                    // Professional info
                    professionalSection
                    
                    // Company (if external)
                    if formateur.exterieur, let societe = formateur.societe, !societe.isEmpty {
                        companySection(societe)
                    }
                    
                    // Address
                    if let adresse = formateur.adresseComplete {
                        addressSection(adresse)
                    }
                    
                    // Sessions history
                    if !sessions.isEmpty {
                        sessionsHistorySection
                    }
                    
                    // Action buttons
                    actionButtons
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, LTSpacing.lg)
                .padding(.top, LTSpacing.lg)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Formateur")
                    .font(.ltH4)
                    .foregroundColor(.ltText)
            }
        }
        .sheet(isPresented: $showingEditSheet, onDismiss: {
            Task { await refreshFormateur() }
        }) {
            FormateurFormView(viewModel: viewModel, formateurToEdit: formateur)
        }
        .alert("Supprimer le formateur ?", isPresented: $showingDeleteAlert) {
            Button("Annuler", role: .cancel) { }
            Button("Supprimer", role: .destructive) {
                Task {
                    try? await viewModel.deleteFormateur(formateur)
                    dismiss()
                }
            }
        }
        .task {
            if let id = formateur.id {
                sessions = await viewModel.fetchSessionsForFormateur(id)
            }
        }
    }
    
    // MARK: - Header Card
    private var headerCard: some View {
        LTCard(variant: .accent) {
            VStack(spacing: LTSpacing.md) {
                // Avatar with glow
                LTAvatar(
                    initials: formateur.initiales,
                    size: .xl,
                    color: badgeColor,
                    showGradientBorder: true
                )
                
                VStack(spacing: LTSpacing.sm) {
                    Text(formateur.nomComplet)
                        .font(.ltH2)
                        .foregroundColor(.ltText)
                    
                    Text(formateur.specialite)
                        .font(.ltBody)
                        .foregroundColor(.ltTextSecondary)
                    
                    LTTypeBadge(isExterne: formateur.exterieur)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    // MARK: - Quick Actions
    private var quickActionsSection: some View {
        HStack(spacing: LTSpacing.md) {
            QuickActionButton(
                icon: "phone.fill",
                title: "Appeler",
                color: .emerald500
            ) {
                ContactService.shared.call(phoneNumber: formateur.telephone)
            }
            
            QuickActionButton(
                icon: "envelope.fill",
                title: "Email",
                color: .info
            ) {
                ContactService.shared.sendEmail(to: formateur.email)
            }
            
            QuickActionButton(
                icon: "message.fill",
                title: "SMS",
                color: .warning
            ) {
                ContactService.shared.sendSMS(to: formateur.telephone)
            }
        }
    }
    
    // MARK: - Contact Section
    private var contactSection: some View {
        LTInfoSection(title: "Coordonnées", icon: "person.fill") {
            VStack(spacing: LTSpacing.md) {
                ContactRowNew(
                    icon: "phone",
                    label: "Téléphone",
                    value: formateur.telephone
                ) {
                    ContactService.shared.call(phoneNumber: formateur.telephone)
                }
                
                ContactRowNew(
                    icon: "envelope",
                    label: "Email",
                    value: formateur.email
                ) {
                    ContactService.shared.sendEmail(to: formateur.email)
                }
            }
        }
    }
    
    // MARK: - Professional Section
    private var professionalSection: some View {
        LTInfoSection(title: "Informations professionnelles", icon: "briefcase.fill") {
            VStack(spacing: LTSpacing.sm) {
                LTInfoRow(label: "Taux horaire", value: "\(formateur.tauxHoraire) €/h")
                
                if let nda = formateur.nda, !nda.isEmpty {
                    LTInfoRow(label: "NDA", value: nda)
                }
                
                if let siret = formateur.siret, !siret.isEmpty {
                    LTInfoRow(label: "SIRET", value: siret)
                }
            }
        }
    }
    
    // MARK: - Company Section
    private func companySection(_ societe: String) -> some View {
        LTInfoSection(title: "Société", icon: "building.2.fill") {
            Text(societe)
                .font(.ltBody)
                .foregroundColor(.ltText)
        }
    }
    
    // MARK: - Address Section
    private func addressSection(_ adresse: String) -> some View {
        LTInfoSection(title: "Adresse", icon: "mappin.circle.fill") {
            VStack(alignment: .leading, spacing: LTSpacing.sm) {
                Text(adresse)
                    .font(.ltBody)
                    .foregroundColor(.ltText)
                
                LTButton("Ouvrir dans Plans", variant: .subtle, icon: "map.fill", size: .small) {
                    ContactService.shared.openInMaps(address: adresse)
                }
            }
        }
    }
    
    // MARK: - Sessions History
    private var sessionsHistorySection: some View {
        LTInfoSection(title: "Historique des sessions", icon: "calendar") {
            VStack(spacing: LTSpacing.sm) {
                ForEach(sessions.prefix(5)) { session in
                    HStack {
                        VStack(alignment: .leading, spacing: LTSpacing.xxs) {
                            Text(session.module)
                                .font(.ltBodyMedium)
                                .foregroundColor(.ltText)
                            
                            Text(session.displayDate)
                                .font(.ltCaption)
                                .foregroundColor(.ltTextSecondary)
                        }
                        
                        Spacer()
                        
                        LTModaliteBadge(isPreentiel: session.modalite == .presentiel)
                    }
                    .padding(LTSpacing.sm)
                    .background(Color.ltBackgroundSecondary)
                    .clipShape(RoundedRectangle(cornerRadius: LTRadius.md))
                }
            }
        }
    }
    
    // MARK: - Action Buttons
    private var actionButtons: some View {
        VStack(spacing: LTSpacing.md) {
            LTButton("Modifier", variant: .secondary, icon: "pencil", isFullWidth: true) {
                showingEditSheet = true
            }
            
            if authService.userRole == .admin {
                LTButton("Supprimer", variant: .destructive, icon: "trash", isFullWidth: true) {
                    showingDeleteAlert = true
                }
            }
        }
        .padding(.top, LTSpacing.lg)
    }
    
    // MARK: - Helpers
    private func refreshFormateur() async {
        guard let id = formateur.id else { return }
        do {
            let api = try await APIService.shared.getFormateur(id: Int(id))
            await MainActor.run {
                self.formateur = mapAPIFormateur(api)
            }
        } catch {
            print("Erreur refresh formateur: \(error)")
        }
    }

    private func mapAPIFormateur(_ api: APIFormateur) -> Formateur {
        let specialite = (api.specialites?.first).map { String($0) } ?? ""
        let taux = Decimal(api.tarifJournalier ?? 0)
        let id64 = Int64(api.id)
        let extras = ExtrasStore.shared.getFormateurExtras(id: id64)
        return Formateur(
            id: id64,
            prenom: api.prenom,
            nom: api.nom,
            email: api.email,
            telephone: api.telephone ?? "",
            specialite: specialite,
            tauxHoraire: taux,
            exterieur: extras?.exterieur ?? false,
            societe: extras?.societe,
            siret: extras?.siret,
            nda: extras?.nda,
            rue: api.adresse,
            codePostal: api.codePostal,
            ville: api.ville
        )
    }
}

// MARK: - Quick Action Button
private struct QuickActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
            action()
        }) {
            VStack(spacing: LTSpacing.sm) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: icon)
                        .font(.system(size: LTIconSize.lg, weight: .semibold))
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(.ltCaptionMedium)
                    .foregroundColor(.ltText)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, LTSpacing.md)
            .background(Color.ltCard)
            .clipShape(RoundedRectangle(cornerRadius: LTRadius.lg))
            .ltCardShadow()
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.ltSpringSubtle, value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}

// MARK: - Contact Row
private struct ContactRowNew: View {
    let icon: String
    let label: String
    let value: String
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            action()
        }) {
            HStack(spacing: LTSpacing.md) {
                Image(systemName: icon)
                    .font(.system(size: LTIconSize.md))
                    .foregroundColor(.emerald500)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: LTSpacing.xxs) {
                    Text(label)
                        .font(.ltCaption)
                        .foregroundColor(.ltTextSecondary)
                    Text(value)
                        .font(.ltBodyMedium)
                        .foregroundColor(.ltText)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: LTIconSize.sm))
                    .foregroundColor(.ltTextTertiary)
            }
            .padding(LTSpacing.md)
            .background(Color.ltBackgroundSecondary)
            .clipShape(RoundedRectangle(cornerRadius: LTRadius.md))
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.ltSpringSubtle, value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}

#Preview {
    NavigationView {
        FormateurDetailView(formateur: Formateur(
            prenom: "Jean",
            nom: "Dupont",
            email: "jean.dupont@example.com",
            telephone: "06 12 34 56 78",
            specialite: "Swift & iOS",
            tauxHoraire: 50,
            exterieur: false
        ))
        .environmentObject(AuthService.shared)
    }
}
