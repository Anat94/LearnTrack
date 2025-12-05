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
            VStack(spacing: 0) {
                // Barre de recherche
                SearchBar(text: $viewModel.searchText)
                    .padding(.horizontal)
                    .padding(.top)
                
                // Liste
                if viewModel.isLoading {
                    Spacer()
                    ProgressView("Chargement...")
                    Spacer()
                } else if viewModel.filteredClients.isEmpty {
                    EmptyStateView(
                        icon: "building.2.slash",
                        title: "Aucun client",
                        message: "Aucun client trouvé"
                    )
                } else {
                    List {
                        ForEach(viewModel.filteredClients) { client in
                            NavigationLink(destination: ClientDetailView(client: client)) {
                                ClientRowView(client: client)
                                    .listRowSeparator(.hidden)
                            }
                            .listRowBackground(Color.clear)
                        }
                    }
                    .listStyle(PlainListStyle())
                    .scrollContentBackground(.hidden)
                    .refreshable { await viewModel.fetchClients() }
                }
            }
            .navigationTitle("Clients")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddClient = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(LT.ColorToken.primary)
                    }
                }
            }
            .sheet(isPresented: $showingAddClient) {
                ClientFormView(viewModel: viewModel)
            }
            .task {
                await viewModel.fetchClients()
            }
            .ltScreen()
        }
    }
}

struct ClientRowView: View {
    let client: Client
    
    var body: some View {
        HStack(spacing: 12) {
            // Avatar avec initiales
            Circle()
                .fill(LT.ColorToken.primary.opacity(0.2))
                .frame(width: 50, height: 50)
                .overlay(
                    Text(client.initiales)
                        .font(.headline)
                        .foregroundColor(LT.ColorToken.primary)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(client.raisonSociale)
                    .font(.headline)
                
                HStack(spacing: 4) {
                    Image(systemName: "mappin.circle")
                        .font(.caption)
                    Text(client.villeDisplay)
                        .font(.subheadline)
                }
                .foregroundColor(LT.ColorToken.textSecondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ClientsListView()
}
