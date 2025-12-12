//
//  FormateurDetailView.swift
//  LearnTrack
//
//  Détail d'un formateur style Winamax - Design audacieux
//

import SwiftUI

struct FormateurDetailView: View {
    @State var formateur: Formateur
    @StateObject private var viewModel = FormateurViewModel()
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
                                        colors: formateur.exterieur ?
                                            [theme.accentOrange, theme.accentOrange.opacity(0.7)] :
                                            [theme.primaryGreen, theme.primaryGreen.opacity(0.7)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 120, height: 120)
                                .shadow(
                                    color: (formateur.exterieur ? theme.accentOrange : theme.primaryGreen).opacity(0.4),
                                    radius: 20,
                                    y: 10
                                )
                            
                            Text(formateur.initiales)
                                .font(.system(size: 42, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                        
                        VStack(spacing: 8) {
                            Text(formateur.nomComplet)
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(theme.textPrimary)
                            
                            Text(formateur.specialite)
                                .font(.winamaxHeadline())
                                .foregroundColor(theme.textSecondary)
                            
                            WinamaxBadge(
                                text: formateur.type,
                                color: formateur.exterieur ? theme.accentOrange : theme.primaryGreen
                            )
                        }
                        
                        Spacer()
                    }
                    .frame(height: 280)
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            colors: formateur.exterieur ?
                                [theme.accentOrange.opacity(0.15), theme.accentOrange.opacity(0.05), .clear] :
                                [theme.primaryGreen.opacity(0.15), theme.primaryGreen.opacity(0.05), .clear],
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
                            ContactService.shared.call(phoneNumber: formateur.telephone)
                        }
                        
                        QuickActionButton(
                            icon: "envelope.fill",
                            title: "Email",
                            color: theme.accentOrange
                        ) {
                            ContactService.shared.sendEmail(to: formateur.email)
                        }
                        
                        QuickActionButton(
                            icon: "message.fill",
                            title: "SMS",
                            color: theme.primaryGreen
                        ) {
                            ContactService.shared.sendSMS(to: formateur.telephone)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    // Contenu principal
                    VStack(spacing: 20) {
                        // Coordonnées
                        DetailCard(
                            icon: "person.fill",
                            iconColor: theme.primaryGreen,
                            title: "Coordonnées",
                            content: {
                                VStack(spacing: 12) {
                                    ContactDetailRow(
                                        icon: "phone.fill",
                                        label: "Téléphone",
                                        value: formateur.telephone,
                                        color: theme.primaryGreen
                                    ) {
                                        ContactService.shared.call(phoneNumber: formateur.telephone)
                                    }
                                    
                                    ContactDetailRow(
                                        icon: "envelope.fill",
                                        label: "Email",
                                        value: formateur.email,
                                        color: theme.accentOrange
                                    ) {
                                        ContactService.shared.sendEmail(to: formateur.email)
                                    }
                                }
                            }
                        )
                        
                        // Informations professionnelles
                        DetailCard(
                            icon: "briefcase.fill",
                            iconColor: theme.accentOrange,
                            title: "Informations professionnelles",
                            content: {
                                VStack(spacing: 16) {
                                    InfoDetailRow(
                                        icon: "eurosign.circle.fill",
                                        label: "Taux horaire",
                                        value: "\(formateur.tauxHoraire) €/h",
                                        color: theme.primaryGreen
                                    )
                                    
                                    if let nda = formateur.nda, !nda.isEmpty {
                                        InfoDetailRow(
                                            icon: "doc.text.fill",
                                            label: "NDA",
                                            value: nda,
                                            color: theme.textSecondary
                                        )
                                    }
                                    
                                    if let siret = formateur.siret, !siret.isEmpty {
                                        InfoDetailRow(
                                            icon: "number.circle.fill",
                                            label: "SIRET",
                                            value: siret,
                                            color: theme.textSecondary
                                        )
                                    }
                                }
                            }
                        )
                        
                        // Société (si externe)
                        if formateur.exterieur, let societe = formateur.societe, !societe.isEmpty {
                            DetailCard(
                                icon: "building.2.fill",
                                iconColor: theme.accentOrange,
                                title: "Société",
                                content: {
                                    Text(societe)
                                        .font(.winamaxBody())
                                        .foregroundColor(theme.textPrimary)
                                }
                            )
                        }
                        
                        // Adresse
                        if let adresse = formateur.adresseComplete {
                            DetailCard(
                                icon: "mappin.circle.fill",
                                iconColor: theme.primaryGreen,
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
                        
                        // Historique des sessions
                        if !sessions.isEmpty {
                            DetailCard(
                                icon: "calendar",
                                iconColor: theme.accentOrange,
                                title: "Historique des sessions",
                                content: {
                                    VStack(spacing: 12) {
                                        ForEach(sessions.prefix(5)) { session in
                                            SessionHistoryRow(session: session)
                                            
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

// Bouton d'action rapide
struct QuickActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var theme: AppTheme {
        colorScheme == .dark ? .dark : .light
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 56, height: 56)
                    
                    Image(systemName: icon)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(.winamaxCaption())
                    .foregroundColor(theme.textPrimary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(theme.borderColor, lineWidth: 1.5)
        )
        .shadow(color: theme.shadowColor, radius: 8, y: 4)
    }
}

// Row de contact détaillé
struct ContactDetailRow: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var theme: AppTheme {
        colorScheme == .dark ? .dark : .light
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(label)
                        .font(.winamaxCaption())
                        .foregroundColor(theme.textSecondary)
                    
                    Text(value)
                        .font(.winamaxBody())
                        .foregroundColor(theme.textPrimary)
                }
                
                Spacer()
                
                Image(systemName: "arrow.up.right.square.fill")
                    .font(.system(size: 16))
                    .foregroundColor(color)
            }
            .padding(12)
            .background(theme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(theme.borderColor, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

// Row d'information détaillée
struct InfoDetailRow: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    @Environment(\.colorScheme) var colorScheme
    
    var theme: AppTheme {
        colorScheme == .dark ? .dark : .light
    }
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.winamaxCaption())
                    .foregroundColor(theme.textSecondary)
                
                Text(value)
                    .font(.winamaxBody())
                    .foregroundColor(theme.textPrimary)
            }
            
            Spacer()
        }
    }
}

// Row pour l'historique des sessions
struct SessionHistoryRow: View {
    let session: Session
    @Environment(\.colorScheme) var colorScheme
    
    var theme: AppTheme {
        colorScheme == .dark ? .dark : .light
    }
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(session.module)
                    .font(.winamaxBody())
                    .foregroundColor(theme.textPrimary)
                
                Text(session.displayDate)
                    .font(.winamaxCaption())
                    .foregroundColor(theme.textSecondary)
            }
            
            Spacer()
        }
    }
}

#Preview {
    NavigationView {
        FormateurDetailView(formateur: Formateur(
            prenom: "Jean",
            nom: "Dupont",
            email: "jean.dupont@example.com",
            telephone: "01 23 45 67 89",
            specialite: "Swift & iOS",
            tauxHoraire: 50,
            exterieur: false
        ))
        .environmentObject(AuthService.shared)
    }
    .preferredColorScheme(.dark)
}
