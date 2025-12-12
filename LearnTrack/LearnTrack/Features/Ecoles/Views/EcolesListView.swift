//
//  EcolesListView.swift
//  LearnTrack
//
//  Liste des écoles - Design Emerald Premium
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
                
                VStack(spacing: LTSpacing.md) {
                    // Search bar
                    LTSearchBar(text: $viewModel.searchText, placeholder: "Rechercher une école...")
                        .padding(.horizontal, LTSpacing.lg)
                        .padding(.top, LTSpacing.sm)
                    
                    // Content
                    Group {
                        if viewModel.isLoading {
                            loadingView
                        } else if viewModel.filteredEcoles.isEmpty {
                            emptyStateView
                        } else {
                            ecolesList
                        }
                    }
                }
            }
            .navigationTitle("Écoles")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
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
    
    // MARK: - Loading View
    private var loadingView: some View {
        VStack(spacing: LTSpacing.md) {
            ForEach(0..<4, id: \.self) { _ in
                LTSkeletonPersonRow()
            }
        }
        .padding(.horizontal, LTSpacing.lg)
    }
    
    // MARK: - Empty State
    private var emptyStateView: some View {
        LTEmptyState(
            icon: "graduationcap.fill",
            title: "Aucune école",
            message: "Aucune école trouvée",
            actionTitle: "Ajouter",
            action: { showingAddEcole = true }
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Ecoles List
    private var ecolesList: some View {
        ScrollView {
            LazyVStack(spacing: LTSpacing.md) {
                ForEach(Array(viewModel.filteredEcoles.enumerated()), id: \.element.id) { index, ecole in
                    NavigationLink(destination: EcoleDetailView(ecole: ecole)) {
                        ecoleCard(ecole)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .animation(.ltSpringSmooth.delay(Double(index) * 0.03), value: viewModel.filteredEcoles.count)
                }
            }
            .padding(.horizontal, LTSpacing.lg)
            .padding(.bottom, 120)
        }
        .refreshable {
            await viewModel.fetchEcoles()
        }
    }
    
    // MARK: - Ecole Card
    private func ecoleCard(_ ecole: Ecole) -> some View {
        LTCard(variant: .interactive) {
            HStack(spacing: LTSpacing.md) {
                // Icon
                ZStack {
                    Circle()
                        .fill(Color.emerald500.opacity(0.15))
                        .frame(width: LTHeight.avatarMedium, height: LTHeight.avatarMedium)
                    
                    Image(systemName: "graduationcap.fill")
                        .font(.system(size: LTIconSize.lg))
                        .foregroundColor(.emerald500)
                }
                
                // Info
                VStack(alignment: .leading, spacing: LTSpacing.xs) {
                    Text(ecole.nom)
                        .font(.ltBodySemibold)
                        .foregroundColor(.ltText)
                    
                    if let ville = ecole.ville, !ville.isEmpty {
                        Text(ville)
                            .font(.ltCaption)
                            .foregroundColor(.ltTextSecondary)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: LTIconSize.sm, weight: .semibold))
                    .foregroundColor(.ltTextTertiary)
            }
        }
    }
}

#Preview {
    EcolesListView()
        .environmentObject(AuthService.shared)
        .preferredColorScheme(.dark)
}
