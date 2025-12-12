//
//  LTTextField.swift
//  LearnTrack
//
//  Composant champ texte - Design Emerald
//

import SwiftUI

// MARK: - LTTextField View
struct LTTextField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var icon: String? = nil
    var keyboardType: UIKeyboardType = .default
    var autocapitalization: UITextAutocapitalizationType = .sentences
    var isSecure: Bool = false
    var errorMessage: String? = nil
    var helperText: String? = nil
    var isDisabled: Bool = false
    
    @State private var isFocused = false
    @State private var showPassword = false
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
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: LTIconSize.md))
                        .foregroundColor(isFocused ? .emerald500 : .ltTextTertiary)
                }
                
                if isSecure && !showPassword {
                    SecureField(placeholder, text: $text)
                        .font(.ltBody)
                        .focused($fieldFocused)
                } else {
                    TextField(placeholder, text: $text)
                        .font(.ltBody)
                        .keyboardType(keyboardType)
                        .textInputAutocapitalization(autocapitalization == .none ? .never : .sentences)
                        .autocorrectionDisabled()
                        .focused($fieldFocused)
                }
                
                if isSecure {
                    Button(action: { showPassword.toggle() }) {
                        Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                            .font(.system(size: LTIconSize.md))
                            .foregroundColor(.ltTextTertiary)
                    }
                }
                
                if !text.isEmpty && !isSecure {
                    Button(action: { text = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: LTIconSize.md))
                            .foregroundColor(.ltTextTertiary)
                    }
                }
            }
            .foregroundColor(.ltText)
            .padding(.horizontal, LTSpacing.lg)
            .frame(height: LTHeight.inputLarge)
            .background(Color.ltBackgroundSecondary)
            .clipShape(RoundedRectangle(cornerRadius: LTRadius.lg))
            .overlay(
                RoundedRectangle(cornerRadius: LTRadius.lg)
                    .stroke(
                        errorMessage != nil ? Color.error :
                            (isFocused ? Color.emerald500 : Color.ltBorderSubtle),
                        lineWidth: isFocused || errorMessage != nil ? 2 : 1
                    )
            )
            .opacity(isDisabled ? 0.5 : 1.0)
            .onChange(of: fieldFocused) { _, newValue in
                withAnimation(.ltSpringSubtle) {
                    isFocused = newValue
                }
            }
            
            // Error or helper
            if let error = errorMessage {
                Text(error)
                    .font(.ltCaption)
                    .foregroundColor(.error)
            } else if let helper = helperText {
                Text(helper)
                    .font(.ltCaption)
                    .foregroundColor(.ltTextTertiary)
            }
        }
        .disabled(isDisabled)
    }
}

// MARK: - Text Area
struct LTTextArea: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var minHeight: CGFloat = 100
    
    @State private var isFocused = false
    @FocusState private var fieldFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: LTSpacing.sm) {
            if !label.isEmpty {
                Text(label)
                    .font(.ltLabel)
                    .foregroundColor(.ltTextSecondary)
            }
            
            TextEditor(text: $text)
                .font(.ltBody)
                .foregroundColor(.ltText)
                .scrollContentBackground(.hidden)
                .background(Color.ltBackgroundSecondary)
                .frame(minHeight: minHeight)
                .padding(LTSpacing.md)
                .clipShape(RoundedRectangle(cornerRadius: LTRadius.lg))
                .overlay(
                    RoundedRectangle(cornerRadius: LTRadius.lg)
                        .stroke(isFocused ? Color.emerald500 : Color.ltBorderSubtle,
                               lineWidth: isFocused ? 2 : 1)
                )
                .focused($fieldFocused)
                .onChange(of: fieldFocused) { _, newValue in
                    withAnimation(.ltSpringSubtle) {
                        isFocused = newValue
                    }
                }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        LTTextField(label: "Email", placeholder: "votre@email.com", text: .constant(""), icon: "envelope")
        LTTextField(label: "Mot de passe", placeholder: "••••••••", text: .constant("test"), isSecure: true)
        LTTextField(label: "Avec erreur", placeholder: "", text: .constant(""), errorMessage: "Ce champ est requis")
    }
    .padding()
    .background(Color.ltBackground)
}
