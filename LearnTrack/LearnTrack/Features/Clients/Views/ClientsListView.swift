//
//  ClientsListView.swift
//  LearnTrack
//
//  Liste des clients - Design Emerald
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
                    Text("Clients")
                        .font(.ltH3)
                        .foregroundColor(.ltText)
                }
                
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
    
    // MARK: - Header
    private var headerSection: some View {
        LTSearchBar(text: $viewModel.searchText, placeholder: "Rechercher un client...")
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
        } else if viewModel.filteredClients.isEmpty {
            LTEmptyState(
                icon: "building.2.slash",
                title: "Aucun client",
                message: "Aucun client trouvé. Ajoutez-en un nouveau !",
                actionTitle: "Ajouter un client"
            ) {
                showingAddClient = true
            }
        } else {
            ScrollView {
                LazyVStack(spacing: LTSpacing.md) {
                    ForEach(Array(viewModel.filteredClients.enumerated()), id: \.element.id) { index, client in
                        NavigationLink(destination: ClientDetailView(client: client)) {
                            ClientCardNew(client: client)
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
                await viewModel.fetchClients()
            }
        }
    }
}

// MARK: - New Client Card
struct ClientCardNew: View {
    let client: Client
    
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: LTSpacing.md) {
            // Avatar
            LTAvatar(
                initials: client.initiales,
                size: .medium,
                color: .info
            )
            
            // Info
            VStack(alignment: .leading, spacing: LTSpacing.xs) {
                Text(client.raisonSociale)
                    .font(.ltBodySemibold)
                    .foregroundColor(.ltText)
                
                LTIconLabel(icon: "mappin.circle", text: client.villeDisplay)
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
    ClientsListView()
}
