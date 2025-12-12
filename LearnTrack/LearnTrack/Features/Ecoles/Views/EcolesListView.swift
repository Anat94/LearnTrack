//
//  EcolesListView.swift
//  LearnTrack
//
//  Liste des écoles - Design Emerald
//

import SwiftUI

struct EcolesListView: View {
    @StateObject private var viewModel = EcoleViewModel()
    @State private var showingAddEcole = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.ltBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    headerSection
                    
                    // Content
                    contentSection
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Écoles")
                        .font(.ltH3)
                        .foregroundColor(.ltText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    LTIconButton(icon: "plus", variant: .primary, size: .small) {
                        showingAddEcole = true
                    }
                }
            }
            .sheet(isPresented: $showingAddEcole) {
                EcoleFormView(viewModel: viewModel)
            }
            .task {
                await viewModel.fetchEcoles()
            }
        }
    }
    
    // MARK: - Header
    private var headerSection: some View {
        LTSearchBar(text: $viewModel.searchText, placeholder: "Rechercher une école...")
            .padding(.horizontal, LTSpacing.lg)
            .padding(.vertical, LTSpacing.md)
            .background(Color.ltCard)
    }
    
    // MARK: - Content
    @ViewBuilder
    private var contentSection: some View {
        if viewModel.isLoading {
            ScrollView {
                LazyVStack(spacing: LTSpacing.md) {
                    ForEach(0..<6) { _ in
                        LTSkeletonPersonRow()
                    }
                }
                .padding(.horizontal, LTSpacing.lg)
                .padding(.top, LTSpacing.lg)
            }
        } else if viewModel.filteredEcoles.isEmpty {
            LTEmptyState(
                icon: "graduationcap.fill",
                title: "Aucune école",
                message: "Aucune école trouvée. Ajoutez-en une nouvelle !",
                actionTitle: "Ajouter une école"
            ) {
                showingAddEcole = true
            }
        } else {
            ScrollView {
                LazyVStack(spacing: LTSpacing.md) {
                    ForEach(Array(viewModel.filteredEcoles.enumerated()), id: \.element.id) { index, ecole in
                        NavigationLink(destination: EcoleDetailView(ecole: ecole)) {
                            EcoleCardNew(ecole: ecole)
                                .ltStaggered(index: index)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, LTSpacing.lg)
                .padding(.top, LTSpacing.lg)
                .padding(.bottom, 100)
            }
            .refreshable {
                await viewModel.fetchEcoles()
            }
        }
    }
}

// MARK: - New Ecole Card
struct EcoleCardNew: View {
    let ecole: Ecole
    
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: LTSpacing.md) {
            // Avatar
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.emerald400, .emerald600],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: LTHeight.avatarMedium, height: LTHeight.avatarMedium)
                
                Image(systemName: "graduationcap.fill")
                    .font(.system(size: LTIconSize.lg))
                    .foregroundColor(.white)
            }
            
            // Info
            VStack(alignment: .leading, spacing: LTSpacing.xs) {
                Text(ecole.nom)
                    .font(.ltBodySemibold)
                    .foregroundColor(.ltText)
                
                if let ville = ecole.ville, !ville.isEmpty {
                    LTIconLabel(icon: "mappin.circle", text: ville)
                }
            }
            
            Spacer()
            
            // Chevron
            Image(systemName: "chevron.right")
                .font(.system(size: LTIconSize.sm, weight: .semibold))
                .foregroundColor(.ltTextTertiary)
        }
        .padding(LTSpacing.md)
        .background(Color.ltCard)
        .clipShape(RoundedRectangle(cornerRadius: LTRadius.xl))
        .overlay(
            RoundedRectangle(cornerRadius: LTRadius.xl)
                .stroke(Color.ltBorderSubtle, lineWidth: 1)
        )
        .ltCardShadow()
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.ltSpringSubtle, value: isPressed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}

#Preview {
    EcolesListView()
}
