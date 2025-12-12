//
//  FormateursListView.swift
//  LearnTrack
//
//  Liste des formateurs style Winamax
//

import SwiftUI

struct FormateursListView: View {
    @StateObject private var viewModel = FormateurViewModel()
    @State private var showingAddFormateur = false
    @Environment(\.colorScheme) var colorScheme
    
    var theme: AppTheme {
        colorScheme == .dark ? .dark : .light
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                WinamaxBackground()
                
                VStack(spacing: 16) {
                    SearchBar(text: $viewModel.searchText, placeholder: "Rechercher un formateur...")
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                    
                    // Filtre type
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(FormateurViewModel.FilterType.allCases, id: \.self) { type in
                                Button(action: {
                                    withAnimation(.spring(response: 0.3)) {
                                        viewModel.filterType = type
                                    }
                                }) {
                                    Text(type.rawValue)
                                        .font(.system(size: 14, weight: .bold, design: .rounded))
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 10)
                                        .background(
                                            Group {
                                                if viewModel.filterType == type {
                                                    LinearGradient(
                                                        colors: [theme.primaryGreen, theme.primaryGreen.opacity(0.85)],
                                                        startPoint: .leading,
                                                        endPoint: .trailing
                                                    )
                                                } else {
                                                    theme.cardBackground
                                                }
                                            }
                                        )
                                        .foregroundColor(viewModel.filterType == type ? .white : theme.textPrimary)
                                        .clipShape(Capsule(style: .continuous))
                                        .overlay(
                                            Capsule(style: .continuous)
                                                .stroke(viewModel.filterType == type ? .clear : theme.borderColor, lineWidth: 1.5)
                                        )
                                        .shadow(
                                            color: viewModel.filterType == type ? theme.primaryGreen.opacity(0.3) : theme.shadowColor,
                                            radius: viewModel.filterType == type ? 8 : 4,
                                            y: viewModel.filterType == type ? 4 : 2
                                        )
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: theme.primaryGreen))
                            .scaleEffect(1.2)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if viewModel.filteredFormateurs.isEmpty {
                        EmptyStateView(
                            icon: "person.2.slash",
                            title: "Aucun formateur",
                            message: "Aucun formateur trouvé"
                        )
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 14) {
                                ForEach(viewModel.filteredFormateurs) { formateur in
                                    NavigationLink(destination: FormateurDetailView(formateur: formateur)) {
                                        FormateurRowView(formateur: formateur)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                        }
                        .refreshable {
                            await viewModel.fetchFormateurs()
                        }
                    }
                }
            }
            .navigationTitle("Formateurs")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddFormateur = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(theme.primaryGreen)
                            .shadow(color: theme.primaryGreen.opacity(0.3), radius: 8, y: 4)
                    }
                }
            }
            .sheet(isPresented: $showingAddFormateur) {
                FormateurFormView(viewModel: viewModel)
            }
            .task {
                await viewModel.fetchFormateurs()
            }
        }
    }
}

struct FormateurRowView: View {
    let formateur: Formateur
    @Environment(\.colorScheme) var colorScheme
    
    var theme: AppTheme {
        colorScheme == .dark ? .dark : .light
    }
    
    var body: some View {
        HStack(spacing: 14) {
            // Avatar avec initiales
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: formateur.exterieur ? 
                                [theme.accentOrange, theme.accentOrange.opacity(0.7)] :
                                [theme.primaryGreen, theme.primaryGreen.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 56, height: 56)
                    .shadow(
                        color: (formateur.exterieur ? theme.accentOrange : theme.primaryGreen).opacity(0.3),
                        radius: 8,
                        y: 4
                    )
                
                Text(formateur.initiales)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(formateur.nomComplet)
                    .font(.winamaxHeadline())
                    .foregroundColor(theme.textPrimary)
                
                Text(formateur.specialite)
                    .font(.winamaxCaption())
                    .foregroundColor(theme.textSecondary)
                
                // Badge type
                WinamaxBadge(
                    text: formateur.type,
                    color: formateur.exterieur ? theme.accentOrange : theme.primaryGreen
                )
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(theme.textSecondary)
        }
        .winamaxCard()
    }
}

#Preview {
    FormateursListView()
        .preferredColorScheme(.dark)
}
