//
//  SessionViewModel.swift
//  LearnTrack
//
//  ViewModel pour la gestion des sessions
//

import Foundation

@MainActor
class SessionViewModel: ObservableObject {
    @Published var sessions: [Session] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText = ""
    @Published var selectedMonth: Int = Calendar.current.component(.month, from: Date())
    
    
    // Charger toutes les sessions
    func fetchSessions() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response: [APISession] = try await APIService.shared.getSessions()
            sessions = response.compactMap { self.mapAPISession($0) }
            // Enrichir avec relations (formateur/client/ecole) si possible
            await enrichRelations()
            isLoading = false
        } catch {
            errorMessage = "Erreur lors du chargement des sessions"
            isLoading = false
            print("Erreur: \(error)")
        }
    }
    
    // Créer une session
    func createSession(_ session: Session) async throws {
        let payload = mapToAPISessionCreate(session)
        let created = try await APIService.shared.createSession(payload)
        let id64 = Int64(created.id)
        let extras = SessionExtras(
            modalite: session.modalite == .presentiel ? "P" : "D",
            lieu: session.lieu,
            tarifSousTraitant: NSDecimalNumber(decimal: session.tarifSousTraitant).doubleValue,
            fraisRembourser: NSDecimalNumber(decimal: session.fraisRembourser).doubleValue,
            refContrat: session.refContrat
        )
        ExtrasStore.shared.setSessionExtras(id: id64, extras)
        await fetchSessions()
    }
    
    // Mettre à jour une session
    func updateSession(_ session: Session) async throws {
        guard let id64 = session.id else { return }
        let id = Int(id64)
        let payload = mapToAPISessionUpdate(session)
        _ = try await APIService.shared.updateSession(id: id, payload)
        let extras = SessionExtras(
            modalite: session.modalite == .presentiel ? "P" : "D",
            lieu: session.lieu,
            tarifSousTraitant: NSDecimalNumber(decimal: session.tarifSousTraitant).doubleValue,
            fraisRembourser: NSDecimalNumber(decimal: session.fraisRembourser).doubleValue,
            refContrat: session.refContrat
        )
        ExtrasStore.shared.setSessionExtras(id: id64, extras)
        await fetchSessions()
    }
    
    // Supprimer une session
    func deleteSession(_ session: Session) async throws {
        guard let id64 = session.id else { return }
        let id = Int(id64)
        try await APIService.shared.deleteSession(id: id)
        await fetchSessions()
    }
    
    // Sessions filtrées
    var filteredSessions: [Session] {
        sessions.filter { session in
            let matchesSearch = searchText.isEmpty || 
                session.module.localizedCaseInsensitiveContains(searchText) ||
                session.formateur?.nomComplet.localizedCaseInsensitiveContains(searchText) ?? false
            
            let sessionMonth = Calendar.current.component(.month, from: session.date)
            let matchesMonth = sessionMonth == selectedMonth
            
            return matchesSearch && matchesMonth
        }
    }

    // MARK: - Mapping helpers
    private func mapAPISession(_ api: APISession) -> Session? {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale(identifier: "fr_FR_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: api.dateDebut) else { return nil }

        func trimTime(_ s: String?) -> String { guard let s = s, s.count >= 5 else { return "" }; return String(s.prefix(5)) }

        let id64 = Int64(api.id)
        let extras = ExtrasStore.shared.getSessionExtras(id: id64)
        let modalite: Session.Modalite = (extras?.modalite == "D") ? .distanciel : .presentiel
        let lieu = extras?.lieu ?? ""
        let st = Decimal(extras?.tarifSousTraitant ?? 0)
        let fr = Decimal(extras?.fraisRembourser ?? 0)
        let ref = extras?.refContrat

        return Session(
            id: id64,
            module: api.titre,
            date: date,
            debut: trimTime(api.heureDebut),
            fin: trimTime(api.heureFin),
            modalite: modalite,
            lieu: lieu,
            tarifClient: Decimal(api.prix ?? 0),
            tarifSousTraitant: st,
            fraisRembourser: fr,
            refContrat: ref,
            ecoleId: api.ecoleId != nil ? Int64(api.ecoleId!) : nil,
            clientId: api.clientId != nil ? Int64(api.clientId!) : nil,
            formateurId: api.formateurId != nil ? Int64(api.formateurId!) : nil,
            ecole: nil,
            client: nil,
            formateur: nil
        )
    }

    // Enrichir les sessions avec les objets liés pour l'affichage
    private func enrichRelations() async {
        let current = self.sessions
        let formateurIds = Set(current.compactMap { $0.formateurId })
        let clientIds = Set(current.compactMap { $0.clientId })
        let ecoleIds = Set(current.compactMap { $0.ecoleId })

        // Fetch details in parallel (best-effort)
        var formateurs: [Int64: Formateur] = [:]
        var clientsMap: [Int64: Client] = [:]
        var ecoles: [Int64: Ecole] = [:]

        await withTaskGroup(of: Void.self) { group in
            for fid in formateurIds {
                group.addTask {
                    if let api = try? await APIService.shared.getFormateur(id: Int(fid)) {
                        await MainActor.run {
                            let f = self.mapAPIFormateur(api)
                            formateurs[fid] = f
                        }
                    }
                }
            }
            for cid in clientIds {
                group.addTask {
                    if let api = try? await APIService.shared.getClient(id: Int(cid)) {
                        await MainActor.run {
                            let c = self.mapAPIClient(api)
                            clientsMap[cid] = c
                        }
                    }
                }
            }
            for eid in ecoleIds {
                group.addTask {
                    if let api = try? await APIService.shared.getEcole(id: Int(eid)) {
                        await MainActor.run {
                            let e = self.mapAPIEcole(api)
                            ecoles[eid] = e
                        }
                    }
                }
            }
        }

        await MainActor.run {
            self.sessions = current.map { s in
                var s2 = s
                if let id = s.formateurId { s2.formateur = formateurs[id] }
                if let id = s.clientId { s2.client = clientsMap[id] }
                if let id = s.ecoleId { s2.ecole = ecoles[id] }
                return s2
            }
        }
    }

    // Mapping for linked objects
    private func mapAPIFormateur(_ api: APIFormateur) -> Formateur {
        let specialite = (api.specialites?.first).map { String($0) } ?? ""
        let taux = Decimal(api.tarifJournalier ?? 0)
        let id64 = Int64(api.id)
        let extras = ExtrasStore.shared.getFormateurExtras(id: id64)
        return Formateur(
            id: id64,
            prenom: api.prenom,
            nom: api.nom,
            email: api.email,
            telephone: api.telephone ?? "",
            specialite: specialite,
            tauxHoraire: taux,
            exterieur: extras?.exterieur ?? false,
            societe: extras?.societe,
            siret: extras?.siret,
            nda: extras?.nda,
            rue: api.adresse,
            codePostal: api.codePostal,
            ville: api.ville
        )
    }

    private func mapAPIClient(_ api: APIClient) -> Client {
        let id64 = Int64(api.id)
        let extras = ExtrasStore.shared.getClientExtras(id: id64)
        return Client(
            id: id64,
            raisonSociale: api.nom,
            rue: api.adresse,
            codePostal: api.codePostal,
            ville: api.ville,
            nomContact: api.contactNom ?? "",
            email: api.email ?? (api.contactEmail ?? ""),
            telephone: api.telephone ?? (api.contactTelephone ?? ""),
            siret: api.siret,
            numeroTva: extras?.numeroTva
        )
    }

    private func mapAPIEcole(_ api: APIEcole) -> Ecole {
        Ecole(
            id: Int64(api.id),
            nom: api.nom,
            rue: api.adresse,
            codePostal: api.codePostal,
            ville: api.ville,
            nomContact: api.responsableNom ?? "",
            email: api.email ?? "",
            telephone: api.telephone ?? ""
        )
    }

    private func mapToAPISessionCreate(_ s: Session) -> APISessionCreate {
        // date -> YYYY-MM-DD
        let df = DateFormatter()
        df.calendar = Calendar(identifier: .gregorian)
        df.locale = Locale(identifier: "fr_FR_POSIX")
        df.dateFormat = "yyyy-MM-dd"
        let dateStr = df.string(from: s.date)

        func toServerTime(_ t: String) -> String? { t.isEmpty ? nil : (t.count == 5 ? t + ":00" : t) }

        return APISessionCreate(
            titre: s.module,
            description: nil,
            dateDebut: dateStr,
            dateFin: dateStr,
            heureDebut: toServerTime(s.debut),
            heureFin: toServerTime(s.fin),
            clientId: s.clientId != nil ? Int(s.clientId!) : nil,
            ecoleId: s.ecoleId != nil ? Int(s.ecoleId!) : nil,
            formateurId: s.formateurId != nil ? Int(s.formateurId!) : nil,
            nbParticipants: nil,
            statut: nil,
            prix: NSDecimalNumber(decimal: s.tarifClient).doubleValue,
            notes: nil
        )
    }

    private func mapToAPISessionUpdate(_ s: Session) -> APISessionUpdate {
        let df = DateFormatter()
        df.calendar = Calendar(identifier: .gregorian)
        df.locale = Locale(identifier: "fr_FR_POSIX")
        df.dateFormat = "yyyy-MM-dd"
        let dateStr = df.string(from: s.date)

        func toServerTime(_ t: String) -> String? { t.isEmpty ? nil : (t.count == 5 ? t + ":00" : t) }

        return APISessionUpdate(
            titre: s.module,
            description: nil,
            dateDebut: dateStr,
            dateFin: dateStr,
            heureDebut: toServerTime(s.debut),
            heureFin: toServerTime(s.fin),
            clientId: s.clientId != nil ? Int(s.clientId!) : nil,
            ecoleId: s.ecoleId != nil ? Int(s.ecoleId!) : nil,
            formateurId: s.formateurId != nil ? Int(s.formateurId!) : nil,
            nbParticipants: nil,
            statut: nil,
            prix: NSDecimalNumber(decimal: s.tarifClient).doubleValue,
            notes: nil
        )
    }
}
