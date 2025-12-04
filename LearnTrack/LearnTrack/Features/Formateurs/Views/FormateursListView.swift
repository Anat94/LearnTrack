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
                // Barre de recherche
                SearchBar(text: $viewModel.searchText)
                    .padding()
                
                // Filtre type
                Picker("Type", selection: $viewModel.filterType) {
                    ForEach(FormateurViewModel.FilterType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
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
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                    .refreshable {
                        await viewModel.fetchFormateurs()
                    }
                }
            }
            .navigationTitle("Formateurs")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddFormateur = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddFormateur) {
                FormateurFormView(viewModel: viewModel)
            }
            .task {
                await viewModel.fetchFormateurs()
            }
        }
    }
}

struct FormateurRowView: View {
    let formateur: Formateur
    
    var body: some View {
        HStack(spacing: 12) {
            // Avatar avec initiales
            Circle()
                .fill(formateur.exterieur ? Color.orange.opacity(0.2) : Color.green.opacity(0.2))
                .frame(width: 50, height: 50)
                .overlay(
                    Text(formateur.initiales)
                        .font(.headline)
                        .foregroundColor(formateur.exterieur ? .orange : .green)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(formateur.nomComplet)
                    .font(.headline)
                
                Text(formateur.specialite)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                // Badge type
                Text(formateur.type)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(formateur.exterieur ? Color.orange.opacity(0.2) : Color.green.opacity(0.2))
                    .foregroundColor(formateur.exterieur ? .orange : .green)
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
