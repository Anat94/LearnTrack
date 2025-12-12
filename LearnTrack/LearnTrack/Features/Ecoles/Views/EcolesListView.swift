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
                        .animation(.easeOut(duration: 0.3), value: hasAppeared)
                    
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
                hasAppeared = true
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
            loadingView
        } else if viewModel.filteredEcoles.isEmpty {
            LTEmptyState(
                icon: "graduationcap",
                title: "Aucune école",
                message: "Aucune école trouvée",
                actionTitle: "Ajouter",
                action: { showingAddEcole = true }
            )
        } else {
            ecolesList
        }
    }
    
    // MARK: - Loading
    private var loadingView: some View {
        ScrollView {
            VStack(spacing: LTSpacing.md) {
                ForEach(0..<4, id: \.self) { _ in
                    LTSkeletonCard()
                }
            }
            .padding(.horizontal, LTSpacing.lg)
        }
    }
    
    // MARK: - List
    private var ecolesList: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: LTSpacing.md) {
                ForEach(Array(viewModel.filteredEcoles.enumerated()), id: \.element.id) { index, ecole in
                    NavigationLink(destination: EcoleDetailView(ecole: ecole)) {
                        LTEcoleCardContent(name: ecole.nom, ville: ecole.ville)
                    }
                    .ltListCardStyle()
                    .opacity(hasAppeared ? 1 : 0)
                    .offset(y: hasAppeared ? 0 : 20)
                    .animation(
                        .easeOut(duration: 0.3).delay(Double(index) * 0.05),
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
}

#Preview {
    EcolesListView()
        .environmentObject(AuthService.shared)
        .preferredColorScheme(.dark)
}
