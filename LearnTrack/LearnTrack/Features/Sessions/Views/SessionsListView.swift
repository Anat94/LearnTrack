//
//  SessionsListView.swift
//  LearnTrack
//
//  Liste des sessions - Design Emerald
//

import SwiftUI

struct SessionsListView: View {
    @StateObject private var viewModel = SessionViewModel()
    @State private var showingAddSession = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Color.ltBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header avec recherche et filtres
                    headerSection
                    
                    // Contenu
                    contentSection
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Sessions")
                        .font(.ltH3)
                        .foregroundColor(.ltText)
                }
                
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
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: LTSpacing.md) {
            // Search bar
            LTSearchBar(text: $viewModel.searchText)
                .padding(.horizontal, LTSpacing.lg)
                .padding(.top, LTSpacing.md)
            
            // Month filter
            LTMonthFilter(selectedMonth: $viewModel.selectedMonth)
        }
        .padding(.bottom, LTSpacing.md)
        .background(Color.ltCard)
    }
    
    // MARK: - Content Section
    @ViewBuilder
    private var contentSection: some View {
        if viewModel.isLoading {
            // Skeleton loading
            ScrollView {
                LazyVStack(spacing: LTSpacing.md) {
                    ForEach(0..<5) { _ in
                        LTSkeletonCard()
                    }
                }
                .padding(.horizontal, LTSpacing.lg)
                .padding(.top, LTSpacing.lg)
            }
        } else if viewModel.filteredSessions.isEmpty {
            // Empty state
            LTEmptyState(
                icon: "calendar.badge.exclamationmark",
                title: "Aucune session",
                message: "Aucune session trouvée pour ce mois. Créez-en une nouvelle !",
                actionTitle: "Créer une session"
            ) {
                showingAddSession = true
            }
        } else {
            // Sessions list
            ScrollView {
                LazyVStack(spacing: LTSpacing.md) {
                    ForEach(Array(viewModel.filteredSessions.enumerated()), id: \.element.id) { index, session in
                        NavigationLink(destination: SessionDetailView(session: session)) {
                            SessionCardNew(session: session)
                                .ltStaggered(index: index)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, LTSpacing.lg)
                .padding(.top, LTSpacing.lg)
                .padding(.bottom, 100) // Space for tab bar
            }
            .refreshable {
                await viewModel.fetchSessions()
            }
        }
    }
}

// MARK: - New Session Card
struct SessionCardNew: View {
    let session: Session
    
    @State private var isPressed = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: LTSpacing.md) {
            // Header avec module et badge
            HStack(alignment: .top) {
                Text(session.module)
                    .font(.ltH4)
                    .foregroundColor(.ltText)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                LTModaliteBadge(isPreentiel: session.modalite == .presentiel)
            }
            
            // Date et horaires
            HStack(spacing: LTSpacing.lg) {
                LTIconLabel(icon: "calendar", text: session.displayDate)
                LTIconLabel(icon: "clock", text: session.displayHoraires)
            }
            
            // Formateur
            if let formateur = session.formateur {
                LTIconLabel(icon: "person.fill", text: formateur.nomComplet)
            }
            
            // Lieu (si présentiel)
            if session.modalite == .presentiel && !session.lieu.isEmpty {
                LTIconLabel(icon: "mappin.circle.fill", text: session.lieu, color: .ltTextTertiary)
            }
        }
        .padding(LTSpacing.lg)
        .background(Color.ltCard)
        .clipShape(RoundedRectangle(cornerRadius: LTRadius.xl))
        .overlay(
            RoundedRectangle(cornerRadius: LTRadius.xl)
                .stroke(Color.ltBorderSubtle, lineWidth: 1)
        )
        .ltCardShadow()
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.ltSpringSubtle, value: isPressed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}

#Preview {
    SessionsListView()
        .environmentObject(AuthService.shared)
}
