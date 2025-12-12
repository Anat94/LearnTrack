//
//  EmptyStateView.swift
//  LearnTrack
//
//  Vue pour les états vides style Winamax
//

import SwiftUI

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    @Environment(\.colorScheme) var colorScheme
    
    var theme: AppTheme {
        colorScheme == .dark ? .dark : .light
    }
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [theme.primaryGreen.opacity(0.2), theme.primaryGreen.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                
                Image(systemName: icon)
                    .font(.system(size: 50, weight: .semibold))
                    .foregroundColor(theme.primaryGreen)
            }
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.winamaxHeadline())
                    .foregroundColor(theme.textPrimary)
                
                Text(message)
                    .font(.winamaxCaption())
                    .foregroundColor(theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(40)
    }
}

#Preview {
    Group {
        EmptyStateView(
            icon: "calendar.badge.exclamationmark",
            title: "Aucune session",
            message: "Aucune session trouvée pour ce mois"
        )
        .preferredColorScheme(.light)
        
        EmptyStateView(
            icon: "calendar.badge.exclamationmark",
            title: "Aucune session",
            message: "Aucune session trouvée pour ce mois"
        )
        .preferredColorScheme(.dark)
    }
}
