//
//  SessionsListView.swift
//  LearnTrack
//
//  Liste des sessions - Design Emerald Premium
//

import SwiftUI

struct SessionsListView: View {
    @StateObject private var viewModel = SessionViewModel()
    @State private var showingAddSession = false
    @State private var selectedDate = Date()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.ltBackground
                    .ignoresSafeArea()
                
                VStack(spacing: LTSpacing.md) {
                    // Search bar
                    LTSearchBar(text: $viewModel.searchText, placeholder: "Rechercher une session...")
                        .padding(.horizontal, LTSpacing.lg)
                        .padding(.top, LTSpacing.sm)
                    
                    // Month filter
                    LTMonthFilter(selectedMonth: $selectedDate)
                        .padding(.horizontal, LTSpacing.lg)
                        .onChange(of: selectedDate) { _, newDate in
                            viewModel.selectedMonth = Calendar.current.component(.month, from: newDate)
                        }
                    
                    // Content
                    Group {
                        if viewModel.isLoading {
                            loadingView
                        } else if viewModel.filteredSessions.isEmpty {
                            emptyStateView
                        } else {
                            sessionsList
                        }
                    }
                }
            }
            .navigationTitle("Sessions")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    LTIconButton(icon: "plus", variant: .primary, size: .small) {
                        showingAddSession = true
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
    
    // MARK: - Loading View
    private var loadingView: some View {
        VStack(spacing: LTSpacing.md) {
            ForEach(0..<3, id: \.self) { _ in
                LTSkeletonCard()
            }
        }
        .padding(.horizontal, LTSpacing.lg)
    }
    
    // MARK: - Empty State
    private var emptyStateView: some View {
        LTEmptyState(
            icon: "calendar.badge.exclamationmark",
            title: "Aucune session",
            message: "Aucune session trouvée pour ce mois",
            actionTitle: "Créer une session",
            action: { showingAddSession = true }
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Sessions List
    private var sessionsList: some View {
        ScrollView {
            LazyVStack(spacing: LTSpacing.md) {
                ForEach(Array(viewModel.filteredSessions.enumerated()), id: \.element.id) { index, session in
                    NavigationLink(destination: SessionDetailView(session: session)) {
                        sessionCard(session)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .opacity(1)
                    .animation(.ltSpringSmooth.delay(Double(index) * 0.03), value: viewModel.filteredSessions.count)
                }
            }
            .padding(.horizontal, LTSpacing.lg)
            .padding(.bottom, 120) // Espace pour la TabBar
        }
        .refreshable {
            await viewModel.fetchSessions()
        }
    }
    
    // MARK: - Session Card
    private func sessionCard(_ session: Session) -> some View {
        LTCard(variant: .interactive) {
            VStack(alignment: .leading, spacing: LTSpacing.md) {
                // Header
                HStack(alignment: .top) {
                    Text(session.module)
                        .font(.ltH4)
                        .foregroundColor(.ltText)
                        .lineLimit(2)
                    
                    Spacer()
                    
                    LTModaliteBadge(isPresentiel: session.modalite == .presentiel)
                }
                
                // Date et heure
                HStack(spacing: LTSpacing.lg) {
                    LTIconLabel(
                        icon: "calendar",
                        text: session.date.formatted(date: .abbreviated, time: .omitted)
                    )
                    LTIconLabel(
                        icon: "clock",
                        text: "\(session.debut) - \(session.fin)"
                    )
                }
                
                // Formateur
                if let formateur = session.formateur {
                    LTIconLabel(
                        icon: "person.fill",
                        text: formateur.nomComplet
                    )
                }
                
                // Client
                if let client = session.client {
                    LTIconLabel(
                        icon: "building.2.fill",
                        text: client.raisonSociale,
                        color: .ltTextTertiary
                    )
                }
            }
        }
    }
}

#Preview {
    SessionsListView()
        .environmentObject(AuthService.shared)
        .preferredColorScheme(.dark)
}
