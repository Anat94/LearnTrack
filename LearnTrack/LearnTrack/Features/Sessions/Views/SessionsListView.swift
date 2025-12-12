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
            ZStack {
                BrandBackground()
                
                VStack(spacing: 16) {
                    // Barre de recherche
                    SearchBar(text: $viewModel.searchText, placeholder: "Trouver une session ou un module")
                        .padding(.horizontal)
                        .padding(.top, 8)
                    
                    // Filtres par mois
                    MonthFilterView(selectedMonth: $viewModel.selectedMonth)
                        .padding(.horizontal)
                    
                    // Liste des sessions
                    Group {
                        if viewModel.isLoading {
                            ProgressView("Chargement stylé...")
                                .progressViewStyle(CircularProgressViewStyle(tint: .brandCyan))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else if viewModel.filteredSessions.isEmpty {
                            EmptyStateView(
                                icon: "calendar.badge.exclamationmark",
                                title: "Aucune session",
                                message: "Ajustez vos filtres ou ajoutez-en une nouvelle."
                            )
                        } else {
                            ScrollView {
                                LazyVStack(spacing: 14) {
                                    ForEach(viewModel.filteredSessions) { session in
                                        NavigationLink(destination: SessionDetailView(session: session)) {
                                            SessionCardView(session: session)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.bottom, 12)
                            }
                            .refreshable {
                                await viewModel.fetchSessions()
                            }
                        }
                    }
                }
            }
            .navigationTitle("Sessions")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddSession = true }) {
                        Image(systemName: "plus.app.fill")
                            .font(.title2)
                            .foregroundColor(.brandCyan)
                            .shadow(color: .brandPink.opacity(0.35), radius: 10, y: 6)
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
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(session.module)
                        .font(.headline)
                        .foregroundColor(.white)
                        .lineLimit(2)
                    
                    HStack(spacing: 12) {
                        Label(session.displayDate, systemImage: "calendar")
                        Label(session.displayHoraires, systemImage: "clock")
                    }
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.75))
                }
                
                Spacer()
                
                // Badge Présentiel/Distanciel
                HStack(spacing: 6) {
                    Image(systemName: session.modalite.icon)
                    Text(session.modalite.label)
                        .fontWeight(.semibold)
                }
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    LinearGradient(
                        colors: session.modalite == .presentiel ? [.brandCyan, .brandIndigo] : [.green, .brandCyan],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(12)
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.25), radius: 10, y: 8)
            }
            
            Divider()
                .background(Color.white.opacity(0.1))
            
            HStack(spacing: 12) {
                if let formateur = session.formateur {
                    Label(formateur.nomComplet, systemImage: "person.fill")
                }
                
                if session.modalite == .presentiel {
                    Label(session.lieu, systemImage: "mappin.circle.fill")
                        .lineLimit(1)
                }
            }
            .font(.subheadline)
            .foregroundColor(.white.opacity(0.78))
        }
        .glassCard()
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
                            .font(.subheadline.weight(.semibold))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(
                                Group {
                                    if selectedMonth == month {
                                        LinearGradient(
                                            colors: [.brandCyan, .brandPink],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    } else {
                                        Color.white.opacity(0.08)
                                    }
                                }
                            )
                            .foregroundColor(selectedMonth == month ? .white : .white.opacity(0.8))
                            .clipShape(Capsule(style: .continuous))
                            .overlay(
                                Capsule(style: .continuous)
                                    .stroke(Color.white.opacity(0.18), lineWidth: 1)
                            )
                            .shadow(color: Color.brandCyan.opacity(selectedMonth == month ? 0.25 : 0), radius: 10, y: 6)
                    }
                }
            }
        }
    }
}

#Preview {
    SessionsListView()
}
