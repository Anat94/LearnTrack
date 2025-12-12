//
//  LTFormComponents.swift
//  LearnTrack
//
//  Composants de formulaire - Design SaaS compact
//

import SwiftUI

// MARK: - Form Section
struct LTFormSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content
    
    var body: some View {
        LTCard {
            VStack(alignment: .leading, spacing: LTSpacing.md) {
                Text(title)
                    .font(.ltBodySemibold)
                    .foregroundColor(.ltText)
                
                content
            }
        }
    }
}

// MARK: - Form Field
struct LTFormField: View {
    let label: String
    @Binding var text: String
    var placeholder: String = ""
    var keyboardType: UIKeyboardType = .default
    var isSecure: Bool = false
    
    @State private var isFocused = false
    @FocusState private var fieldFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: LTSpacing.xs) {
            Text(label)
                .font(.ltSmall)
                .foregroundColor(.ltTextSecondary)
            
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .font(.ltBody)
            .foregroundColor(.ltText)
            .keyboardType(keyboardType)
            .focused($fieldFocused)
            .padding(.horizontal, LTSpacing.md)
            .frame(height: LTHeight.inputSmall)
            .background(Color.ltBackgroundSecondary)
            .clipShape(RoundedRectangle(cornerRadius: LTRadius.md))
            .overlay(
                RoundedRectangle(cornerRadius: LTRadius.md)
                    .stroke(isFocused ? Color.emerald500 : Color.clear, lineWidth: 1)
            )
            .onChange(of: fieldFocused) { _, newValue in
                withAnimation(.ltFast) { isFocused = newValue }
            }
        }
    }
}

// MARK: - Form Toggle
struct LTFormToggle: View {
    let label: String
    @Binding var isOn: Bool
    var icon: String? = nil
    
    var body: some View {
        Toggle(isOn: $isOn) {
            HStack(spacing: LTSpacing.sm) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: LTIconSize.md))
                        .foregroundColor(.emerald500)
                }
                
                Text(label)
                    .font(.ltBody)
                    .foregroundColor(.ltText)
            }
        }
        .tint(.emerald500)
    }
}

// MARK: - Form Picker
struct LTFormPicker<T: Hashable>: View {
    let label: String
    @Binding var selection: T
    let options: [(value: T, label: String)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: LTSpacing.xs) {
            Text(label)
                .font(.ltSmall)
                .foregroundColor(.ltTextSecondary)
            
            Menu {
                ForEach(options, id: \.value) { option in
                    Button(action: { selection = option.value }) {
                        Text(option.label)
                    }
                }
            } label: {
                HStack {
                    Text(options.first(where: { $0.value == selection })?.label ?? "")
                        .font(.ltBody)
                        .foregroundColor(.ltText)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: LTIconSize.xs))
                        .foregroundColor(.ltTextSecondary)
                }
                .padding(.horizontal, LTSpacing.md)
                .frame(height: LTHeight.inputSmall)
                .background(Color.ltBackgroundSecondary)
                .clipShape(RoundedRectangle(cornerRadius: LTRadius.md))
            }
        }
    }
}

// MARK: - Form Date Picker
struct LTFormDatePicker: View {
    let label: String
    @Binding var date: Date
    var displayedComponents: DatePicker.Components = .date
    
    var body: some View {
        VStack(alignment: .leading, spacing: LTSpacing.xs) {
            Text(label)
                .font(.ltSmall)
                .foregroundColor(.ltTextSecondary)
            
            DatePicker("", selection: $date, displayedComponents: displayedComponents)
                .labelsHidden()
                .datePickerStyle(.compact)
                .tint(.emerald500)
        }
    }
}

// MARK: - Form Row (horizontal)
struct LTFormRow: View {
    let spacing: CGFloat
    let content: () -> AnyView
    
    init(spacing: CGFloat = LTSpacing.md, @ViewBuilder content: @escaping () -> some View) {
        self.spacing = spacing
        self.content = { AnyView(content()) }
    }
    
    var body: some View {
        HStack(spacing: spacing) {
            content()
        }
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 16) {
            LTFormSection(title: "Identité") {
                LTFormField(label: "Prénom", text: .constant("Jean"), placeholder: "Prénom")
                LTFormField(label: "Nom", text: .constant("Dupont"), placeholder: "Nom")
            }
            
            LTFormSection(title: "Options") {
                LTFormToggle(label: "Formateur externe", isOn: .constant(true), icon: "person.badge.key.fill")
            }
        }
        .padding()
    }
    .background(Color.ltBackground)
    .preferredColorScheme(.dark)
}
