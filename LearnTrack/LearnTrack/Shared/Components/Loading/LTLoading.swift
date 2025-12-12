//
//  LTLoading.swift
//  LearnTrack
//
//  Composants de chargement - Design Emerald
//

import SwiftUI

// MARK: - Shimmer View
struct LTShimmerView: View {
    var width: CGFloat? = nil
    var height: CGFloat = 20
    var cornerRadius: CGFloat = LTRadius.md
    
    @State private var phase: CGFloat = -1
    
    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color.ltBackgroundSecondary)
            .frame(width: width, height: height)
            .overlay(
                GeometryReader { geometry in
                    LinearGradient(
                        colors: [
                            .clear,
                            .white.opacity(0.3),
                            .clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geometry.size.width * 0.5)
                    .offset(x: phase * geometry.size.width)
                }
                .mask(RoundedRectangle(cornerRadius: cornerRadius))
            )
            .onAppear {
                withAnimation(.linear(duration: 1.2).repeatForever(autoreverses: false)) {
                    phase = 1.5
                }
            }
    }
}

// MARK: - Skeleton Card
struct LTSkeletonCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: LTSpacing.md) {
            LTShimmerView(width: 180, height: 20)
            LTShimmerView(height: 16)
            LTShimmerView(width: 120, height: 16)
        }
        .padding(LTSpacing.lg)
        .background(Color.ltCard)
        .clipShape(RoundedRectangle(cornerRadius: LTRadius.xl))
    }
}

// MARK: - Skeleton Person Row
struct LTSkeletonPersonRow: View {
    var body: some View {
        HStack(spacing: LTSpacing.md) {
            LTShimmerView(width: LTHeight.avatarMedium, height: LTHeight.avatarMedium, cornerRadius: LTRadius.full)
            
            VStack(alignment: .leading, spacing: LTSpacing.sm) {
                LTShimmerView(width: 140, height: 16)
                LTShimmerView(width: 100, height: 14)
            }
            
            Spacer()
        }
        .padding(LTSpacing.md)
        .background(Color.ltCard)
        .clipShape(RoundedRectangle(cornerRadius: LTRadius.xl))
    }
}

// MARK: - Spinner
struct LTSpinner: View {
    var size: CGFloat = 40
    var lineWidth: CGFloat = 3
    var color: Color = .emerald500
    
    @State private var rotation: Double = 0
    
    var body: some View {
        Circle()
            .trim(from: 0, to: 0.7)
            .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
            .frame(width: size, height: size)
            .rotationEffect(.degrees(rotation))
            .onAppear {
                withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                    rotation = 360
                }
            }
    }
}

// MARK: - Loading Overlay
struct LTLoadingOverlay: View {
    var message: String? = nil
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: LTSpacing.lg) {
                LTSpinner(size: 50, lineWidth: 4)
                
                if let message = message {
                    Text(message)
                        .font(.ltBodyMedium)
                        .foregroundColor(.white)
                }
            }
            .padding(LTSpacing.xxl)
            .background(
                RoundedRectangle(cornerRadius: LTRadius.xxl)
                    .fill(.ultraThinMaterial)
            )
        }
    }
}

// MARK: - Empty State
struct LTEmptyState: View {
    let icon: String
    let title: String
    let message: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: LTSpacing.lg) {
            ZStack {
                Circle()
                    .fill(Color.emerald500.opacity(0.1))
                    .frame(width: 80, height: 80)
                
                Image(systemName: icon)
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundColor(.emerald500)
            }
            
            Text(title)
                .font(.ltH3)
                .foregroundColor(.ltText)
            
            Text(message)
                .font(.ltBody)
                .foregroundColor(.ltTextSecondary)
                .multilineTextAlignment(.center)
            
            if let actionTitle = actionTitle, let action = action {
                LTButton(actionTitle, variant: .primary, icon: "plus", action: action)
                    .padding(.top, LTSpacing.md)
            }
        }
        .padding(LTSpacing.xxl)
    }
}

#Preview {
    VStack(spacing: 24) {
        LTSkeletonCard()
        LTSkeletonPersonRow()
        LTSpinner()
        LTEmptyState(
            icon: "calendar.badge.exclamationmark",
            title: "Aucune session",
            message: "Créez votre première session de formation",
            actionTitle: "Créer",
            action: {}
        )
    }
    .padding()
    .background(Color.ltBackground)
}
