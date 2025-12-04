//
//  Formateur.swift
//  LearnTrack
//
//  Modèle de données pour les formateurs
//

import Foundation

struct Formateur: Codable, Identifiable {
    let id: Int64?
    var prenom: String
    var nom: String
    var email: String
    var telephone: String
    var specialite: String
    var tauxHoraire: Decimal
    var exterieur: Bool
    var societe: String?
    var siret: String?
    var nda: String?
    var rue: String?
    var codePostal: String?
    var ville: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case prenom
        case nom
        case email
        case telephone
        case specialite
        case tauxHoraire = "taux_horaire"
        case exterieur
        case societe
        case siret
        case nda
        case rue
        case codePostal = "code_postal"
        case ville
    }
    
    // Propriétés calculées
    var nomComplet: String {
        return "\(prenom) \(nom)"
    }
    
    var initiales: String {
        let first = prenom.prefix(1)
        let last = nom.prefix(1)
        return "\(first)\(last)".uppercased()
    }
    
    var type: String {
        return exterieur ? "Externe" : "Interne"
    }
    
    var adresseComplete: String? {
        guard let rue = rue,
              let cp = codePostal,
              let ville = ville else {
            return nil
        }
        return "\(rue), \(cp) \(ville)"
    }
    
    // Initializer
    init(
        id: Int64? = nil,
        prenom: String = "",
        nom: String = "",
        email: String = "",
        telephone: String = "",
        specialite: String = "",
        tauxHoraire: Decimal = 0,
        exterieur: Bool = false,
        societe: String? = nil,
        siret: String? = nil,
        nda: String? = nil,
        rue: String? = nil,
        codePostal: String? = nil,
        ville: String? = nil
    ) {
        self.id = id
        self.prenom = prenom
        self.nom = nom
        self.email = email
        self.telephone = telephone
        self.specialite = specialite
        self.tauxHoraire = tauxHoraire
        self.exterieur = exterieur
        self.societe = societe
        self.siret = siret
        self.nda = nda
        self.rue = rue
        self.codePostal = codePostal
        self.ville = ville
    }
}
