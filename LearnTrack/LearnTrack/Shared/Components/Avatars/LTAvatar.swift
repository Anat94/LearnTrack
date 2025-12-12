//
//  LTAvatar.swift
//  LearnTrack
//
//  Composant avatar custom avec bordure gradient
//

import SwiftUI

// MARK: - Avatar Sizes
enum LTAvatarSize {
    case small
    case medium
    case large
    case xl
    
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
        case .small: return .ltCaptionBold
        case .medium: return .ltBodySemibold
        case .large: return .ltH4
        case .xl: return .ltH2
        }
    }
    
    var borderWidth: CGFloat {
        switch self {
        case .small: return 2
        case .medium: return 2.5
        case .large: return 3
        case .xl: return 4
        }
    }
    
    var statusSize: CGFloat {
        switch self {
        case .small: return 10
        case .medium: return 12
        case .large: return 14
        case .xl: return 18
        }
    }
}

// MARK: - LTAvatar View
struct LTAvatar: View {
    let initials: String
    let imageURL: URL?
    let size: LTAvatarSize
    let color: Color
    let showBorder: Bool
    let showGradientBorder: Bool
    let status: LTStatusBadge.Status?
    
    init(
        initials: String,
        imageURL: URL? = nil,
        size: LTAvatarSize = .medium,
        color: Color = .emerald500,
        showBorder: Bool = false,
        showGradientBorder: Bool = false,
        status: LTStatusBadge.Status? = nil
    ) {
        self.initials = initials
        self.imageURL = imageURL
        self.size = size
        self.color = color
        self.showBorder = showBorder
        self.showGradientBorder = showGradientBorder
        self.status = status
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            avatarContent
                .frame(width: size.dimension, height: size.dimension)
                .clipShape(Circle())
                .overlay(borderOverlay)
                .if(showGradientBorder) { view in
                    view.overlay(gradientBorderOverlay)
                }
            
            // Status indicator
            if let status = status {
                Circle()
                    .fill(status.color)
                    .frame(width: size.statusSize, height: size.statusSize)
                    .overlay(
                        Circle()
                            .stroke(Color.ltCard, lineWidth: 2)
                    )
                    .offset(x: 2, y: 2)
            }
        }
    }
    
    @ViewBuilder
    private var avatarContent: some View {
        if let imageURL = imageURL {
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    initialsView
                case .empty:
                    initialsView
                        .ltShimmer()
                @unknown default:
                    initialsView
                }
            }
        } else {
            initialsView
        }
    }
    
    private var initialsView: some View {
        Circle()
            .fill(
                LinearGradient(
                    colors: [color.opacity(0.7), color],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                Text(initials.prefix(2).uppercased())
                    .font(size.font)
                    .foregroundColor(.white)
            )
    }
    
    @ViewBuilder
    private var borderOverlay: some View {
        if showBorder {
            Circle()
                .stroke(Color.ltCard, lineWidth: size.borderWidth)
        }
    }
    
    private var gradientBorderOverlay: some View {
        Circle()
            .stroke(
                LinearGradient(
                    colors: [.emerald400, .emerald600],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: size.borderWidth
            )
    }
}

// MARK: - Avatar Group (Stack)
struct LTAvatarGroup: View {
    let avatars: [(initials: String, color: Color)]
    let size: LTAvatarSize
    let maxVisible: Int
    let overlapOffset: CGFloat
    
    init(
        avatars: [(initials: String, color: Color)],
        size: LTAvatarSize = .small,
        maxVisible: Int = 4,
        overlapOffset: CGFloat? = nil
    ) {
        self.avatars = avatars
        self.size = size
        self.maxVisible = maxVisible
        self.overlapOffset = overlapOffset ?? (size.dimension * 0.6)
    }
    
    var visibleAvatars: [(initials: String, color: Color)] {
        Array(avatars.prefix(maxVisible))
    }
    
    var remainingCount: Int {
        max(0, avatars.count - maxVisible)
    }
    
    var body: some View {
        HStack(spacing: -overlapOffset + size.dimension) {
            ForEach(Array(visibleAvatars.enumerated()), id: \.offset) { index, avatar in
                LTAvatar(
                    initials: avatar.initials,
                    size: size,
                    color: avatar.color,
                    showBorder: true
                )
                .zIndex(Double(visibleAvatars.count - index))
            }
            
            if remainingCount > 0 {
                Circle()
                    .fill(Color.slate200)
                    .frame(width: size.dimension, height: size.dimension)
                    .overlay(
                        Text("+\(remainingCount)")
                            .font(size.font)
                            .foregroundColor(.ltTextSecondary)
                    )
                    .overlay(
                        Circle()
                            .stroke(Color.ltCard, lineWidth: size.borderWidth)
                    )
            }
        }
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
        initials: String? = nil,
        size: LTAvatarSize = .medium,
        color: Color = .emerald500
    ) {
        self.name = name
        self.subtitle = subtitle
        self.initials = initials ?? String(name.split(separator: " ").compactMap { $0.first }.prefix(2))
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

// MARK: - Preview
#Preview("Avatars") {
    ScrollView {
        VStack(spacing: 32) {
            Text("Avatar Sizes")
                .font(.ltH3)
            
            HStack(spacing: 20) {
                LTAvatar(initials: "JD", size: .small)
                LTAvatar(initials: "JD", size: .medium)
                LTAvatar(initials: "JD", size: .large)
                LTAvatar(initials: "JD", size: .xl)
            }
            
            Divider()
            
            Text("Colors")
                .font(.ltH3)
            
            HStack(spacing: 16) {
                LTAvatar(initials: "AB", color: .emerald500)
                LTAvatar(initials: "CD", color: .info)
                LTAvatar(initials: "EF", color: .warning)
                LTAvatar(initials: "GH", color: .error)
            }
            
            Divider()
            
            Text("With Status")
                .font(.ltH3)
            
            HStack(spacing: 16) {
                LTAvatar(initials: "ON", size: .large, status: .online)
                LTAvatar(initials: "OF", size: .large, status: .offline)
                LTAvatar(initials: "BS", size: .large, status: .busy)
                LTAvatar(initials: "AW", size: .large, status: .away)
            }
            
            Divider()
            
            Text("Gradient Border")
                .font(.ltH3)
            
            HStack(spacing: 16) {
                LTAvatar(initials: "VIP", size: .large, showGradientBorder: true)
                LTAvatar(initials: "PRO", size: .xl, showGradientBorder: true)
            }
            
            Divider()
            
            Text("Avatar Group")
                .font(.ltH3)
            
            LTAvatarGroup(avatars: [
                ("JD", .emerald500),
                ("MM", .info),
                ("AB", .warning),
                ("CD", .error),
                ("EF", .slate500),
                ("GH", .emerald700)
            ])
            
            Divider()
            
            Text("Avatar with Name")
                .font(.ltH3)
            
            VStack(spacing: 16) {
                LTAvatarWithName(
                    name: "Jean Dupont",
                    subtitle: "Formateur Swift",
                    size: .medium
                )
                
                LTAvatarWithName(
                    name: "Marie Martin",
                    subtitle: "React Native Expert",
                    size: .large,
                    color: .info
                )
            }
        }
        .padding()
    }
    .background(Color.ltBackground)
}
