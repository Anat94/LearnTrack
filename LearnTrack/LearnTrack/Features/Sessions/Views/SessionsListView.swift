//
//  SessionsListView.swift
//  LearnTrack
//
//  Liste des sessions - Design Premium
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
                
                VStack(spacing: 0) {
                    headerSection
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
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: LTSpacing.md) {
            LTSearchBar(text: $viewModel.searchText, placeholder: "Rechercher...")
                .padding(.horizontal, LTSpacing.lg)
            
            LTMonthFilter(selectedMonth: $selectedDate)
                .padding(.horizontal, LTSpacing.lg)
                .onChange(of: selectedDate) { _, newDate in
                    viewModel.selectedMonth = Calendar.current.component(.month, from: newDate)
                }
        }
        .padding(.top, LTSpacing.sm)
        .padding(.bottom, LTSpacing.md)
    }
    
    // MARK: - Content Section
    @ViewBuilder
    private var contentSection: some View {
        if viewModel.isLoading {
            ScrollView {
                VStack(spacing: LTSpacing.md) {
                    ForEach(0..<4, id: \.self) { index in
                        LTSkeletonCard()
                            .ltStaggered(index: index)
                    }
                }
                .padding(.horizontal, LTSpacing.lg)
            }
        } else if viewModel.filteredSessions.isEmpty {
            LTEmptyState(
                icon: "calendar.badge.exclamationmark",
                title: "Aucune session",
                message: "Aucune session pour ce mois",
                actionTitle: "Créer",
                action: { showingAddSession = true }
            )
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
        .ltScaleOnPress()
    }
    
    // MARK: - Sessions List
    private var sessionsList: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: LTSpacing.md) {
                ForEach(Array(viewModel.filteredSessions.enumerated()), id: \.element.id) { index, session in
                    NavigationLink(destination: SessionDetailView(session: session)) {
                        SessionCardView(session: session)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .ltStaggered(index: index)
                }
            }
            .padding(.horizontal, LTSpacing.lg)
            .padding(.bottom, 100)
        }
        .refreshable {
            await viewModel.fetchSessions()
        }
    }
}

// MARK: - Session Card
struct SessionCardView: View {
    let session: Session
    @State private var isPressed = false
    
    var body: some View {
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
        .padding(LTSpacing.lg)
        .background(Color.ltCard)
        .clipShape(RoundedRectangle(cornerRadius: LTRadius.xl))
        .overlay(
            RoundedRectangle(cornerRadius: LTRadius.xl)
                .stroke(Color.ltBorderSubtle, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
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
        .preferredColorScheme(.dark)
}
