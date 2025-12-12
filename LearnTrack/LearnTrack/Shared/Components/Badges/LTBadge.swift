//
//  LTBadge.swift
//  LearnTrack
//
//  Composant badge - Design Emerald
//

import SwiftUI

// MARK: - Badge Sizes
enum LTBadgeSize {
    case small, medium, large
    
    var font: Font {
        switch self {
        case .small: return .ltSmallMedium
        case .medium: return .ltCaptionMedium
        case .large: return .ltLabel
        }
    }
    
    var iconSize: CGFloat {
        switch self {
        case .small: return 10
        case .medium: return 12
        case .large: return 14
        }
    }
    
    var horizontalPadding: CGFloat {
        switch self {
        case .small: return LTSpacing.sm
        case .medium: return LTSpacing.md
        case .large: return LTSpacing.lg
        }
    }
    
    var verticalPadding: CGFloat {
        switch self {
        case .small: return LTSpacing.xxs
        case .medium: return LTSpacing.xs
        case .large: return LTSpacing.sm
        }
    }
    
    var cornerRadius: CGFloat {
        switch self {
        case .small: return LTRadius.xs
        case .medium: return LTRadius.sm
        case .large: return LTRadius.md
        }
    }
}

// MARK: - LTBadge View
struct LTBadge: View {
    let text: String
    let icon: String?
    let color: Color
    let size: LTBadgeSize
    let isPill: Bool
    
    init(
        text: String,
        icon: String? = nil,
        color: Color = .emerald500,
        size: LTBadgeSize = .medium,
        isPill: Bool = false
    ) {
        self.text = text
        self.icon = icon
        self.color = color
        self.size = size
        self.isPill = isPill
    }
    
    var body: some View {
        HStack(spacing: LTSpacing.xxs) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: size.iconSize, weight: .semibold))
            }
            Text(text)
                .font(size.font)
        }
        .foregroundColor(color)
        .padding(.horizontal, size.horizontalPadding)
        .padding(.vertical, size.verticalPadding)
        .background(color.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: isPill ? LTRadius.full : size.cornerRadius))
    }
}

// MARK: - Modalité Badge
struct LTModaliteBadge: View {
    let isPresentiel: Bool
    
    var body: some View {
        LTBadge(
            text: isPresentiel ? "Présentiel" : "Distanciel",
            icon: isPresentiel ? "person.2.fill" : "video.fill",
            color: isPresentiel ? .emerald500 : .info
        )
    }
}

// MARK: - Type Badge
struct LTTypeBadge: View {
    let isExterne: Bool
    
    var body: some View {
        LTBadge(
            text: isExterne ? "Externe" : "Interne",
            color: isExterne ? .warning : .emerald500,
            size: .small
        )
    }
}

#Preview {
    VStack(spacing: 16) {
        HStack {
            LTBadge(text: "Default")
            LTBadge(text: "Info", color: .info)
            LTBadge(text: "Warning", color: .warning)
        }
        HStack {
            LTBadge(text: "With Icon", icon: "star.fill")
            LTBadge(text: "Pill", isPill: true)
        }
        HStack {
            LTModaliteBadge(isPresentiel: true)
            LTModaliteBadge(isPresentiel: false)
        }
    }
    .padding()
    .background(Color.ltBackground)
}
