//
//  EcoleViewModel.swift
//  LearnTrack
//
//  ViewModel pour la gestion des écoles
//

import Foundation
import Supabase

@MainActor
class EcoleViewModel: ObservableObject {
    @Published var ecoles: [Ecole] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText = ""
    
    private let supabase = SupabaseManager.shared.client!
    
    // Charger toutes les écoles
    func fetchEcoles() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response: [Ecole] = try await supabase
                .from("ecoles")
                .select()
                .order("nom", ascending: true)
                .execute()
                .value
            
            ecoles = response
            isLoading = false
        } catch {
            errorMessage = "Erreur lors du chargement des écoles"
            isLoading = false
            print("Erreur: \(error)")
        }
    }
    
    // Créer une école
    func createEcole(_ ecole: Ecole) async throws {
        try await supabase
            .from("ecoles")
            .insert(ecole)
            .execute()
        
        await fetchEcoles()
    }
    
    // Mettre à jour une école
    func updateEcole(_ ecole: Ecole) async throws {
        guard let id = ecole.id else { return }
        
        try await supabase
            .from("ecoles")
            .update(ecole)
            .eq("id", value: id)
            .execute()
        
        await fetchEcoles()
    }
    
    // Supprimer une école
    func deleteEcole(_ ecole: Ecole) async throws {
        guard let id = ecole.id else { return }
        
        try await supabase
            .from("ecoles")
            .delete()
            .eq("id", value: id)
            .execute()
        
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
}
