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
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.brandCyan.opacity(0.9))
            
            TextField(placeholder, text: $text)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .foregroundColor(.white)
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.brandPink.opacity(0.9))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(14)
        .background(
            Color.white.opacity(0.07)
                .blur(radius: 0)
        )
        .neonBordered(radius: 14)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: Color.black.opacity(0.2), radius: 12, x: 0, y: 8)
    }
}

#Preview {
    SearchBar(text: .constant(""))
        .padding()
}
