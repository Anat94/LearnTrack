//
//  FormateurDetailView.swift
//  LearnTrack
//
//  Détail d'un formateur
//

import SwiftUI

struct FormateurDetailView: View {
    let formateur: Formateur
    @StateObject private var viewModel = FormateurViewModel()
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authService: AuthService
    
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    @State private var sessions: [Session] = []
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // En-tête avec avatar
                VStack(spacing: 12) {
                    Circle()
                        .fill(formateur.exterieur ? Color.orange.opacity(0.2) : Color.green.opacity(0.2))
                        .frame(width: 100, height: 100)
                        .overlay(
                            Text(formateur.initiales)
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(formateur.exterieur ? .orange : .green)
                        )
                    
                    Text(formateur.nomComplet)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(formateur.specialite)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    // Badge type
                    Text(formateur.type)
                        .font(.subheadline)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(formateur.exterieur ? Color.orange.opacity(0.2) : Color.green.opacity(0.2))
                        .foregroundColor(formateur.exterieur ? .orange : .green)
                        .cornerRadius(8)
                }
                .frame(maxWidth: .infinity)
                .padding(.top)
                
                // Boutons d'action rapide
                HStack(spacing: 12) {
                    ActionButton(icon: "phone.fill", title: "Appeler", color: .green) {
                        ContactService.shared.call(phoneNumber: formateur.telephone)
                    }
                    
                    ActionButton(icon: "envelope.fill", title: "Email", color: .blue) {
                        ContactService.shared.sendEmail(to: formateur.email)
                    }
                    
                    ActionButton(icon: "message.fill", title: "Message", color: .orange) {
                        ContactService.shared.sendSMS(to: formateur.telephone)
                    }
                }
                .padding(.horizontal)
                
                Divider()
                
                // Coordonnées
                InfoSection(title: "Coordonnées", icon: "person.fill") {
                    ContactRow(icon: "phone", label: "Téléphone", value: formateur.telephone) {
                        ContactService.shared.call(phoneNumber: formateur.telephone)
                    }
                    
                    ContactRow(icon: "envelope", label: "Email", value: formateur.email) {
                        ContactService.shared.sendEmail(to: formateur.email)
                    }
                }
                
                Divider()
                
                // Informations professionnelles
                InfoSection(title: "Informations professionnelles", icon: "briefcase.fill") {
                    InfoRow(label: "Taux horaire", value: "\(formateur.tauxHoraire) €/h")
                    
                    if let nda = formateur.nda, !nda.isEmpty {
                        InfoRow(label: "NDA", value: nda)
                    }
                    
                    if let siret = formateur.siret, !siret.isEmpty {
                        InfoRow(label: "SIRET", value: siret)
                    }
                }
                
                // Société (si externe)
                if formateur.exterieur, let societe = formateur.societe, !societe.isEmpty {
                    Divider()
                    
                    InfoSection(title: "Société", icon: "building.2.fill") {
                        Text(societe)
                            .font(.body)
                    }
                }
                
                // Adresse
                if let adresse = formateur.adresseComplete {
                    Divider()
                    
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
                                
                                Text(session.displayDate)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
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
        .sheet(isPresented: $showingEditSheet) {
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
}

// Bouton d'action rapide
struct ActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                Text(title)
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(color.opacity(0.1))
            .foregroundColor(color)
            .cornerRadius(12)
        }
    }
}

// Ligne de contact cliquable
struct ContactRow: View {
    let icon: String
    let label: String
    let value: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(label)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(value)
                        .font(.body)
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    NavigationView {
        FormateurDetailView(formateur: Formateur(
            prenom: "Jean",
            nom: "Dupont",
            email: "jean.dupont@example.com",
            telephone: "06 12 34 56 78",
            specialite: "Swift & iOS",
            tauxHoraire: 50,
            exterieur: false
        ))
        .environmentObject(AuthService.shared)
    }
}
