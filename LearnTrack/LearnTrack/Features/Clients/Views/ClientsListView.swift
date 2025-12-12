//
//  ClientsListView.swift
//  LearnTrack
//
//  Liste des clients - Design Premium
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
                    // Search
                    LTSearchBar(text: $viewModel.searchText, placeholder: "Rechercher...")
                        .padding(.horizontal, LTSpacing.lg)
                        .padding(.vertical, LTSpacing.md)
                    
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
                    addButton
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
    
    // MARK: - Add Button
    private var addButton: some View {
        Button {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            showingAddClient = true
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
        .ltScaleOnPress()
    }
    
    // MARK: - Content
    @ViewBuilder
    private var contentSection: some View {
        if viewModel.isLoading {
            ScrollView {
                VStack(spacing: LTSpacing.md) {
                    ForEach(0..<4, id: \.self) { index in
                        LTSkeletonPersonRow()
                            .ltStaggered(index: index)
                    }
                }
                .padding(.horizontal, LTSpacing.lg)
            }
        } else if viewModel.filteredClients.isEmpty {
            LTEmptyState(
                icon: "building.2.slash",
                title: "Aucun client",
                message: "Aucun client trouvé",
                actionTitle: "Ajouter",
                action: { showingAddClient = true }
            )
        } else {
            clientsList
        }
    }
    
    // MARK: - List
    private var clientsList: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: LTSpacing.md) {
                ForEach(Array(viewModel.filteredClients.enumerated()), id: \.element.id) { index, client in
                    NavigationLink(destination: ClientDetailView(client: client)) {
                        ClientCardView(client: client)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .ltStaggered(index: index)
                }
            }
            .padding(.horizontal, LTSpacing.lg)
            .padding(.bottom, 100)
        }
        .refreshable {
            await viewModel.fetchClients()
        }
    }
}

// MARK: - Client Card
struct ClientCardView: View {
    let client: Client
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: LTSpacing.md) {
            LTAvatar(initials: client.initiales, size: .medium, color: .info)
            
            VStack(alignment: .leading, spacing: LTSpacing.xs) {
                Text(client.raisonSociale)
                    .font(.ltBodySemibold)
                    .foregroundColor(.ltText)
                
                Text(client.email.isEmpty ? (client.ville ?? "") : client.email)
                    .font(.ltCaption)
                    .foregroundColor(.ltTextSecondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: LTIconSize.sm, weight: .semibold))
                .foregroundColor(.ltTextTertiary)
        }
        .padding(LTSpacing.lg)
        .background(Color.ltCard)
        .clipShape(RoundedRectangle(cornerRadius: LTRadius.xl))
        .overlay(
            RoundedRectangle(cornerRadius: LTRadius.xl)
                .stroke(Color.ltBorderSubtle, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
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
        .environmentObject(AuthService.shared)
        .preferredColorScheme(.dark)
}
