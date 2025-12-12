//
//  SessionsListView.swift
//  LearnTrack
//
//  Liste des sessions style Winamax
//

import SwiftUI

struct SessionsListView: View {
    @StateObject private var viewModel = SessionViewModel()
    @State private var showingAddSession = false
    @Environment(\.colorScheme) var colorScheme
    
    var theme: AppTheme {
        colorScheme == .dark ? .dark : .light
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                WinamaxBackground()
                
                VStack(spacing: 16) {
                    // Barre de recherche
                    SearchBar(text: $viewModel.searchText, placeholder: "Rechercher une session...")
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                    
                    // Filtres par mois
                    MonthFilterView(selectedMonth: $viewModel.selectedMonth)
                        .padding(.horizontal, 20)
                    
                    // Liste des sessions
                    Group {
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: theme.primaryGreen))
                                .scaleEffect(1.2)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else if viewModel.filteredSessions.isEmpty {
                            EmptyStateView(
                                icon: "calendar.badge.exclamationmark",
                                title: "Aucune session",
                                message: "Aucune session trouvée pour ce mois"
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
                                .padding(.horizontal, 20)
                                .padding(.bottom, 20)
                            }
                            .refreshable {
                                await viewModel.fetchSessions()
                            }
                        }
                    }
                }
            }
            .navigationTitle("Sessions")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddSession = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(theme.primaryGreen)
                            .shadow(color: theme.primaryGreen.opacity(0.3), radius: 8, y: 4)
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
    @Environment(\.colorScheme) var colorScheme
    
    var theme: AppTheme {
        colorScheme == .dark ? .dark : .light
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(session.module)
                        .font(.winamaxHeadline())
                        .foregroundColor(theme.textPrimary)
                        .lineLimit(2)
                    
                    HStack(spacing: 12) {
                        Label(session.displayDate, systemImage: "calendar")
                        Label(session.displayHoraires, systemImage: "clock")
                    }
                    .font(.winamaxCaption())
                    .foregroundColor(theme.textSecondary)
                }
                
                Spacer()
                
                // Badge modalité
                WinamaxBadge(
                    text: session.modalite.label,
                    color: session.modalite == .presentiel ? theme.primaryGreen : theme.accentOrange
                )
            }
            
            Divider()
                .background(theme.borderColor)
            
            HStack(spacing: 12) {
                if let formateur = session.formateur {
                    Label(formateur.nomComplet, systemImage: "person.fill")
                        .font(.winamaxCaption())
                        .foregroundColor(theme.textSecondary)
                }
                
                if session.modalite == .presentiel {
                    Label(session.lieu, systemImage: "mappin.circle.fill")
                        .font(.winamaxCaption())
                        .foregroundColor(theme.textSecondary)
                        .lineLimit(1)
                }
            }
        }
        .winamaxCard()
    }
}

// Filtre par mois
struct MonthFilterView: View {
    @Binding var selectedMonth: Int
    @Environment(\.colorScheme) var colorScheme
    
    var theme: AppTheme {
        colorScheme == .dark ? .dark : .light
    }
    
    let months = [
        "Jan", "Fév", "Mar", "Avr", "Mai", "Juin",
        "Juil", "Août", "Sep", "Oct", "Nov", "Déc"
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(1...12, id: \.self) { month in
                    Button(action: {
                        withAnimation(.spring(response: 0.3)) {
                            selectedMonth = month
                        }
                    }) {
                        Text(months[month - 1])
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(
                                Group {
                                    if selectedMonth == month {
                                        LinearGradient(
                                            colors: [theme.primaryGreen, theme.primaryGreen.opacity(0.85)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    } else {
                                        theme.cardBackground
                                    }
                                }
                            )
                            .foregroundColor(selectedMonth == month ? .white : theme.textPrimary)
                            .clipShape(Capsule(style: .continuous))
                            .overlay(
                                Capsule(style: .continuous)
                                    .stroke(selectedMonth == month ? .clear : theme.borderColor, lineWidth: 1.5)
                            )
                            .shadow(
                                color: selectedMonth == month ? theme.primaryGreen.opacity(0.3) : theme.shadowColor,
                                radius: selectedMonth == month ? 8 : 4,
                                y: selectedMonth == month ? 4 : 2
                            )
                    }
                }
            }
        }
    }
}

#Preview {
    SessionsListView()
        .preferredColorScheme(.dark)
}
