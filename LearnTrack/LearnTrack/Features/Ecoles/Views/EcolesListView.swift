//
//  EcolesListView.swift
//  LearnTrack
//
//  Liste des écoles - Design Premium
//

import SwiftUI

struct EcolesListView: View {
    @StateObject private var viewModel = EcoleViewModel()
    @State private var showingAddEcole = false
    @State private var hasAppeared = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.ltBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Search
                    LTSearchBar(text: $viewModel.searchText, placeholder: "Rechercher...")
                        .padding(.horizontal, LTSpacing.lg)
                        .padding(.vertical, LTSpacing.md)
                        .opacity(hasAppeared ? 1 : 0)
                        .offset(y: hasAppeared ? 0 : -20)
                    
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
                    addButton
                }
            }
            .sheet(isPresented: $showingAddEcole) {
                EcoleFormView(viewModel: viewModel)
            }
            .task {
                await viewModel.fetchEcoles()
            }
            .onAppear {
                withAnimation(.easeOut(duration: 0.3).delay(0.1)) {
                    hasAppeared = true
                }
            }
        }
    }
    
    // MARK: - Add Button
    private var addButton: some View {
        Button {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            showingAddEcole = true
        } label: {
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [.emerald400, .emerald600], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 36, height: 36)
                    .shadow(color: .emerald500.opacity(0.4), radius: 8, y: 2)
                
                Image(systemName: "plus")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
            }
        }
    }
    
    // MARK: - Content
    @ViewBuilder
    private var contentSection: some View {
        if viewModel.isLoading {
            ScrollView {
                VStack(spacing: LTSpacing.md) {
                    ForEach(0..<4, id: \.self) { index in
                        LTSkeletonCard()
                            .opacity(hasAppeared ? 1 : 0)
                            .animation(.easeOut(duration: 0.4).delay(Double(index) * 0.1), value: hasAppeared)
                    }
                }
                .padding(.horizontal, LTSpacing.lg)
            }
        } else if viewModel.filteredEcoles.isEmpty {
            LTEmptyState(
                icon: "graduationcap",
                title: "Aucune école",
                message: "Aucune école trouvée",
                actionTitle: "Ajouter",
                action: { showingAddEcole = true }
            )
            .opacity(hasAppeared ? 1 : 0)
        } else {
            ecolesList
        }
    }
    
    // MARK: - List
    private var ecolesList: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: LTSpacing.md) {
                ForEach(Array(viewModel.filteredEcoles.enumerated()), id: \.element.id) { index, ecole in
                    NavigationLink(destination: EcoleDetailView(ecole: ecole)) {
                        ecoleCard(ecole)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .opacity(hasAppeared ? 1 : 0)
                    .offset(y: hasAppeared ? 0 : 30)
                    .animation(
                        .spring(response: 0.5, dampingFraction: 0.8).delay(Double(index) * 0.05),
                        value: hasAppeared
                    )
                }
            }
            .padding(.horizontal, LTSpacing.lg)
            .padding(.bottom, 100)
        }
        .refreshable {
            await viewModel.fetchEcoles()
        }
    }
    
    // MARK: - Card
    private func ecoleCard(_ ecole: Ecole) -> some View {
        LTInteractiveCard(action: {}) {
            HStack(spacing: LTSpacing.md) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.emerald500.opacity(0.2), .emerald600.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: LTHeight.avatarMedium, height: LTHeight.avatarMedium)
                    
                    Image(systemName: "graduationcap.fill")
                        .font(.system(size: LTIconSize.lg))
                        .foregroundColor(.emerald500)
                }
                
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
        .allowsHitTesting(false)
    }
}

#Preview {
    EcolesListView()
        .environmentObject(AuthService.shared)
        .preferredColorScheme(.dark)
}
