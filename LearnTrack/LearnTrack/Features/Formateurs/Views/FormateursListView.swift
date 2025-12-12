//
//  FormateursListView.swift
//  LearnTrack
//
//  Liste des formateurs - Design Emerald Premium
//

import SwiftUI

struct FormateursListView: View {
    @StateObject private var viewModel = FormateurViewModel()
    @State private var showingAddFormateur = false
    @State private var selectedFilterIndex = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.ltBackground
                    .ignoresSafeArea()
                
                VStack(spacing: LTSpacing.md) {
                    // Search bar
                    LTSearchBar(text: $viewModel.searchText, placeholder: "Rechercher un formateur...")
                        .padding(.horizontal, LTSpacing.lg)
                        .padding(.top, LTSpacing.sm)
                    
                    // Filter tabs
                    LTSegmentedControl(
                        selectedIndex: $selectedFilterIndex,
                        items: ["Tous", "Internes", "Externes"]
                    )
                    .padding(.horizontal, LTSpacing.lg)
                    
                    // Content
                    Group {
                        if viewModel.isLoading {
                            loadingView
                        } else if viewModel.filteredFormateurs.isEmpty {
                            emptyStateView
                        } else {
                            formateursList
                        }
                    }
                }
            }
            .navigationTitle("Formateurs")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    LTIconButton(icon: "plus", variant: .primary, size: .small) {
                        showingAddFormateur = true
                    }
                }
            }
            .sheet(isPresented: $showingAddFormateur) {
                FormateurFormView(viewModel: viewModel)
            }
            .task {
                await viewModel.fetchFormateurs()
            }
            .onChange(of: selectedFilterIndex) { _, newValue in
                withAnimation(.ltSpringSnappy) {
                    switch newValue {
                    case 0: viewModel.filterType = .tous
                    case 1: viewModel.filterType = .internes
                    case 2: viewModel.filterType = .externes
                    default: viewModel.filterType = .tous
                    }
                }
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
            icon: "person.2.slash",
            title: "Aucun formateur",
            message: "Aucun formateur trouvé",
            actionTitle: "Ajouter",
            action: { showingAddFormateur = true }
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Formateurs List
    private var formateursList: some View {
        ScrollView {
            LazyVStack(spacing: LTSpacing.md) {
                ForEach(Array(viewModel.filteredFormateurs.enumerated()), id: \.element.id) { index, formateur in
                    NavigationLink(destination: FormateurDetailView(formateur: formateur)) {
                        LTPersonCard(
                            name: formateur.nomComplet,
                            subtitle: formateur.specialite.isEmpty ? formateur.email : formateur.specialite,
                            initials: formateur.initiales,
                            badge: formateur.exterieur ? "Externe" : "Interne",
                            badgeColor: formateur.exterieur ? .warning : .emerald500,
                            action: {}
                        )
                        .allowsHitTesting(false)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .animation(.ltSpringSmooth.delay(Double(index) * 0.03), value: viewModel.filteredFormateurs.count)
                }
            }
            .padding(.horizontal, LTSpacing.lg)
            .padding(.bottom, 120)
        }
        .refreshable {
            await viewModel.fetchFormateurs()
        }
    }
}

#Preview {
    FormateursListView()
        .environmentObject(AuthService.shared)
        .preferredColorScheme(.dark)
}
