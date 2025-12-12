//
//  EcoleDetailView.swift
//  LearnTrack
//
//  Détail d'une école style Winamax - Design audacieux
//

import SwiftUI

struct EcoleDetailView: View {
    @State var ecole: Ecole
    @StateObject private var viewModel = EcoleViewModel()
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var authService: AuthService
    
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    
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
                                        colors: [theme.accentOrange, theme.accentOrange.opacity(0.7)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 120, height: 120)
                                .shadow(color: theme.accentOrange.opacity(0.4), radius: 20, y: 10)
                            
                            Text(ecole.initiales)
                                .font(.system(size: 42, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                        
                        VStack(spacing: 8) {
                            Text(ecole.nom)
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(theme.textPrimary)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                            
                            if !ecole.villeDisplay.isEmpty {
                                HStack(spacing: 6) {
                                    Image(systemName: "mappin.circle.fill")
                                        .font(.system(size: 14))
                                    Text(ecole.villeDisplay)
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
                            colors: [theme.accentOrange.opacity(0.15), theme.accentOrange.opacity(0.05), .clear],
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
                            ContactService.shared.call(phoneNumber: ecole.telephone)
                        }
                        
                        QuickActionButton(
                            icon: "envelope.fill",
                            title: "Email",
                            color: theme.accentOrange
                        ) {
                            ContactService.shared.sendEmail(to: ecole.email)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    // Contenu principal
                    VStack(spacing: 20) {
                        // Contact
                        DetailCard(
                            icon: "person.fill",
                            iconColor: theme.primaryGreen,
                            title: "Contact",
                            content: {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text(ecole.nomContact)
                                        .font(.winamaxHeadline())
                                        .foregroundColor(theme.textPrimary)
                                    
                                    VStack(spacing: 12) {
                                        ContactDetailRow(
                                            icon: "phone.fill",
                                            label: "Téléphone",
                                            value: ecole.telephone,
                                            color: theme.primaryGreen
                                        ) {
                                            ContactService.shared.call(phoneNumber: ecole.telephone)
                                        }
                                        
                                        ContactDetailRow(
                                            icon: "envelope.fill",
                                            label: "Email",
                                            value: ecole.email,
                                            color: theme.accentOrange
                                        ) {
                                            ContactService.shared.sendEmail(to: ecole.email)
                                        }
                                    }
                                }
                            }
                        )
                        
                        // Adresse
                        if let adresse = ecole.adresseComplete {
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
            Task { await refreshEcole() }
        }) {
            EcoleFormView(viewModel: viewModel, ecoleToEdit: ecole)
        }
        .alert("Supprimer l'école ?", isPresented: $showingDeleteAlert) {
            Button("Annuler", role: .cancel) { }
            Button("Supprimer", role: .destructive) {
                Task {
                    try? await viewModel.deleteEcole(ecole)
                    dismiss()
                }
            }
        }
    }
    
    private func refreshEcole() async {
        guard let id = ecole.id else { return }
        do {
            let api = try await APIService.shared.getEcole(id: Int(id))
            await MainActor.run { self.ecole = mapAPIEcole(api) }
        } catch { print("Erreur refresh ecole: \(error)") }
    }
    
    private func mapAPIEcole(_ api: APIEcole) -> Ecole {
        Ecole(
            id: Int64(api.id),
            nom: api.nom,
            rue: api.adresse,
            codePostal: api.codePostal,
            ville: api.ville,
            nomContact: api.responsableNom ?? "",
            email: api.email ?? "",
            telephone: api.telephone ?? ""
        )
    }
}

#Preview {
    NavigationView {
        EcoleDetailView(ecole: Ecole(
            nom: "École Supérieure de Formation",
            rue: "45 avenue des Sciences",
            codePostal: "75013",
            ville: "Paris",
            nomContact: "Pierre Durand",
            email: "contact@ecole.fr",
            telephone: "01 45 67 89 01"
        ))
        .environmentObject(AuthService.shared)
    }
    .preferredColorScheme(.dark)
}
