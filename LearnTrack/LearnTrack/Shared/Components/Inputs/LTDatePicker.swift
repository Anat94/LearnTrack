//
//  LTDatePicker.swift
//  LearnTrack
//
//  Custom Date Picker - Design Emerald
//

import SwiftUI

// MARK: - Date Picker Style
struct LTDatePickerStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .datePickerStyle(.compact)
            .tint(.emerald500)
            .accentColor(.emerald500)
    }
}

extension View {
    func ltDatePickerStyle() -> some View {
        modifier(LTDatePickerStyle())
    }
}

// MARK: - Date Field
struct LTDateField: View {
    let label: String
    @Binding var date: Date
    var displayedComponents: DatePickerComponents = [.date]
    var icon: String? = "calendar"
    
    @State private var isFocused = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: LTSpacing.sm) {
            // Label
            if !label.isEmpty {
                Text(label)
                    .font(.ltLabel)
                    .foregroundColor(.ltTextSecondary)
            }
            
            // Field
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
                    .onChange(of: date) { _, _ in
                        withAnimation(.ltSpringSubtle) {
                            isFocused = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation(.ltSpringSubtle) {
                                isFocused = false
                            }
                        }
                    }
                
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
            // Label
            if !label.isEmpty {
                Text(label)
                    .font(.ltLabel)
                    .foregroundColor(.ltTextSecondary)
            }
            
            // Field
            HStack(spacing: LTSpacing.md) {
                Image(systemName: "clock")
                    .font(.system(size: LTIconSize.md))
                    .foregroundColor(isFocused ? .emerald500 : .ltTextTertiary)
                
                TextField("00:00", text: $time)
                    .font(.ltBody)
                    .foregroundColor(.ltText)
                    .keyboardType(.numbersAndPunctuation)
                    .focused($fieldFocused)
                    .onChange(of: fieldFocused) { _, newValue in
                        withAnimation(.ltSpringSubtle) {
                            isFocused = newValue
                        }
                    }
                
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

// MARK: - Date Range Picker
struct LTDateRangePicker: View {
    let label: String
    @Binding var startDate: Date
    @Binding var endDate: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: LTSpacing.md) {
            if !label.isEmpty {
                Text(label)
                    .font(.ltLabel)
                    .foregroundColor(.ltTextSecondary)
            }
            
            HStack(spacing: LTSpacing.md) {
                LTDateField(label: "", date: $startDate, icon: "calendar")
                
                Image(systemName: "arrow.right")
                    .font(.system(size: LTIconSize.sm))
                    .foregroundColor(.ltTextTertiary)
                
                LTDateField(label: "", date: $endDate, icon: "calendar")
            }
        }
    }
}

// MARK: - Month Year Picker
struct LTMonthYearPicker: View {
    @Binding var selectedDate: Date
    
    private let months = Calendar.current.monthSymbols
    private let currentYear = Calendar.current.component(.year, from: Date())
    
    @State private var selectedMonth: Int
    @State private var selectedYear: Int
    
    init(selectedDate: Binding<Date>) {
        self._selectedDate = selectedDate
        let calendar = Calendar.current
        self._selectedMonth = State(initialValue: calendar.component(.month, from: selectedDate.wrappedValue))
        self._selectedYear = State(initialValue: calendar.component(.year, from: selectedDate.wrappedValue))
    }
    
    var body: some View {
        HStack(spacing: LTSpacing.lg) {
            // Month
            Menu {
                ForEach(1...12, id: \.self) { month in
                    Button {
                        selectedMonth = month
                        updateDate()
                    } label: {
                        if month == selectedMonth {
                            Label(months[month - 1], systemImage: "checkmark")
                        } else {
                            Text(months[month - 1])
                        }
                    }
                }
            } label: {
                HStack(spacing: LTSpacing.sm) {
                    Text(months[selectedMonth - 1])
                        .font(.ltBodyMedium)
                        .foregroundColor(.ltText)
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: LTIconSize.xs))
                        .foregroundColor(.ltTextTertiary)
                }
                .padding(.horizontal, LTSpacing.lg)
                .frame(height: LTHeight.inputMedium)
                .background(Color.ltBackgroundSecondary)
                .clipShape(RoundedRectangle(cornerRadius: LTRadius.md))
            }
            
            // Year
            Menu {
                ForEach((currentYear - 5)...(currentYear + 5), id: \.self) { year in
                    Button {
                        selectedYear = year
                        updateDate()
                    } label: {
                        if year == selectedYear {
                            Label(String(year), systemImage: "checkmark")
                        } else {
                            Text(String(year))
                        }
                    }
                }
            } label: {
                HStack(spacing: LTSpacing.sm) {
                    Text(String(selectedYear))
                        .font(.ltBodyMedium)
                        .foregroundColor(.ltText)
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: LTIconSize.xs))
                        .foregroundColor(.ltTextTertiary)
                }
                .padding(.horizontal, LTSpacing.lg)
                .frame(height: LTHeight.inputMedium)
                .background(Color.ltBackgroundSecondary)
                .clipShape(RoundedRectangle(cornerRadius: LTRadius.md))
            }
        }
    }
    
    private func updateDate() {
        var components = DateComponents()
        components.year = selectedYear
        components.month = selectedMonth
        components.day = 1
        
        if let date = Calendar.current.date(from: components) {
            selectedDate = date
        }
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        Color.ltBackground
            .ignoresSafeArea()
        
        VStack(spacing: LTSpacing.xl) {
            LTDateField(label: "Date de la session", date: .constant(Date()))
            
            LTTimeField(label: "Heure de début", time: .constant("09:00"))
            
            LTMonthYearPicker(selectedDate: .constant(Date()))
        }
        .padding()
    }
}
