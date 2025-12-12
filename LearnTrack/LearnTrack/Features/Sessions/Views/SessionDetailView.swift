//
//  SessionDetailView.swift
//  LearnTrack
//
//  Détail d'une session - Design Emerald
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
            Color.ltBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: LTSpacing.lg) {
                    // Header card
                    headerCard
                    
                    // Info sections
                    VStack(spacing: LTSpacing.md) {
                        dateTimeSection
                        locationSection
                        intervenantsSection
                        tarifsSection
                        
                        if let refContrat = session.refContrat, !refContrat.isEmpty {
                            referenceSection(refContrat)
                        }
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
                Text("Détail")
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
            VStack(alignment: .leading, spacing: LTSpacing.md) {
                Text(session.module)
                    .font(.ltH2)
                    .foregroundColor(.ltText)
                
                LTModaliteBadge(isPreentiel: session.modalite == .presentiel)
            }
        }
    }
    
    // MARK: - Date & Time Section
    private var dateTimeSection: some View {
        LTInfoSection(title: "Date et horaires", icon: "calendar") {
            VStack(spacing: LTSpacing.sm) {
                LTInfoRow(label: "Date", value: session.displayDate)
                LTInfoRow(label: "Début", value: session.debut)
                LTInfoRow(label: "Fin", value: session.fin)
            }
        }
    }
    
    // MARK: - Location Section
    private var locationSection: some View {
        LTInfoSection(title: "Lieu", icon: "mappin.circle.fill") {
            VStack(alignment: .leading, spacing: LTSpacing.sm) {
                Text(session.lieu)
                    .font(.ltBody)
                    .foregroundColor(.ltText)
                
                if session.modalite == .presentiel,
                   !session.lieu.isEmpty,
                   session.lieu != "À distance" {
                    LTButton("Ouvrir dans Plans", variant: .subtle, size: .small, icon: "map.fill") {
                        ContactService.shared.openInMaps(address: session.lieu)
                    }
                }
            }
        }
    }
    
    // MARK: - Intervenants Section
    private var intervenantsSection: some View {
        LTInfoSection(title: "Intervenants", icon: "person.3.fill") {
            VStack(spacing: LTSpacing.md) {
                if let formateur = session.formateur {
                    NavigationLink(destination: FormateurDetailView(formateur: formateur)) {
                        IntervenantRow(type: "Formateur", name: formateur.nomComplet)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                if let client = session.client {
                    NavigationLink(destination: ClientDetailView(client: client)) {
                        IntervenantRow(type: "Client", name: client.raisonSociale)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                if let ecole = session.ecole {
                    NavigationLink(destination: EcoleDetailView(ecole: ecole)) {
                        IntervenantRow(type: "École", name: ecole.nom)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
    
    // MARK: - Tarifs Section
    private var tarifsSection: some View {
        LTInfoSection(title: "Tarifs", icon: "eurosign.circle.fill") {
            VStack(spacing: LTSpacing.sm) {
                LTInfoRow(label: "Tarif client", value: "\(session.tarifClient) €")
                LTInfoRow(label: "Tarif sous-traitant", value: "\(session.tarifSousTraitant) €")
                LTInfoRow(label: "Frais à rembourser", value: "\(session.fraisRembourser) €")
                
                Divider()
                    .padding(.vertical, LTSpacing.sm)
                
                HStack {
                    Text("Marge")
                        .font(.ltBodySemibold)
                        .foregroundColor(.ltText)
                    Spacer()
                    Text("\(session.marge) €")
                        .font(.ltMonoLarge)
                        .foregroundColor(session.marge >= 0 ? .emerald500 : .error)
                }
            }
        }
    }
    
    // MARK: - Reference Section
    private func referenceSection(_ ref: String) -> some View {
        LTInfoSection(title: "Référence contrat", icon: "doc.text.fill") {
            Text(ref)
                .font(.ltMono)
                .foregroundColor(.ltText)
        }
    }
    
    // MARK: - Action Buttons
    private var actionButtons: some View {
        VStack(spacing: LTSpacing.md) {
            LTButton("Partager la session", variant: .primary, icon: "square.and.arrow.up", isFullWidth: true) {
                showingShareSheet = true
            }
            
            HStack(spacing: LTSpacing.md) {
                LTButton("Modifier", variant: .secondary, icon: "pencil", isFullWidth: true) {
                    showingEditSheet = true
                }
                
                LTButton("Supprimer", variant: .destructive, icon: "trash", isFullWidth: true) {
                    showingDeleteAlert = true
                }
            }
        }
        .padding(.top, LTSpacing.lg)
    }
}

// MARK: - Intervenant Row
private struct IntervenantRow: View {
    let type: String
    let name: String
    
    @State private var isPressed = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: LTSpacing.xxs) {
                Text(type)
                    .font(.ltCaption)
                    .foregroundColor(.ltTextSecondary)
                Text(name)
                    .font(.ltBodyMedium)
                    .foregroundColor(.ltText)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: LTIconSize.sm, weight: .semibold))
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

// MARK: - Info Section Component
struct LTInfoSection<Content: View>: View {
    let title: String
    let icon: String
    @ViewBuilder let content: Content
    
    var body: some View {
        LTCard {
            VStack(alignment: .leading, spacing: LTSpacing.md) {
                // Header
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

// MARK: - Info Row Component
struct LTInfoRow: View {
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
            module: "Swift & SwiftUI Avancé",
            date: Date(),
            debut: "09:00",
            fin: "17:00",
            modalite: .presentiel,
            lieu: "Paris - WeWork La Défense",
            tarifClient: 1200,
            tarifSousTraitant: 800,
            fraisRembourser: 50
        ))
    }
}
