//
//  EcolesListView.swift
//  LearnTrack
//
//  Liste des écoles
//

import SwiftUI

struct EcolesListView: View {
    @StateObject private var viewModel = EcoleViewModel()
    @State private var showingAddEcole = false
    
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
                } else if viewModel.filteredEcoles.isEmpty {
                    EmptyStateView(
                        icon: "graduationcap.circle",
                        title: "Aucune école",
                        message: "Aucune école trouvée"
                    )
                } else {
                    List {
                        ForEach(viewModel.filteredEcoles) { ecole in
                            NavigationLink(destination: EcoleDetailView(ecole: ecole)) {
                                EcoleRowView(ecole: ecole)
                                    .listRowSeparator(.hidden)
                            }
                            .listRowBackground(Color.clear)
                        }
                    }
                    .listStyle(PlainListStyle())
                    .scrollContentBackground(.hidden)
                    .refreshable { await viewModel.fetchEcoles() }
                }
            }
            .navigationTitle("Écoles")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddEcole = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(LT.ColorToken.primary)
                    }
                }
            }
            .sheet(isPresented: $showingAddEcole) {
                EcoleFormView(viewModel: viewModel)
            }
            .task {
                await viewModel.fetchEcoles()
            }
            .ltScreen()
        }
    }
}

struct EcoleRowView: View {
    let ecole: Ecole
    
    var body: some View {
        HStack(spacing: 12) {
            // Avatar avec initiales
            Circle()
                .fill(LT.ColorToken.secondary.opacity(0.2))
                .frame(width: 50, height: 50)
                .overlay(
                    Text(ecole.initiales)
                        .font(.headline)
                        .foregroundColor(LT.ColorToken.secondary)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(ecole.nom)
                    .font(.headline)
                
                HStack(spacing: 4) {
                    Image(systemName: "mappin.circle")
                        .font(.caption)
                    Text(ecole.villeDisplay)
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
    EcolesListView()
}
