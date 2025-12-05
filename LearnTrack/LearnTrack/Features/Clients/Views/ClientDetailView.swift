//
//  ClientDetailView.swift
//  LearnTrack
//
//  Détail d'un client
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
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // En-tête
                VStack(spacing: 12) {
                    Circle()
                        .fill(Color.blue.opacity(0.2))
                        .frame(width: 100, height: 100)
                        .overlay(
                            Text(client.initiales)
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(.blue)
                        )
                    
                    Text(client.raisonSociale)
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.top)
                
                // Boutons d'action rapide
                HStack(spacing: 12) {
                    ActionButton(icon: "phone.fill", title: "Appeler", color: .green) {
                        ContactService.shared.call(phoneNumber: client.telephone)
                    }
                    
                    ActionButton(icon: "envelope.fill", title: "Email", color: .blue) {
                        ContactService.shared.sendEmail(to: client.email)
                    }
                }
                .padding(.horizontal)
                
                Divider()
                
                // Contact principal
                InfoSection(title: "Contact principal", icon: "person.fill") {
                    Text(client.nomContact)
                        .font(.headline)
                        .padding(.bottom, 8)
                    
                    ContactRow(icon: "phone", label: "Téléphone", value: client.telephone) {
                        ContactService.shared.call(phoneNumber: client.telephone)
                    }
                    
                    ContactRow(icon: "envelope", label: "Email", value: client.email) {
                        ContactService.shared.sendEmail(to: client.email)
                    }
                }
                
                Divider()
                
                // Adresse
                if let adresse = client.adresseComplete {
                    InfoSection(title: "Adresse", icon: "mappin.circle.fill") {
                        Text(adresse)
                            .font(.body)
                        
                        Button(action: {
                            ContactService.shared.openInMaps(address: adresse)
                        }) {
                            Label("Ouvrir dans Plans", systemImage: "map.fill")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                        .padding(.top, 4)
                    }
                    
                    Divider()
                }
                
                // Informations fiscales
                InfoSection(title: "Informations fiscales", icon: "doc.text.fill") {
                    if let siret = client.siret, !siret.isEmpty {
                        InfoRow(label: "SIRET", value: siret)
                    }
                    
                    if let tva = client.numeroTva, !tva.isEmpty {
                        InfoRow(label: "N° TVA", value: tva)
                    }
                }
                
                // Statistiques
                if !sessions.isEmpty {
                    Divider()
                    
                    InfoSection(title: "Statistiques", icon: "chart.bar.fill") {
                        HStack {
                            StatCard(
                                value: "\(sessions.count)",
                                label: "Sessions",
                                color: .blue
                            )
                            
                            StatCard(
                                value: "\(calculateTotalCA()) €",
                                label: "CA total",
                                color: .green
                            )
                        }
                    }
                }
                
                // Historique des sessions
                if !sessions.isEmpty {
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Historique des sessions", systemImage: "calendar")
                            .font(.headline)
                            .foregroundColor(.blue)
                        
                        ForEach(sessions.prefix(5)) { session in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(session.module)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                
                                HStack {
                                    Text(session.displayDate)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    
                                    Spacer()
                                    
                                    Text("\(session.tarifClient) €")
                                        .font(.caption)
                                        .foregroundColor(.green)
                                }
                            }
                            .padding(.vertical, 4)
                            
                            if session.id != sessions.prefix(5).last?.id {
                                Divider()
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Boutons d'action
                VStack(spacing: 12) {
                    Button(action: { showingEditSheet = true }) {
                        Label("Modifier", systemImage: "pencil")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    
                    if authService.userRole == .admin {
                        Button(action: { showingDeleteAlert = true }) {
                            Label("Supprimer", systemImage: "trash")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical)
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
}

extension ClientDetailView {
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

// Carte de statistique
struct StatCard: View {
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
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
