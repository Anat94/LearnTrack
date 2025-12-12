//
//  EcoleViewModel.swift
//  LearnTrack
//
//  ViewModel pour la gestion des écoles
//

import Foundation

@MainActor
class EcoleViewModel: ObservableObject {
    @Published var ecoles: [Ecole] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText = ""
    
    private let service: APIServiceProtocol
    
    init(service: APIServiceProtocol = APIService.shared) {
        self.service = service
    }
    
    
    // Charger toutes les écoles
    func fetchEcoles() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response: [APIEcole] = try await self.service.getEcoles()
            let mapped = response.map { self.mapAPIEcole($0) }
            ecoles = mapped.sorted { $0.nom.localizedCaseInsensitiveCompare($1.nom) == .orderedAscending }
            isLoading = false
        } catch {
            errorMessage = "Erreur lors du chargement des écoles"
            isLoading = false
            print("Erreur: \(error)")
        }
    }
    
    // Créer une école
    func createEcole(_ ecole: Ecole) async throws {
        let payload = mapToAPIEcoleCreate(ecole)
        _ = try await self.service.createEcole(payload)
        await fetchEcoles()
    }
    
    // Mettre à jour une école
    func updateEcole(_ ecole: Ecole) async throws {
        guard let id64 = ecole.id else { return }
        let id = Int(id64)
        let payload = mapToAPIEcoleUpdate(ecole)
        _ = try await self.service.updateEcole(id: id, payload)
        await fetchEcoles()
    }
    
    // Supprimer une école
    func deleteEcole(_ ecole: Ecole) async throws {
        guard let id64 = ecole.id else { return }
        let id = Int(id64)
        try await self.service.deleteEcole(id: id)
        await fetchEcoles()
    }
    
    // Écoles filtrées
    var filteredEcoles: [Ecole] {
        guard !searchText.isEmpty else { return ecoles }
        
        return ecoles.filter { ecole in
            ecole.nom.localizedCaseInsensitiveContains(searchText) ||
            ecole.ville?.localizedCaseInsensitiveContains(searchText) ?? false
        }
    }

    // MARK: - Mapping helpers
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

    private func mapToAPIEcoleCreate(_ ecole: Ecole) -> APIEcoleCreate {
        APIEcoleCreate(
            nom: ecole.nom,
            adresse: ecole.rue,
            ville: ecole.ville,
            codePostal: ecole.codePostal,
            telephone: ecole.telephone,
            email: ecole.email,
            responsableNom: ecole.nomContact,
            capacite: nil,
            notes: nil
        )
    }

    private func mapToAPIEcoleUpdate(_ ecole: Ecole) -> APIEcoleUpdate {
        APIEcoleUpdate(
            nom: ecole.nom,
            adresse: ecole.rue,
            ville: ecole.ville,
            codePostal: ecole.codePostal,
            telephone: ecole.telephone,
            email: ecole.email,
            responsableNom: ecole.nomContact,
            capacite: nil,
            notes: nil,
            actif: nil
        )
    }
}
