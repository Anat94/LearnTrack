import SwiftUI

struct DashboardView: View {
    @StateObject private var sessionVM = SessionViewModel()
    @StateObject private var clientVM = ClientViewModel()
    @StateObject private var formateurVM = FormateurViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    LTHeroHeader(title: "Bienvenue", subtitle: "Votre tableau de bord", systemImage: "sparkles")

                    // KPIs
                    HStack(spacing: 12) {
                        LT.Tile(title: "Sessions", value: "\(sessionVM.sessions.count)", systemImage: "calendar", color: LT.ColorToken.secondary)
                        LT.Tile(title: "Formateurs", value: "\(formateurVM.formateurs.count)", systemImage: "person.2.fill", color: LT.ColorToken.primary)
                    }
                    .padding(.horizontal)

                    HStack(spacing: 12) {
                        LT.Tile(title: "Clients", value: "\(clientVM.clients.count)", systemImage: "building.2.fill", color: LT.ColorToken.accent)
                        LT.Tile(title: "À venir", value: upcomingCountLabel, systemImage: "clock.fill", color: LT.ColorToken.secondary)
                    }
                    .padding(.horizontal)

                    // Next sessions preview
                    if !sessionVM.sessions.isEmpty {
                        LT.SectionCard {
                            VStack(alignment: .leading, spacing: 10) {
                                Label("Prochaines sessions", systemImage: "chevron.right.circle").font(.headline)
                                ForEach(nextSessions.prefix(3)) { s in
                                    HStack {
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(s.module).font(.subheadline).foregroundColor(LT.ColorToken.textPrimary)
                                            Text("\(s.displayDate) • \(s.displayHoraires)").font(.caption).foregroundColor(LT.ColorToken.textSecondary)
                                        }
                                        Spacer()
                                        LT.Badge(text: s.modalite.label, color: s.modalite == .presentiel ? LT.ColorToken.secondary : LT.ColorToken.primary)
                                    }
                                    if s.id != nextSessions.prefix(3).last?.id { Divider() }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    Spacer(minLength: 20)
                }
                .ltScreen()
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
        .task {
            await sessionVM.fetchSessions()
            await clientVM.fetchClients()
            await formateurVM.fetchFormateurs()
        }
    }

    private var nextSessions: [Session] {
        sessionVM.sessions.sorted { $0.date < $1.date }
    }
    private var upcomingCountLabel: String { "\(nextSessions.filter { $0.date >= Date() }.count)" }
}

