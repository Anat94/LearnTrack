//
//  ClientDetailView.swift
//  LearnTrack
//
//  Détail d'un client style Winamax - Design audacieux
//

import SwiftUI

struct ClientDetailView: View {
    @State var client: Client
    @StateObject private var viewModel = ClientViewModel()
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var authService: AuthService
    
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    @State private var sessions: [Session] = []
    
    var theme: AppTheme {
        colorScheme == .dark ? .dark : .light
    }
    
    var body: some View {
        ZStack {
            WinamaxBackground()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Hero Header
                    VStack(spacing: 20) {
                        Spacer()
                        
                        // Avatar avec gradient
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [theme.primaryGreen, theme.primaryGreen.opacity(0.7)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 120, height: 120)
                                .shadow(color: theme.primaryGreen.opacity(0.4), radius: 20, y: 10)
                            
                            Text(client.initiales)
                                .font(.system(size: 42, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                        
                        VStack(spacing: 8) {
                            Text(client.raisonSociale)
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(theme.textPrimary)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                            
                            if !client.villeDisplay.isEmpty {
                                HStack(spacing: 6) {
                                    Image(systemName: "mappin.circle.fill")
                                        .font(.system(size: 14))
                                    Text(client.villeDisplay)
                                        .font(.winamaxHeadline())
                                }
                                .foregroundColor(theme.textSecondary)
                            }
                        }
                        
                        Spacer()
                    }
                    .frame(height: 280)
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            colors: [theme.primaryGreen.opacity(0.15), theme.primaryGreen.opacity(0.05), .clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    
                    // Actions rapides
                    HStack(spacing: 12) {
                        QuickActionButton(
                            icon: "phone.fill",
                            title: "Appeler",
                            color: theme.primaryGreen
                        ) {
                            ContactService.shared.call(phoneNumber: client.telephone)
                        }
                        
                        QuickActionButton(
                            icon: "envelope.fill",
                            title: "Email",
                            color: theme.accentOrange
                        ) {
                            ContactService.shared.sendEmail(to: client.email)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    // Contenu principal
                    VStack(spacing: 20) {
                        // Contact principal
                        DetailCard(
                            icon: "person.fill",
                            iconColor: theme.primaryGreen,
                            title: "Contact principal",
                            content: {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text(client.nomContact)
                                        .font(.winamaxHeadline())
                                        .foregroundColor(theme.textPrimary)
                                    
                                    VStack(spacing: 12) {
                                        ContactDetailRow(
                                            icon: "phone.fill",
                                            label: "Téléphone",
                                            value: client.telephone,
                                            color: theme.primaryGreen
                                        ) {
                                            ContactService.shared.call(phoneNumber: client.telephone)
                                        }
                                        
                                        ContactDetailRow(
                                            icon: "envelope.fill",
                                            label: "Email",
                                            value: client.email,
                                            color: theme.accentOrange
                                        ) {
                                            ContactService.shared.sendEmail(to: client.email)
                                        }
                                    }
                                }
                            }
                        )
                        
                        // Adresse
                        if let adresse = client.adresseComplete {
                            DetailCard(
                                icon: "mappin.circle.fill",
                                iconColor: theme.accentOrange,
                                title: "Adresse",
                                content: {
                                    VStack(alignment: .leading, spacing: 12) {
                                        Text(adresse)
                                            .font(.winamaxBody())
                                            .foregroundColor(theme.textPrimary)
                                        
                                        Button(action: {
                                            ContactService.shared.openInMaps(address: adresse)
                                        }) {
                                            HStack {
                                                Image(systemName: "map.fill")
                                                Text("Ouvrir dans Plans")
                                            }
                                            .font(.winamaxCaption())
                                            .foregroundColor(theme.primaryGreen)
                                        }
                                    }
                                }
                            )
                        }
                        
                        // Informations fiscales
                        if let siret = client.siret, !siret.isEmpty, let tva = client.numeroTva, !tva.isEmpty {
                            DetailCard(
                                icon: "doc.text.fill",
                                iconColor: theme.textSecondary,
                                title: "Informations fiscales",
                                content: {
                                    VStack(spacing: 16) {
                                        InfoDetailRow(
                                            icon: "number.circle.fill",
                                            label: "SIRET",
                                            value: siret,
                                            color: theme.textSecondary
                                        )
                                        
                                        InfoDetailRow(
                                            icon: "doc.text.fill",
                                            label: "N° TVA",
                                            value: tva,
                                            color: theme.textSecondary
                                        )
                                    }
                                }
                            )
                        }
                        
                        // Statistiques
                        if !sessions.isEmpty {
                            DetailCard(
                                icon: "chart.bar.fill",
                                iconColor: theme.primaryGreen,
                                title: "Statistiques",
                                content: {
                                    HStack(spacing: 12) {
                                        StatCardWinamax(
                                            value: "\(sessions.count)",
                                            label: "Sessions",
                                            color: theme.primaryGreen,
                                            icon: "calendar"
                                        )
                                        
                                        StatCardWinamax(
                                            value: "\(calculateTotalCA()) €",
                                            label: "CA total",
                                            color: theme.accentOrange,
                                            icon: "eurosign.circle.fill"
                                        )
                                    }
                                }
                            )
                        }
                        
                        // Historique des sessions
                        if !sessions.isEmpty {
                            DetailCard(
                                icon: "calendar",
                                iconColor: theme.accentOrange,
                                title: "Historique des sessions",
                                content: {
                                    VStack(spacing: 12) {
                                        ForEach(sessions.prefix(5)) { session in
                                            HStack {
                                                VStack(alignment: .leading, spacing: 4) {
                                                    Text(session.module)
                                                        .font(.winamaxBody())
                                                        .foregroundColor(theme.textPrimary)
                                                    
                                                    Text(session.displayDate)
                                                        .font(.winamaxCaption())
                                                        .foregroundColor(theme.textSecondary)
                                                }
                                                
                                                Spacer()
                                                
                                                Text("\(session.tarifClient) €")
                                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                                    .foregroundColor(theme.primaryGreen)
                                            }
                                            
                                            if session.id != sessions.prefix(5).last?.id {
                                                Divider()
                                                    .background(theme.borderColor)
                                            }
                                        }
                                    }
                                }
                            )
                        }
                        
                        // Boutons d'action
                        VStack(spacing: 12) {
                            Button(action: { showingEditSheet = true }) {
                                HStack {
                                    Image(systemName: "pencil.fill")
                                    Text("Modifier")
                                }
                            }
                            .buttonStyle(WinamaxPrimaryButton())
                            
                            if authService.userRole == .admin {
                                Button(action: { showingDeleteAlert = true }) {
                                    HStack {
                                        Image(systemName: "trash.fill")
                                        Text("Supprimer")
                                    }
                                }
                                .buttonStyle(WinamaxDangerButton())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    }
                    .padding(.top, 20)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
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

// Carte de statistique Winamax
struct StatCardWinamax: View {
    let value: String
    let label: String
    let color: Color
    let icon: String
    @Environment(\.colorScheme) var colorScheme
    
    var theme: AppTheme {
        colorScheme == .dark ? .dark : .light
    }
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(color)
            }
            
            Text(value)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(color)
            
            Text(label)
                .font(.winamaxCaption())
                .foregroundColor(theme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(theme.borderColor, lineWidth: 1.5)
        )
        .shadow(color: theme.shadowColor, radius: 8, y: 4)
    }
}

#Preview {
    NavigationView {
        ClientDetailView(client: Client(
            raisonSociale: "Acme Corporation",
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
    .preferredColorScheme(.dark)
}
