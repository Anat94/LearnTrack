import SwiftUI

// MARK: - Emerald Campus Theme

enum LT {
    enum ColorToken {
        // Dynamic colors (light/dark)
        static var primary: Color { dynamic(light: "#10B981", dark: "#34D399") }   // Emerald
        static var secondary: Color { dynamic(light: "#0EA5E9", dark: "#38BDF8") } // Sky blue
        static var accent: Color { dynamic(light: "#F59E0B", dark: "#FBBF24") }    // Amber

        static var bg: Color { dynamic(light: "#F4F9F7", dark: "#0C1A17") }
        static var surface: Color { dynamic(light: "#FFFFFF", dark: "#0F2320") }
        static var border: Color { dynamic(light: "#E5E7EB", dark: "#1F3A37") }

        static var textPrimary: Color { dynamic(light: "#0B0F14", dark: "#F9FAFB") }
        static var textSecondary: Color { dynamic(light: "#6B7280", dark: "#9CA3AF") }

        static var success: Color { dynamic(light: "#10B981", dark: "#10B981") }
        static var warning: Color { dynamic(light: "#F59E0B", dark: "#F59E0B") }
        static var danger: Color { dynamic(light: "#EF4444", dark: "#F87171") }
    }

    enum Metric {
        static let cornerM: CGFloat = 12
        static let cornerL: CGFloat = 16
        static let padding: CGFloat = 16
        static let cardPadding: CGFloat = 14
        static let chipPaddingH: CGFloat = 14
        static let chipPaddingV: CGFloat = 8
        static let elevation: CGFloat = 6
    }

    // Section card container
    struct SectionCard<Content: View>: View {
        let content: Content
        init(@ViewBuilder content: () -> Content) { self.content = content() }
        var body: some View {
            content
                .padding(LT.Metric.cardPadding)
                .background(LT.ColorToken.surface)
                .cornerRadius(LT.Metric.cornerL)
                .overlay(
                    RoundedRectangle(cornerRadius: LT.Metric.cornerL)
                        .stroke(LT.ColorToken.border.opacity(0.7), lineWidth: 1)
                )
        }
    }

    // Badge with soft background
    struct Badge: View {
        let text: String
        let color: Color
        var body: some View {
            Text(text)
                .font(.caption).fontWeight(.semibold)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(color.opacity(0.15))
                .foregroundColor(color)
                .cornerRadius(10)
        }
    }

    // Chip (selectable)
    struct Chip: View {
        let label: String
        let selected: Bool
        var body: some View {
            Text(label)
                .font(.subheadline)
                .fontWeight(selected ? .semibold : .regular)
                .padding(.horizontal, LT.Metric.chipPaddingH)
                .padding(.vertical, LT.Metric.chipPaddingV)
                .background(selected ? LT.ColorToken.primary : LT.ColorToken.border.opacity(0.3))
                .foregroundColor(selected ? .white : LT.ColorToken.textPrimary)
                .cornerRadius(20)
        }
    }

    // Primary button style
    struct PrimaryButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .font(.headline)
                .frame(maxWidth: .infinity, minHeight: 52)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [LT.ColorToken.primary, LT.ColorToken.secondary]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .foregroundColor(.white)
                .cornerRadius(LT.Metric.cornerL)
                .shadow(color: LT.ColorToken.primary.opacity(0.25), radius: 10, x: 0, y: 6)
                .scaleEffect(configuration.isPressed ? 0.98 : 1)
                .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
        }
    }

    // Secondary button style (outlined)
    struct SecondaryButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .font(.subheadline).fontWeight(.semibold)
                .frame(maxWidth: .infinity, minHeight: 46)
                .background(LT.ColorToken.surface)
                .foregroundColor(LT.ColorToken.primary)
                .overlay(
                    RoundedRectangle(cornerRadius: LT.Metric.cornerM)
                        .stroke(LT.ColorToken.primary.opacity(0.6), lineWidth: 1)
                )
                .cornerRadius(LT.Metric.cornerM)
                .scaleEffect(configuration.isPressed ? 0.98 : 1)
        }
    }
}

// MARK: - Screen modifier
struct LTScreen: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            LT.ColorToken.bg.ignoresSafeArea()
            // Soft decorative shapes for originality
            Circle()
                .fill(LT.ColorToken.secondary.opacity(0.10))
                .blur(radius: 30)
                .frame(width: 220, height: 220)
                .offset(x: -140, y: -260)
            Circle()
                .fill(LT.ColorToken.primary.opacity(0.10))
                .blur(radius: 30)
                .frame(width: 260, height: 260)
                .offset(x: 160, y: 320)
            content
        }
    }
}

extension View {
    func ltScreen() -> some View { modifier(LTScreen()) }
}

// MARK: - Color helpers
private func dynamic(light: String, dark: String) -> Color {
    Color(UIColor { tc in
        if tc.userInterfaceStyle == .dark { return UIColor(hex: dark) }
        return UIColor(hex: light)
    })
}

private extension UIColor {
    convenience init(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexString.hasPrefix("#") { hexString.removeFirst() }
        var rgb: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgb)
        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b, alpha: 1)
    }
}

// MARK: - Extra components
struct LTHeroHeader: View {
    let title: String
    let subtitle: String?
    let systemImage: String

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(
                gradient: Gradient(colors: [LT.ColorToken.primary, LT.ColorToken.secondary]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 140)
            .cornerRadius(20)
            .overlay(
                Image(systemName: systemImage)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white.opacity(0.15))
                    .frame(width: 120, height: 120)
                    .offset(x: 200, y: 10), alignment: .topLeading
            )
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                }
            }
            .padding(16)
        }
        .padding(.horizontal)
        .padding(.top)
    }
}

struct LTIconTextField: View {
    let systemImage: String
    let placeholder: String
    @Binding var text: String
    var keyboard: UIKeyboardType = .default
    var autocap: UITextAutocapitalizationType = .sentences
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: systemImage)
                .foregroundColor(LT.ColorToken.textSecondary)
            TextField(placeholder, text: $text)
                .keyboardType(keyboard)
                .textInputAutocapitalization(autocap == .none ? .never : .sentences)
                .autocorrectionDisabled()
        }
        .padding(12)
        .background(LT.ColorToken.surface)
        .overlay(
            RoundedRectangle(cornerRadius: LT.Metric.cornerM)
                .stroke(LT.ColorToken.border.opacity(0.7), lineWidth: 1)
        )
        .cornerRadius(LT.Metric.cornerM)
    }
}

struct LTIconSecureField: View {
    let systemImage: String
    let placeholder: String
    @Binding var text: String
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: systemImage)
                .foregroundColor(LT.ColorToken.textSecondary)
            SecureField(placeholder, text: $text)
        }
        .padding(12)
        .background(LT.ColorToken.surface)
        .overlay(
            RoundedRectangle(cornerRadius: LT.Metric.cornerM)
                .stroke(LT.ColorToken.border.opacity(0.7), lineWidth: 1)
        )
        .cornerRadius(LT.Metric.cornerM)
    }
}

// MARK: - TextField Style (shared)
struct LTTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .padding()
            .background(LT.ColorToken.surface)
            .cornerRadius(LT.Metric.cornerM)
            .foregroundColor(LT.ColorToken.textPrimary)
            .overlay(
                RoundedRectangle(cornerRadius: LT.Metric.cornerM)
                    .stroke(LT.ColorToken.border.opacity(0.7), lineWidth: 1)
            )
    }
}
