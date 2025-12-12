//
//  LTSearchBar.swift
//  LearnTrack
//
//  Barre de recherche et filtres - Design Emerald
//

import SwiftUI

// MARK: - LTSearchBar
struct LTSearchBar: View {
    @Binding var text: String
    var placeholder: String = "Rechercher..."
    
    @State private var isFocused = false
    @FocusState private var fieldFocused: Bool
    
    var body: some View {
        HStack(spacing: LTSpacing.md) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: LTIconSize.md))
                .foregroundColor(isFocused ? .emerald500 : .ltTextTertiary)
            
            TextField(placeholder, text: $text)
                .font(.ltBody)
                .foregroundColor(.ltText)
                .focused($fieldFocused)
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: LTIconSize.md))
                        .foregroundColor(.ltTextTertiary)
                }
            }
        }
        .padding(.horizontal, LTSpacing.lg)
        .frame(height: LTHeight.inputMedium)
        .background(Color.ltBackgroundSecondary)
        .clipShape(RoundedRectangle(cornerRadius: LTRadius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: LTRadius.lg)
                .stroke(isFocused ? Color.emerald500 : Color.ltBorderSubtle, lineWidth: isFocused ? 2 : 1)
        )
        .onChange(of: fieldFocused) { _, newValue in
            withAnimation(.ltSpringSubtle) { isFocused = newValue }
        }
    }
}

// MARK: - Segmented Control
struct LTSegmentedControl: View {
    @Binding var selectedIndex: Int
    let items: [String]
    
    var body: some View {
        HStack(spacing: LTSpacing.xs) {
            ForEach(items.indices, id: \.self) { index in
                Button(action: {
                    withAnimation(.ltSpringSnappy) {
                        selectedIndex = index
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()
                    }
                }) {
                    Text(items[index])
                        .font(.ltCaptionMedium)
                        .foregroundColor(selectedIndex == index ? .white : .ltTextSecondary)
                        .padding(.horizontal, LTSpacing.lg)
                        .padding(.vertical, LTSpacing.sm)
                        .background(
                            selectedIndex == index ?
                                Color.emerald500 : Color.clear
                        )
                        .clipShape(Capsule())
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(LTSpacing.xs)
        .background(Color.ltBackgroundSecondary)
        .clipShape(Capsule())
    }
}

// MARK: - Month Filter
struct LTMonthFilter: View {
    @Binding var selectedMonth: Date
    
    private let calendar = Calendar.current
    
    var body: some View {
        HStack(spacing: LTSpacing.md) {
            Button(action: { changeMonth(-1) }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: LTIconSize.md, weight: .semibold))
                    .foregroundColor(.emerald500)
            }
            
            Text(monthYearString)
                .font(.ltBodySemibold)
                .foregroundColor(.ltText)
                .frame(minWidth: 120)
            
            Button(action: { changeMonth(1) }) {
                Image(systemName: "chevron.right")
                    .font(.system(size: LTIconSize.md, weight: .semibold))
                    .foregroundColor(.emerald500)
            }
        }
        .padding(.horizontal, LTSpacing.lg)
        .padding(.vertical, LTSpacing.sm)
        .background(Color.ltCard)
        .clipShape(RoundedRectangle(cornerRadius: LTRadius.lg))
        .ltCardShadow()
    }
    
    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: selectedMonth).capitalized
    }
    
    private func changeMonth(_ delta: Int) {
        if let newDate = calendar.date(byAdding: .month, value: delta, to: selectedMonth) {
            withAnimation(.ltSpringSubtle) {
                selectedMonth = newDate
            }
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        LTSearchBar(text: .constant(""))
        LTSegmentedControl(selectedIndex: .constant(0), items: ["Tous", "Actifs", "Inactifs"])
        LTMonthFilter(selectedMonth: .constant(Date()))
    }
    .padding()
    .background(Color.ltBackground)
}
