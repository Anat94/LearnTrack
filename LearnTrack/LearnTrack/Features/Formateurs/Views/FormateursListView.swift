//
//  FormateursListView.swift
//  LearnTrack
//
//  Liste des formateurs
//

import SwiftUI

struct FormateursListView: View {
    @StateObject private var viewModel = FormateurViewModel()
    @State private var showingAddFormateur = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                LTHeroHeader(title: "Formateurs", subtitle: "Réseau d'intervenants", systemImage: "person.2.fill")
                // Barre de recherche
                SearchBar(text: $viewModel.searchText)
                    .padding(.horizontal)
                    .padding(.top)
                
                // Filtre type
                HStack(spacing: 10) {
                    ForEach(FormateurViewModel.FilterType.allCases, id: \.self) { type in
                        Button(action: { viewModel.filterType = type }) {
                            LT.Chip(label: type.rawValue, selected: viewModel.filterType == type)
                        }
                    }
                }
                .padding(.horizontal)
                
                // Liste
                if viewModel.isLoading {
                    Spacer()
                    ProgressView("Chargement...")
                    Spacer()
                } else if viewModel.filteredFormateurs.isEmpty {
                    EmptyStateView(
                        icon: "person.2.slash",
                        title: "Aucun formateur",
                        message: "Aucun formateur trouvé"
                    )
                } else {
                    List {
                        ForEach(viewModel.filteredFormateurs) { formateur in
                            NavigationLink(destination: FormateurDetailView(formateur: formateur)) {
                                FormateurRowView(formateur: formateur)
                                    .listRowSeparator(.hidden)
                            }
                            .listRowBackground(Color.clear)
                        }
                    }
                    .listStyle(PlainListStyle())
                    .scrollContentBackground(.hidden)
                    .refreshable { await viewModel.fetchFormateurs() }
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddFormateur = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(LT.ColorToken.primary)
                    }
                }
            }
            .sheet(isPresented: $showingAddFormateur) {
                FormateurFormView(viewModel: viewModel)
            }
            .task {
                await viewModel.fetchFormateurs()
            }
            .ltScreen()
        }
    }
}

struct FormateurRowView: View {
    let formateur: Formateur
    
    var body: some View {
        HStack(spacing: 12) {
            // Avatar avec initiales
            Circle()
                .fill(formateur.exterieur ? LT.ColorToken.accent.opacity(0.2) : LT.ColorToken.primary.opacity(0.2))
                .frame(width: 50, height: 50)
                .overlay(
                    Text(formateur.initiales)
                        .font(.headline)
                        .foregroundColor(formateur.exterieur ? LT.ColorToken.accent : LT.ColorToken.primary)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(formateur.nomComplet)
                    .font(.headline)
                
                Text(formateur.specialite)
                    .font(.subheadline)
                    .foregroundColor(LT.ColorToken.textSecondary)
                
                // Badge type
                Text(formateur.type)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(formateur.exterieur ? LT.ColorToken.accent.opacity(0.2) : LT.ColorToken.primary.opacity(0.2))
                    .foregroundColor(formateur.exterieur ? LT.ColorToken.accent : LT.ColorToken.primary)
                    .cornerRadius(4)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    FormateursListView()
}
