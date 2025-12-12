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

// Card pour afficher une session - Design moderne
struct SessionCardView: View {
    let session: Session
    @Environment(\.colorScheme) var colorScheme
    @State private var isPressed = false
    
    var theme: AppTheme {
        colorScheme == .dark ? .dark : .light
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(session.module)
                        .font(.winamaxHeadline())
                        .foregroundColor(theme.textPrimary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    HStack(spacing: 16) {
                        HStack(spacing: 6) {
                            Image(systemName: "calendar")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(theme.primaryGreen)
                            Text(session.displayDate)
                                .font(.winamaxCaption())
                                .foregroundColor(theme.textSecondary)
                        }
                        
                        HStack(spacing: 6) {
                            Image(systemName: "clock")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(theme.accentOrange)
                            Text(session.displayHoraires)
                                .font(.winamaxCaption())
                                .foregroundColor(theme.textSecondary)
                        }
                    }
                }
                
                Spacer()
                
                // Badge modalité avec glow
                WinamaxBadge(
                    text: session.modalite.label,
                    color: session.modalite == .presentiel ? theme.primaryGreen : theme.accentOrange,
                    size: .medium
                )
            }
            
            // Divider avec gradient
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            theme.borderColor.opacity(0.5),
                            theme.borderColor.opacity(0.2),
                            theme.borderColor.opacity(0.5)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 1)
                .padding(.vertical, 4)
            
            HStack(spacing: 14) {
                if let formateur = session.formateur {
                    HStack(spacing: 6) {
                        Image(systemName: "person.fill")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(theme.primaryGreen.opacity(0.8))
                        Text(formateur.nomComplet)
                            .font(.winamaxCaption())
                            .foregroundColor(theme.textSecondary)
                    }
                }
                
                if session.modalite == .presentiel {
                    HStack(spacing: 6) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(theme.accentOrange.opacity(0.8))
                        Text(session.lieu)
                            .font(.winamaxCaption())
                            .foregroundColor(theme.textSecondary)
                            .lineLimit(1)
                    }
                }
            }
        }
        .winamaxCard(
            padding: 18,
            cornerRadius: 22,
            hasGlow: true,
            glowColor: session.modalite == .presentiel ? theme.primaryGreen : theme.accentOrange
        )
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
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
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
                            selectedMonth = month
                        }
                    }) {
                        Text(months[month - 1])
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .padding(.horizontal, 18)
                            .padding(.vertical, 12)
                            .background(
                                Group {
                                    if selectedMonth == month {
                                        ZStack {
                                            LinearGradient(
                                                colors: [
                                                    theme.primaryGreen,
                                                    theme.primaryGreen.opacity(0.9),
                                                    theme.primaryGreen.opacity(0.85)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                            
                                            LinearGradient(
                                                colors: [
                                                    Color.white.opacity(0.25),
                                                    .clear
                                                ],
                                                startPoint: .top,
                                                endPoint: .center
                                            )
                                        }
                                    } else {
                                        theme.cardBackground
                                    }
                                }
                            )
                            .foregroundColor(selectedMonth == month ? .white : theme.textPrimary)
                            .clipShape(Capsule(style: .continuous))
                            .overlay(
                                Capsule(style: .continuous)
                                    .stroke(
                                        selectedMonth == month ?
                                            LinearGradient(
                                                colors: [
                                                    Color.white.opacity(0.4),
                                                    Color.white.opacity(0.1)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ) :
                                            LinearGradient(
                                                colors: [
                                                    theme.borderColor,
                                                    theme.borderColor.opacity(0.6)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                        lineWidth: selectedMonth == month ? 1 : 1.5
                                    )
                            )
                            .shadow(
                                color: selectedMonth == month ? theme.primaryGreen.opacity(0.4) : theme.shadowColor,
                                radius: selectedMonth == month ? 12 : 6,
                                y: selectedMonth == month ? 6 : 3
                            )
                            .shadow(
                                color: selectedMonth == month ? theme.primaryGreen.opacity(0.2) : .clear,
                                radius: selectedMonth == month ? 6 : 0,
                                y: selectedMonth == month ? 3 : 0
                            )
                            .scaleEffect(selectedMonth == month ? 1.05 : 1.0)
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
