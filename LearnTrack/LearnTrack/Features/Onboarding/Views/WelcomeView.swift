import SwiftUI
import UIKit

struct WelcomeView: View {
    @AppStorage("hasOnboarded") private var hasOnboarded = false
    @AppStorage("onboarding_role") private var role: String = ""
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Spacer(minLength: 10)

                // App icon / Branding
                ZStack {
                    Circle().fill(LT.ColorToken.secondary.opacity(0.2)).frame(width: 120, height: 120)
                    Image(systemName: "graduationcap.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(LT.ColorToken.primary)
                }

                Text("Bienvenue")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(LT.ColorToken.textPrimary)

                Text("Pour commencer, choisissez votre profil afin d'accéder à votre espace personnel de formation.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(LT.ColorToken.textSecondary)
                    .font(.subheadline)
                    .padding(.horizontal)

                // Cards
                VStack(spacing: 14) {
                    RoleCard(title: "Animateur", subtitle: "Utilisez LearnTrack en tant que formateur, enseignant ou intervenant.", systemImage: "person.crop.square.fill.and.at.rectangle", accent: LT.ColorToken.primary) {
                        select(role: "animateur")
                    }
                    RoleCard(title: "Stagiaire", subtitle: "Utilisez LearnTrack en tant qu'élève ou apprenant.", systemImage: "qrcode.viewfinder", accent: LT.ColorToken.secondary) {
                        select(role: "stagiaire")
                    }
                }
                .padding(.horizontal)

                Button("Besoin d'aide ?") {
                    if let url = URL(string: "https://github.com") { UIApplication.shared.open(url) }
                }
                .buttonStyle(LT.SecondaryButtonStyle())
                .padding(.horizontal)

                Spacer()

                NavigationLink(destination: LoginView(), isActive: Binding(get: { hasOnboarded }, set: { _ in })) { EmptyView() }
            }
            .ltScreen()
            .navigationBarHidden(true)
        }
    }

    private func select(role: String) {
        self.role = role
        self.hasOnboarded = true
    }
}

private struct RoleCard: View {
    let title: String
    let subtitle: String
    let systemImage: String
    let accent: Color
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(title).font(.headline).foregroundColor(LT.ColorToken.textPrimary)
                    Text(subtitle).font(.subheadline).foregroundColor(LT.ColorToken.textSecondary)
                }
                Spacer()
                Image(systemName: systemImage)
                    .font(.system(size: 28))
                    .foregroundColor(accent)
                    .padding(10)
                    .background(accent.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(16)
            .background(LT.ColorToken.surface)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(LT.ColorToken.border.opacity(0.7), lineWidth: 1)
            )
            .cornerRadius(16)
        }
    }
}
