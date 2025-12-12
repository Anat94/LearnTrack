//
//  SearchBar.swift
//  LearnTrack
//
//  Barre de recherche style Winamax
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var placeholder: String = "Rechercher..."
    @Environment(\.colorScheme) var colorScheme
    
    var theme: AppTheme {
        colorScheme == .dark ? .dark : .light
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(theme.primaryGreen)
                .font(.system(size: 16, weight: .semibold))
            
            TextField(placeholder, text: $text)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .foregroundColor(theme.textPrimary)
                .font(.winamaxBody())
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(theme.textSecondary)
                        .font(.system(size: 18))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(14)
        .background(theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(theme.borderColor, lineWidth: 1.5)
        )
        .shadow(color: theme.shadowColor, radius: 8, y: 4)
    }
}

#Preview {
    Group {
        SearchBar(text: .constant(""))
            .padding()
            .preferredColorScheme(.light)
        
        SearchBar(text: .constant(""))
            .padding()
            .preferredColorScheme(.dark)
    }
}
