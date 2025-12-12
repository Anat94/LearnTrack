//
//  LTLoading.swift
//  LearnTrack
//
//  Composants de chargement custom (shimmer, spinner)
//

import SwiftUI

// MARK: - Shimmer Skeleton
struct LTShimmerView: View {
    let width: CGFloat?
    let height: CGFloat
    let cornerRadius: CGFloat
    
    @State private var phase: CGFloat = 0
    
    init(
        width: CGFloat? = nil,
        height: CGFloat = 20,
        cornerRadius: CGFloat = LTRadius.md
    ) {
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color.slate200)
            .frame(width: width, height: height)
            .overlay(
                GeometryReader { geometry in
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0),
                            Color.white.opacity(0.6),
                            Color.white.opacity(0)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geometry.size.width * 0.6)
                    .offset(x: -geometry.size.width * 0.3 + (geometry.size.width * 1.3 * phase))
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .onAppear {
                withAnimation(.linear(duration: 1.2).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
    }
}

// MARK: - Skeleton Card
struct LTSkeletonCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: LTSpacing.md) {
            // Title
            HStack {
                LTShimmerView(width: 200, height: 24)
                Spacer()
                LTShimmerView(width: 80, height: 28, cornerRadius: LTRadius.sm)
            }
            
            // Subtitle lines
            HStack(spacing: LTSpacing.lg) {
                LTShimmerView(width: 100, height: 16)
                LTShimmerView(width: 80, height: 16)
            }
            
            // Person
            LTShimmerView(width: 120, height: 16)
        }
        .padding(LTSpacing.lg)
        .background(Color.ltCard)
        .clipShape(RoundedRectangle(cornerRadius: LTRadius.xl))
        .ltCardShadow()
    }
}

// MARK: - Skeleton Person Row
struct LTSkeletonPersonRow: View {
    var body: some View {
        HStack(spacing: LTSpacing.md) {
            // Avatar
            LTShimmerView(width: 48, height: 48, cornerRadius: 24)
            
            // Info
            VStack(alignment: .leading, spacing: LTSpacing.xs) {
                LTShimmerView(width: 140, height: 18)
                LTShimmerView(width: 100, height: 14)
                LTShimmerView(width: 60, height: 20, cornerRadius: LTRadius.xs)
            }
            
            Spacer()
            
            // Chevron
            LTShimmerView(width: 12, height: 20)
        }
        .padding(LTSpacing.md)
        .background(Color.ltCard)
        .clipShape(RoundedRectangle(cornerRadius: LTRadius.xl))
        .ltCardShadow()
    }
}

// MARK: - Custom Spinner
struct LTSpinner: View {
    let size: CGFloat
    let lineWidth: CGFloat
    let color: Color
    
    @State private var isAnimating = false
    
    init(
        size: CGFloat = 32,
        lineWidth: CGFloat = 3,
        color: Color = .emerald500
    ) {
        self.size = size
        self.lineWidth = lineWidth
        self.color = color
    }
    
    var body: some View {
        Circle()
            .trim(from: 0, to: 0.7)
            .stroke(
                LinearGradient(
                    colors: [color, color.opacity(0.3)],
                    startPoint: .leading,
                    endPoint: .trailing
                ),
                style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
            )
            .frame(width: size, height: size)
            .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
            .onAppear {
                withAnimation(.linear(duration: 0.8).repeatForever(autoreverses: false)) {
                    isAnimating = true
                }
            }
    }
}

// MARK: - Loading Overlay
struct LTLoadingOverlay: View {
    let isLoading: Bool
    let message: String?
    
    init(isLoading: Bool, message: String? = nil) {
        self.isLoading = isLoading
        self.message = message
    }
    
    var body: some View {
        if isLoading {
            ZStack {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                
                VStack(spacing: LTSpacing.lg) {
                    LTSpinner(size: 48, lineWidth: 4)
                    
                    if let message = message {
                        Text(message)
                            .font(.ltBodyMedium)
                            .foregroundColor(.ltText)
                    }
                }
                .padding(LTSpacing.xxl)
                .background(
                    RoundedRectangle(cornerRadius: LTRadius.xl)
                        .fill(.ultraThinMaterial)
                )
                .ltElevatedShadow()
            }
            .transition(.opacity)
        }
    }
}

// MARK: - Loading State View
struct LTLoadingState: View {
    let message: String
    
    init(_ message: String = "Chargement...") {
        self.message = message
    }
    
    var body: some View {
        VStack(spacing: LTSpacing.lg) {
            LTSpinner(size: 40, lineWidth: 3)
            
            Text(message)
                .font(.ltBody)
                .foregroundColor(.ltTextSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Empty State View (Refait)
struct LTEmptyState: View {
    let icon: String
    let title: String
    let message: String
    let actionTitle: String?
    let action: (() -> Void)?
    
    init(
        icon: String,
        title: String,
        message: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: LTSpacing.xl) {
            // Icon with gradient background
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.emerald100, .emerald50],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                
                Image(systemName: icon)
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(.emerald500)
            }
            
            VStack(spacing: LTSpacing.sm) {
                Text(title)
                    .font(.ltH3)
                    .foregroundColor(.ltText)
                
                Text(message)
                    .font(.ltBody)
                    .foregroundColor(.ltTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, LTSpacing.xl)
            }
            
            if let actionTitle = actionTitle, let action = action {
                LTButton(actionTitle, variant: .primary, icon: "plus") {
                    action()
                }
                .padding(.top, LTSpacing.md)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

// MARK: - Preview
#Preview("Loading States") {
    ScrollView {
        VStack(spacing: 32) {
            Text("Shimmer Skeletons")
                .font(.ltH2)
            
            VStack(spacing: LTSpacing.md) {
                LTSkeletonCard()
                LTSkeletonCard()
            }
            .padding(.horizontal)
            
            Divider()
            
            Text("Person Skeleton")
                .font(.ltH2)
            
            VStack(spacing: LTSpacing.md) {
                LTSkeletonPersonRow()
                LTSkeletonPersonRow()
                LTSkeletonPersonRow()
            }
            .padding(.horizontal)
            
            Divider()
            
            Text("Spinners")
                .font(.ltH2)
            
            HStack(spacing: 24) {
                LTSpinner(size: 24)
                LTSpinner(size: 32)
                LTSpinner(size: 48, lineWidth: 4)
                LTSpinner(size: 32, color: .info)
            }
            
            Divider()
            
            Text("Loading State")
                .font(.ltH2)
            
            LTLoadingState("Chargement des sessions...")
                .frame(height: 150)
            
            Divider()
            
            Text("Empty State")
                .font(.ltH2)
            
            LTEmptyState(
                icon: "calendar.badge.exclamationmark",
                title: "Aucune session",
                message: "Vous n'avez pas encore de session pour ce mois.",
                actionTitle: "Créer une session"
            ) { }
            .frame(height: 350)
        }
        .padding()
    }
    .background(Color.ltBackground)
}
