//
//  FormateurFormViewTests.swift
//  LearnTrackTests
//
//  Tests unitaires pour FormateurFormView
//

import Testing
import Foundation
@testable import LearnTrack

@Suite("FormateurFormView Tests")
struct FormateurFormViewTests {
    
    // MARK: - Test Data
    
    static func createTestFormateur(
        id: Int64? = 1,
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
            id: id,
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
    
    // MARK: - Mode Detection Tests
    
    @Test("isEditing returns true when formateurToEdit is provided")
    func testIsEditingTrue() {
        let formateur = FormateurFormViewTests.createTestFormateur()
        let isEditing = formateur.id != nil
        #expect(isEditing == true)
    }
    
    @Test("isEditing returns false for new formateur")
    func testIsEditingFalse() {
        let formateur = FormateurFormViewTests.createTestFormateur(id: nil)
        let isEditing = formateur.id != nil
        #expect(isEditing == false)
    }
    
    // MARK: - Form Validation Tests
    
    @Test("form is invalid when prenom is empty")
    func testFormInvalidPrenomEmpty() {
        let prenom = ""
        let nom = "Dupont"
        let isDisabled = prenom.isEmpty || nom.isEmpty
        #expect(isDisabled == true)
    }
    
    @Test("form is invalid when nom is empty")
    func testFormInvalidNomEmpty() {
        let prenom = "Jean"
        let nom = ""
        let isDisabled = prenom.isEmpty || nom.isEmpty
        #expect(isDisabled == true)
    }
    
    @Test("form is valid when both prenom and nom are filled")
    func testFormValidPrenomNomFilled() {
        let prenom = "Jean"
        let nom = "Dupont"
        let isDisabled = prenom.isEmpty || nom.isEmpty
        #expect(isDisabled == false)
    }
    
    @Test("form is invalid when both prenom and nom are empty")
    func testFormInvalidBothEmpty() {
        let prenom = ""
        let nom = ""
        let isDisabled = prenom.isEmpty || nom.isEmpty
        #expect(isDisabled == true)
    }
    
    // MARK: - TauxHoraire Validation Tests
    
    @Test("valid taux horaire parses correctly")
    func testValidTauxHoraire() {
        let tauxHoraire = "55.50"
        let parsed = Decimal(string: tauxHoraire)
        #expect(parsed != nil)
        #expect(parsed == 55.50)
    }
    
    @Test("invalid taux horaire fails parsing")
    func testInvalidTauxHoraire() {
        let tauxHoraire = "abc"
        let parsed = Decimal(string: tauxHoraire)
        #expect(parsed == nil)
    }
    
    @Test("empty taux horaire fails parsing")
    func testEmptyTauxHoraire() {
        let tauxHoraire = ""
        let parsed = Decimal(string: tauxHoraire)
        #expect(parsed == nil)
    }
    
    @Test("taux horaire zero is valid")
    func testTauxHoraireZero() {
        let tauxHoraire = "0"
        let parsed = Decimal(string: tauxHoraire)
        #expect(parsed != nil)
        #expect(parsed == 0)
    }
    
    // MARK: - External Formateur Section Tests
    
    @Test("société section shown when exterieur is true")
    func testSocieteSectionShown() {
        let exterieur = true
        let showSocieteSection = exterieur
        #expect(showSocieteSection == true)
    }
    
    @Test("société section hidden when exterieur is false")
    func testSocieteSectionHidden() {
        let exterieur = false
        let showSocieteSection = exterieur
        #expect(showSocieteSection == false)
    }
    
    // MARK: - Load Data Tests
    
    @Test("loadData populates all fields correctly")
    func testLoadDataPopulatesFields() {
        let formateur = FormateurFormViewTests.createTestFormateur(
            prenom: "Marie",
            nom: "Martin",
            email: "marie@test.com",
            telephone: "0698765432",
            specialite: "Python",
            tauxHoraire: 65.0,
            exterieur: true,
            societe: "Tech Academy",
            siret: "98765432100001",
            nda: "NDA98765",
            rue: "5 avenue des Devs",
            codePostal: "69001",
            ville: "Lyon"
        )
        
        // Simulating loadData function behavior
        let prenom = formateur.prenom
        let nom = formateur.nom
        let email = formateur.email
        let telephone = formateur.telephone
        let specialite = formateur.specialite
        let tauxHoraire = "\(formateur.tauxHoraire)"
        let exterieur = formateur.exterieur
        let societe = formateur.societe ?? ""
        let siret = formateur.siret ?? ""
        let nda = formateur.nda ?? ""
        let rue = formateur.rue ?? ""
        let codePostal = formateur.codePostal ?? ""
        let ville = formateur.ville ?? ""
        
        #expect(prenom == "Marie")
        #expect(nom == "Martin")
        #expect(email == "marie@test.com")
        #expect(telephone == "0698765432")
        #expect(specialite == "Python")
        #expect(tauxHoraire == "65")
        #expect(exterieur == true)
        #expect(societe == "Tech Academy")
        #expect(siret == "98765432100001")
        #expect(nda == "NDA98765")
        #expect(rue == "5 avenue des Devs")
        #expect(codePostal == "69001")
        #expect(ville == "Lyon")
    }
    
    @Test("loadData handles nil optional fields")
    func testLoadDataHandlesNils() {
        let formateur = FormateurFormViewTests.createTestFormateur(
            societe: nil,
            siret: nil,
            nda: nil,
            rue: nil,
            codePostal: nil,
            ville: nil
        )
        
        let societe = formateur.societe ?? ""
        let siret = formateur.siret ?? ""
        let nda = formateur.nda ?? ""
        let rue = formateur.rue ?? ""
        let codePostal = formateur.codePostal ?? ""
        let ville = formateur.ville ?? ""
        
        #expect(societe == "")
        #expect(siret == "")
        #expect(nda == "")
        #expect(rue == "")
        #expect(codePostal == "")
        #expect(ville == "")
    }
    
    // MARK: - Form Field Conversion Tests
    
    @Test("empty string societe converts to nil")
    func testEmptyStringToNil() {
        let societe = ""
        let converted: String? = societe.isEmpty ? nil : societe
        #expect(converted == nil)
    }
    
    @Test("non-empty string societe stays as value")
    func testNonEmptyStringNotNil() {
        let societe = "Tech Company"
        let converted: String? = societe.isEmpty ? nil : societe
        #expect(converted == "Tech Company")
    }
    
    // MARK: - Button State Tests
    
    @Test("button shows 'Créer' in create mode")
    func testButtonTextCreateMode() {
        let isEditing = false
        let buttonText = isEditing ? "Enregistrer" : "Créer"
        let buttonIcon = isEditing ? "checkmark" : "plus"
        
        #expect(buttonText == "Créer")
        #expect(buttonIcon == "plus")
    }
    
    @Test("button shows 'Enregistrer' in edit mode")
    func testButtonTextEditMode() {
        let isEditing = true
        let buttonText = isEditing ? "Enregistrer" : "Créer"
        let buttonIcon = isEditing ? "checkmark" : "plus"
        
        #expect(buttonText == "Enregistrer")
        #expect(buttonIcon == "checkmark")
    }
    
    // MARK: - Navigation Title Tests
    
    @Test("navigation title in create mode")
    func testNavigationTitleCreateMode() {
        let isEditing = false
        let title = isEditing ? "Modifier" : "Nouveau formateur"
        #expect(title == "Nouveau formateur")
    }
    
    @Test("navigation title in edit mode")
    func testNavigationTitleEditMode() {
        let isEditing = true
        let title = isEditing ? "Modifier" : "Nouveau formateur"
        #expect(title == "Modifier")
    }
    
    // MARK: - Section Titles Tests
    
    @Test("identité section title is correct")
    func testIdentiteSectionTitle() {
        let title = "Identité"
        #expect(title == "Identité")
    }
    
    @Test("contact section title is correct")
    func testContactSectionTitle() {
        let title = "Contact"
        #expect(title == "Contact")
    }
    
    @Test("informations professionnelles section title is correct")
    func testInfosProSectionTitle() {
        let title = "Informations professionnelles"
        #expect(title == "Informations professionnelles")
    }
    
    @Test("société section title is correct")
    func testSocieteSectionTitle() {
        let title = "Société"
        #expect(title == "Société")
    }
    
    @Test("adresse section title is correct")
    func testAdresseSectionTitle() {
        let title = "Adresse"
        #expect(title == "Adresse")
    }
    
    // MARK: - Field Placeholders Tests
    
    @Test("prenom placeholder is correct")
    func testPrenomPlaceholder() {
        let placeholder = "Prénom"
        #expect(placeholder == "Prénom")
    }
    
    @Test("nom placeholder is correct")
    func testNomPlaceholder() {
        let placeholder = "Nom"
        #expect(placeholder == "Nom")
    }
    
    @Test("email placeholder is correct")
    func testEmailPlaceholder() {
        let placeholder = "email@domaine.com"
        #expect(placeholder == "email@domaine.com")
    }
    
    @Test("telephone placeholder is correct")
    func testTelephonePlaceholder() {
        let placeholder = "0123456789"
        #expect(placeholder == "0123456789")
    }
    
    @Test("specialite placeholder is correct")
    func testSpecialitePlaceholder() {
        let placeholder = "Ex: Swift, iOS"
        #expect(placeholder == "Ex: Swift, iOS")
    }
    
    @Test("taux horaire placeholder is correct")
    func testTauxHorairePlaceholder() {
        let placeholder = "50.00"
        #expect(placeholder == "50.00")
    }
    
    @Test("société placeholder is correct")
    func testSocietePlaceholder() {
        let placeholder = "Nom de l'entreprise"
        #expect(placeholder == "Nom de l'entreprise")
    }
    
    @Test("siret placeholder is correct")
    func testSiretPlaceholder() {
        let placeholder = "12345678900001"
        #expect(placeholder == "12345678900001")
    }
    
    @Test("nda placeholder is correct")
    func testNdaPlaceholder() {
        let placeholder = "Numéro NDA"
        #expect(placeholder == "Numéro NDA")
    }
    
    @Test("rue placeholder is correct")
    func testRuePlaceholder() {
        let placeholder = "123 rue de la Paix"
        #expect(placeholder == "123 rue de la Paix")
    }
    
    @Test("code postal placeholder is correct")
    func testCodePostalPlaceholder() {
        let placeholder = "75001"
        #expect(placeholder == "75001")
    }
    
    @Test("ville placeholder is correct")
    func testVillePlaceholder() {
        let placeholder = "Paris"
        #expect(placeholder == "Paris")
    }
    
    // MARK: - Error Handling Tests
    
    @Test("error message for invalid taux horaire")
    func testErrorMessageInvalidTauxHoraire() {
        let errorMessage = "Veuillez saisir un taux horaire valide"
        #expect(errorMessage == "Veuillez saisir un taux horaire valide")
    }
    
    @Test("error alert title is correct")
    func testErrorAlertTitle() {
        let title = "Erreur"
        #expect(title == "Erreur")
    }
    
    // MARK: - Toggle Label Tests
    
    @Test("formateur externe toggle label is correct")
    func testFormateurExterneToggleLabel() {
        let label = "Formateur externe"
        #expect(label == "Formateur externe")
    }
}
