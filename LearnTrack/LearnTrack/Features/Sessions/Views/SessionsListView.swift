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
                    .padding()
                
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
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                    .refreshable {
                        await viewModel.fetchSessions()
                    }
                }
            }
            .navigationTitle("Sessions")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddSession = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddSession) {
                SessionFormView(viewModel: viewModel)
            }
            .task {
                await viewModel.fetchSessions()
            }
        }
    }
}

// Card pour afficher une session
struct SessionCardView: View {
    let session: Session
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // En-tête avec module et badge modalité
            HStack {
                Text(session.module)
                    .font(.headline)
                    .lineLimit(2)
                
                Spacer()
                
                // Badge Présentiel/Distanciel
                HStack(spacing: 4) {
                    Image(systemName: session.modalite.icon)
                        .font(.caption)
                    Text(session.modalite.label)
                        .font(.caption)
                        .fontWeight(.medium)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(session.modalite == .presentiel ? Color.blue.opacity(0.2) : Color.green.opacity(0.2))
                .foregroundColor(session.modalite == .presentiel ? .blue : .green)
                .cornerRadius(8)
            }
            
            // Date et horaires
            HStack(spacing: 16) {
                Label(session.displayDate, systemImage: "calendar")
                    .font(.subheadline)
                
                Label(session.displayHoraires, systemImage: "clock")
                    .font(.subheadline)
            }
            .foregroundColor(.secondary)
            
            // Formateur
            if let formateur = session.formateur {
                Label(formateur.nomComplet, systemImage: "person.fill")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // Lieu (si présentiel)
            if session.modalite == .presentiel {
                Label(session.lieu, systemImage: "mappin.circle.fill")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
        }
        .padding(.vertical, 8)
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
                    Button(action: {
                        selectedMonth = month
                    }) {
                        Text(months[month - 1])
                            .font(.subheadline)
                            .fontWeight(selectedMonth == month ? .semibold : .regular)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(selectedMonth == month ? Color.blue : Color.gray.opacity(0.2))
                            .foregroundColor(selectedMonth == month ? .white : .primary)
                            .cornerRadius(20)
                    }
                }
            }
        }
    }
}

#Preview {
    SessionsListView()
}
