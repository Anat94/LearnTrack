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
        guard let supabaseURL = URL(string: "https://epsksludoqhtpxjwrdmk.supabase.co/") else {
            fatalError("URL Supabase invalide")
        }
        
        let supabaseKey = "sb_publishable_EGI8p-vAtwRsEkk6ajwhAA_odtrHX6S"
        
        client = SupabaseClient(
            supabaseURL: supabaseURL,
            supabaseKey: supabaseKey
        )
    }
}
