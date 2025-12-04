//
//  Session.swift
//  LearnTrack
//
//  Modèle de données pour les sessions de formation
//

import Foundation

struct Session: Codable, Identifiable {
    let id: Int64?
    var module: String
    var date: Date
    var debut: String // Format "HH:mm"
    var fin: String // Format "HH:mm"
    var modalite: Modalite
    var lieu: String
    var tarifClient: Decimal
    var tarifSousTraitant: Decimal
    var fraisRembourser: Decimal
    var refContrat: String?
    var ecoleId: Int64?
    var clientId: Int64?
    var formateurId: Int64?
    
    // Relations (pour les vues complètes)
    var ecole: Ecole?
    var client: Client?
    var formateur: Formateur?
    
    enum CodingKeys: String, CodingKey {
        case id
        case module
        case date
        case debut
        case fin
        case modalite
        case lieu
        case tarifClient = "tarif_client"
        case tarifSousTraitant = "tarif_sous_traitant"
        case fraisRembourser = "frais_rembourser"
        case refContrat = "ref_contrat"
        case ecoleId = "ecole_id"
        case clientId = "client_id"
        case formateurId = "formateur_id"
        case ecole
        case client
        case formateur
    }
    
    enum Modalite: String, Codable, CaseIterable {
        case presentiel = "P"
        case distanciel = "D"
        
        var label: String {
            switch self {
            case .presentiel: return "Présentiel"
            case .distanciel: return "Distanciel"
            }
        }
        
        var icon: String {
            switch self {
            case .presentiel: return "person.fill"
            case .distanciel: return "video.fill"
            }
        }
        
        var color: String {
            switch self {
            case .presentiel: return "blue"
            case .distanciel: return "green"
            }
        }
    }
    
    // Propriétés calculées
    var marge: Decimal {
        return tarifClient - tarifSousTraitant - fraisRembourser
    }
    
    var displayDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "fr_FR")
        return formatter.string(from: date)
    }
    
    var displayHoraires: String {
        return "\(debut) - \(fin)"
    }
    
    // Initializer pour les nouvelles sessions
    init(
        id: Int64? = nil,
        module: String = "",
        date: Date = Date(),
        debut: String = "09:00",
        fin: String = "17:00",
        modalite: Modalite = .presentiel,
        lieu: String = "",
        tarifClient: Decimal = 0,
        tarifSousTraitant: Decimal = 0,
        fraisRembourser: Decimal = 0,
        refContrat: String? = nil,
        ecoleId: Int64? = nil,
        clientId: Int64? = nil,
        formateurId: Int64? = nil,
        ecole: Ecole? = nil,
        client: Client? = nil,
        formateur: Formateur? = nil
    ) {
        self.id = id
        self.module = module
        self.date = date
        self.debut = debut
        self.fin = fin
        self.modalite = modalite
        self.lieu = lieu
        self.tarifClient = tarifClient
        self.tarifSousTraitant = tarifSousTraitant
        self.fraisRembourser = fraisRembourser
        self.refContrat = refContrat
        self.ecoleId = ecoleId
        self.clientId = clientId
        self.formateurId = formateurId
        self.ecole = ecole
        self.client = client
        self.formateur = formateur
    }
    
    // Format de partage
    func shareText() -> String {
        var text = """
        📚 Session de Formation
        
        Module: \(module)
        📅 Date: \(displayDate)
        ⏰ Horaires: \(displayHoraires)
        📍 Modalité: \(modalite.label)
        """
        
        if modalite == .presentiel {
            text += "\n📌 Lieu: \(lieu)"
        }
        
        if let formateur = formateur {
            text += "\n👤 Formateur: \(formateur.prenom) \(formateur.nom)"
        }
        
        if let client = client {
            text += "\n🏢 Client: \(client.raisonSociale)"
        }
        
        text += "\n💰 Tarif client: \(tarifClient) €"
        
        return text
    }
}
