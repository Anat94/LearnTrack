//
//  SupabaseManager.swift
//  LearnTrack
//
//  Configuration et client Supabase
//

import Foundation
import Supabase

class SupabaseManager {
    static let shared = SupabaseManager()
    
    private(set) var client: SupabaseClient!
    
    private init() {}
    
    func configure() {
        // IMPORTANT: Remplacez ces valeurs par vos propres credentials Supabase
        guard let supabaseURL = URL(string: "https://votre-projet.supabase.co") else {
            fatalError("URL Supabase invalide")
        }
        
        let supabaseKey = "votre-anon-key-ici"
        
        client = SupabaseClient(
            supabaseURL: supabaseURL,
            supabaseKey: supabaseKey
        )
    }
}
