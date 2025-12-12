//
//  EcolesListView.swift
//  LearnTrack
//
//  Liste des écoles style Winamax
//

import SwiftUI

struct EcolesListView: View {
    @StateObject private var viewModel = EcoleViewModel()
    @State private var showingAddEcole = false
    @Environment(\.colorScheme) var colorScheme
    
    var theme: AppTheme {
        colorScheme == .dark ? .dark : .light
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                WinamaxBackground()
                
                VStack(spacing: 16) {
                    SearchBar(text: $viewModel.searchText, placeholder: "Rechercher une école...")
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: theme.primaryGreen))
                            .scaleEffect(1.2)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if viewModel.filteredEcoles.isEmpty {
                        EmptyStateView(
                            icon: "graduationcap.circle",
                            title: "Aucune école",
                            message: "Aucune école trouvée"
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
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                        }
                        .refreshable {
                            await viewModel.fetchEcoles()
                        }
                    }
                }
            }
            .navigationTitle("Écoles")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddEcole = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(theme.primaryGreen)
                            .shadow(color: theme.primaryGreen.opacity(0.3), radius: 8, y: 4)
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
                            colors: [theme.accentOrange, theme.accentOrange.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 56, height: 56)
                    .shadow(color: theme.accentOrange.opacity(0.3), radius: 8, y: 4)
                
                Text(ecole.initiales)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(ecole.nom)
                    .font(.winamaxHeadline())
                    .foregroundColor(theme.textPrimary)
                
                HStack(spacing: 6) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 12))
                    Text(ecole.villeDisplay)
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
    EcolesListView()
        .preferredColorScheme(.dark)
}
