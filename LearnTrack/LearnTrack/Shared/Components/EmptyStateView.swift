//
//  EmptyStateView.swift
//  LearnTrack
//
//  Vue pour les états vides
//

import SwiftUI

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(LT.ColorToken.secondary)
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(LT.ColorToken.textPrimary)
            Text(message)
                .font(.subheadline)
                .foregroundColor(LT.ColorToken.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clear)
    }
}

#Preview {
    EmptyStateView(
        icon: "calendar.badge.exclamationmark",
        title: "Aucune session",
        message: "Aucune session trouvée pour ce mois"
    )
}
