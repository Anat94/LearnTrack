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
    }
    
    // MARK: - Content
    @ViewBuilder
    private var contentSection: some View {
        if viewModel.isLoading {
            ScrollView {
                VStack(spacing: LTSpacing.md) {
                    ForEach(0..<4, id: \.self) { index in
                        LTSkeletonPersonRow()
                            .opacity(hasAppeared ? 1 : 0)
                            .animation(.easeOut(duration: 0.4).delay(Double(index) * 0.1), value: hasAppeared)
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
            .opacity(hasAppeared ? 1 : 0)
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
            await viewModel.fetchClients()
        }
    }
}

#Preview {
    ClientsListView()
        .environmentObject(AuthService.shared)
        .preferredColorScheme(.dark)
}
