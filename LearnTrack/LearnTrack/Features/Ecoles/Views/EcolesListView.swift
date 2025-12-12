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
            ZStack {
                BrandBackground()
                
                VStack(spacing: 16) {
                    // Barre de recherche
                    SearchBar(text: $viewModel.searchText, placeholder: "Rechercher une école")
                        .padding(.horizontal)
                        .padding(.top, 8)
                    
                    if viewModel.isLoading {
                        ProgressView("Chargement...")
                            .progressViewStyle(CircularProgressViewStyle(tint: .brandCyan))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if viewModel.filteredEcoles.isEmpty {
                        EmptyStateView(
                            icon: "graduationcap.circle",
                            title: "Aucune école",
                            message: "Ajoutez votre première école ou ajustez la recherche."
                        )
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 14) {
                                ForEach(viewModel.filteredEcoles) { ecole in
                                    NavigationLink(destination: EcoleDetailView(ecole: ecole)) {
                                        EcoleRowView(ecole: ecole)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 12)
                        }
                        .refreshable {
                            await viewModel.fetchEcoles()
                        }
                    }
                }
            }
            .navigationTitle("Écoles")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddEcole = true }) {
                        Image(systemName: "sparkles.square.filled.on.square")
                            .font(.title2)
                            .foregroundColor(.brandCyan)
                    }
                }
            }
            .sheet(isPresented: $showingAddEcole) {
                EcoleFormView(viewModel: viewModel)
            }
            .task {
                await viewModel.fetchEcoles()
            }
        }
    }
}

struct EcoleRowView: View {
    let ecole: Ecole
    
    var body: some View {
        HStack(spacing: 14) {
            // Avatar avec initiales
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.brandIndigo, .brandPink],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 54, height: 54)
                    .shadow(color: .brandPink.opacity(0.28), radius: 10, y: 6)
                
                Text(ecole.initiales)
                    .font(.headline)
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(ecole.nom)
                    .font(.headline)
                    .foregroundColor(.white)
                
                HStack(spacing: 6) {
                    Image(systemName: "mappin.circle")
                        .font(.caption)
                    Text(ecole.villeDisplay)
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
    EcolesListView()
}
