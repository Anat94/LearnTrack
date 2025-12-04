//
//  SessionViewModel.swift
//  LearnTrack
//
//  ViewModel pour la gestion des sessions
//

import Foundation
import Supabase

@MainActor
class SessionViewModel: ObservableObject {
    @Published var sessions: [Session] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText = ""
    @Published var selectedMonth: Int = Calendar.current.component(.month, from: Date())
    
    private let supabase = SupabaseManager.shared.client!
    
    // Charger toutes les sessions
    func fetchSessions() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response: [Session] = try await supabase
                .from("sessions")
                .select("""
                    *,
                    formateur:formateurs(*),
                    client:clients(*),
                    ecole:ecoles(*)
                """)
                .order("date", ascending: false)
                .execute()
                .value
            
            sessions = response
            isLoading = false
        } catch {
            errorMessage = "Erreur lors du chargement des sessions"
            isLoading = false
            print("Erreur: \(error)")
        }
    }
    
    // Créer une session
    func createSession(_ session: Session) async throws {
        var sessionToCreate = session
        // Encoder les données
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        try await supabase
            .from("sessions")
            .insert(session)
            .execute()
        
        await fetchSessions()
    }
    
    // Mettre à jour une session
    func updateSession(_ session: Session) async throws {
        guard let id = session.id else { return }
        
        try await supabase
            .from("sessions")
            .update(session)
            .eq("id", value: id as! PostgrestFilterValue)
            .execute()
        
        await fetchSessions()
    }
    
    // Supprimer une session
    func deleteSession(_ session: Session) async throws {
        guard let id = session.id else { return }
        
        try await supabase
            .from("sessions")
            .delete()
            .eq("id", value: id as! PostgrestFilterValue)
            .execute()
        
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
}
