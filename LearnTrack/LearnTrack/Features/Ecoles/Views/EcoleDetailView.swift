//
//  EcoleDetailView.swift
//  LearnTrack
//
//  Détail école - Design SaaS compact
//

import SwiftUI

struct EcoleDetailView: View {
    @State var ecole: Ecole
    @StateObject private var viewModel = EcoleViewModel()
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authService: AuthService
    
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ZStack {
            Color.ltBackground.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: LTSpacing.md) {
                    // Header
                    headerCard
                    
                    // Quick Actions
                    quickActionsRow
                    
                    // Contact
                    contactCard
                    
                    // Adresse
                    if let adresse = ecole.adresseComplete {
                        adresseCard(adresse)
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
                Text("École")
                    .font(.ltH4)
                    .foregroundColor(.ltText)
            }
        }
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
    
    // MARK: - Header Card
    private var headerCard: some View {
        LTCard(variant: .accent) {
            HStack(spacing: LTSpacing.md) {
                ZStack {
                    Circle()
                        .fill(Color.warning.opacity(0.15))
                        .frame(width: LTHeight.avatarLarge, height: LTHeight.avatarLarge)
                    
                    Image(systemName: "graduationcap.fill")
                        .font(.system(size: LTIconSize.xl))
                        .foregroundColor(.warning)
                }
                
                VStack(alignment: .leading, spacing: LTSpacing.xs) {
                    Text(ecole.nom)
                        .font(.ltH3)
                        .foregroundColor(.ltText)
                        .lineLimit(2)
                    
                    if !ecole.villeDisplay.isEmpty {
                        HStack(spacing: LTSpacing.xs) {
                            Image(systemName: "mappin")
                                .font(.system(size: LTIconSize.xs))
                            Text(ecole.villeDisplay)
                                .font(.ltCaption)
                        }
                        .foregroundColor(.ltTextSecondary)
                    }
                }
                
                Spacer()
            }
        }
    }
    
    // MARK: - Quick Actions
    private var quickActionsRow: some View {
        HStack(spacing: LTSpacing.sm) {
            QuickActionCompact(icon: "phone.fill", title: "Appeler", color: .emerald500) {
                ContactService.shared.call(phoneNumber: ecole.telephone)
            }
            
            QuickActionCompact(icon: "envelope.fill", title: "Email", color: .warning) {
                ContactService.shared.sendEmail(to: ecole.email)
            }
        }
    }
    
    // MARK: - Contact Card
    private var contactCard: some View {
        LTCard {
            VStack(alignment: .leading, spacing: LTSpacing.md) {
                SectionHeader(icon: "person.fill", title: "Contact", color: .emerald500)
                
                if !ecole.nomContact.isEmpty {
                    Text(ecole.nomContact)
                        .font(.ltBodySemibold)
                        .foregroundColor(.ltText)
                }
                
                VStack(spacing: LTSpacing.sm) {
                    ContactRowCompact(icon: "phone.fill", label: "Téléphone", value: ecole.telephone, color: .emerald500) {
                        ContactService.shared.call(phoneNumber: ecole.telephone)
                    }
                    
                    ContactRowCompact(icon: "envelope.fill", label: "Email", value: ecole.email, color: .warning) {
                        ContactService.shared.sendEmail(to: ecole.email)
                    }
                }
            }
        }
    }
    
    // MARK: - Adresse Card
    private func adresseCard(_ adresse: String) -> some View {
        LTCard {
            VStack(alignment: .leading, spacing: LTSpacing.sm) {
                SectionHeader(icon: "mappin.circle.fill", title: "Adresse", color: .warning)
                
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
            nom: "École Supérieure",
            rue: "45 avenue des Sciences",
            codePostal: "75013",
            ville: "Paris",
            nomContact: "Pierre Durand",
            email: "contact@ecole.fr",
            telephone: "0145678901"
        ))
        .environmentObject(AuthService.shared)
    }
    .preferredColorScheme(.dark)
}
