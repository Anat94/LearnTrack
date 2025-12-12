//
//  LTBadge.swift
//  LearnTrack
//
//  Composant badge/tag custom
//

import SwiftUI

// MARK: - Badge Sizes
enum LTBadgeSize {
    case small
    case medium
    case large
    
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
        .clipShape(
            RoundedRectangle(cornerRadius: isPill ? LTRadius.full : size.cornerRadius)
        )
    }
}

// MARK: - Status Badge (Online/Offline/Busy)
struct LTStatusBadge: View {
    let status: Status
    let showLabel: Bool
    
    enum Status {
        case online
        case offline
        case busy
        case away
        
        var color: Color {
            switch self {
            case .online: return .success
            case .offline: return .slate400
            case .busy: return .error
            case .away: return .warning
            }
        }
        
        var label: String {
            switch self {
            case .online: return "En ligne"
            case .offline: return "Hors ligne"
            case .busy: return "Occupé"
            case .away: return "Absent"
            }
        }
    }
    
    init(_ status: Status, showLabel: Bool = false) {
        self.status = status
        self.showLabel = showLabel
    }
    
    var body: some View {
        HStack(spacing: LTSpacing.xs) {
            Circle()
                .fill(status.color)
                .frame(width: 8, height: 8)
            
            if showLabel {
                Text(status.label)
                    .font(.ltSmallMedium)
                    .foregroundColor(.ltTextSecondary)
            }
        }
    }
}

// MARK: - Count Badge (Notifications)
struct LTCountBadge: View {
    let count: Int
    let color: Color
    let maxCount: Int
    
    init(_ count: Int, color: Color = .error, maxCount: Int = 99) {
        self.count = count
        self.color = color
        self.maxCount = maxCount
    }
    
    var displayText: String {
        if count > maxCount {
            return "\(maxCount)+"
        }
        return "\(count)"
    }
    
    var body: some View {
        if count > 0 {
            Text(displayText)
                .font(.ltSmallMedium)
                .foregroundColor(.white)
                .padding(.horizontal, count > 9 ? LTSpacing.sm : LTSpacing.xs)
                .padding(.vertical, LTSpacing.xxs)
                .frame(minWidth: 20, minHeight: 20)
                .background(color)
                .clipShape(Capsule())
        }
    }
}

// MARK: - Modalité Badge (Présentiel/Distanciel)
struct LTModaliteBadge: View {
    let isPreentiel: Bool
    
    var body: some View {
        LTBadge(
            text: isPreentiel ? "Présentiel" : "Distanciel",
            icon: isPreentiel ? "person.2.fill" : "video.fill",
            color: isPreentiel ? .emerald500 : .info,
            size: .medium
        )
    }
}

// MARK: - Type Badge (Interne/Externe)
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

// MARK: - Preview
#Preview("Badges") {
    ScrollView {
        VStack(spacing: 24) {
            Text("Standard Badges")
                .font(.ltH3)
            
            HStack(spacing: 12) {
                LTBadge(text: "Default")
                LTBadge(text: "Info", color: .info)
                LTBadge(text: "Warning", color: .warning)
                LTBadge(text: "Error", color: .error)
            }
            
            Divider()
            
            Text("With Icons")
                .font(.ltH3)
            
            HStack(spacing: 12) {
                LTBadge(text: "New", icon: "sparkles")
                LTBadge(text: "Verified", icon: "checkmark.seal.fill", color: .info)
                LTBadge(text: "Premium", icon: "star.fill", color: .warning)
            }
            
            Divider()
            
            Text("Sizes")
                .font(.ltH3)
            
            HStack(spacing: 12) {
                LTBadge(text: "Small", size: .small)
                LTBadge(text: "Medium", size: .medium)
                LTBadge(text: "Large", size: .large)
            }
            
            Divider()
            
            Text("Pill Style")
                .font(.ltH3)
            
            HStack(spacing: 12) {
                LTBadge(text: "Pill Badge", isPill: true)
                LTBadge(text: "Tech", icon: "laptopcomputer", color: .info, isPill: true)
            }
            
            Divider()
            
            Text("Status Badges")
                .font(.ltH3)
            
            HStack(spacing: 20) {
                LTStatusBadge(.online, showLabel: true)
                LTStatusBadge(.offline, showLabel: true)
                LTStatusBadge(.busy, showLabel: true)
                LTStatusBadge(.away, showLabel: true)
            }
            
            Divider()
            
            Text("Count Badges")
                .font(.ltH3)
            
            HStack(spacing: 20) {
                LTCountBadge(3)
                LTCountBadge(42)
                LTCountBadge(150)
                LTCountBadge(5, color: .info)
            }
            
            Divider()
            
            Text("Specialized Badges")
                .font(.ltH3)
            
            HStack(spacing: 12) {
                LTModaliteBadge(isPreentiel: true)
                LTModaliteBadge(isPreentiel: false)
            }
            
            HStack(spacing: 12) {
                LTTypeBadge(isExterne: false)
                LTTypeBadge(isExterne: true)
            }
        }
        .padding()
    }
    .background(Color.ltBackground)
}
