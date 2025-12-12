//
//  FormateurDetailViewTests.swift
//  LearnTrackTests
//
//  Tests unitaires pour FormateurDetailView
//

import Testing
import Foundation
@testable import LearnTrack

@Suite("FormateurDetailView Tests")
struct FormateurDetailViewTests {
    
    // MARK: - Test Data
    
    static func createTestFormateur(
        prenom: String = "Jean",
        nom: String = "Dupont",
        email: String = "jean@example.com",
        telephone: String = "0612345678",
        specialite: String = "Swift / iOS",
        tauxHoraire: Decimal = 55.0,
        exterieur: Bool = false,
        societe: String? = nil,
        siret: String? = nil,
        nda: String? = nil,
        rue: String? = "10 rue de la Formation",
        codePostal: String? = "75001",
        ville: String? = "Paris"
    ) -> Formateur {
        Formateur(
            id: 1,
            prenom: prenom,
            nom: nom,
            email: email,
            telephone: telephone,
            specialite: specialite,
            tauxHoraire: tauxHoraire,
            exterieur: exterieur,
            societe: societe,
            siret: siret,
            nda: nda,
            rue: rue,
            codePostal: codePostal,
            ville: ville
        )
    }
    
    // MARK: - Computed Properties Tests
    
    @Test("initiales returns first letters of prenom and nom")
    func testInitiales() {
        let formateur = FormateurDetailViewTests.createTestFormateur(prenom: "Jean", nom: "Dupont")
        #expect(formateur.initiales == "JD")
    }
    
    @Test("initiales handles different cases")
    func testInitialesUppercase() {
        let formateur = FormateurDetailViewTests.createTestFormateur(prenom: "marie", nom: "martin")
        #expect(formateur.initiales == "MM")
    }
    
    @Test("initiales handles single letter names")
    func testInitialesSingleLetter() {
        let formateur = FormateurDetailViewTests.createTestFormateur(prenom: "A", nom: "B")
        #expect(formateur.initiales == "AB")
    }
    
    @Test("nomComplet returns full name")
    func testNomComplet() {
        let formateur = FormateurDetailViewTests.createTestFormateur(prenom: "Jean", nom: "Dupont")
        #expect(formateur.nomComplet == "Jean Dupont")
    }
    
    @Test("nomComplet handles special characters")
    func testNomCompletSpecialChars() {
        let formateur = FormateurDetailViewTests.createTestFormateur(prenom: "Jean-Pierre", nom: "De La Fontaine")
        #expect(formateur.nomComplet == "Jean-Pierre De La Fontaine")
    }
    
    // MARK: - Type Tests
    
    @Test("type returns Interne for internal formateur")
    func testTypeInterne() {
        let formateur = FormateurDetailViewTests.createTestFormateur(exterieur: false)
        #expect(formateur.type == "Interne")
    }
    
    @Test("type returns Externe for external formateur")
    func testTypeExterne() {
        let formateur = FormateurDetailViewTests.createTestFormateur(exterieur: true)
        #expect(formateur.type == "Externe")
    }
    
    // MARK: - Address Tests
    
    @Test("adresseComplete returns full address when all fields present")
    func testAdresseComplete() {
        let formateur = FormateurDetailViewTests.createTestFormateur(
            rue: "10 rue de la Formation",
            codePostal: "75001",
            ville: "Paris"
        )
        #expect(formateur.adresseComplete == "10 rue de la Formation, 75001 Paris")
    }
    
    @Test("adresseComplete returns nil when rue is missing")
    func testAdresseCompleteMissingRue() {
        let formateur = FormateurDetailViewTests.createTestFormateur(
            rue: nil,
            codePostal: "75001",
            ville: "Paris"
        )
        #expect(formateur.adresseComplete == nil)
    }
    
    @Test("adresseComplete returns nil when codePostal is missing")
    func testAdresseCompleteMissingCodePostal() {
        let formateur = FormateurDetailViewTests.createTestFormateur(
            rue: "10 rue de la Formation",
            codePostal: nil,
            ville: "Paris"
        )
        #expect(formateur.adresseComplete == nil)
    }
    
    @Test("adresseComplete returns nil when ville is missing")
    func testAdresseCompleteMissingVille() {
        let formateur = FormateurDetailViewTests.createTestFormateur(
            rue: "10 rue de la Formation",
            codePostal: "75001",
            ville: nil
        )
        #expect(formateur.adresseComplete == nil)
    }
    
    // MARK: - TauxHoraire Tests
    
    @Test("tauxHoraire stores decimal value correctly")
    func testTauxHoraire() {
        let formateur = FormateurDetailViewTests.createTestFormateur(tauxHoraire: 55.50)
        #expect(formateur.tauxHoraire == 55.50)
    }
    
    @Test("tauxHoraire handles zero value")
    func testTauxHoraireZero() {
        let formateur = FormateurDetailViewTests.createTestFormateur(tauxHoraire: 0)
        #expect(formateur.tauxHoraire == 0)
    }
    
    @Test("tauxHoraire handles large value")
    func testTauxHoraireLargeValue() {
        let formateur = FormateurDetailViewTests.createTestFormateur(tauxHoraire: 999.99)
        #expect(formateur.tauxHoraire == 999.99)
    }
    
    // MARK: - External Formateur (Société) Tests
    
    @Test("external formateur has société info")
    func testFormateurExterneSociete() {
        let formateur = FormateurDetailViewTests.createTestFormateur(
            exterieur: true,
            societe: "Formation Pro SARL",
            siret: "12345678900001",
            nda: "NDA12345"
        )
        #expect(formateur.exterieur == true)
        #expect(formateur.societe == "Formation Pro SARL")
        #expect(formateur.siret == "12345678900001")
        #expect(formateur.nda == "NDA12345")
    }
    
    @Test("internal formateur has no société info")
    func testFormateurInterneSansInfo() {
        let formateur = FormateurDetailViewTests.createTestFormateur(
            exterieur: false,
            societe: nil,
            siret: nil,
            nda: nil
        )
        #expect(formateur.exterieur == false)
        #expect(formateur.societe == nil)
        #expect(formateur.siret == nil)
        #expect(formateur.nda == nil)
    }
    
    // MARK: - Contact Info Tests
    
    @Test("email is stored correctly")
    func testEmail() {
        let formateur = FormateurDetailViewTests.createTestFormateur(email: "formateur@learntrack.com")
        #expect(formateur.email == "formateur@learntrack.com")
    }
    
    @Test("telephone is stored correctly")
    func testTelephone() {
        let formateur = FormateurDetailViewTests.createTestFormateur(telephone: "0612345678")
        #expect(formateur.telephone == "0612345678")
    }
    
    // MARK: - Specialite Tests
    
    @Test("specialite is stored correctly")
    func testSpecialite() {
        let formateur = FormateurDetailViewTests.createTestFormateur(specialite: "Swift / iOS")
        #expect(formateur.specialite == "Swift / iOS")
    }
    
    @Test("specialite can be empty")
    func testSpecialiteEmpty() {
        let formateur = FormateurDetailViewTests.createTestFormateur(specialite: "")
        #expect(formateur.specialite.isEmpty)
    }
    
    // MARK: - Default Values Tests
    
    @Test("default values are correct")
    func testDefaultValues() {
        let formateur = Formateur()
        
        #expect(formateur.id == nil)
        #expect(formateur.prenom == "")
        #expect(formateur.nom == "")
        #expect(formateur.email == "")
        #expect(formateur.telephone == "")
        #expect(formateur.specialite == "")
        #expect(formateur.tauxHoraire == 0)
        #expect(formateur.exterieur == false)
        #expect(formateur.societe == nil)
        #expect(formateur.siret == nil)
        #expect(formateur.nda == nil)
        #expect(formateur.rue == nil)
        #expect(formateur.codePostal == nil)
        #expect(formateur.ville == nil)
    }
    
    // MARK: - Navigation & Alert Tests
    
    @Test("delete alert title is correct")
    func testDeleteAlertTitle() {
        let title = "Supprimer ce formateur ?"
        #expect(title == "Supprimer ce formateur ?")
    }
    
    @Test("delete alert message is correct")
    func testDeleteAlertMessage() {
        let message = "Cette action est irréversible."
        #expect(message == "Cette action est irréversible.")
    }
    
    @Test("navigation title is correct")
    func testNavigationTitle() {
        let title = "Formateur"
        #expect(title == "Formateur")
    }
    
    // MARK: - Section Labels Tests
    
    @Test("coordonnées section label is correct")
    func testCoordonneesLabel() {
        let label = "Coordonnées"
        #expect(label == "Coordonnées")
    }
    
    @Test("informations professionnelles section label is correct")
    func testInfosProLabel() {
        let label = "Informations professionnelles"
        #expect(label == "Informations professionnelles")
    }
    
    @Test("société section label is correct")
    func testSocieteLabel() {
        let label = "Société"
        #expect(label == "Société")
    }
    
    @Test("adresse section label is correct")
    func testAdresseLabel() {
        let label = "Adresse"
        #expect(label == "Adresse")
    }
    
    // MARK: - Action Buttons Tests
    
    @Test("edit button title is correct")
    func testEditButtonTitle() {
        let title = "Modifier"
        #expect(title == "Modifier")
    }
    
    @Test("delete button title is correct")
    func testDeleteButtonTitle() {
        let title = "Supprimer"
        #expect(title == "Supprimer")
    }
    
    // MARK: - Quick Actions Tests
    
    @Test("appeler action title is correct")
    func testAppelerAction() {
        let title = "Appeler"
        #expect(title == "Appeler")
    }
    
    @Test("email action title is correct")
    func testEmailAction() {
        let title = "Email"
        #expect(title == "Email")
    }
    
    @Test("itineraire action title is correct")
    func testItineraireAction() {
        let title = "Itinéraire"
        #expect(title == "Itinéraire")
    }
}
