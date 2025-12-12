//
//  FormateurDetailView.swift
//  LearnTrack
//
//  Détail formateur - Design SaaS compact
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
    
    var body: some View {
        ZStack {
            LTGradientBackground()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: LTSpacing.md) {
                    // Header
                    headerCard
                    
                    // Quick Actions
                    quickActionsRow
                    
                    // Coordonnées
                    coordonneesCard
                    
                    // Infos Pro
                    infosProCard
                    
                    // Société (si externe)
                    if formateur.exterieur, let societe = formateur.societe, !societe.isEmpty {
                        societeCard(societe)
                    }
                    
                    // Adresse
                    if let adresse = formateur.adresseComplete {
                        adresseCard(adresse)
                    }
                    
                    // Historique Sessions
                    if !sessions.isEmpty {
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
            HStack(spacing: LTSpacing.md) {
                LTAvatar(
                    initials: formateur.initiales,
                    size: .large,
                    color: formateur.exterieur ? .warning : .emerald500,
                    showGradientBorder: true
                )
                
                VStack(alignment: .leading, spacing: LTSpacing.xs) {
                    Text(formateur.nomComplet)
                        .font(.ltH3)
                        .foregroundColor(.ltText)
                    
                    if !formateur.specialite.isEmpty {
                        Text(formateur.specialite)
                            .font(.ltCaption)
                            .foregroundColor(.ltTextSecondary)
                    }
                    
                    LTTypeBadge(isExterne: formateur.exterieur)
                }
                
                Spacer()
            }
        }
    }
    
    // MARK: - Quick Actions
    private var quickActionsRow: some View {
        HStack(spacing: LTSpacing.sm) {
            QuickActionCompact(icon: "phone.fill", title: "Appeler", color: .emerald500) {
                ContactService.shared.call(phoneNumber: formateur.telephone)
            }
            
            QuickActionCompact(icon: "envelope.fill", title: "Email", color: .warning) {
                ContactService.shared.sendEmail(to: formateur.email)
            }
            
            QuickActionCompact(icon: "message.fill", title: "SMS", color: .info) {
                ContactService.shared.sendSMS(to: formateur.telephone)
            }
        }
    }
    
    // MARK: - Coordonnées Card
    private var coordonneesCard: some View {
        LTCard {
            VStack(alignment: .leading, spacing: LTSpacing.md) {
                SectionHeader(icon: "person.fill", title: "Coordonnées", color: .emerald500)
                
                VStack(spacing: LTSpacing.sm) {
                    ContactRowCompact(icon: "phone.fill", label: "Téléphone", value: formateur.telephone, color: .emerald500) {
                        ContactService.shared.call(phoneNumber: formateur.telephone)
                    }
                    
                    ContactRowCompact(icon: "envelope.fill", label: "Email", value: formateur.email, color: .warning) {
                        ContactService.shared.sendEmail(to: formateur.email)
                    }
                }
            }
        }
    }
    
    // MARK: - Infos Pro Card
    private var infosProCard: some View {
        LTCard {
            VStack(alignment: .leading, spacing: LTSpacing.md) {
                SectionHeader(icon: "briefcase.fill", title: "Informations", color: .warning)
                
                VStack(spacing: LTSpacing.sm) {
                    InfoRowCompact(label: "Taux horaire", value: "\(formateur.tauxHoraire) €/h")
                    
                    if let nda = formateur.nda, !nda.isEmpty {
                        InfoRowCompact(label: "NDA", value: nda)
                    }
                    
                    if let siret = formateur.siret, !siret.isEmpty {
                        InfoRowCompact(label: "SIRET", value: siret)
                    }
                }
            }
        }
    }
    
    // MARK: - Société Card
    private func societeCard(_ societe: String) -> some View {
        LTCard {
            HStack(spacing: LTSpacing.sm) {
                Image(systemName: "building.2.fill")
                    .font(.system(size: LTIconSize.md))
                    .foregroundColor(.warning)
                
                VStack(alignment: .leading, spacing: LTSpacing.xxs) {
                    Text("Société")
                        .font(.ltSmall)
                        .foregroundColor(.ltTextSecondary)
                    Text(societe)
                        .font(.ltBodyMedium)
                        .foregroundColor(.ltText)
                }
                
                Spacer()
            }
        }
    }
    
    // MARK: - Adresse Card
    private func adresseCard(_ adresse: String) -> some View {
        LTCard {
            VStack(alignment: .leading, spacing: LTSpacing.sm) {
                SectionHeader(icon: "mappin.circle.fill", title: "Adresse", color: .emerald500)
                
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
    
    // MARK: - Refresh
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

// MARK: - Compact Components

struct QuickActionCompact: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            action()
        }) {
            VStack(spacing: LTSpacing.xs) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.1))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: LTIconSize.md))
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(.ltSmall)
                    .foregroundColor(.ltText)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, LTSpacing.md)
            .background(Color.ltCard)
            .clipShape(RoundedRectangle(cornerRadius: LTRadius.lg))
            .overlay(
                RoundedRectangle(cornerRadius: LTRadius.lg)
                    .stroke(Color.ltBorderSubtle, lineWidth: 0.5)
            )
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

struct SectionHeader: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        HStack(spacing: LTSpacing.sm) {
            Image(systemName: icon)
                .font(.system(size: LTIconSize.md))
                .foregroundColor(color)
            
            Text(title)
                .font(.ltBodySemibold)
                .foregroundColor(.ltText)
        }
    }
}

struct ContactRowCompact: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: LTSpacing.md) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.1))
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: icon)
                        .font(.system(size: LTIconSize.sm))
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: LTSpacing.xxs) {
                    Text(label)
                        .font(.ltSmall)
                        .foregroundColor(.ltTextSecondary)
                    Text(value)
                        .font(.ltBodyMedium)
                        .foregroundColor(.ltText)
                }
                
                Spacer()
                
                Image(systemName: "arrow.up.right")
                    .font(.system(size: LTIconSize.xs))
                    .foregroundColor(color)
            }
            .padding(LTSpacing.sm)
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

struct InfoRowCompact: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.ltBody)
                .foregroundColor(.ltTextSecondary)
            Spacer()
            Text(value)
                .font(.ltBodyMedium)
                .foregroundColor(.ltText)
        }
    }
}

#Preview {
    NavigationView {
        FormateurDetailView(formateur: Formateur(
            prenom: "Jean",
            nom: "Dupont",
            email: "jean@example.com",
            telephone: "0123456789",
            specialite: "Swift",
            tauxHoraire: 50,
            exterieur: false
        ))
        .environmentObject(AuthService.shared)
    }
    .preferredColorScheme(.dark)
}
