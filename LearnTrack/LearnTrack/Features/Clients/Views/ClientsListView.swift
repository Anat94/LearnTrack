//
//  ClientsListView.swift
//  LearnTrack
//
//  Liste des clients - Design Emerald Premium
//

import SwiftUI

struct ClientsListView: View {
    @StateObject private var viewModel = ClientViewModel()
    @State private var showingAddClient = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.ltBackground
                    .ignoresSafeArea()
                
                VStack(spacing: LTSpacing.md) {
                    // Search bar
                    LTSearchBar(text: $viewModel.searchText, placeholder: "Rechercher un client...")
                        .padding(.horizontal, LTSpacing.lg)
                        .padding(.top, LTSpacing.sm)
                    
                    // Content
                    Group {
                        if viewModel.isLoading {
                            loadingView
                        } else if viewModel.filteredClients.isEmpty {
                            emptyStateView
                        } else {
                            clientsList
                        }
                    }
                }
            }
            .navigationTitle("Clients")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    LTIconButton(icon: "plus", variant: .primary, size: .small) {
                        showingAddClient = true
                    }
                }
            }
            .sheet(isPresented: $showingAddClient) {
                ClientFormView(viewModel: viewModel)
            }
            .task {
                await viewModel.fetchClients()
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
            icon: "building.2.slash",
            title: "Aucun client",
            message: "Aucun client trouvé",
            actionTitle: "Ajouter",
            action: { showingAddClient = true }
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Clients List
    private var clientsList: some View {
        ScrollView {
            LazyVStack(spacing: LTSpacing.md) {
                ForEach(Array(viewModel.filteredClients.enumerated()), id: \.element.id) { index, client in
                    NavigationLink(destination: ClientDetailView(client: client)) {
                        LTPersonCard(
                            name: client.raisonSociale,
                            subtitle: client.email.isEmpty ? (client.ville ?? "") : client.email,
                            initials: client.initiales,
                            badgeColor: .info,
                            action: {}
                        )
                        .allowsHitTesting(false)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .animation(.ltSpringSmooth.delay(Double(index) * 0.03), value: viewModel.filteredClients.count)
                }
            }
            .padding(.horizontal, LTSpacing.lg)
            .padding(.bottom, 120)
        }
        .refreshable {
            await viewModel.fetchClients()
        }
    }
}

#Preview {
    ClientsListView()
        .environmentObject(AuthService.shared)
        .preferredColorScheme(.dark)
}
