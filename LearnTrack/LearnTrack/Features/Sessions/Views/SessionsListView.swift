//
//  SessionsListView.swift
//  LearnTrack
//
//  Liste des sessions de formation
//

import SwiftUI

struct SessionsListView: View {
    @StateObject private var viewModel = SessionViewModel()
    @State private var showingAddSession = false
    @State private var selectedSession: Session?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Barre de recherche
                SearchBar(text: $viewModel.searchText)
                    .padding(.horizontal)
                    .padding(.top)
                
                // Filtres par mois
                MonthFilterView(selectedMonth: $viewModel.selectedMonth)
                    .padding(.horizontal)
                
                // Liste des sessions
                if viewModel.isLoading {
                    Spacer()
                    ProgressView("Chargement...")
                    Spacer()
                } else if viewModel.filteredSessions.isEmpty {
                    EmptyStateView(
                        icon: "calendar.badge.exclamationmark",
                        title: "Aucune session",
                        message: "Aucune session trouvée pour ce mois"
                    )
                } else {
                    List {
                        ForEach(viewModel.filteredSessions) { session in
                            NavigationLink(destination: SessionDetailView(session: session)) {
                                SessionCardView(session: session)
                                    .listRowSeparator(.hidden)
                            }
                            .listRowBackground(Color.clear)
                        }
                    }
                    .listStyle(PlainListStyle())
                    .scrollContentBackground(.hidden)
                    .refreshable { await viewModel.fetchSessions() }
                }
            }
            .navigationTitle("Sessions")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddSession = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(LT.ColorToken.primary)
                    }
                }
            }
            .sheet(isPresented: $showingAddSession) {
                SessionFormView(viewModel: viewModel)
            }
            .task {
                await viewModel.fetchSessions()
            }
            .ltScreen()
        }
    }
}

// Card pour afficher une session
struct SessionCardView: View {
    let session: Session
    
    var body: some View {
        LT.SectionCard {
            VStack(alignment: .leading, spacing: 12) {
                // En-tête avec module et badge modalité
                HStack(alignment: .top) {
                    Text(session.module)
                        .font(.headline)
                        .foregroundColor(LT.ColorToken.textPrimary)
                        .lineLimit(2)
                    Spacer()
                    LT.Badge(
                        text: session.modalite.label,
                        color: session.modalite == .presentiel ? LT.ColorToken.secondary : LT.ColorToken.primary
                    )
                }
                
                // Date et horaires
                HStack(spacing: 16) {
                    Label(session.displayDate, systemImage: "calendar")
                        .font(.subheadline)
                
                    Label(session.displayHoraires, systemImage: "clock")
                        .font(.subheadline)
                }
                .foregroundColor(LT.ColorToken.textSecondary)
                
                // Formateur
                if let formateur = session.formateur {
                    Label(formateur.nomComplet, systemImage: "person.fill")
                        .font(.subheadline)
                        .foregroundColor(LT.ColorToken.textSecondary)
                }
                
                // Lieu (si présentiel)
                if session.modalite == .presentiel && !session.lieu.isEmpty {
                    Label(session.lieu, systemImage: "mappin.circle.fill")
                        .font(.caption)
                        .foregroundColor(LT.ColorToken.textSecondary)
                        .lineLimit(1)
                }
            }
            .padding(.vertical, 2)
        }
    }
}

// Filtre par mois
struct MonthFilterView: View {
    @Binding var selectedMonth: Int
    
    let months = [
        "Janvier", "Février", "Mars", "Avril", "Mai", "Juin",
        "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(1...12, id: \.self) { month in
                    Button(action: { selectedMonth = month }) {
                        LT.Chip(label: months[month - 1], selected: selectedMonth == month)
                    }
                }
            }
        }
    }
}

#Preview {
    SessionsListView()
}
