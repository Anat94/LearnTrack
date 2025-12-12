//
//  EcoleDetailView.swift
//  LearnTrack
//
//  Détail d'une école - Design Emerald
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
            Color.ltBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: LTSpacing.lg) {
                    // Header card
                    headerCard
                    
                    // Quick actions
                    quickActionsSection
                    
                    // Contact info
                    contactSection
                    
                    // Address
                    if let adresse = ecole.adresseComplete {
                        addressSection(adresse)
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
            VStack(spacing: LTSpacing.md) {
                // Icon avatar
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.emerald400, .emerald600],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: LTHeight.avatarXL, height: LTHeight.avatarXL)
                    
                    Image(systemName: "graduationcap.fill")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                }
                .overlay(
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [.emerald400, .emerald600],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 3
                        )
                )
                
                Text(ecole.nom)
                    .font(.ltH2)
                    .foregroundColor(.ltText)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    // MARK: - Quick Actions
    private var quickActionsSection: some View {
        HStack(spacing: LTSpacing.md) {
            QuickActionButtonEcole(
                icon: "phone.fill",
                title: "Appeler",
                color: .emerald500
            ) {
                ContactService.shared.call(phoneNumber: ecole.telephone)
            }
            
            QuickActionButtonEcole(
                icon: "envelope.fill",
                title: "Email",
                color: .info
            ) {
                ContactService.shared.sendEmail(to: ecole.email)
            }
        }
    }
    
    // MARK: - Contact Section
    private var contactSection: some View {
        LTInfoSection(title: "Contact", icon: "person.fill") {
            VStack(alignment: .leading, spacing: LTSpacing.md) {
                Text(ecole.nomContact)
                    .font(.ltH4)
                    .foregroundColor(.ltText)
                
                ContactRowEcole(
                    icon: "phone",
                    label: "Téléphone",
                    value: ecole.telephone
                ) {
                    ContactService.shared.call(phoneNumber: ecole.telephone)
                }
                
                ContactRowEcole(
                    icon: "envelope",
                    label: "Email",
                    value: ecole.email
                ) {
                    ContactService.shared.sendEmail(to: ecole.email)
                }
            }
        }
    }
    
    // MARK: - Address Section
    private func addressSection(_ adresse: String) -> some View {
        LTInfoSection(title: "Adresse", icon: "mappin.circle.fill") {
            VStack(alignment: .leading, spacing: LTSpacing.sm) {
                Text(adresse)
                    .font(.ltBody)
                    .foregroundColor(.ltText)
                
                LTButton("Ouvrir dans Plans", variant: .subtle, size: .small, icon: "map.fill") {
                    ContactService.shared.openInMaps(address: adresse)
                }
            }
        }
    }
    
    // MARK: - Action Buttons
    private var actionButtons: some View {
        VStack(spacing: LTSpacing.md) {
            LTButton("Modifier", variant: .secondary, icon: "pencil", isFullWidth: true) {
                showingEditSheet = true
            }
            
            if authService.userRole == .admin {
                LTButton("Supprimer", variant: .destructive, icon: "trash", isFullWidth: true) {
                    showingDeleteAlert = true
                }
            }
        }
        .padding(.top, LTSpacing.lg)
    }
    
    // MARK: - Helpers
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

// MARK: - Quick Action Button (Ecole)
private struct QuickActionButtonEcole: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
            action()
        }) {
            VStack(spacing: LTSpacing.sm) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: icon)
                        .font(.system(size: LTIconSize.lg, weight: .semibold))
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(.ltCaptionMedium)
                    .foregroundColor(.ltText)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, LTSpacing.md)
            .background(Color.ltCard)
            .clipShape(RoundedRectangle(cornerRadius: LTRadius.lg))
            .ltCardShadow()
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

// MARK: - Contact Row (Ecole)
private struct ContactRowEcole: View {
    let icon: String
    let label: String
    let value: String
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            action()
        }) {
            HStack(spacing: LTSpacing.md) {
                Image(systemName: icon)
                    .font(.system(size: LTIconSize.md))
                    .foregroundColor(.emerald500)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: LTSpacing.xxs) {
                    Text(label)
                        .font(.ltCaption)
                        .foregroundColor(.ltTextSecondary)
                    Text(value)
                        .font(.ltBodyMedium)
                        .foregroundColor(.ltText)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: LTIconSize.sm))
                    .foregroundColor(.ltTextTertiary)
            }
            .padding(LTSpacing.md)
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
}
