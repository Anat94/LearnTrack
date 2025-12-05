//
//  SearchBar.swift
//  LearnTrack
//
//  Composant de barre de recherche réutilisable
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var placeholder: String = "Rechercher..."
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(LT.ColorToken.textSecondary)
            TextField(placeholder, text: $text)
                .autocorrectionDisabled()
                .foregroundColor(LT.ColorToken.textPrimary)
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(LT.ColorToken.textSecondary)
                }
            }
        }
        .padding(10)
        .background(LT.ColorToken.surface)
        .overlay(
            RoundedRectangle(cornerRadius: LT.Metric.cornerM)
                .stroke(LT.ColorToken.border.opacity(0.7), lineWidth: 1)
        )
        .cornerRadius(LT.Metric.cornerM)
    }
}

#Preview {
    SearchBar(text: .constant(""))
        .padding()
}
