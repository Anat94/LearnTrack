//
//  SessionDetailView.swift
//  LearnTrack
//
//  Détail d'une session
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
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // En-tête avec module
                VStack(alignment: .leading, spacing: 8) {
                    Text(session.module)
                        .font(.title2)
                        .fontWeight(.bold)
                    HStack {
                        LT.Badge(
                            text: session.modalite.label,
                            color: session.modalite == .presentiel ? LT.ColorToken.secondary : LT.ColorToken.primary
                        )
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                
                Divider()
                
                // Date et horaires
                InfoSection(title: "Date et horaires", icon: "calendar") {
                    InfoRow(label: "Date", value: session.displayDate)
                    InfoRow(label: "Début", value: session.debut)
                    InfoRow(label: "Fin", value: session.fin)
                }
                
                Divider()
                
                // Lieu
                InfoSection(title: "Lieu", icon: "mappin.circle.fill") {
                    Text(session.lieu)
                        .font(.body)
                    
                    if session.modalite == .presentiel,
                       !session.lieu.isEmpty,
                       session.lieu != "À distance" {
                        Button(action: {
                            ContactService.shared.openInMaps(address: session.lieu)
                        }) {
                            Label("Ouvrir dans Plans", systemImage: "map.fill")
                                .font(.subheadline)
                                .foregroundColor(LT.ColorToken.secondary)
                        }
                        .padding(.top, 4)
                    }
                }
                
                Divider()
                
                // Intervenants
                InfoSection(title: "Intervenants", icon: "person.3.fill") {
                    if let formateur = session.formateur {
                        NavigationLink(destination: Text("Détail formateur")) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Formateur")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text(formateur.nomComplet)
                                        .font(.body)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.secondary)
                                    .font(.caption)
                            }
                        }
                    }
                    
                    if let client = session.client {
                        NavigationLink(destination: Text("Détail client")) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Client")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text(client.raisonSociale)
                                        .font(.body)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.secondary)
                                    .font(.caption)
                            }
                        }
                    }
                    
                    if let ecole = session.ecole {
                        NavigationLink(destination: Text("Détail école")) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("École")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text(ecole.nom)
                                        .font(.body)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.secondary)
                                    .font(.caption)
                            }
                        }
                    }
                }
                
                Divider()
                
                // Tarifs
                InfoSection(title: "Tarifs", icon: "eurosign.circle.fill") {
                    InfoRow(label: "Tarif client", value: "\(session.tarifClient) €")
                    InfoRow(label: "Tarif sous-traitant", value: "\(session.tarifSousTraitant) €")
                    InfoRow(label: "Frais à rembourser", value: "\(session.fraisRembourser) €")
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    HStack {
                        Text("Marge")
                            .font(.headline)
                        Spacer()
                        Text("\(session.marge) €")
                            .font(.headline)
                            .foregroundColor(session.marge >= 0 ? .green : .red)
                    }
                }
                
                // Référence contrat
                if let refContrat = session.refContrat, !refContrat.isEmpty {
                    Divider()
                    
                    InfoSection(title: "Référence", icon: "doc.text.fill") {
                        Text(refContrat)
                            .font(.body)
                    }
                }
                
                // Boutons d'action
                VStack(spacing: 12) {
                    Button(action: { showingShareSheet = true }) { Label("Partager la session", systemImage: "square.and.arrow.up") }
                        .buttonStyle(LT.PrimaryButtonStyle())
                    Button(action: { showingEditSheet = true }) { Label("Modifier", systemImage: "pencil") }
                        .buttonStyle(LT.PrimaryButtonStyle())
                    Button(action: { showingDeleteAlert = true }) {
                        Label("Supprimer", systemImage: "trash")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(LT.ColorToken.danger)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical)
            }
        }
        .ltScreen()
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

// Section d'informations
struct InfoSection<Content: View>: View {
    let title: String
    let icon: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: icon)
                .font(.headline)
                .foregroundColor(LT.ColorToken.secondary)
            content
        }
        .padding(.horizontal)
    }
}

// Ligne d'information
struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(LT.ColorToken.textSecondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
                .foregroundColor(LT.ColorToken.textPrimary)
        }
        .font(.body)
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
}
