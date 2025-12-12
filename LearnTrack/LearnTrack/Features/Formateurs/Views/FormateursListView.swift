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
            .onAppear {
                hasAppeared = true
            }
            .onChange(of: selectedFilterIndex) { _, newValue in
                withAnimation(.easeOut(duration: 0.2)) {
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
        .opacity(hasAppeared ? 1 : 0)
        .offset(y: hasAppeared ? 0 : -20)
        .animation(.easeOut(duration: 0.3), value: hasAppeared)
    }
    
    // MARK: - Content
    @ViewBuilder
    private var contentSection: some View {
        if viewModel.isLoading {
            ScrollView {
                VStack(spacing: LTSpacing.md) {
                    ForEach(0..<4, id: \.self) { _ in
                        LTSkeletonPersonRow()
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
    }
    
    // MARK: - List
    private var formateursList: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: LTSpacing.md) {
                ForEach(Array(viewModel.filteredFormateurs.enumerated()), id: \.element.id) { index, formateur in
                    NavigationLink(destination: FormateurDetailView(formateur: formateur)) {
                        LTPersonCardContent(
                            name: formateur.nomComplet,
                            subtitle: formateur.specialite.isEmpty ? formateur.email : formateur.specialite,
                            initials: formateur.initiales,
                            badge: formateur.exterieur ? "Externe" : "Interne",
                            badgeColor: formateur.exterieur ? .warning : .emerald500
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
            await viewModel.fetchFormateurs()
        }
    }
}

#Preview {
    FormateursListView()
        .environmentObject(AuthService.shared)
        .preferredColorScheme(.dark)
}
