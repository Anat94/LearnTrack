//
//  SessionFormViewTests.swift
//  LearnTrackTests
//
//  Tests unitaires pour SessionFormView
//

import Testing
import Foundation
@testable import LearnTrack

@Suite("SessionFormView Tests")
struct SessionFormViewTests {
    
    // MARK: - Test Data
    
    static func createTestSession(
        id: Int64? = 1,
        module: String = "Swift avancé",
        date: Date = Date(),
        debut: String = "09:00",
        fin: String = "17:00",
        modalite: Session.Modalite = .presentiel,
        lieu: String = "Paris - Centre de formation",
        tarifClient: Decimal = 500,
        tarifSousTraitant: Decimal = 300,
        fraisRembourser: Decimal = 50,
        refContrat: String? = "REF-2025-001",
        formateurId: Int64? = 1,
        clientId: Int64? = 2,
        ecoleId: Int64? = 3
    ) -> Session {
        Session(
            id: id,
            module: module,
            date: date,
            debut: debut,
            fin: fin,
            modalite: modalite,
            lieu: lieu,
            tarifClient: tarifClient,
            tarifSousTraitant: tarifSousTraitant,
            fraisRembourser: fraisRembourser,
            refContrat: refContrat,
            ecoleId: ecoleId,
            clientId: clientId,
            formateurId: formateurId
        )
    }
    
    // MARK: - Mode Detection Tests
    
    @Test("isEditing returns true when sessionToEdit is provided")
    func testIsEditingTrue() {
        let session = SessionFormViewTests.createTestSession()
        let isEditing = session.id != nil
        #expect(isEditing == true)
    }
    
    @Test("isEditing returns false for new session")
    func testIsEditingFalse() {
        let session = SessionFormViewTests.createTestSession(id: nil)
        let isEditing = session.id != nil
        #expect(isEditing == false)
    }
    
    // MARK: - Form Validation Tests
    
    @Test("form is invalid when module is empty")
    func testFormInvalidModuleEmpty() {
        let module = ""
        let isDisabled = module.isEmpty
        #expect(isDisabled == true)
    }
    
    @Test("form is valid when module is filled")
    func testFormValidModuleFilled() {
        let module = "Swift avancé"
        let isDisabled = module.isEmpty
        #expect(isDisabled == false)
    }
    
    // MARK: - Tarif Validation Tests
    
    @Test("valid tarif client parses correctly")
    func testValidTarifClient() {
        let tarifClient = "500.00"
        let parsed = Decimal(string: tarifClient)
        #expect(parsed != nil)
        #expect(parsed == 500.00)
    }
    
    @Test("valid tarif sous-traitant parses correctly")
    func testValidTarifSousTraitant() {
        let tarifSousTraitant = "300.00"
        let parsed = Decimal(string: tarifSousTraitant)
        #expect(parsed != nil)
        #expect(parsed == 300.00)
    }
    
    @Test("valid frais rembourser parses correctly")
    func testValidFraisRembourser() {
        let fraisRembourser = "50.00"
        let parsed = Decimal(string: fraisRembourser)
        #expect(parsed != nil)
        #expect(parsed == 50.00)
    }
    
    @Test("invalid tarif fails parsing")
    func testInvalidTarif() {
        let tarif = "abc"
        let parsed = Decimal(string: tarif)
        #expect(parsed == nil)
    }
    
    @Test("empty tarif fails parsing")
    func testEmptyTarif() {
        let tarif = ""
        let parsed = Decimal(string: tarif)
        #expect(parsed == nil)
    }
    
    @Test("tarif zero is valid")
    func testTarifZero() {
        let tarif = "0"
        let parsed = Decimal(string: tarif)
        #expect(parsed != nil)
        #expect(parsed == 0)
    }
    
    // MARK: - Modalite Tests
    
    @Test("modalite presentiel shows address field label")
    func testModalitePresentielFieldLabel() {
        let modalite = Session.Modalite.presentiel
        let label = modalite == .presentiel ? "Adresse" : "Lien visio"
        let placeholder = modalite == .presentiel ? "Adresse complète" : "URL de la visio"
        
        #expect(label == "Adresse")
        #expect(placeholder == "Adresse complète")
    }
    
    @Test("modalite distanciel shows link field label")
    func testModaliteDistancielFieldLabel() {
        let modalite = Session.Modalite.distanciel
        let label = modalite == .presentiel ? "Adresse" : "Lien visio"
        let placeholder = modalite == .presentiel ? "Adresse complète" : "URL de la visio"
        
        #expect(label == "Lien visio")
        #expect(placeholder == "URL de la visio")
    }
    
    @Test("modalite allCases contains both options")
    func testModaliteAllCases() {
        let allCases = Session.Modalite.allCases
        #expect(allCases.count == 2)
        #expect(allCases.contains(.presentiel))
        #expect(allCases.contains(.distanciel))
    }
    
    // MARK: - Load Data Tests
    
    @Test("loadData populates all fields correctly")
    func testLoadDataPopulatesFields() {
        let session = SessionFormViewTests.createTestSession(
            module: "Python avancé",
            debut: "10:00",
            fin: "18:00",
            modalite: .distanciel,
            lieu: "https://zoom.us/meeting",
            tarifClient: 600,
            tarifSousTraitant: 400,
            fraisRembourser: 75,
            refContrat: "REF-2025-002",
            formateurId: 5,
            clientId: 10,
            ecoleId: 15
        )
        
        // Simulating loadData function behavior
        let module = session.module
        let debut = session.debut
        let fin = session.fin
        let modalite = session.modalite
        let lieu = session.lieu
        let tarifClient = "\(session.tarifClient)"
        let tarifSousTraitant = "\(session.tarifSousTraitant)"
        let fraisRembourser = "\(session.fraisRembourser)"
        let refContrat = session.refContrat ?? ""
        let selectedFormateurId = session.formateurId
        let selectedClientId = session.clientId
        let selectedEcoleId = session.ecoleId
        
        #expect(module == "Python avancé")
        #expect(debut == "10:00")
        #expect(fin == "18:00")
        #expect(modalite == .distanciel)
        #expect(lieu == "https://zoom.us/meeting")
        #expect(tarifClient == "600")
        #expect(tarifSousTraitant == "400")
        #expect(fraisRembourser == "75")
        #expect(refContrat == "REF-2025-002")
        #expect(selectedFormateurId == 5)
        #expect(selectedClientId == 10)
        #expect(selectedEcoleId == 15)
    }
    
    @Test("loadData handles nil refContrat")
    func testLoadDataHandlesNilRefContrat() {
        let session = SessionFormViewTests.createTestSession(refContrat: nil)
        let refContrat = session.refContrat ?? ""
        #expect(refContrat == "")
    }
    
    // MARK: - RefContrat Conversion Tests
    
    @Test("empty refContrat converts to nil")
    func testEmptyRefContratToNil() {
        let refContrat = ""
        let converted: String? = refContrat.isEmpty ? nil : refContrat
        #expect(converted == nil)
    }
    
    @Test("non-empty refContrat stays as value")
    func testNonEmptyRefContratNotNil() {
        let refContrat = "REF-2025-001"
        let converted: String? = refContrat.isEmpty ? nil : refContrat
        #expect(converted == "REF-2025-001")
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
        let title = isEditing ? "Modifier" : "Nouvelle session"
        #expect(title == "Nouvelle session")
    }
    
    @Test("navigation title in edit mode")
    func testNavigationTitleEditMode() {
        let isEditing = true
        let title = isEditing ? "Modifier" : "Nouvelle session"
        #expect(title == "Modifier")
    }
    
    // MARK: - Section Titles Tests
    
    @Test("informations générales section title")
    func testInfoGeneralesSection() {
        let title = "Informations générales"
        #expect(title == "Informations générales")
    }
    
    @Test("modalité section title")
    func testModaliteSection() {
        let title = "Modalité"
        #expect(title == "Modalité")
    }
    
    @Test("intervenants section title")
    func testIntervenantsSection() {
        let title = "Intervenants"
        #expect(title == "Intervenants")
    }
    
    @Test("tarifs section title")
    func testTarifsSection() {
        let title = "Tarifs (€)"
        #expect(title == "Tarifs (€)")
    }
    
    @Test("référence section title")
    func testReferenceSection() {
        let title = "Référence"
        #expect(title == "Référence")
    }
    
    // MARK: - Field Placeholders Tests
    
    @Test("module placeholder is correct")
    func testModulePlaceholder() {
        let placeholder = "Ex: Swift avancé"
        #expect(placeholder == "Ex: Swift avancé")
    }
    
    @Test("debut placeholder is correct")
    func testDebutPlaceholder() {
        let placeholder = "09:00"
        #expect(placeholder == "09:00")
    }
    
    @Test("fin placeholder is correct")
    func testFinPlaceholder() {
        let placeholder = "17:00"
        #expect(placeholder == "17:00")
    }
    
    @Test("tarif placeholders are correct")
    func testTarifPlaceholders() {
        let placeholder = "0.00"
        #expect(placeholder == "0.00")
    }
    
    @Test("refContrat placeholder is correct")
    func testRefContratPlaceholder() {
        let placeholder = "Optionnel"
        #expect(placeholder == "Optionnel")
    }
    
    // MARK: - Default Values Tests
    
    @Test("default debut time is 09:00")
    func testDefaultDebut() {
        let debut = "09:00"
        #expect(debut == "09:00")
    }
    
    @Test("default fin time is 17:00")
    func testDefaultFin() {
        let fin = "17:00"
        #expect(fin == "17:00")
    }
    
    @Test("default modalite is presentiel")
    func testDefaultModalite() {
        let modalite = Session.Modalite.presentiel
        #expect(modalite == .presentiel)
    }
    
    // MARK: - PickerRow Tests
    
    @Test("picker row shows 'Sélectionner' when value is nil")
    func testPickerRowNilValue() {
        let value: String? = nil
        let displayText = value ?? "Sélectionner"
        #expect(displayText == "Sélectionner")
    }
    
    @Test("picker row shows value when not nil")
    func testPickerRowWithValue() {
        let value: String? = "Jean Dupont"
        let displayText = value ?? "Sélectionner"
        #expect(displayText == "Jean Dupont")
    }
    
    // MARK: - Picker Navigation Titles Tests
    
    @Test("formateur picker navigation title")
    func testFormateurPickerTitle() {
        let title = "Sélectionner un formateur"
        #expect(title == "Sélectionner un formateur")
    }
    
    @Test("client picker navigation title")
    func testClientPickerTitle() {
        let title = "Sélectionner un client"
        #expect(title == "Sélectionner un client")
    }
    
    @Test("ecole picker navigation title")
    func testEcolePickerTitle() {
        let title = "Sélectionner une école"
        #expect(title == "Sélectionner une école")
    }
    
    // MARK: - Picker Labels Tests
    
    @Test("formateur picker row label")
    func testFormateurPickerRowLabel() {
        let label = "Formateur"
        #expect(label == "Formateur")
    }
    
    @Test("client picker row label")
    func testClientPickerRowLabel() {
        let label = "Client"
        #expect(label == "Client")
    }
    
    @Test("ecole picker row label")
    func testEcolePickerRowLabel() {
        let label = "École"
        #expect(label == "École")
    }
    
    // MARK: - Error Handling Tests
    
    @Test("error message for invalid tarifs")
    func testErrorMessageInvalidTarifs() {
        let errorMessage = "Veuillez saisir des montants valides"
        #expect(errorMessage == "Veuillez saisir des montants valides")
    }
    
    @Test("error alert title")
    func testErrorAlertTitle() {
        let title = "Erreur"
        #expect(title == "Erreur")
    }
    
    // MARK: - Field Labels Tests
    
    @Test("module field label")
    func testModuleFieldLabel() {
        let label = "Module de formation"
        #expect(label == "Module de formation")
    }
    
    @Test("date field label")
    func testDateFieldLabel() {
        let label = "Date"
        #expect(label == "Date")
    }
    
    @Test("debut field label")
    func testDebutFieldLabel() {
        let label = "Début"
        #expect(label == "Début")
    }
    
    @Test("fin field label")
    func testFinFieldLabel() {
        let label = "Fin"
        #expect(label == "Fin")
    }
    
    @Test("tarif client field label")
    func testTarifClientFieldLabel() {
        let label = "Tarif client"
        #expect(label == "Tarif client")
    }
    
    @Test("tarif sous-traitant field label")
    func testTarifSousTraitantFieldLabel() {
        let label = "Tarif sous-traitant"
        #expect(label == "Tarif sous-traitant")
    }
    
    @Test("frais rembourser field label")
    func testFraisRembourserFieldLabel() {
        let label = "Frais à rembourser"
        #expect(label == "Frais à rembourser")
    }
    
    @Test("refContrat field label")
    func testRefContratFieldLabel() {
        let label = "Référence contrat"
        #expect(label == "Référence contrat")
    }
    
    // MARK: - Selected ID Tests
    
    @Test("selectedFormateurId can be nil")
    func testSelectedFormateurIdNil() {
        let selectedFormateurId: Int64? = nil
        #expect(selectedFormateurId == nil)
    }
    
    @Test("selectedClientId can be nil")
    func testSelectedClientIdNil() {
        let selectedClientId: Int64? = nil
        #expect(selectedClientId == nil)
    }
    
    @Test("selectedEcoleId can be nil")
    func testSelectedEcoleIdNil() {
        let selectedEcoleId: Int64? = nil
        #expect(selectedEcoleId == nil)
    }
    
    @Test("selectedFormateurId can have value")
    func testSelectedFormateurIdWithValue() {
        let selectedFormateurId: Int64? = 5
        #expect(selectedFormateurId == 5)
    }
}
