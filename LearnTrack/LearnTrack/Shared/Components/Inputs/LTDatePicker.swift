//
//  LTDatePicker.swift
//  LearnTrack
//
//  Custom Date Picker - Design Emerald
//

import SwiftUI

// MARK: - Date Field
struct LTDateField: View {
    let label: String
    @Binding var date: Date
    var displayedComponents: DatePickerComponents = [.date]
    var icon: String? = "calendar"
    
    @State private var isFocused = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: LTSpacing.sm) {
            if !label.isEmpty {
                Text(label)
                    .font(.ltLabel)
                    .foregroundColor(.ltTextSecondary)
            }
            
            HStack(spacing: LTSpacing.md) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: LTIconSize.md))
                        .foregroundColor(isFocused ? .emerald500 : .ltTextTertiary)
                }
                
                DatePicker("", selection: $date, displayedComponents: displayedComponents)
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    .tint(.emerald500)
                
                Spacer()
            }
            .padding(.horizontal, LTSpacing.lg)
            .frame(height: LTHeight.inputLarge)
            .background(Color.ltBackgroundSecondary)
            .clipShape(RoundedRectangle(cornerRadius: LTRadius.lg))
            .overlay(
                RoundedRectangle(cornerRadius: LTRadius.lg)
                    .stroke(isFocused ? Color.emerald500 : Color.ltBorderSubtle, lineWidth: isFocused ? 2 : 1)
            )
        }
    }
}

// MARK: - Time Field
struct LTTimeField: View {
    let label: String
    @Binding var time: String
    
    @State private var isFocused = false
    @FocusState private var fieldFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: LTSpacing.sm) {
            if !label.isEmpty {
                Text(label)
                    .font(.ltLabel)
                    .foregroundColor(.ltTextSecondary)
            }
            
            HStack(spacing: LTSpacing.md) {
                Image(systemName: "clock")
                    .font(.system(size: LTIconSize.md))
                    .foregroundColor(isFocused ? .emerald500 : .ltTextTertiary)
                
                TextField("00:00", text: $time)
                    .font(.ltBody)
                    .foregroundColor(.ltText)
                    .keyboardType(.numbersAndPunctuation)
                    .focused($fieldFocused)
                
                Spacer()
            }
            .padding(.horizontal, LTSpacing.lg)
            .frame(height: LTHeight.inputLarge)
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
}

#Preview {
    VStack(spacing: 20) {
        LTDateField(label: "Date de la session", date: .constant(Date()))
        LTTimeField(label: "Heure de début", time: .constant("09:00"))
    }
    .padding()
    .background(Color.ltBackground)
}
