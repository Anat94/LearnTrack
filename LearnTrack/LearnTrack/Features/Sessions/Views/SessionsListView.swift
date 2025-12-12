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
    @State private var hasAppeared = false
    
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
            .onAppear {
                hasAppeared = true
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
        .opacity(hasAppeared ? 1 : 0)
        .offset(y: hasAppeared ? 0 : -20)
        .animation(.easeOut(duration: 0.3), value: hasAppeared)
    }
    
    // MARK: - Content Section
    @ViewBuilder
    private var contentSection: some View {
        if viewModel.isLoading {
            ScrollView {
                VStack(spacing: LTSpacing.md) {
                    ForEach(0..<4, id: \.self) { _ in
                        LTSkeletonCard()
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
    }
    
    // MARK: - Sessions List
    private var sessionsList: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: LTSpacing.md) {
                ForEach(Array(viewModel.filteredSessions.enumerated()), id: \.element.id) { index, session in
                    NavigationLink(destination: SessionDetailView(session: session)) {
                        LTSessionCardContent(
                            title: session.module,
                            date: session.date.formatted(date: .abbreviated, time: .omitted),
                            time: "\(session.debut) - \(session.fin)",
                            formateur: session.formateur?.nomComplet,
                            client: session.client?.raisonSociale,
                            isPresentiel: session.modalite == .presentiel
                        )
                    }
                    .ltListCardStyle()
                    .opacity(hasAppeared ? 1 : 0)
                    .offset(y: hasAppeared ? 0 : 20)
                    .animation(
                        .easeOut(duration: 0.3).delay(Double(index) * 0.05),
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
}

#Preview {
    SessionsListView()
        .environmentObject(AuthService.shared)
        .preferredColorScheme(.dark)
}
