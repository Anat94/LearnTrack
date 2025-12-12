//
//  ClientDetailView.swift
//  LearnTrack
//
//  Détail d'un client - Design Emerald
//

import SwiftUI

struct ClientDetailView: View {
    @State var client: Client
    @StateObject private var viewModel = ClientViewModel()
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authService: AuthService
    
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    @State private var sessions: [Session] = []
    
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
                    
                    // Address
                    if let adresse = client.adresseComplete {
                        addressSection(adresse)
                    }
                    
                    // Fiscal info
                    fiscalSection
                    
                    // Statistics
                    if !sessions.isEmpty {
                        statisticsSection
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
                Text("Client")
                    .font(.ltH4)
                    .foregroundColor(.ltText)
            }
        }
        .sheet(isPresented: $showingEditSheet, onDismiss: {
            Task { await refreshClient() }
        }) {
            ClientFormView(viewModel: viewModel, clientToEdit: client)
        }
        .alert("Supprimer le client ?", isPresented: $showingDeleteAlert) {
            Button("Annuler", role: .cancel) { }
            Button("Supprimer", role: .destructive) {
                Task {
                    try? await viewModel.deleteClient(client)
                    dismiss()
                }
            }
        }
        .task {
            if let id = client.id {
                sessions = await viewModel.fetchSessionsForClient(id)
            }
        }
    }
    
    // MARK: - Header Card
    private var headerCard: some View {
        LTCard(variant: .accent) {
            VStack(spacing: LTSpacing.md) {
                LTAvatar(
                    initials: client.initiales,
                    size: .xl,
                    color: .info,
                    showGradientBorder: true
                )
                
                Text(client.raisonSociale)
                    .font(.ltH2)
                    .foregroundColor(.ltText)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    // MARK: - Quick Actions
    private var quickActionsSection: some View {
        HStack(spacing: LTSpacing.md) {
            QuickActionButtonClient(
                icon: "phone.fill",
                title: "Appeler",
                color: .emerald500
            ) {
                ContactService.shared.call(phoneNumber: client.telephone)
            }
            
            QuickActionButtonClient(
                icon: "envelope.fill",
                title: "Email",
                color: .info
            ) {
                ContactService.shared.sendEmail(to: client.email)
            }
        }
    }
    
    // MARK: - Contact Section
    private var contactSection: some View {
        LTInfoSection(title: "Contact principal", icon: "person.fill") {
            VStack(alignment: .leading, spacing: LTSpacing.md) {
                Text(client.nomContact)
                    .font(.ltH4)
                    .foregroundColor(.ltText)
                
                ContactRowClient(
                    icon: "phone",
                    label: "Téléphone",
                    value: client.telephone
                ) {
                    ContactService.shared.call(phoneNumber: client.telephone)
                }
                
                ContactRowClient(
                    icon: "envelope",
                    label: "Email",
                    value: client.email
                ) {
                    ContactService.shared.sendEmail(to: client.email)
                }
            }
        }
    }
    
    // MARK: - Address Section
    private func addressSection(_ adresse: String) -> some View {
        LTInfoSection(title: "Adresse", icon: "mappin.circle.fill") {
            VStack(alignment: .leading, spacing: LTSpacing.sm) {
                Text(adresse)
                    .font(.ltBody)
                    .foregroundColor(.ltText)
                
                LTButton("Ouvrir dans Plans", variant: .subtle, size: .small, icon: "map.fill") {
                    ContactService.shared.openInMaps(address: adresse)
                }
            }
        }
    }
    
    // MARK: - Fiscal Section
    private var fiscalSection: some View {
        LTInfoSection(title: "Informations fiscales", icon: "doc.text.fill") {
            VStack(spacing: LTSpacing.sm) {
                if let siret = client.siret, !siret.isEmpty {
                    LTInfoRow(label: "SIRET", value: siret)
                }
                if let tva = client.numeroTva, !tva.isEmpty {
                    LTInfoRow(label: "N° TVA", value: tva)
                }
                if client.siret == nil && client.numeroTva == nil {
                    Text("Aucune information fiscale")
                        .font(.ltCaption)
                        .foregroundColor(.ltTextTertiary)
                }
            }
        }
    }
    
    // MARK: - Statistics Section
    private var statisticsSection: some View {
        LTInfoSection(title: "Statistiques", icon: "chart.bar.fill") {
            HStack(spacing: LTSpacing.md) {
                StatCardNew(
                    value: "\(sessions.count)",
                    label: "Sessions",
                    color: .info
                )
                
                StatCardNew(
                    value: "\(calculateTotalCA()) €",
                    label: "CA total",
                    color: .emerald500
                )
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
                        
                        Text("\(session.tarifClient) €")
                            .font(.ltMonoLarge)
                            .foregroundColor(.emerald500)
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
    private func calculateTotalCA() -> Decimal {
        sessions.reduce(0) { $0 + $1.tarifClient }
    }
    
    private func refreshClient() async {
        guard let id = client.id else { return }
        do {
            let api = try await APIService.shared.getClient(id: Int(id))
            await MainActor.run { self.client = mapAPIClient(api) }
        } catch { print("Erreur refresh client: \(error)") }
    }
    
    private func mapAPIClient(_ api: APIClient) -> Client {
        let id64 = Int64(api.id)
        let extras = ExtrasStore.shared.getClientExtras(id: id64)
        return Client(
            id: id64,
            raisonSociale: api.nom,
            rue: api.adresse,
            codePostal: api.codePostal,
            ville: api.ville,
            nomContact: api.contactNom ?? "",
            email: api.email ?? (api.contactEmail ?? ""),
            telephone: api.telephone ?? (api.contactTelephone ?? ""),
            siret: api.siret,
            numeroTva: extras?.numeroTva
        )
    }
}

// MARK: - Quick Action Button (Client)
private struct QuickActionButtonClient: View {
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

// MARK: - Contact Row (Client)
private struct ContactRowClient: View {
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

// MARK: - Stat Card
private struct StatCardNew: View {
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: LTSpacing.sm) {
            Text(value)
                .font(.ltH2)
                .foregroundColor(color)
            
            Text(label)
                .font(.ltCaption)
                .foregroundColor(.ltTextSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(LTSpacing.lg)
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: LTRadius.lg))
    }
}

#Preview {
    NavigationView {
        ClientDetailView(client: Client(
            raisonSociale: "Acme Corp",
            rue: "123 rue de la Paix",
            codePostal: "75001",
            ville: "Paris",
            nomContact: "Marie Martin",
            email: "contact@acme.com",
            telephone: "01 23 45 67 89",
            siret: "12345678900001"
        ))
        .environmentObject(AuthService.shared)
    }
}
