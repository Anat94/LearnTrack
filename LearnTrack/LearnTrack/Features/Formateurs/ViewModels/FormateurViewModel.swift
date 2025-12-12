//
//  FormateurViewModel.swift
//  LearnTrack
//
//  ViewModel pour la gestion des formateurs
//

import Foundation

@MainActor
class FormateurViewModel: ObservableObject {
    @Published var formateurs: [Formateur] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText = ""
    @Published var filterType: FilterType = .tous
    
    private let service: APIServiceProtocol
    
    init(service: APIServiceProtocol = APIService.shared) {
        self.service = service
    }
    
    enum FilterType: String, CaseIterable {
        case tous = "Tous"
        case internes = "Internes"
        case externes = "Externes"
    }
    
    // Charger tous les formateurs
    func fetchFormateurs() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response: [APIFormateur] = try await self.service.getFormateurs()
            let mapped = response.map { self.mapAPIFormateur($0) }
            formateurs = mapped.sorted { $0.nom.localizedCaseInsensitiveCompare($1.nom) == .orderedAscending }
            isLoading = false
        } catch {
            errorMessage = "Erreur lors du chargement des formateurs"
            isLoading = false
            print("Erreur: \(error)")
        }
    }
    
    // Créer un formateur
    func createFormateur(_ formateur: Formateur) async throws {
        let payload = mapToAPIFormateurCreate(formateur)
        let created = try await self.service.createFormateur(payload)
        let id64 = Int64(created.id)
        let extras = FormateurExtras(
            exterieur: formateur.exterieur,
            societe: formateur.societe,
            siret: formateur.siret,
            nda: formateur.nda
        )
        ExtrasStore.shared.setFormateurExtras(id: id64, extras)
        await fetchFormateurs()
    }
    
    // Mettre à jour un formateur
    func updateFormateur(_ formateur: Formateur) async throws {
        guard let id64 = formateur.id else { return }
        let id = Int(id64)
        let payload = mapToAPIFormateurUpdate(formateur)
        _ = try await self.service.updateFormateur(id: id, payload)
        let extras = FormateurExtras(
            exterieur: formateur.exterieur,
            societe: formateur.societe,
            siret: formateur.siret,
            nda: formateur.nda
        )
        ExtrasStore.shared.setFormateurExtras(id: id64, extras)
        await fetchFormateurs()
    }
    
    // Supprimer un formateur
    func deleteFormateur(_ formateur: Formateur) async throws {
        guard let id64 = formateur.id else { return }
        let id = Int(id64)
        try await self.service.deleteFormateur(id: id)
        await fetchFormateurs()
    }
    
    // Formateurs filtrés
    var filteredFormateurs: [Formateur] {
        formateurs.filter { formateur in
            let matchesSearch = searchText.isEmpty ||
                formateur.nomComplet.localizedCaseInsensitiveContains(searchText) ||
                formateur.specialite.localizedCaseInsensitiveContains(searchText)
            
            let matchesType: Bool
            switch filterType {
            case .tous:
                matchesType = true
            case .internes:
                matchesType = !formateur.exterieur
            case .externes:
                matchesType = formateur.exterieur
            }
            
            return matchesSearch && matchesType
        }
    }
    
    // Charger les sessions d'un formateur
    func fetchSessionsForFormateur(_ formateurId: Int64) async -> [Session] {
        do {
            let apiSessions: [APISession] = try await self.service.getFormateurSessions(formateurId: Int(formateurId))
            return apiSessions.compactMap { self.mapAPISession($0) }
        } catch {
            print("Erreur chargement sessions: \(error)")
            return []
        }
    }

    // MARK: - Mapping helpers
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
            tarifJournalier: taux,
            exterieur: extras?.exterieur ?? false,
            societe: extras?.societe,
            siret: extras?.siret,
            nda: extras?.nda,
            rue: api.adresse,
            codePostal: api.codePostal,
            ville: api.ville
        )
    }

    private func mapToAPIFormateurCreate(_ f: Formateur) -> APIFormateurCreate {
        APIFormateurCreate(
            nom: f.nom,
            prenom: f.prenom,
            email: f.email,
            telephone: f.telephone,
            specialites: f.specialite.isEmpty ? nil : [f.specialite],
            tarifJournalier: NSDecimalNumber(decimal: f.tarifJournalier).doubleValue,
            adresse: f.rue,
            ville: f.ville,
            codePostal: f.codePostal,
            notes: nil
        )
    }

    private func mapToAPIFormateurUpdate(_ f: Formateur) -> APIFormateurUpdate {
        APIFormateurUpdate(
            nom: f.nom,
            prenom: f.prenom,
            email: f.email,
            telephone: f.telephone,
            specialites: f.specialite.isEmpty ? nil : [f.specialite],
            tarifJournalier: NSDecimalNumber(decimal: f.tarifJournalier).doubleValue,
            adresse: f.rue,
            ville: f.ville,
            codePostal: f.codePostal,
            notes: nil,
            actif: nil
        )
    }

    private func mapAPISession(_ api: APISession) -> Session? {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale(identifier: "fr_FR_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: api.dateDebut) else { return nil }

        func trimTime(_ s: String?) -> String { guard let s = s, s.count >= 5 else { return "" }; return String(s.prefix(5)) }

        return Session(
            id: Int64(api.id),
            module: api.titre,
            date: date,
            debut: trimTime(api.heureDebut),
            fin: trimTime(api.heureFin),
            modalite: .presentiel,
            lieu: "",
            tarifClient: Decimal(api.prix ?? 0),
            tarifSousTraitant: 0,
            fraisRembourser: 0,
            refContrat: nil,
            ecoleId: api.ecoleId != nil ? Int64(api.ecoleId!) : nil,
            clientId: api.clientId != nil ? Int64(api.clientId!) : nil,
            formateurId: api.formateurId != nil ? Int64(api.formateurId!) : nil,
            ecole: nil,
            client: nil,
            formateur: nil
        )
    }
}
