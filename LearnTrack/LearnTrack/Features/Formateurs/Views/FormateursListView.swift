//
//  FormateursListView.swift
//  LearnTrack
//
//  Liste des formateurs - Design Premium
//

import SwiftUI

struct FormateursListView: View {
    @StateObject private var viewModel = FormateurViewModel()
    @State private var showingAddFormateur = false
    @State private var selectedFilterIndex = 0
    
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
                    Text("Formateurs")
                        .font(.ltH3)
                        .foregroundColor(.ltText)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    addButton
                }
            }
            .sheet(isPresented: $showingAddFormateur) {
                FormateurFormView(viewModel: viewModel)
            }
            .task {
                await viewModel.fetchFormateurs()
            }
            .onChange(of: selectedFilterIndex) { _, newValue in
                withAnimation(.ltSpringSnappy) {
                    switch newValue {
                    case 0: viewModel.filterType = .tous
                    case 1: viewModel.filterType = .internes
                    case 2: viewModel.filterType = .externes
                    default: viewModel.filterType = .tous
                    }
                }
            }
        }
    }
    
    // MARK: - Header
    private var headerSection: some View {
        VStack(spacing: LTSpacing.md) {
            LTSearchBar(text: $viewModel.searchText, placeholder: "Rechercher...")
                .padding(.horizontal, LTSpacing.lg)
            
            LTSegmentedControl(
                selectedIndex: $selectedFilterIndex,
                items: ["Tous", "Internes", "Externes"]
            )
            .padding(.horizontal, LTSpacing.lg)
        }
        .padding(.top, LTSpacing.sm)
        .padding(.bottom, LTSpacing.md)
    }
    
    // MARK: - Content
    @ViewBuilder
    private var contentSection: some View {
        if viewModel.isLoading {
            ScrollView {
                VStack(spacing: LTSpacing.md) {
                    ForEach(0..<4, id: \.self) { index in
                        LTSkeletonPersonRow()
                            .ltStaggered(index: index)
                    }
                }
                .padding(.horizontal, LTSpacing.lg)
            }
        } else if viewModel.filteredFormateurs.isEmpty {
            LTEmptyState(
                icon: "person.2.slash",
                title: "Aucun formateur",
                message: "Aucun formateur trouvé",
                actionTitle: "Ajouter",
                action: { showingAddFormateur = true }
            )
        } else {
            formateursList
        }
    }
    
    // MARK: - Add Button
    private var addButton: some View {
        Button {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            showingAddFormateur = true
        } label: {
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [.emerald400, .emerald600], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 36, height: 36)
                    .shadow(color: .emerald500.opacity(0.4), radius: 8, y: 2)
                
                Image(systemName: "plus")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .ltScaleOnPress()
    }
    
    // MARK: - List
    private var formateursList: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: LTSpacing.md) {
                ForEach(Array(viewModel.filteredFormateurs.enumerated()), id: \.element.id) { index, formateur in
                    NavigationLink(destination: FormateurDetailView(formateur: formateur)) {
                        FormateurCardView(formateur: formateur)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .ltStaggered(index: index)
                }
            }
            .padding(.horizontal, LTSpacing.lg)
            .padding(.bottom, 100)
        }
        .refreshable {
            await viewModel.fetchFormateurs()
        }
    }
}

// MARK: - Formateur Card
struct FormateurCardView: View {
    let formateur: Formateur
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: LTSpacing.md) {
            LTAvatar(
                initials: formateur.initiales,
                size: .medium,
                color: formateur.exterieur ? .warning : .emerald500
            )
            
            VStack(alignment: .leading, spacing: LTSpacing.xs) {
                Text(formateur.nomComplet)
                    .font(.ltBodySemibold)
                    .foregroundColor(.ltText)
                
                Text(formateur.specialite.isEmpty ? formateur.email : formateur.specialite)
                    .font(.ltCaption)
                    .foregroundColor(.ltTextSecondary)
                
                LTBadge(
                    text: formateur.exterieur ? "Externe" : "Interne",
                    color: formateur.exterieur ? .warning : .emerald500,
                    size: .small
                )
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: LTIconSize.sm, weight: .semibold))
                .foregroundColor(.ltTextTertiary)
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
    FormateursListView()
        .environmentObject(AuthService.shared)
        .preferredColorScheme(.dark)
}
