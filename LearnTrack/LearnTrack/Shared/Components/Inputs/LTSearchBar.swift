//
//  LTSearchBar.swift
//  LearnTrack
//
//  Barre de recherche custom avec style glassmorphism
//

import SwiftUI

struct LTSearchBar: View {
    @Binding var text: String
    let placeholder: String
    let showCancelButton: Bool
    let onSubmit: (() -> Void)?
    let onCancel: (() -> Void)?
    
    @FocusState private var isFocused: Bool
    @State private var isEditing = false
    
    init(
        text: Binding<String>,
        placeholder: String = "Rechercher...",
        showCancelButton: Bool = true,
        onSubmit: (() -> Void)? = nil,
        onCancel: (() -> Void)? = nil
    ) {
        self._text = text
        self.placeholder = placeholder
        self.showCancelButton = showCancelButton
        self.onSubmit = onSubmit
        self.onCancel = onCancel
    }
    
    var body: some View {
        HStack(spacing: LTSpacing.md) {
            // Search field
            HStack(spacing: LTSpacing.sm) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: LTIconSize.md, weight: .medium))
                    .foregroundColor(isFocused ? .emerald500 : .ltTextTertiary)
                
                TextField(placeholder, text: $text)
                    .font(.ltBody)
                    .foregroundColor(.ltText)
                    .focused($isFocused)
                    .submitLabel(.search)
                    .onSubmit {
                        onSubmit?()
                    }
                
                // Clear button
                if !text.isEmpty {
                    Button(action: {
                        text = ""
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: LTIconSize.md))
                            .foregroundColor(.ltTextTertiary)
                    }
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(.horizontal, LTSpacing.lg)
            .frame(height: LTHeight.inputMedium)
            .background(
                RoundedRectangle(cornerRadius: LTRadius.lg)
                    .fill(Color.ltCard)
                    .overlay(
                        RoundedRectangle(cornerRadius: LTRadius.lg)
                            .stroke(
                                isFocused ? Color.emerald500 : Color.ltBorderSubtle,
                                lineWidth: isFocused ? 2 : 1
                            )
                    )
            )
            .ltCardShadow()
            .animation(.ltSpringSubtle, value: isFocused)
            
            // Cancel button
            if showCancelButton && isEditing {
                Button(action: {
                    text = ""
                    isFocused = false
                    isEditing = false
                    onCancel?()
                    UIApplication.shared.hideKeyboard()
                }) {
                    Text("Annuler")
                        .font(.ltButtonMedium)
                        .foregroundColor(.emerald500)
                }
                .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .animation(.ltSpringSmooth, value: isEditing)
        .onChange(of: isFocused) { _, newValue in
            withAnimation {
                isEditing = newValue
            }
        }
    }
}

// MARK: - Search Bar with Filters
struct LTSearchBarWithFilters: View {
    @Binding var text: String
    @Binding var selectedFilter: Int
    let placeholder: String
    let filters: [String]
    
    var body: some View {
        VStack(spacing: LTSpacing.md) {
            LTSearchBar(text: $text, placeholder: placeholder)
            
            // Filter chips
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: LTSpacing.sm) {
                    ForEach(Array(filters.enumerated()), id: \.offset) { index, filter in
                        LTFilterChip(
                            text: filter,
                            isSelected: selectedFilter == index,
                            action: {
                                withAnimation(.ltSpringSnappy) {
                                    selectedFilter = index
                                }
                                let impact = UIImpactFeedbackGenerator(style: .light)
                                impact.impactOccurred()
                            }
                        )
                    }
                }
            }
        }
    }
}

// MARK: - Filter Chip
struct LTFilterChip: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.ltCaptionMedium)
                .foregroundColor(isSelected ? .white : .ltText)
                .padding(.horizontal, LTSpacing.lg)
                .padding(.vertical, LTSpacing.sm)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.emerald500 : Color.ltCard)
                )
                .overlay(
                    Capsule()
                        .stroke(
                            isSelected ? Color.clear : Color.ltBorder,
                            lineWidth: 1
                        )
                )
                .scaleEffect(isPressed ? 0.95 : 1.0)
                .animation(.ltSpringSubtle, value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
        .if(isSelected) { view in
            view.ltShadow(.glowSubtle)
        }
    }
}

// MARK: - Month Filter (for Sessions)
struct LTMonthFilter: View {
    @Binding var selectedMonth: Int
    
    private let months = [
        "Jan", "Fév", "Mar", "Avr", "Mai", "Juin",
        "Juil", "Aoû", "Sep", "Oct", "Nov", "Déc"
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: LTSpacing.sm) {
                ForEach(1...12, id: \.self) { month in
                    LTFilterChip(
                        text: months[month - 1],
                        isSelected: selectedMonth == month,
                        action: {
                            withAnimation(.ltSpringSnappy) {
                                selectedMonth = month
                            }
                        }
                    )
                }
            }
            .padding(.horizontal, LTSpacing.lg)
        }
    }
}

// MARK: - Segmented Control Custom
struct LTSegmentedControl: View {
    @Binding var selectedIndex: Int
    let items: [String]
    
    @Namespace private var animation
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                Button(action: {
                    withAnimation(.ltSpringSnappy) {
                        selectedIndex = index
                    }
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                }) {
                    Text(item)
                        .font(.ltCaptionMedium)
                        .foregroundColor(selectedIndex == index ? .white : .ltTextSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, LTSpacing.sm)
                        .background {
                            if selectedIndex == index {
                                Capsule()
                                    .fill(Color.emerald500)
                                    .matchedGeometryEffect(id: "segment", in: animation)
                            }
                        }
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(LTSpacing.xs)
        .background(
            Capsule()
                .fill(Color.ltBackgroundSecondary)
        )
    }
}

// MARK: - Preview
#Preview("Search & Filters") {
    VStack(spacing: 24) {
        Text("Search Bar")
            .font(.ltH3)
        
        LTSearchBar(text: .constant(""))
        
        LTSearchBar(text: .constant("Swift"))
        
        Divider()
        
        Text("With Filters")
            .font(.ltH3)
        
        LTSearchBarWithFilters(
            text: .constant(""),
            selectedFilter: .constant(0),
            placeholder: "Rechercher une session...",
            filters: ["Tout", "Présentiel", "Distanciel", "Confirmé"]
        )
        
        Divider()
        
        Text("Month Filter")
            .font(.ltH3)
        
        LTMonthFilter(selectedMonth: .constant(12))
        
        Divider()
        
        Text("Segmented Control")
            .font(.ltH3)
        
        LTSegmentedControl(
            selectedIndex: .constant(0),
            items: ["Tous", "Internes", "Externes"]
        )
        .padding(.horizontal)
        
        Spacer()
    }
    .padding()
    .background(Color.ltBackground)
}
