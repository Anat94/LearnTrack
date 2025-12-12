//
//  ClientsListView.swift
//  LearnTrack
//
//  Liste des clients
//

import SwiftUI

struct ClientsListView: View {
    @StateObject private var viewModel = ClientViewModel()
    @State private var showingAddClient = false
    
    var body: some View {
        NavigationView {
            ZStack {
                BrandBackground()
                
                VStack(spacing: 16) {
                    SearchBar(text: $viewModel.searchText, placeholder: "Rechercher une entreprise")
                        .padding(.horizontal)
                        .padding(.top, 8)
                    
                    if viewModel.isLoading {
                        ProgressView("Chargement...")
                            .progressViewStyle(CircularProgressViewStyle(tint: .brandCyan))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if viewModel.filteredClients.isEmpty {
                        EmptyStateView(
                            icon: "building.2.slash",
                            title: "Aucun client",
                            message: "Ajoutez votre premier partenaire ou ajustez la recherche."
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
                            .padding(.horizontal)
                            .padding(.bottom, 12)
                        }
                        .refreshable {
                            await viewModel.fetchClients()
                        }
                    }
                }
            }
            .navigationTitle("Clients")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddClient = true }) {
                        Image(systemName: "sparkles.rectangle.on.rectangle")
                            .font(.title2)
                            .foregroundColor(.brandCyan)
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
    
    var body: some View {
        HStack(spacing: 14) {
            // Avatar avec initiales
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.brandCyan, .brandPink],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 54, height: 54)
                    .shadow(color: .brandCyan.opacity(0.3), radius: 10, y: 6)
                
                Text(client.initiales)
                    .font(.headline)
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(client.raisonSociale)
                    .font(.headline)
                    .foregroundColor(.white)
                
                HStack(spacing: 6) {
                    Image(systemName: "mappin.circle")
                        .font(.caption)
                    Text(client.villeDisplay)
                        .font(.subheadline)
                }
                .foregroundColor(.white.opacity(0.75))
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.white.opacity(0.6))
        }
        .glassCard()
    }
}

#Preview {
    ClientsListView()
}
