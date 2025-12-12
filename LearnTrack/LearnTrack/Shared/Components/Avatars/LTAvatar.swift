//
//  LTAvatar.swift
//  LearnTrack
//
//  Composant avatar - Design Emerald
//

import SwiftUI

// MARK: - Avatar Sizes
enum LTAvatarSize {
    case small, medium, large, xl
    
    var dimension: CGFloat {
        switch self {
        case .small: return LTHeight.avatarSmall
        case .medium: return LTHeight.avatarMedium
        case .large: return LTHeight.avatarLarge
        case .xl: return LTHeight.avatarXL
        }
    }
    
    var font: Font {
        switch self {
        case .small: return .ltCaptionMedium
        case .medium: return .ltBodySemibold
        case .large: return .ltH4
        case .xl: return .ltH2
        }
    }
}

// MARK: - LTAvatar View
struct LTAvatar: View {
    let initials: String
    let size: LTAvatarSize
    let color: Color
    let imageName: String?
    let showGradientBorder: Bool
    
    init(
        initials: String,
        size: LTAvatarSize = .medium,
        color: Color = .emerald500,
        imageName: String? = nil,
        showGradientBorder: Bool = false
    ) {
        self.initials = initials
        self.size = size
        self.color = color
        self.imageName = imageName
        self.showGradientBorder = showGradientBorder
    }
    
    var body: some View {
        ZStack {
            if let imageName = imageName {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size.dimension, height: size.dimension)
                    .clipShape(Circle())
            } else {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: size.dimension, height: size.dimension)
                
                Text(initials)
                    .font(size.font)
                    .foregroundColor(color)
            }
        }
        .overlay(
            showGradientBorder ?
                Circle()
                    .stroke(LinearGradient.emeraldGradient, lineWidth: 3)
                    .padding(-2)
                : nil
        )
    }
}

// MARK: - Avatar with Name
struct LTAvatarWithName: View {
    let name: String
    let subtitle: String?
    let initials: String
    let size: LTAvatarSize
    let color: Color
    
    init(
        name: String,
        subtitle: String? = nil,
        initials: String,
        size: LTAvatarSize = .medium,
        color: Color = .emerald500
    ) {
        self.name = name
        self.subtitle = subtitle
        self.initials = initials
        self.size = size
        self.color = color
    }
    
    var body: some View {
        HStack(spacing: LTSpacing.md) {
            LTAvatar(initials: initials, size: size, color: color)
            
            VStack(alignment: .leading, spacing: LTSpacing.xxs) {
                Text(name)
                    .font(.ltBodySemibold)
                    .foregroundColor(.ltText)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.ltCaption)
                        .foregroundColor(.ltTextSecondary)
                }
            }
        }
    }
}

#Preview {
    VStack(spacing: 24) {
        HStack(spacing: 16) {
            LTAvatar(initials: "JD", size: .small)
            LTAvatar(initials: "JD", size: .medium)
            LTAvatar(initials: "JD", size: .large)
            LTAvatar(initials: "JD", size: .xl, showGradientBorder: true)
        }
        
        LTAvatarWithName(name: "Jean Dupont", subtitle: "Formateur", initials: "JD")
    }
    .padding()
    .background(Color.ltBackground)
}
