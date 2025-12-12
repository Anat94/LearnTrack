//
//  ClientsListView.swift
//  LearnTrack
//
//  Liste des clients style Winamax
//

import SwiftUI

struct ClientsListView: View {
    @StateObject private var viewModel = ClientViewModel()
    @State private var showingAddClient = false
    @Environment(\.colorScheme) var colorScheme
    
    var theme: AppTheme {
        colorScheme == .dark ? .dark : .light
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                WinamaxBackground()
                
                VStack(spacing: 16) {
                    SearchBar(text: $viewModel.searchText, placeholder: "Rechercher une entreprise...")
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: theme.primaryGreen))
                            .scaleEffect(1.2)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if viewModel.filteredClients.isEmpty {
                        EmptyStateView(
                            icon: "building.2.slash",
                            title: "Aucun client",
                            message: "Ajoutez votre premier partenaire ou ajustez la recherche"
                        )
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 14) {
                                ForEach(viewModel.filteredClients) { client in
                                    NavigationLink(destination: ClientDetailView(client: client)) {
                                        ClientRowView(client: client)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                        }
                        .refreshable {
                            await viewModel.fetchClients()
                        }
                    }
                }
            }
            .navigationTitle("Clients")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddClient = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(theme.primaryGreen)
                            .shadow(color: theme.primaryGreen.opacity(0.3), radius: 8, y: 4)
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
}

struct ClientRowView: View {
    let client: Client
    @Environment(\.colorScheme) var colorScheme
    
    var theme: AppTheme {
        colorScheme == .dark ? .dark : .light
    }
    
    var body: some View {
        HStack(spacing: 14) {
            // Avatar avec initiales
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [theme.primaryGreen, theme.primaryGreen.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 56, height: 56)
                    .shadow(color: theme.primaryGreen.opacity(0.3), radius: 8, y: 4)
                
                Text(client.initiales)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(client.raisonSociale)
                    .font(.winamaxHeadline())
                    .foregroundColor(theme.textPrimary)
                
                HStack(spacing: 6) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 12))
                    Text(client.villeDisplay)
                        .font(.winamaxCaption())
                }
                .foregroundColor(theme.textSecondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(theme.textSecondary)
        }
        .winamaxCard()
    }
}

#Preview {
    ClientsListView()
        .preferredColorScheme(.dark)
}
