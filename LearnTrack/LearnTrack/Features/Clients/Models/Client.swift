//
//  Client.swift
//  LearnTrack
//
//  Modèle de données pour les clients
//

import Foundation

struct Client: Codable, Identifiable {
    let id: Int64?
    var raisonSociale: String
    var rue: String?
    var codePostal: String?
    var ville: String?
    var nomContact: String
    var email: String
    var telephone: String
    var siret: String?
    var numeroTva: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case raisonSociale = "raison_sociale"
        case rue
        case codePostal = "code_postal"
        case ville
        case nomContact = "nom_contact"
        case email
        case telephone
        case siret
        case numeroTva = "numero_tva"
    }
    
    // Propriétés calculées
    var initiales: String {
        let words = raisonSociale.split(separator: " ")
        if words.count >= 2 {
            let first = words[0].prefix(1)
            let second = words[1].prefix(1)
            return "\(first)\(second)".uppercased()
        } else if let first = words.first {
            return String(first.prefix(2)).uppercased()
        }
        return "CL"
    }
    
    var adresseComplete: String? {
        guard let rue = rue,
              let cp = codePostal,
              let ville = ville else {
            return nil
        }
        return "\(rue), \(cp) \(ville)"
    }
    
    var villeDisplay: String {
        return ville ?? "Non renseignée"
    }
    
    // Initializer
    init(
        id: Int64? = nil,
        raisonSociale: String = "",
        rue: String? = nil,
        codePostal: String? = nil,
        ville: String? = nil,
        nomContact: String = "",
        email: String = "",
        telephone: String = "",
        siret: String? = nil,
        numeroTva: String? = nil
    ) {
        self.id = id
        self.raisonSociale = raisonSociale
        self.rue = rue
        self.codePostal = codePostal
        self.ville = ville
        self.nomContact = nomContact
        self.email = email
        self.telephone = telephone
        self.siret = siret
        self.numeroTva = numeroTva
    }
}
