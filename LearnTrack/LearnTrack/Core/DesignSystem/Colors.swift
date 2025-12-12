//
//  Colors.swift
//  LearnTrack
//
//  Design System - Palette de couleurs Emerald Premium
//

import SwiftUI

// MARK: - Emerald Palette
extension Color {
    // Primary Emerald
    static let emerald50 = Color(hex: "#ECFDF5")
    static let emerald100 = Color(hex: "#D1FAE5")
    static let emerald200 = Color(hex: "#A7F3D0")
    static let emerald300 = Color(hex: "#6EE7B7")
    static let emerald400 = Color(hex: "#34D399")
    static let emerald500 = Color(hex: "#10B981")  // Main accent
    static let emerald600 = Color(hex: "#059669")
    static let emerald700 = Color(hex: "#047857")
    static let emerald800 = Color(hex: "#065F46")
    static let emerald900 = Color(hex: "#064E3B")
    static let emerald950 = Color(hex: "#022C22")
    
    // Slate (Neutrals)
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
    
    // Semantic Colors
    static let success = Color(hex: "#10B981")
    static let warning = Color(hex: "#F59E0B")
    static let error = Color(hex: "#EF4444")
    static let info = Color(hex: "#3B82F6")
    static let destructive = Color(hex: "#DC2626")
}

// MARK: - Adaptive Theme Colors
extension Color {
    // Background
    static var ltBackground: Color {
        Color(UIColor { tc in
            tc.userInterfaceStyle == .dark ? UIColor(Color.slate950) : UIColor(Color.slate50)
        })
    }
    
    static var ltBackgroundSecondary: Color {
        Color(UIColor { tc in
            tc.userInterfaceStyle == .dark ? UIColor(Color.slate900) : UIColor(Color.slate100)
        })
    }
    
    // Card / Surface
    static var ltCard: Color {
        Color(UIColor { tc in
            tc.userInterfaceStyle == .dark ? UIColor(Color.slate800.opacity(0.8)) : UIColor(.white)
        })
    }
    
    static var ltCardHover: Color {
        Color(UIColor { tc in
            tc.userInterfaceStyle == .dark ? UIColor(Color.slate700) : UIColor(Color.slate50)
        })
    }
    
    // Text
    static var ltText: Color {
        Color(UIColor { tc in
            tc.userInterfaceStyle == .dark ? UIColor(Color.slate50) : UIColor(Color.slate900)
        })
    }
    
    static var ltTextSecondary: Color {
        Color(UIColor { tc in
            tc.userInterfaceStyle == .dark ? UIColor(Color.slate400) : UIColor(Color.slate600)
        })
    }
    
    static var ltTextTertiary: Color {
        Color(UIColor { tc in
            tc.userInterfaceStyle == .dark ? UIColor(Color.slate500) : UIColor(Color.slate400)
        })
    }
    
    // Borders
    static var ltBorder: Color {
        Color(UIColor { tc in
            tc.userInterfaceStyle == .dark ? UIColor(Color.slate700) : UIColor(Color.slate200)
        })
    }
    
    static var ltBorderSubtle: Color {
        Color(UIColor { tc in
            tc.userInterfaceStyle == .dark ? UIColor(Color.slate800) : UIColor(Color.slate100)
        })
    }
    
    // Primary
    static var ltPrimary: Color { .emerald500 }
    static var ltPrimaryHover: Color { .emerald600 }
}

// MARK: - Gradients
extension LinearGradient {
    static let emeraldGradient = LinearGradient(
        colors: [.emerald400, .emerald600],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let emeraldVertical = LinearGradient(
        colors: [.emerald500, .emerald700],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let darkBackground = LinearGradient(
        colors: [Color.slate900, Color.slate950],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let glassOverlay = LinearGradient(
        colors: [.white.opacity(0.15), .white.opacity(0.05)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// MARK: - Color from Hex
extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let r = Double((rgb & 0xFF0000) >> 16) / 255.0
        let g = Double((rgb & 0x00FF00) >> 8) / 255.0
        let b = Double(rgb & 0x0000FF) / 255.0
        
        self.init(red: r, green: g, blue: b)
    }
}

// MARK: - UIColor extension
extension UIColor {
    convenience init(_ color: Color) {
        let components = color.cgColor?.components ?? [0, 0, 0, 1]
        self.init(
            red: components.count > 0 ? components[0] : 0,
            green: components.count > 1 ? components[1] : 0,
            blue: components.count > 2 ? components[2] : 0,
            alpha: components.count > 3 ? components[3] : 1
        )
    }
}
