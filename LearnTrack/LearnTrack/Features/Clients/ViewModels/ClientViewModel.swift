//
//  ClientViewModel.swift
//  LearnTrack
//
//  ViewModel pour la gestion des clients
//

import Foundation
import Supabase

@MainActor
class ClientViewModel: ObservableObject {
    @Published var clients: [Client] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText = ""
    
    private let supabase = SupabaseManager.shared.client!
    
    // Charger tous les clients
    func fetchClients() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response: [Client] = try await supabase
                .from("clients")
                .select()
                .order("raison_sociale", ascending: true)
                .execute()
                .value
            
            clients = response
            isLoading = false
        } catch {
            errorMessage = "Erreur lors du chargement des clients"
            isLoading = false
            print("Erreur: \(error)")
        }
    }
    
    // Créer un client
    func createClient(_ client: Client) async throws {
        try await supabase
            .from("clients")
            .insert(client)
            .execute()
        
        await fetchClients()
    }
    
    // Mettre à jour un client
    func updateClient(_ client: Client) async throws {
        guard let id = client.id else { return }
        
        try await supabase
            .from("clients")
            .update(client)
            .eq("id", value: id as! PostgrestFilterValue)
            .execute()
        
        await fetchClients()
    }
    
    // Supprimer un client
    func deleteClient(_ client: Client) async throws {
        guard let id = client.id else { return }
        
        try await supabase
            .from("clients")
            .delete()
            .eq("id", value: id as! PostgrestFilterValue)
            .execute()
        
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
            let response: [Session] = try await supabase
                .from("sessions")
                .select("""
                    *,
                    formateur:formateurs(*),
                    client:clients(*),
                    ecole:ecoles(*)
                """)
                .eq("client_id", value: clientId as! PostgrestFilterValue)
                .order("date", ascending: false)
                .execute()
                .value
            
            return response
        } catch {
            print("Erreur chargement sessions: \(error)")
            return []
        }
    }
}
