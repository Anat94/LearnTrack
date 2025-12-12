//
//  SessionDetailView.swift
//  LearnTrack
//
//  Détail d'une session style Winamax - Design audacieux
//

import SwiftUI

struct SessionDetailView: View {
    let session: Session
    @StateObject private var viewModel = SessionViewModel()
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    @State private var showingShareSheet = false
    
    var theme: AppTheme {
        colorScheme == .dark ? .dark : .light
    }
    
    var body: some View {
        ZStack {
            WinamaxBackground()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Hero Header avec gradient
                    VStack(spacing: 20) {
                        // Badge modalité en haut
                        HStack {
                            Spacer()
                            WinamaxBadge(
                                text: session.modalite.label,
                                color: session.modalite == .presentiel ? theme.primaryGreen : theme.accentOrange
                            )
                            .padding(.trailing, 20)
                            .padding(.top, 8)
                        }
                        
                        Spacer()
                        
                        // Module avec style hero
                        VStack(spacing: 12) {
                            Text(session.module)
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundColor(theme.textPrimary)
                                .multilineTextAlignment(.center)
                                .lineLimit(3)
                            
                            // Date et horaires en highlight
                            HStack(spacing: 20) {
                                VStack(spacing: 4) {
                                    Image(systemName: "calendar")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(theme.primaryGreen)
                                    Text(session.displayDate)
                                        .font(.winamaxHeadline())
                                        .foregroundColor(theme.textPrimary)
                                }
                                
                                Divider()
                                    .frame(height: 40)
                                    .background(theme.borderColor)
                                
                                VStack(spacing: 4) {
                                    Image(systemName: "clock")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(theme.accentOrange)
                                    Text("\(session.debut) - \(session.fin)")
                                        .font(.winamaxHeadline())
                                        .foregroundColor(theme.textPrimary)
                                }
                            }
                            .padding(.vertical, 16)
                            .padding(.horizontal, 24)
                            .background(
                                LinearGradient(
                                    colors: [
                                        theme.cardBackground,
                                        theme.cardBackground.opacity(0.7)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .stroke(
                                        LinearGradient(
                                            colors: [theme.primaryGreen.opacity(0.3), theme.accentOrange.opacity(0.3)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 2
                                    )
                            )
                            .shadow(color: theme.shadowColor, radius: 15, y: 8)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                    }
                    .frame(height: 280)
                    .background(
                        LinearGradient(
                            colors: session.modalite == .presentiel ?
                                [theme.primaryGreen.opacity(0.15), theme.primaryGreen.opacity(0.05), .clear] :
                                [theme.accentOrange.opacity(0.15), theme.accentOrange.opacity(0.05), .clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    
                    // Contenu principal
                    VStack(spacing: 20) {
                        // Lieu
                        if session.modalite == .presentiel && !session.lieu.isEmpty && session.lieu != "À distance" {
                            DetailCard(
                                icon: "mappin.circle.fill",
                                iconColor: theme.primaryGreen,
                                title: "Lieu",
                                content: {
                                    VStack(alignment: .leading, spacing: 12) {
                                        Text(session.lieu)
                                            .font(.winamaxBody())
                                            .foregroundColor(theme.textPrimary)
                                        
                                        Button(action: {
                                            ContactService.shared.openInMaps(address: session.lieu)
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
                        
                        // Intervenants
                        DetailCard(
                            icon: "person.3.fill",
                            iconColor: theme.accentOrange,
                            title: "Intervenants",
                            content: {
                                VStack(spacing: 12) {
                                    if let formateur = session.formateur {
                                        NavigationLink(destination: FormateurDetailView(formateur: formateur)) {
                                            IntervenantRow(
                                                label: "Formateur",
                                                name: formateur.nomComplet,
                                                color: theme.primaryGreen
                                            )
                                        }
                                        .buttonStyle(.plain)
                                    }
                                    
                                    if let client = session.client {
                                        NavigationLink(destination: ClientDetailView(client: client)) {
                                            IntervenantRow(
                                                label: "Client",
                                                name: client.raisonSociale,
                                                color: theme.accentOrange
                                            )
                                        }
                                        .buttonStyle(.plain)
                                    }
                                    
                                    if let ecole = session.ecole {
                                        NavigationLink(destination: EcoleDetailView(ecole: ecole)) {
                                            IntervenantRow(
                                                label: "École",
                                                name: ecole.nom,
                                                color: theme.primaryGreen
                                            )
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                        )
                        
                        // Tarifs avec style financier
                        DetailCard(
                            icon: "eurosign.circle.fill",
                            iconColor: theme.primaryGreen,
                            title: "Tarifs",
                            content: {
                                VStack(spacing: 16) {
                                    TarifRow(label: "Tarif client", value: "\(session.tarifClient) €", color: theme.primaryGreen)
                                    TarifRow(label: "Tarif sous-traitant", value: "\(session.tarifSousTraitant) €", color: theme.textSecondary)
                                    TarifRow(label: "Frais à rembourser", value: "\(session.fraisRembourser) €", color: theme.textSecondary)
                                    
                                    Divider()
                                        .background(theme.borderColor)
                                    
                                    // Marge en highlight
                                    HStack {
                                        Text("Marge")
                                            .font(.winamaxHeadline())
                                            .foregroundColor(theme.textPrimary)
                                        
                                        Spacer()
                                        
                                        Text("\(session.marge) €")
                                            .font(.system(size: 24, weight: .bold, design: .rounded))
                                            .foregroundColor(session.marge >= 0 ? theme.primaryGreen : Color.red)
                                    }
                                    .padding(.top, 8)
                                }
                            }
                        )
                        
                        // Référence contrat
                        if let refContrat = session.refContrat, !refContrat.isEmpty {
                            DetailCard(
                                icon: "doc.text.fill",
                                iconColor: theme.textSecondary,
                                title: "Référence contrat",
                                content: {
                                    Text(refContrat)
                                        .font(.winamaxBody())
                                        .foregroundColor(theme.textPrimary)
                                }
                            )
                        }
                        
                        // Boutons d'action
                        VStack(spacing: 12) {
                            Button(action: { showingShareSheet = true }) {
                                HStack {
                                    Image(systemName: "square.and.arrow.up.fill")
                                    Text("Partager")
                                }
                            }
                            .buttonStyle(WinamaxSecondaryButton())
                            
                            Button(action: { showingEditSheet = true }) {
                                HStack {
                                    Image(systemName: "pencil.fill")
                                    Text("Modifier")
                                }
                            }
                            .buttonStyle(WinamaxPrimaryButton())
                            
                            Button(action: { showingDeleteAlert = true }) {
                                HStack {
                                    Image(systemName: "trash.fill")
                                    Text("Supprimer")
                                }
                            }
                            .buttonStyle(WinamaxDangerButton())
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    }
                    .padding(.top, 20)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingEditSheet) {
            SessionFormView(viewModel: viewModel, sessionToEdit: session)
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(items: [session.shareText()])
        }
        .alert("Supprimer la session ?", isPresented: $showingDeleteAlert) {
            Button("Annuler", role: .cancel) { }
            Button("Supprimer", role: .destructive) {
                Task {
                    try? await viewModel.deleteSession(session)
                    dismiss()
                }
            }
        } message: {
            Text("Cette action est irréversible.")
        }
    }
}

// Carte de détail réutilisable
struct DetailCard<Content: View>: View {
    let icon: String
    let iconColor: Color
    let title: String
    @ViewBuilder let content: Content
    @Environment(\.colorScheme) var colorScheme
    
    var theme: AppTheme {
        colorScheme == .dark ? .dark : .light
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(iconColor)
                }
                
                Text(title)
                    .font(.winamaxHeadline())
                    .foregroundColor(theme.textPrimary)
            }
            
            content
        }
        .winamaxCard()
        .padding(.horizontal, 20)
    }
}

// Row pour les intervenants
struct IntervenantRow: View {
    let label: String
    let name: String
    let color: Color
    @Environment(\.colorScheme) var colorScheme
    
    var theme: AppTheme {
        colorScheme == .dark ? .dark : .light
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [color, color.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 44, height: 44)
                .overlay(
                    Text(String(name.prefix(2)).uppercased())
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                )
                .shadow(color: color.opacity(0.3), radius: 8, y: 4)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.winamaxCaption())
                    .foregroundColor(theme.textSecondary)
                
                Text(name)
                    .font(.winamaxBody())
                    .foregroundColor(theme.textPrimary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(theme.textSecondary)
        }
        .padding(12)
        .background(theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(theme.borderColor, lineWidth: 1)
        )
    }
}

// Row pour les tarifs
struct TarifRow: View {
    let label: String
    let value: String
    let color: Color
    @Environment(\.colorScheme) var colorScheme
    
    var theme: AppTheme {
        colorScheme == .dark ? .dark : .light
    }
    
    var body: some View {
        HStack {
            Text(label)
                .font(.winamaxBody())
                .foregroundColor(theme.textSecondary)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(color)
        }
    }
}

#Preview {
    NavigationView {
        SessionDetailView(session: Session(
            module: "Swift avancé et développement iOS",
            date: Date(),
            debut: "09:00",
            fin: "17:00",
            modalite: .presentiel,
            lieu: "Paris, 123 rue de la Paix",
            tarifClient: 1200,
            tarifSousTraitant: 800,
            fraisRembourser: 50
        ))
    }
    .preferredColorScheme(.dark)
}
