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
                LTGradientBackground()
                
                VStack(spacing: 0) {
                    headerSection
                    
                    ScrollView(showsIndicators: false) {
                        contentSection
                    }
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
        .background(Color.clear) // Garde le header fixe
    }
    
    // MARK: - Content Section
    @ViewBuilder
    private var contentSection: some View {
        if viewModel.isLoading {
            VStack(spacing: LTSpacing.md) {
                ForEach(0..<4, id: \.self) { index in
                    LTSkeletonCard()
                        .ltStaggered(index: index)
                }
            }
            .padding(.horizontal, LTSpacing.lg)
            .padding(.bottom, 100)
        } else if viewModel.filteredSessions.isEmpty {
            VStack {
                Spacer(minLength: 80)
                LTEmptyState(
                    icon: "calendar.badge.exclamationmark",
                    title: "Aucune session",
                    message: "Aucune session pour ce mois",
                    actionTitle: "Créer",
                    action: { showingAddSession = true }
                )
                Spacer()
            }
            .frame(minHeight: 400)
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
}

// MARK: - Session Card
struct SessionCardView: View {
    let session: Session
    @State private var isPressed = false
    
    var accentColor: Color {
        session.modalite == .presentiel ? .emerald500 : .warning
    }
    
    var body: some View {
        HStack(spacing: 0) {
            // Bande colorée à gauche
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [accentColor, accentColor.opacity(0.7)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 4)
            
            VStack(alignment: .leading, spacing: LTSpacing.md) {
                // Header avec badge
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: LTSpacing.xs) {
                        Text(session.module)
                            .font(.ltH4)
                            .foregroundColor(.ltText)
                            .lineLimit(2)
                        
                        // Date & Heure sur une ligne
                        HStack(spacing: LTSpacing.md) {
                            HStack(spacing: LTSpacing.xs) {
                                Image(systemName: "calendar")
                                    .font(.system(size: LTIconSize.sm))
                                    .foregroundColor(accentColor)
                                Text(session.date.formatted(date: .abbreviated, time: .omitted))
                                    .font(.ltCaption)
                                    .foregroundColor(.ltTextSecondary)
                            }
                            
                            HStack(spacing: LTSpacing.xs) {
                                Image(systemName: "clock")
                                    .font(.system(size: LTIconSize.sm))
                                    .foregroundColor(accentColor)
                                Text("\(session.debut) - \(session.fin)")
                                    .font(.ltCaption)
                                    .foregroundColor(.ltTextSecondary)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    LTModaliteBadge(isPresentiel: session.modalite == .presentiel)
                }
                
                Divider()
                    .background(Color.ltBorder)
                
                // Infos intervenants
                HStack(spacing: LTSpacing.lg) {
                    if let formateur = session.formateur {
                        HStack(spacing: LTSpacing.xs) {
                            LTAvatar(initials: formateur.initiales, size: .xsmall, color: .emerald500)
                            Text(formateur.nomComplet)
                                .font(.ltSmall)
                                .foregroundColor(.ltText)
                                .lineLimit(1)
                        }
                    }
                    
                    if let client = session.client {
                        HStack(spacing: LTSpacing.xs) {
                            Image(systemName: "building.2.fill")
                                .font(.system(size: LTIconSize.xs))
                                .foregroundColor(.info)
                            Text(client.raisonSociale)
                                .font(.ltSmall)
                                .foregroundColor(.ltTextSecondary)
                                .lineLimit(1)
                        }
                    }
                    
                    Spacer()
                    
                    // Tarif
                    Text("\(session.tarifClient) €")
                        .font(.ltCaptionMedium)
                        .foregroundColor(accentColor)
                }
            }
            .padding(LTSpacing.lg)
        }
        .background(Color.ltCard)
        .clipShape(RoundedRectangle(cornerRadius: LTRadius.xl))
        .overlay(
            RoundedRectangle(cornerRadius: LTRadius.xl)
                .stroke(Color.ltBorderSubtle, lineWidth: 0.5)
        )
        .shadow(color: .black.opacity(0.06), radius: 8, y: 4)
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
