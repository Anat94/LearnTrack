//
//  EcolesListView.swift
//  LearnTrack
//
//  Liste des écoles - Design Premium
//

import SwiftUI

struct EcolesListView: View {
    @StateObject private var viewModel = EcoleViewModel()
    @State private var showingAddEcole = false
    
    var body: some View {
        NavigationView {
            ZStack {
                LTGradientBackground()
                
                VStack(spacing: 0) {
                    // Search
                    LTSearchBar(text: $viewModel.searchText, placeholder: "Rechercher...")
                        .padding(.horizontal, LTSpacing.lg)
                        .padding(.vertical, LTSpacing.md)
                    
                    // Content
                    ScrollView(showsIndicators: false) {
                        contentSection
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Écoles")
                        .font(.ltH3)
                        .foregroundColor(.ltText)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    addButton
                }
            }
            .sheet(isPresented: $showingAddEcole) {
                EcoleFormView(viewModel: viewModel)
            }
            .task {
                await viewModel.fetchEcoles()
            }
        }
    }
    
    // MARK: - Add Button
    private var addButton: some View {
        Button {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            showingAddEcole = true
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
    
    // MARK: - Content
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
        } else if viewModel.filteredEcoles.isEmpty {
            VStack {
                Spacer(minLength: 80)
                LTEmptyState(
                    icon: "graduationcap",
                    title: "Aucune école",
                    message: "Aucune école trouvée",
                    actionTitle: "Ajouter",
                    action: { showingAddEcole = true }
                )
                Spacer()
            }
            .frame(minHeight: 400)
        } else {
            ecolesList
        }
    }
    
    // MARK: - List
    private var ecolesList: some View {
        LazyVStack(spacing: LTSpacing.md) {
            ForEach(Array(viewModel.filteredEcoles.enumerated()), id: \.element.id) { index, ecole in
                NavigationLink(destination: EcoleDetailView(ecole: ecole)) {
                    EcoleCardView(ecole: ecole)
                }
                .buttonStyle(PlainButtonStyle())
                .ltStaggered(index: index)
            }
        }
        .padding(.horizontal, LTSpacing.lg)
        .padding(.bottom, 100)
    }
}

// MARK: - Ecole Card
struct EcoleCardView: View {
    let ecole: Ecole
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: LTSpacing.md) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.emerald500.opacity(0.2), .emerald600.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: LTHeight.avatarMedium, height: LTHeight.avatarMedium)
                
                Image(systemName: "graduationcap.fill")
                    .font(.system(size: LTIconSize.lg))
                    .foregroundColor(.emerald500)
            }
            
            VStack(alignment: .leading, spacing: LTSpacing.xs) {
                Text(ecole.nom)
                    .font(.ltBodySemibold)
                    .foregroundColor(.ltText)
                
                if let ville = ecole.ville, !ville.isEmpty {
                    Text(ville)
                        .font(.ltCaption)
                        .foregroundColor(.ltTextSecondary)
                }
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
    EcolesListView()
        .environmentObject(AuthService.shared)
        .preferredColorScheme(.dark)
}
