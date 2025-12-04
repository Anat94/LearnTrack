//
//  FormateurViewModel.swift
//  LearnTrack
//
//  ViewModel pour la gestion des formateurs
//

import Foundation
import Supabase

@MainActor
class FormateurViewModel: ObservableObject {
    @Published var formateurs: [Formateur] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText = ""
    @Published var filterType: FilterType = .tous
    
    private let supabase = SupabaseManager.shared.client!
    
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
            let response: [Formateur] = try await supabase
                .from("formateurs")
                .select()
                .order("nom", ascending: true)
                .execute()
                .value
            
            formateurs = response
            isLoading = false
        } catch {
            errorMessage = "Erreur lors du chargement des formateurs"
            isLoading = false
            print("Erreur: \(error)")
        }
    }
    
    // Créer un formateur
    func createFormateur(_ formateur: Formateur) async throws {
        try await supabase
            .from("formateurs")
            .insert(formateur)
            .execute()
        
        await fetchFormateurs()
    }
    
    // Mettre à jour un formateur
    func updateFormateur(_ formateur: Formateur) async throws {
        guard let id = formateur.id else { return }
        
        try await supabase
            .from("formateurs")
            .update(formateur)
            .eq("id", value: id as! PostgrestFilterValue)
            .execute()
        
        await fetchFormateurs()
    }
    
    // Supprimer un formateur
    func deleteFormateur(_ formateur: Formateur) async throws {
        guard let id = formateur.id else { return }
        
        try await supabase
            .from("formateurs")
            .delete()
            .eq("id", value: id as! PostgrestFilterValue)
            .execute()
        
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
            let response: [Session] = try await supabase
                .from("sessions")
                .select("""
                    *,
                    formateur:formateurs(*),
                    client:clients(*),
                    ecole:ecoles(*)
                """)
                .eq("formateur_id", value: formateurId as! PostgrestFilterValue)
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
