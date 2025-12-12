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
                .font(.system(size: 64, weight: .semibold))
                .foregroundColor(.brandCyan)
                .shadow(color: .brandPink.opacity(0.25), radius: 12, x: 0, y: 10)
            
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.75))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding(28)
        .glassCard()
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    EmptyStateView(
        icon: "calendar.badge.exclamationmark",
        title: "Aucune session",
        message: "Aucune session trouvée pour ce mois"
    )
}
