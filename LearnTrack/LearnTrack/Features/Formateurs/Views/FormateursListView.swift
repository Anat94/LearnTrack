//
//  FormateursListView.swift
//  LearnTrack
//
//  Liste des formateurs - Design Emerald
//

import SwiftUI

struct FormateursListView: View {
    @StateObject private var viewModel = FormateurViewModel()
    @State private var showingAddFormateur = false
    @State private var selectedFilterIndex = 0
    
    private let filterTitles = ["Tous", "Internes", "Externes"]
    
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
                    Text("Formateurs")
                        .font(.ltH3)
                        .foregroundColor(.ltText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    LTIconButton(icon: "plus", variant: .primary, size: .small) {
                        showingAddFormateur = true
                    }
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
            LTSearchBar(text: $viewModel.searchText, placeholder: "Rechercher un formateur...")
                .padding(.horizontal, LTSpacing.lg)
                .padding(.top, LTSpacing.md)
            
            LTSegmentedControl(
                selectedIndex: $selectedFilterIndex,
                items: filterTitles
            )
            .padding(.horizontal, LTSpacing.lg)
        }
        .padding(.bottom, LTSpacing.md)
        .background(Color.ltCard)
    }
    
    // MARK: - Content
    @ViewBuilder
    private var contentSection: some View {
        if viewModel.isLoading {
            ScrollView {
                LazyVStack(spacing: LTSpacing.md) {
                    ForEach(0..<6) { _ in
                        LTSkeletonPersonRow()
                    }
                }
                .padding(.horizontal, LTSpacing.lg)
                .padding(.top, LTSpacing.lg)
            }
        } else if viewModel.filteredFormateurs.isEmpty {
            LTEmptyState(
                icon: "person.2.slash",
                title: "Aucun formateur",
                message: "Aucun formateur trouvé. Ajoutez-en un nouveau !",
                actionTitle: "Ajouter un formateur"
            ) {
                showingAddFormateur = true
            }
        } else {
            ScrollView {
                LazyVStack(spacing: LTSpacing.md) {
                    ForEach(Array(viewModel.filteredFormateurs.enumerated()), id: \.element.id) { index, formateur in
                        NavigationLink(destination: FormateurDetailView(formateur: formateur)) {
                            FormateurCardNew(formateur: formateur)
                                .ltStaggered(index: index)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, LTSpacing.lg)
                .padding(.top, LTSpacing.lg)
                .padding(.bottom, 100)
            }
            .refreshable {
                await viewModel.fetchFormateurs()
            }
        }
    }
}

// MARK: - New Formateur Card
struct FormateurCardNew: View {
    let formateur: Formateur
    
    @State private var isPressed = false
    
    private var badgeColor: Color {
        formateur.exterieur ? .warning : .emerald500
    }
    
    var body: some View {
        HStack(spacing: LTSpacing.md) {
            // Avatar
            LTAvatar(
                initials: formateur.initiales,
                size: .medium,
                color: badgeColor
            )
            
            // Info
            VStack(alignment: .leading, spacing: LTSpacing.xs) {
                Text(formateur.nomComplet)
                    .font(.ltBodySemibold)
                    .foregroundColor(.ltText)
                
                Text(formateur.specialite)
                    .font(.ltCaption)
                    .foregroundColor(.ltTextSecondary)
                
                LTTypeBadge(isExterne: formateur.exterieur)
            }
            
            Spacer()
            
            // Chevron
            Image(systemName: "chevron.right")
                .font(.system(size: LTIconSize.sm, weight: .semibold))
                .foregroundColor(.ltTextTertiary)
        }
        .padding(LTSpacing.md)
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
    FormateursListView()
}
