//
//  LTTextField.swift
//  LearnTrack
//
//  Composant champ de texte custom
//

import SwiftUI

// MARK: - TextField Variants
enum LTTextFieldVariant {
    case `default`
    case filled
    case outlined
}

// MARK: - LTTextField View
struct LTTextField: View {
    let label: String?
    let placeholder: String
    @Binding var text: String
    let variant: LTTextFieldVariant
    let icon: String?
    let isSecure: Bool
    let isDisabled: Bool
    let errorMessage: String?
    let helperText: String?
    let keyboardType: UIKeyboardType
    let textContentType: UITextContentType?
    let autocapitalization: TextInputAutocapitalization
    let submitLabel: SubmitLabel
    let onSubmit: (() -> Void)?
    
    @FocusState private var isFocused: Bool
    @State private var isPasswordVisible = false
    
    init(
        label: String? = nil,
        placeholder: String = "",
        text: Binding<String>,
        variant: LTTextFieldVariant = .default,
        icon: String? = nil,
        isSecure: Bool = false,
        isDisabled: Bool = false,
        errorMessage: String? = nil,
        helperText: String? = nil,
        keyboardType: UIKeyboardType = .default,
        textContentType: UITextContentType? = nil,
        autocapitalization: TextInputAutocapitalization = .sentences,
        submitLabel: SubmitLabel = .done,
        onSubmit: (() -> Void)? = nil
    ) {
        self.label = label
        self.placeholder = placeholder
        self._text = text
        self.variant = variant
        self.icon = icon
        self.isSecure = isSecure
        self.isDisabled = isDisabled
        self.errorMessage = errorMessage
        self.helperText = helperText
        self.keyboardType = keyboardType
        self.textContentType = textContentType
        self.autocapitalization = autocapitalization
        self.submitLabel = submitLabel
        self.onSubmit = onSubmit
    }
    
    private var hasError: Bool {
        errorMessage != nil
    }
    
    private var borderColor: Color {
        if hasError { return .error }
        if isFocused { return .emerald500 }
        return .ltBorder
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: LTSpacing.sm) {
            // Label
            if let label = label {
                Text(label)
                    .font(.ltLabel)
                    .foregroundColor(hasError ? .error : .ltTextSecondary)
            }
            
            // Input field
            HStack(spacing: LTSpacing.md) {
                // Leading icon
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: LTIconSize.md))
                        .foregroundColor(isFocused ? .emerald500 : .ltTextTertiary)
                }
                
                // Text input
                Group {
                    if isSecure && !isPasswordVisible {
                        SecureField(placeholder, text: $text)
                    } else {
                        TextField(placeholder, text: $text)
                    }
                }
                .font(.ltBody)
                .foregroundColor(.ltText)
                .focused($isFocused)
                .keyboardType(keyboardType)
                .textContentType(textContentType)
                .textInputAutocapitalization(autocapitalization)
                .autocorrectionDisabled(isSecure)
                .submitLabel(submitLabel)
                .onSubmit {
                    onSubmit?()
                }
                
                // Password toggle
                if isSecure {
                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                            .font(.system(size: LTIconSize.md))
                            .foregroundColor(.ltTextTertiary)
                    }
                }
                
                // Clear button
                if !text.isEmpty && !isSecure {
                    Button(action: {
                        text = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: LTIconSize.sm))
                            .foregroundColor(.ltTextTertiary)
                    }
                }
            }
            .padding(.horizontal, LTSpacing.lg)
            .frame(height: LTHeight.inputMedium)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: LTRadius.lg))
            .overlay(
                RoundedRectangle(cornerRadius: LTRadius.lg)
                    .stroke(borderColor, lineWidth: isFocused || hasError ? 2 : 1)
            )
            .animation(.ltFast, value: isFocused)
            .animation(.ltFast, value: hasError)
            .opacity(isDisabled ? 0.5 : 1)
            .disabled(isDisabled)
            
            // Error or helper text
            if let errorMessage = errorMessage {
                HStack(spacing: LTSpacing.xs) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.system(size: LTIconSize.sm))
                    Text(errorMessage)
                        .font(.ltCaption)
                }
                .foregroundColor(.error)
            } else if let helperText = helperText {
                Text(helperText)
                    .font(.ltCaption)
                    .foregroundColor(.ltTextTertiary)
            }
        }
    }
    
    private var backgroundColor: Color {
        switch variant {
        case .default, .outlined:
            return .ltCard
        case .filled:
            return .ltBackgroundSecondary
        }
    }
}

// MARK: - LTTextArea (Multiline)
struct LTTextArea: View {
    let label: String?
    let placeholder: String
    @Binding var text: String
    let minHeight: CGFloat
    let maxHeight: CGFloat
    let errorMessage: String?
    
    @FocusState private var isFocused: Bool
    
    init(
        label: String? = nil,
        placeholder: String = "",
        text: Binding<String>,
        minHeight: CGFloat = 100,
        maxHeight: CGFloat = 200,
        errorMessage: String? = nil
    ) {
        self.label = label
        self.placeholder = placeholder
        self._text = text
        self.minHeight = minHeight
        self.maxHeight = maxHeight
        self.errorMessage = errorMessage
    }
    
    private var hasError: Bool {
        errorMessage != nil
    }
    
    private var borderColor: Color {
        if hasError { return .error }
        if isFocused { return .emerald500 }
        return .ltBorder
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: LTSpacing.sm) {
            if let label = label {
                Text(label)
                    .font(.ltLabel)
                    .foregroundColor(hasError ? .error : .ltTextSecondary)
            }
            
            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text(placeholder)
                        .font(.ltBody)
                        .foregroundColor(.ltTextTertiary)
                        .padding(.horizontal, LTSpacing.lg)
                        .padding(.top, LTSpacing.md)
                }
                
                TextEditor(text: $text)
                    .font(.ltBody)
                    .foregroundColor(.ltText)
                    .focused($isFocused)
                    .scrollContentBackground(.hidden)
                    .padding(.horizontal, LTSpacing.md)
                    .padding(.vertical, LTSpacing.sm)
            }
            .frame(minHeight: minHeight, maxHeight: maxHeight)
            .background(Color.ltCard)
            .clipShape(RoundedRectangle(cornerRadius: LTRadius.lg))
            .overlay(
                RoundedRectangle(cornerRadius: LTRadius.lg)
                    .stroke(borderColor, lineWidth: isFocused || hasError ? 2 : 1)
            )
            .animation(.ltFast, value: isFocused)
            
            if let errorMessage = errorMessage {
                HStack(spacing: LTSpacing.xs) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.system(size: LTIconSize.sm))
                    Text(errorMessage)
                        .font(.ltCaption)
                }
                .foregroundColor(.error)
            }
        }
    }
}

// MARK: - Preview
#Preview("Text Fields") {
    ScrollView {
        VStack(spacing: 24) {
            Text("Default")
                .font(.ltH3)
            
            LTTextField(
                label: "Email",
                placeholder: "votre@email.com",
                text: .constant(""),
                icon: "envelope"
            )
            
            LTTextField(
                label: "Nom complet",
                placeholder: "Jean Dupont",
                text: .constant("Jean Dupont")
            )
            
            Divider()
            
            Text("Password")
                .font(.ltH3)
            
            LTTextField(
                label: "Mot de passe",
                placeholder: "••••••••",
                text: .constant("secret123"),
                icon: "lock",
                isSecure: true
            )
            
            Divider()
            
            Text("States")
                .font(.ltH3)
            
            LTTextField(
                label: "Avec erreur",
                placeholder: "",
                text: .constant("texte invalide"),
                errorMessage: "Ce champ est invalide"
            )
            
            LTTextField(
                label: "Avec aide",
                placeholder: "Entrez votre téléphone",
                text: .constant(""),
                helperText: "Format: 06 12 34 56 78"
            )
            
            LTTextField(
                label: "Désactivé",
                placeholder: "",
                text: .constant("Champ désactivé"),
                isDisabled: true
            )
            
            Divider()
            
            Text("Text Area")
                .font(.ltH3)
            
            LTTextArea(
                label: "Description",
                placeholder: "Décrivez votre session...",
                text: .constant("")
            )
        }
        .padding()
    }
    .background(Color.ltBackground)
}
