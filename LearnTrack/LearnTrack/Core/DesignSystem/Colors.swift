//
//  Colors.swift
//  LearnTrack
//
//  Design System - Palette de couleurs Emerald
//

import SwiftUI

// MARK: - Emerald Palette
extension Color {
    
    // MARK: Emerald (Primary Brand Color)
    static let emerald50 = Color(hex: "#ECFDF5")
    static let emerald100 = Color(hex: "#D1FAE5")
    static let emerald200 = Color(hex: "#A7F3D0")
    static let emerald300 = Color(hex: "#6EE7B7")
    static let emerald400 = Color(hex: "#34D399")
    static let emerald500 = Color(hex: "#10B981")
    static let emerald600 = Color(hex: "#059669")
    static let emerald700 = Color(hex: "#047857")
    static let emerald800 = Color(hex: "#065F46")
    static let emerald900 = Color(hex: "#064E3B")
    static let emerald950 = Color(hex: "#022C22")
    
    // MARK: Slate (Neutrals)
    static let slate50 = Color(hex: "#F8FAFC")
    static let slate100 = Color(hex: "#F1F5F9")
    static let slate200 = Color(hex: "#E2E8F0")
    static let slate300 = Color(hex: "#CBD5E1")
    static let slate400 = Color(hex: "#94A3B8")
    static let slate500 = Color(hex: "#64748B")
    static let slate600 = Color(hex: "#475569")
    static let slate700 = Color(hex: "#334155")
    static let slate800 = Color(hex: "#1E293B")
    static let slate900 = Color(hex: "#0F172A")
    static let slate950 = Color(hex: "#020617")
    
    // MARK: Semantic Colors - Status
    static let success = Color(hex: "#10B981")     // Emerald
    static let warning = Color(hex: "#F59E0B")     // Amber
    static let error = Color(hex: "#EF4444")       // Red
    static let info = Color(hex: "#3B82F6")        // Blue
    
    // MARK: Semantic Colors - Actions
    static let destructive = Color(hex: "#DC2626")
    static let destructiveLight = Color(hex: "#FEE2E2")
}

// MARK: - Theme Colors (Adaptive Light/Dark)
extension Color {
    
    // MARK: Primary (Brand)
    static var ltPrimary: Color {
        Color.emerald500
    }
    
    static var ltPrimaryLight: Color {
        Color.emerald400
    }
    
    static var ltPrimaryDark: Color {
        Color.emerald600
    }
    
    static var ltPrimarySubtle: Color {
        Color.emerald50
    }
    
    // MARK: Backgrounds
    static var ltBackground: Color {
        Color(light: .slate50, dark: .slate950)
    }
    
    static var ltBackgroundSecondary: Color {
        Color(light: .slate100, dark: .slate900)
    }
    
    static var ltCard: Color {
        Color(light: .white, dark: .slate800)
    }
    
    static var ltCardHover: Color {
        Color(light: .slate50, dark: .slate700)
    }
    
    // MARK: Text
    static var ltText: Color {
        Color(light: .slate900, dark: .slate50)
    }
    
    static var ltTextSecondary: Color {
        Color(light: .slate600, dark: .slate400)
    }
    
    static var ltTextTertiary: Color {
        Color(light: .slate400, dark: .slate500)
    }
    
    static var ltTextInverse: Color {
        Color(light: .white, dark: .slate900)
    }
    
    // MARK: Borders
    static var ltBorder: Color {
        Color(light: .slate200, dark: .slate700)
    }
    
    static var ltBorderSubtle: Color {
        Color(light: .slate100, dark: .slate800)
    }
    
    static var ltBorderFocus: Color {
        Color.emerald500
    }
    
    // MARK: Dividers
    static var ltDivider: Color {
        Color(light: .slate200, dark: .slate700)
    }
    
    // MARK: Overlays
    static var ltOverlay: Color {
        Color.black.opacity(0.5)
    }
    
    static var ltOverlayLight: Color {
        Color.black.opacity(0.3)
    }
}

// MARK: - Gradients
extension LinearGradient {
    
    static var ltPrimaryGradient: LinearGradient {
        LinearGradient(
            colors: [.emerald400, .emerald600],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    static var ltDarkGradient: LinearGradient {
        LinearGradient(
            colors: [.slate800, .slate950],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    static var ltLoginGradient: LinearGradient {
        LinearGradient(
            colors: [.emerald900, .slate900],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    static var ltCardGradient: LinearGradient {
        LinearGradient(
            colors: [.emerald50.opacity(0.5), .white],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    static var ltGlowGradient: LinearGradient {
        LinearGradient(
            colors: [.emerald400.opacity(0.6), .emerald500.opacity(0.3)],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

// MARK: - Color Utilities
extension Color {
    
    /// Creates a color that adapts to light/dark mode
    init(light: Color, dark: Color) {
        self.init(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(dark)
            default:
                return UIColor(light)
            }
        })
    }
    
    /// Initialize color from hex string
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Preview
#Preview("Emerald Palette") {
    ScrollView {
        VStack(spacing: 0) {
            Group {
                colorRow("Emerald 50", .emerald50)
                colorRow("Emerald 100", .emerald100)
                colorRow("Emerald 200", .emerald200)
                colorRow("Emerald 300", .emerald300)
                colorRow("Emerald 400", .emerald400)
                colorRow("Emerald 500", .emerald500)
                colorRow("Emerald 600", .emerald600)
                colorRow("Emerald 700", .emerald700)
                colorRow("Emerald 800", .emerald800)
                colorRow("Emerald 900", .emerald900)
            }
            
            Divider().padding(.vertical)
            
            Group {
                colorRow("Slate 50", .slate50)
                colorRow("Slate 100", .slate100)
                colorRow("Slate 200", .slate200)
                colorRow("Slate 400", .slate400)
                colorRow("Slate 600", .slate600)
                colorRow("Slate 800", .slate800)
                colorRow("Slate 900", .slate900)
            }
        }
        .padding()
    }
}

private func colorRow(_ name: String, _ color: Color) -> some View {
    HStack {
        Text(name)
            .foregroundColor(.slate900)
        Spacer()
        RoundedRectangle(cornerRadius: 8)
            .fill(color)
            .frame(width: 100, height: 40)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.slate200, lineWidth: 1)
            )
    }
    .padding(.horizontal)
    .padding(.vertical, 4)
}
