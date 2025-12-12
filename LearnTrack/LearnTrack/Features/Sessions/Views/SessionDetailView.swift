//
//  SessionDetailView.swift
//  LearnTrack
//
//  Détail session - Design SaaS compact
//

import SwiftUI

struct SessionDetailView: View {
    let session: Session
    @StateObject private var viewModel = SessionViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    @State private var showingShareSheet = false
    
    var body: some View {
        ZStack {
            LTGradientBackground()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: LTSpacing.md) {
                    // Header Card
                    headerCard
                    
                    // Date & Horaires
                    dateTimeCard
                    
                    // Lieu
                    if session.modalite == .presentiel && !session.lieu.isEmpty {
                        lieuCard
                    }
                    
                    // Intervenants
                    intervenantsCard
                    
                    // Tarifs
                    tarifsCard
                    
                    // Référence contrat
                    if let refContrat = session.refContrat, !refContrat.isEmpty {
                        refContratCard(refContrat)
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
                Text("Session")
                    .font(.ltH4)
                    .foregroundColor(.ltText)
            }
        }
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
    
    // MARK: - Header Card
    private var headerCard: some View {
        LTCard(variant: .accent) {
            VStack(spacing: LTSpacing.sm) {
                HStack {
                    Text(session.module)
                        .font(.ltH3)
                        .foregroundColor(.ltText)
                        .lineLimit(3)
                    
                    Spacer()
                }
                
                HStack {
                    LTModaliteBadge(isPresentiel: session.modalite == .presentiel)
                    Spacer()
                }
            }
        }
    }
    
    // MARK: - Date & Time Card
    private var dateTimeCard: some View {
        LTCard {
            HStack(spacing: LTSpacing.xl) {
                // Date
                HStack(spacing: LTSpacing.sm) {
                    Image(systemName: "calendar")
                        .font(.system(size: LTIconSize.md))
                        .foregroundColor(.emerald500)
                    
                    VStack(alignment: .leading, spacing: LTSpacing.xxs) {
                        Text("Date")
                            .font(.ltSmall)
                            .foregroundColor(.ltTextSecondary)
                        Text(session.displayDate)
                            .font(.ltBodySemibold)
                            .foregroundColor(.ltText)
                    }
                }
                
                Divider().frame(height: 36)
                
                // Horaires
                HStack(spacing: LTSpacing.sm) {
                    Image(systemName: "clock")
                        .font(.system(size: LTIconSize.md))
                        .foregroundColor(.warning)
                    
                    VStack(alignment: .leading, spacing: LTSpacing.xxs) {
                        Text("Horaires")
                            .font(.ltSmall)
                            .foregroundColor(.ltTextSecondary)
                        Text("\(session.debut) - \(session.fin)")
                            .font(.ltBodySemibold)
                            .foregroundColor(.ltText)
                    }
                }
                
                Spacer()
            }
        }
    }
    
    // MARK: - Lieu Card
    private var lieuCard: some View {
        LTCard {
            VStack(alignment: .leading, spacing: LTSpacing.sm) {
                HStack(spacing: LTSpacing.sm) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: LTIconSize.md))
                        .foregroundColor(.emerald500)
                    
                    Text("Lieu")
                        .font(.ltBodySemibold)
                        .foregroundColor(.ltText)
                }
                
                Text(session.lieu)
                    .font(.ltBody)
                    .foregroundColor(.ltTextSecondary)
                
                Button(action: {
                    ContactService.shared.openInMaps(address: session.lieu)
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
    
    // MARK: - Intervenants Card
    private var intervenantsCard: some View {
        LTCard {
            VStack(alignment: .leading, spacing: LTSpacing.md) {
                HStack(spacing: LTSpacing.sm) {
                    Image(systemName: "person.3.fill")
                        .font(.system(size: LTIconSize.md))
                        .foregroundColor(.warning)
                    
                    Text("Intervenants")
                        .font(.ltBodySemibold)
                        .foregroundColor(.ltText)
                }
                
                VStack(spacing: LTSpacing.sm) {
                    if let formateur = session.formateur {
                        NavigationLink(destination: FormateurDetailView(formateur: formateur)) {
                            IntervenantRowCompact(label: "Formateur", name: formateur.nomComplet, color: .emerald500)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    if let client = session.client {
                        NavigationLink(destination: ClientDetailView(client: client)) {
                            IntervenantRowCompact(label: "Client", name: client.raisonSociale, color: .info)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    if let ecole = session.ecole {
                        NavigationLink(destination: EcoleDetailView(ecole: ecole)) {
                            IntervenantRowCompact(label: "École", name: ecole.nom, color: .warning)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
    }
    
    // MARK: - Tarifs Card
    private var tarifsCard: some View {
        LTCard {
            VStack(alignment: .leading, spacing: LTSpacing.md) {
                HStack(spacing: LTSpacing.sm) {
                    Image(systemName: "eurosign.circle.fill")
                        .font(.system(size: LTIconSize.md))
                        .foregroundColor(.emerald500)
                    
                    Text("Tarifs")
                        .font(.ltBodySemibold)
                        .foregroundColor(.ltText)
                }
                
                VStack(spacing: LTSpacing.sm) {
                    TarifRowCompact(label: "Tarif client", value: "\(session.tarifClient) €")
                    TarifRowCompact(label: "Tarif sous-traitant", value: "\(session.tarifSousTraitant) €")
                    TarifRowCompact(label: "Frais à rembourser", value: "\(session.fraisRembourser) €")
                    
                    Divider()
                    
                    HStack {
                        Text("Marge")
                            .font(.ltBodySemibold)
                            .foregroundColor(.ltText)
                        Spacer()
                        Text("\(session.marge) €")
                            .font(.ltH4)
                            .foregroundColor(session.marge >= 0 ? .emerald500 : .error)
                    }
                }
            }
        }
    }
    
    // MARK: - Ref Contrat Card
    private func refContratCard(_ ref: String) -> some View {
        LTCard {
            HStack(spacing: LTSpacing.sm) {
                Image(systemName: "doc.text.fill")
                    .font(.system(size: LTIconSize.md))
                    .foregroundColor(.ltTextSecondary)
                
                VStack(alignment: .leading, spacing: LTSpacing.xxs) {
                    Text("Référence contrat")
                        .font(.ltSmall)
                        .foregroundColor(.ltTextSecondary)
                    Text(ref)
                        .font(.ltBodyMedium)
                        .foregroundColor(.ltText)
                }
                
                Spacer()
            }
        }
    }
    
    // MARK: - Actions
    private var actionsSection: some View {
        VStack(spacing: LTSpacing.sm) {
            LTButton("Modifier", variant: .primary, icon: "pencil", isFullWidth: true) {
                showingEditSheet = true
            }
            
            LTButton("Partager", variant: .subtle, icon: "square.and.arrow.up", isFullWidth: true) {
                showingShareSheet = true
            }
            
            LTButton("Supprimer", variant: .destructive, icon: "trash", isFullWidth: true) {
                showingDeleteAlert = true
            }
        }
        .padding(.top, LTSpacing.md)
    }
}

// MARK: - Compact Components

struct IntervenantRowCompact: View {
    let label: String
    let name: String
    let color: Color
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: LTSpacing.md) {
            LTAvatar(initials: String(name.prefix(2)).uppercased(), size: .small, color: color)
            
            VStack(alignment: .leading, spacing: LTSpacing.xxs) {
                Text(label)
                    .font(.ltSmall)
                    .foregroundColor(.ltTextSecondary)
                Text(name)
                    .font(.ltBodyMedium)
                    .foregroundColor(.ltText)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: LTIconSize.xs))
                .foregroundColor(.ltTextTertiary)
        }
        .padding(LTSpacing.sm)
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

struct TarifRowCompact: View {
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
        SessionDetailView(session: Session(
            module: "Swift avancé",
            date: Date(),
            debut: "09:00",
            fin: "17:00",
            modalite: .presentiel,
            lieu: "Paris",
            tarifClient: 1200,
            tarifSousTraitant: 800,
            fraisRembourser: 50
        ))
    }
    .preferredColorScheme(.dark)
}
