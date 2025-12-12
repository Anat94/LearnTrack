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
                
                VStack(spacing: 12) {
                    SearchBar(text: $viewModel.searchText, placeholder: "Rechercher un formateur...")
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                    
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
                            LazyVStack(spacing: 12) {
                                ForEach(viewModel.filteredFormateurs) { formateur in
                                    NavigationLink(destination: FormateurDetailView(formateur: formateur)) {
                                        FormateurRowView(formateur: formateur)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 16)
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
    @State private var isPressed = false
    
    var theme: AppTheme {
        colorScheme == .dark ? .dark : .light
    }
    
    var avatarColor: Color {
        formateur.exterieur ? theme.accentOrange : theme.primaryGreen
    }
    
    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                avatarColor.opacity(0.3),
                                avatarColor.opacity(0.1),
                                .clear
                            ],
                            center: .center,
                            startRadius: 5,
                            endRadius: 30
                        )
                    )
                    .frame(width: 60, height: 60)
                    .blur(radius: 8)
                
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                avatarColor,
                                avatarColor.opacity(0.85),
                                avatarColor.opacity(0.75)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 56, height: 56)
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.3),
                                        Color.white.opacity(0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    )
                    .shadow(color: avatarColor.opacity(0.4), radius: 12, y: 6)
                    .shadow(color: avatarColor.opacity(0.2), radius: 6, y: 3)
                
                Text(formateur.initiales)
                    .font(.system(size: 19, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(formateur.nomComplet)
                    .font(.winamaxHeadline())
                    .foregroundColor(theme.textPrimary)
                
                HStack(spacing: 8) {
                    Text(formateur.specialite)
                        .font(.winamaxCaption())
                        .foregroundColor(theme.textSecondary)
                    WinamaxBadge(
                        text: formateur.type,
                        color: avatarColor,
                        size: .small
                    )
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(theme.textSecondary.opacity(0.5))
        }
        .winamaxCard(
            padding: 16,
            cornerRadius: 20,
            hasGlow: true,
            glowColor: avatarColor
        )
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
    }
}

#Preview {
    FormateursListView()
        .preferredColorScheme(.dark)
}
