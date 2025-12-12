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
            ZStack {
                BrandBackground()
                
                VStack(spacing: 16) {
                    // Barre de recherche
                    SearchBar(text: $viewModel.searchText, placeholder: "Rechercher un formateur")
                        .padding(.horizontal)
                        .padding(.top, 8)
                    
                    // Filtre type
                    Picker("Type", selection: $viewModel.filterType) {
                        ForEach(FormateurViewModel.FilterType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    .background(Color.white.opacity(0.04))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .padding(.horizontal)
                    
                    // Liste
                    if viewModel.isLoading {
                        ProgressView("Chargement...")
                            .progressViewStyle(CircularProgressViewStyle(tint: .brandCyan))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if viewModel.filteredFormateurs.isEmpty {
                        EmptyStateView(
                            icon: "person.2.slash",
                            title: "Aucun formateur",
                            message: "Ajoutez votre premier talent ou ajustez la recherche."
                        )
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 14) {
                                ForEach(viewModel.filteredFormateurs) { formateur in
                                    NavigationLink(destination: FormateurDetailView(formateur: formateur)) {
                                        FormateurRowView(formateur: formateur)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 12)
                        }
                        .refreshable {
                            await viewModel.fetchFormateurs()
                        }
                    }
                }
            }
            .navigationTitle("Formateurs")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddFormateur = true }) {
                        Image(systemName: "sparkles.rectangle.stack")
                            .font(.title2)
                            .foregroundColor(.brandCyan)
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
        HStack(spacing: 14) {
            // Avatar avec initiales
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: formateur.exterieur ? [.orange, .brandPink] : [.brandCyan, .green],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 54, height: 54)
                    .shadow(color: .brandCyan.opacity(0.3), radius: 10, y: 6)
                
                Text(formateur.initiales)
                    .font(.headline)
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(formateur.nomComplet)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(formateur.specialite)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.75))
                
                // Badge type
                Text(formateur.type)
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.white.opacity(0.1))
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.white.opacity(0.6))
        }
        .glassCard()
    }
}

#Preview {
    FormateursListView()
}
