//
//  SessionsListView.swift
//  LearnTrack
//
//  Liste des sessions - Design Premium avec animations
//

import SwiftUI

struct SessionsListView: View {
    @StateObject private var viewModel = SessionViewModel()
    @State private var showingAddSession = false
    @State private var selectedDate = Date()
    @State private var hasAppeared = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.ltBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    headerSection
                    
                    // Content
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
                    addButton
                }
            }
            .sheet(isPresented: $showingAddSession) {
                SessionFormView(viewModel: viewModel)
            }
            .task {
                await viewModel.fetchSessions()
            }
            .onAppear {
                withAnimation(.easeOut(duration: 0.3).delay(0.1)) {
                    hasAppeared = true
                }
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: LTSpacing.md) {
            // Search bar
            LTSearchBar(text: $viewModel.searchText, placeholder: "Rechercher...")
                .padding(.horizontal, LTSpacing.lg)
            
            // Month filter
            LTMonthFilter(selectedMonth: $selectedDate)
                .padding(.horizontal, LTSpacing.lg)
                .onChange(of: selectedDate) { _, newDate in
                    viewModel.selectedMonth = Calendar.current.component(.month, from: newDate)
                }
        }
        .padding(.top, LTSpacing.sm)
        .padding(.bottom, LTSpacing.md)
        .opacity(hasAppeared ? 1 : 0)
        .offset(y: hasAppeared ? 0 : -20)
    }
    
    // MARK: - Content Section
    @ViewBuilder
    private var contentSection: some View {
        if viewModel.isLoading {
            loadingView
        } else if viewModel.filteredSessions.isEmpty {
            emptyStateView
        } else {
            sessionsList
        }
    }
    
    // MARK: - Add Button
    private var addButton: some View {
        Button {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            showingAddSession = true
        } label: {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.emerald400, .emerald600],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 36, height: 36)
                    .shadow(color: .emerald500.opacity(0.4), radius: 8, y: 2)
                
                Image(systemName: "plus")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
            }
        }
    }
    
    // MARK: - Loading View
    private var loadingView: some View {
        ScrollView {
            VStack(spacing: LTSpacing.md) {
                ForEach(0..<4, id: \.self) { index in
                    LTSkeletonCard()
                        .opacity(hasAppeared ? 1 : 0)
                        .offset(y: hasAppeared ? 0 : 20)
                        .animation(.easeOut(duration: 0.4).delay(Double(index) * 0.1), value: hasAppeared)
                }
            }
            .padding(.horizontal, LTSpacing.lg)
        }
    }
    
    // MARK: - Empty State
    private var emptyStateView: some View {
        LTEmptyState(
            icon: "calendar.badge.exclamationmark",
            title: "Aucune session",
            message: "Aucune session pour ce mois",
            actionTitle: "Créer",
            action: { showingAddSession = true }
        )
        .opacity(hasAppeared ? 1 : 0)
        .scaleEffect(hasAppeared ? 1 : 0.9)
    }
    
    // MARK: - Sessions List
    private var sessionsList: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: LTSpacing.md) {
                ForEach(Array(viewModel.filteredSessions.enumerated()), id: \.element.id) { index, session in
                    NavigationLink(destination: SessionDetailView(session: session)) {
                        sessionCard(session)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .opacity(hasAppeared ? 1 : 0)
                    .offset(y: hasAppeared ? 0 : 30)
                    .animation(
                        .spring(response: 0.5, dampingFraction: 0.8)
                        .delay(Double(index) * 0.05),
                        value: hasAppeared
                    )
                }
            }
            .padding(.horizontal, LTSpacing.lg)
            .padding(.bottom, 100)
        }
        .refreshable {
            await viewModel.fetchSessions()
        }
    }
    
    // MARK: - Session Card
    private func sessionCard(_ session: Session) -> some View {
        LTInteractiveCard(action: {}) {
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
                
                // Date & Time
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
                    LTIconLabel(icon: "person.fill", text: formateur.nomComplet)
                }
                
                // Client
                if let client = session.client {
                    LTIconLabel(icon: "building.2.fill", text: client.raisonSociale, color: .ltTextTertiary)
                }
            }
        }
        .allowsHitTesting(false) // Let NavigationLink handle tap
    }
}

#Preview {
    SessionsListView()
        .environmentObject(AuthService.shared)
        .preferredColorScheme(.dark)
}
