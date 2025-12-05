//
//  ClientViewModel.swift
//  LearnTrack
//
//  ViewModel pour la gestion des clients
//

import Foundation

@MainActor
class ClientViewModel: ObservableObject {
    @Published var clients: [Client] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText = ""
    
    
    // Charger tous les clients
    func fetchClients() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response: [APIClient] = try await APIService.shared.getClients()
            let mapped = response.map { self.mapAPIClient($0) }
            // Sort by raisonSociale ascending to keep UX similar
            clients = mapped.sorted { $0.raisonSociale.localizedCaseInsensitiveCompare($1.raisonSociale) == .orderedAscending }
            isLoading = false
        } catch {
            errorMessage = "Erreur lors du chargement des clients"
            isLoading = false
            print("Erreur: \(error)")
        }
    }
    
    // Créer un client
    func createClient(_ client: Client) async throws {
        let payload = mapToAPIClientCreate(client)
        let created = try await APIService.shared.createClient(payload)
        let id64 = Int64(created.id)
        ExtrasStore.shared.setClientExtras(id: id64, ClientExtras(numeroTva: client.numeroTva))
        await fetchClients()
    }
    
    // Mettre à jour un client
    func updateClient(_ client: Client) async throws {
        guard let id64 = client.id else { return }
        let id = Int(id64)
        let payload = mapToAPIClientUpdate(client)
        _ = try await APIService.shared.updateClient(id: id, payload)
        ExtrasStore.shared.setClientExtras(id: id64, ClientExtras(numeroTva: client.numeroTva))
        await fetchClients()
    }
    
    // Supprimer un client
    func deleteClient(_ client: Client) async throws {
        guard let id64 = client.id else { return }
        let id = Int(id64)
        try await APIService.shared.deleteClient(id: id)
        await fetchClients()
    }
    
    // Clients filtrés
    var filteredClients: [Client] {
        guard !searchText.isEmpty else { return clients }
        
        return clients.filter { client in
            client.raisonSociale.localizedCaseInsensitiveContains(searchText) ||
            client.ville?.localizedCaseInsensitiveContains(searchText) ?? false
        }
    }
    
    // Charger les sessions d'un client
    func fetchSessionsForClient(_ clientId: Int64) async -> [Session] {
        do {
            let apiSessions: [APISession] = try await APIService.shared.getClientSessions(clientId: Int(clientId))
            return apiSessions.compactMap { self.mapAPISession($0) }
        } catch {
            print("Erreur chargement sessions: \(error)")
            return []
        }
    }

    // MARK: - Mapping helpers
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

    private func mapToAPIClientCreate(_ client: Client) -> APIClientCreate {
        APIClientCreate(
            nom: client.raisonSociale,
            email: client.email,
            telephone: client.telephone,
            adresse: client.rue,
            ville: client.ville,
            codePostal: client.codePostal,
            siret: client.siret,
            contactNom: client.nomContact,
            contactEmail: client.email,
            contactTelephone: client.telephone,
            notes: nil
        )
    }

    private func mapToAPIClientUpdate(_ client: Client) -> APIClientUpdate {
        APIClientUpdate(
            nom: client.raisonSociale,
            email: client.email,
            telephone: client.telephone,
            adresse: client.rue,
            ville: client.ville,
            codePostal: client.codePostal,
            siret: client.siret,
            contactNom: client.nomContact,
            contactEmail: client.email,
            contactTelephone: client.telephone,
            notes: nil,
            actif: nil
        )
    }

    private func mapAPISession(_ api: APISession) -> Session? {
        // Parse date "YYYY-MM-DD"
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale(identifier: "fr_FR_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: api.dateDebut) else { return nil }

        // Convert HH:MM:SS -> HH:mm
        func trimTime(_ s: String?) -> String {
            guard let s = s, s.count >= 5 else { return "" }
            return String(s.prefix(5))
        }

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
