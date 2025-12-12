//
//  ClientDetailView.swift
//  LearnTrack
//
//  Détail client - Design SaaS compact
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
            Color.ltBackground.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: LTSpacing.md) {
                    // Header
                    headerCard
                    
                    // Quick Actions
                    quickActionsRow
                    
                    // Contact
                    contactCard
                    
                    // Adresse
                    if let adresse = client.adresseComplete {
                        adresseCard(adresse)
                    }
                    
                    // Infos fiscales
                    if let siret = client.siret, !siret.isEmpty {
                        infosFiscalesCard(siret: siret, tva: client.numeroTva)
                    }
                    
                    // Stats
                    if !sessions.isEmpty {
                        statsCard
                        sessionsCard
                    }
                    
                    // Actions
                    actionsSection
                }
                .padding(.horizontal, LTSpacing.lg)
                .padding(.top, LTSpacing.md)
                .padding(.bottom, 100)
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
            HStack(spacing: LTSpacing.md) {
                LTAvatar(
                    initials: client.initiales,
                    size: .large,
                    color: .info,
                    showGradientBorder: true
                )
                
                VStack(alignment: .leading, spacing: LTSpacing.xs) {
                    Text(client.raisonSociale)
                        .font(.ltH3)
                        .foregroundColor(.ltText)
                        .lineLimit(2)
                    
                    if !client.villeDisplay.isEmpty {
                        HStack(spacing: LTSpacing.xs) {
                            Image(systemName: "mappin")
                                .font(.system(size: LTIconSize.xs))
                            Text(client.villeDisplay)
                                .font(.ltCaption)
                        }
                        .foregroundColor(.ltTextSecondary)
                    }
                }
                
                Spacer()
            }
        }
    }
    
    // MARK: - Quick Actions
    private var quickActionsRow: some View {
        HStack(spacing: LTSpacing.sm) {
            QuickActionCompact(icon: "phone.fill", title: "Appeler", color: .emerald500) {
                ContactService.shared.call(phoneNumber: client.telephone)
            }
            
            QuickActionCompact(icon: "envelope.fill", title: "Email", color: .warning) {
                ContactService.shared.sendEmail(to: client.email)
            }
        }
    }
    
    // MARK: - Contact Card
    private var contactCard: some View {
        LTCard {
            VStack(alignment: .leading, spacing: LTSpacing.md) {
                SectionHeader(icon: "person.fill", title: "Contact principal", color: .emerald500)
                
                if !client.nomContact.isEmpty {
                    Text(client.nomContact)
                        .font(.ltBodySemibold)
                        .foregroundColor(.ltText)
                }
                
                VStack(spacing: LTSpacing.sm) {
                    ContactRowCompact(icon: "phone.fill", label: "Téléphone", value: client.telephone, color: .emerald500) {
                        ContactService.shared.call(phoneNumber: client.telephone)
                    }
                    
                    ContactRowCompact(icon: "envelope.fill", label: "Email", value: client.email, color: .warning) {
                        ContactService.shared.sendEmail(to: client.email)
                    }
                }
            }
        }
    }
    
    // MARK: - Adresse Card
    private func adresseCard(_ adresse: String) -> some View {
        LTCard {
            VStack(alignment: .leading, spacing: LTSpacing.sm) {
                SectionHeader(icon: "mappin.circle.fill", title: "Adresse", color: .warning)
                
                Text(adresse)
                    .font(.ltBody)
                    .foregroundColor(.ltTextSecondary)
                
                Button(action: {
                    ContactService.shared.openInMaps(address: adresse)
                }) {
                    HStack(spacing: LTSpacing.xs) {
                        Image(systemName: "map")
                        Text("Ouvrir dans Plans")
                    }
                    .font(.ltCaption)
                    .foregroundColor(.emerald500)
                }
            }
        }
    }
    
    // MARK: - Infos Fiscales Card
    private func infosFiscalesCard(siret: String, tva: String?) -> some View {
        LTCard {
            VStack(alignment: .leading, spacing: LTSpacing.md) {
                SectionHeader(icon: "doc.text.fill", title: "Informations fiscales", color: .ltTextSecondary)
                
                VStack(spacing: LTSpacing.sm) {
                    InfoRowCompact(label: "SIRET", value: siret)
                    
                    if let tva = tva, !tva.isEmpty {
                        InfoRowCompact(label: "N° TVA", value: tva)
                    }
                }
            }
        }
    }
    
    // MARK: - Stats Card
    private var statsCard: some View {
        HStack(spacing: LTSpacing.sm) {
            StatCardCompact(value: "\(sessions.count)", label: "Sessions", color: .emerald500, icon: "calendar")
            StatCardCompact(value: "\(calculateTotalCA()) €", label: "CA total", color: .warning, icon: "eurosign.circle.fill")
        }
    }
    
    // MARK: - Sessions Card
    private var sessionsCard: some View {
        LTCard {
            VStack(alignment: .leading, spacing: LTSpacing.md) {
                SectionHeader(icon: "calendar", title: "Sessions récentes", color: .warning)
                
                VStack(spacing: LTSpacing.sm) {
                    ForEach(sessions.prefix(3)) { session in
                        HStack {
                            VStack(alignment: .leading, spacing: LTSpacing.xxs) {
                                Text(session.module)
                                    .font(.ltBodyMedium)
                                    .foregroundColor(.ltText)
                                    .lineLimit(1)
                                Text(session.displayDate)
                                    .font(.ltSmall)
                                    .foregroundColor(.ltTextSecondary)
                            }
                            Spacer()
                            Text("\(session.tarifClient) €")
                                .font(.ltBodySemibold)
                                .foregroundColor(.emerald500)
                        }
                        
                        if session.id != sessions.prefix(3).last?.id {
                            Divider()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Actions
    private var actionsSection: some View {
        VStack(spacing: LTSpacing.sm) {
            LTButton("Modifier", variant: .primary, icon: "pencil", isFullWidth: true) {
                showingEditSheet = true
            }
            
            if authService.userRole == .admin {
                LTButton("Supprimer", variant: .destructive, icon: "trash", isFullWidth: true) {
                    showingDeleteAlert = true
                }
            }
        }
        .padding(.top, LTSpacing.md)
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

// MARK: - Stat Card Compact

struct StatCardCompact: View {
    let value: String
    let label: String
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(spacing: LTSpacing.sm) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 36, height: 36)
                
                Image(systemName: icon)
                    .font(.system(size: LTIconSize.md))
                    .foregroundColor(color)
            }
            
            Text(value)
                .font(.ltH4)
                .foregroundColor(color)
            
            Text(label)
                .font(.ltSmall)
                .foregroundColor(.ltTextSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, LTSpacing.md)
        .background(Color.ltCard)
        .clipShape(RoundedRectangle(cornerRadius: LTRadius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: LTRadius.lg)
                .stroke(Color.ltBorderSubtle, lineWidth: 0.5)
        )
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
            telephone: "0123456789",
            siret: "12345678900001"
        ))
        .environmentObject(AuthService.shared)
    }
    .preferredColorScheme(.dark)
}
