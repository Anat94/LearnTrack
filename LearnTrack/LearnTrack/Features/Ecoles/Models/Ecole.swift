//
//  Ecole.swift
//  LearnTrack
//
//  Modèle de données pour les écoles
//

import Foundation

struct Ecole: Codable, Identifiable {
    let id: Int64?
    var nom: String
    var rue: String?
    var codePostal: String?
    var ville: String?
    var nomContact: String
    var email: String
    var telephone: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case nom
        case rue
        case codePostal = "code_postal"
        case ville
        case nomContact = "nom_contact"
        case email
        case telephone
    }
    
    // Propriétés calculées
    var initiales: String {
        let words = nom.split(separator: " ")
        if words.count >= 2 {
            let first = words[0].prefix(1)
            let second = words[1].prefix(1)
            return "\(first)\(second)".uppercased()
        } else if let first = words.first {
            return String(first.prefix(2)).uppercased()
        }
        return "EC"
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
        nom: String = "",
        rue: String? = nil,
        codePostal: String? = nil,
        ville: String? = nil,
        nomContact: String = "",
        email: String = "",
        telephone: String = ""
    ) {
        self.id = id
        self.nom = nom
        self.rue = rue
        self.codePostal = codePostal
        self.ville = ville
        self.nomContact = nomContact
        self.email = email
        self.telephone = telephone
    }
}
