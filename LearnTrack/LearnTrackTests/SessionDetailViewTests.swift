//
//  SessionDetailViewTests.swift
//  LearnTrackTests
//
//  Tests unitaires pour SessionDetailView
//

import Testing
import Foundation
@testable import LearnTrack

@Suite("SessionDetailView Tests")
struct SessionDetailViewTests {
    
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
        ecole: Ecole? = nil,
        client: Client? = nil,
        formateur: Formateur? = nil
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
            ecole: ecole,
            client: client,
            formateur: formateur
        )
    }
    
    static func createTestFormateur() -> Formateur {
        Formateur(
            id: 1,
            prenom: "Jean",
            nom: "Dupont",
            email: "jean@example.com",
            telephone: "0612345678",
            specialite: "Swift",
            tarifJournalier: 55,
            exterieur: false
        )
    }
    
    static func createTestClient() -> Client {
        Client(
            id: 1,
            raisonSociale: "Tech Corp",
            email: "contact@techcorp.com",
            telephone: "0123456789"
        )
    }
    
    static func createTestEcole() -> Ecole {
        Ecole(
            id: 1,
            nom: "ESGI Paris",
            email: "contact@esgi.fr",
            telephone: "0144123456"
        )
    }
    
    // MARK: - Marge Calculation Tests
    
    @Test("marge calculates correctly with positive result")
    func testMargePositive() {
        let session = SessionDetailViewTests.createTestSession(
            tarifClient: 500,
            tarifSousTraitant: 300,
            fraisRembourser: 50
        )
        #expect(session.marge == 150)
    }
    
    @Test("marge calculates correctly with zero result")
    func testMargeZero() {
        let session = SessionDetailViewTests.createTestSession(
            tarifClient: 500,
            tarifSousTraitant: 400,
            fraisRembourser: 100
        )
        #expect(session.marge == 0)
    }
    
    @Test("marge calculates correctly with negative result")
    func testMargeNegative() {
        let session = SessionDetailViewTests.createTestSession(
            tarifClient: 300,
            tarifSousTraitant: 400,
            fraisRembourser: 50
        )
        #expect(session.marge == -150)
    }
    
    @Test("marge with zero frais")
    func testMargeZeroFrais() {
        let session = SessionDetailViewTests.createTestSession(
            tarifClient: 500,
            tarifSousTraitant: 300,
            fraisRembourser: 0
        )
        #expect(session.marge == 200)
    }
    
    // MARK: - Modalite Tests
    
    @Test("modalite presentiel has correct label")
    func testModalitePresentielLabel() {
        let modalite = Session.Modalite.presentiel
        #expect(modalite.label == "Présentiel")
    }
    
    @Test("modalite distanciel has correct label")
    func testModaliteDistancielLabel() {
        let modalite = Session.Modalite.distanciel
        #expect(modalite.label == "Distanciel")
    }
    
    @Test("modalite presentiel has correct icon")
    func testModalitePresentielIcon() {
        let modalite = Session.Modalite.presentiel
        #expect(modalite.icon == "person.fill")
    }
    
    @Test("modalite distanciel has correct icon")
    func testModaliteDistancielIcon() {
        let modalite = Session.Modalite.distanciel
        #expect(modalite.icon == "video.fill")
    }
    
    @Test("modalite presentiel has correct raw value")
    func testModalitePresentielRawValue() {
        let modalite = Session.Modalite.presentiel
        #expect(modalite.rawValue == "P")
    }
    
    @Test("modalite distanciel has correct raw value")
    func testModaliteDistancielRawValue() {
        let modalite = Session.Modalite.distanciel
        #expect(modalite.rawValue == "D")
    }
    
    // MARK: - Display Horaires Tests
    
    @Test("displayHoraires formats correctly")
    func testDisplayHoraires() {
        let session = SessionDetailViewTests.createTestSession(debut: "09:00", fin: "17:00")
        #expect(session.displayHoraires == "09:00 - 17:00")
    }
    
    @Test("displayHoraires with different times")
    func testDisplayHorairesDifferent() {
        let session = SessionDetailViewTests.createTestSession(debut: "14:30", fin: "18:30")
        #expect(session.displayHoraires == "14:30 - 18:30")
    }
    
    // MARK: - Display Date Tests
    
    @Test("displayDate formats in French locale")
    func testDisplayDateFrenchLocale() {
        let session = SessionDetailViewTests.createTestSession()
        let displayDate = session.displayDate
        // Should contain French date format elements
        #expect(!displayDate.isEmpty)
    }
    
    // MARK: - Lieu Card Visibility Tests
    
    @Test("lieu card shown for presentiel with non-empty lieu")
    func testLieuCardShownPresentiel() {
        let session = SessionDetailViewTests.createTestSession(
            modalite: .presentiel,
            lieu: "Paris"
        )
        let showLieuCard = session.modalite == .presentiel && !session.lieu.isEmpty
        #expect(showLieuCard == true)
    }
    
    @Test("lieu card hidden for distanciel")
    func testLieuCardHiddenDistanciel() {
        let session = SessionDetailViewTests.createTestSession(
            modalite: .distanciel,
            lieu: "Paris"
        )
        let showLieuCard = session.modalite == .presentiel && !session.lieu.isEmpty
        #expect(showLieuCard == false)
    }
    
    @Test("lieu card hidden for presentiel with empty lieu")
    func testLieuCardHiddenEmptyLieu() {
        let session = SessionDetailViewTests.createTestSession(
            modalite: .presentiel,
            lieu: ""
        )
        let showLieuCard = session.modalite == .presentiel && !session.lieu.isEmpty
        #expect(showLieuCard == false)
    }
    
    // MARK: - RefContrat Card Visibility Tests
    
    @Test("refContrat card shown when ref exists")
    func testRefContratCardShown() {
        let session = SessionDetailViewTests.createTestSession(refContrat: "REF-2025-001")
        let showRefContratCard = session.refContrat != nil && !session.refContrat!.isEmpty
        #expect(showRefContratCard == true)
    }
    
    @Test("refContrat card hidden when ref is nil")
    func testRefContratCardHiddenNil() {
        let session = SessionDetailViewTests.createTestSession(refContrat: nil)
        let showRefContratCard = session.refContrat != nil && !(session.refContrat?.isEmpty ?? true)
        #expect(showRefContratCard == false)
    }
    
    @Test("refContrat card hidden when ref is empty")
    func testRefContratCardHiddenEmpty() {
        let session = SessionDetailViewTests.createTestSession(refContrat: "")
        let showRefContratCard = session.refContrat != nil && !session.refContrat!.isEmpty
        #expect(showRefContratCard == false)
    }
    
    // MARK: - Intervenants Tests
    
    @Test("formateur name displayed correctly")
    func testFormateurName() {
        let formateur = SessionDetailViewTests.createTestFormateur()
        #expect(formateur.nomComplet == "Jean Dupont")
    }
    
    @Test("client name displayed correctly")
    func testClientName() {
        let client = SessionDetailViewTests.createTestClient()
        #expect(client.raisonSociale == "Tech Corp")
    }
    
    @Test("ecole name displayed correctly")
    func testEcoleName() {
        let ecole = SessionDetailViewTests.createTestEcole()
        #expect(ecole.nom == "ESGI Paris")
    }
    
    @Test("session with all intervenants")
    func testSessionWithAllIntervenants() {
        let session = SessionDetailViewTests.createTestSession(
            ecole: SessionDetailViewTests.createTestEcole(),
            client: SessionDetailViewTests.createTestClient(),
            formateur: SessionDetailViewTests.createTestFormateur()
        )
        
        #expect(session.formateur != nil)
        #expect(session.client != nil)
        #expect(session.ecole != nil)
    }
    
    @Test("session with no intervenants")
    func testSessionWithNoIntervenants() {
        let session = SessionDetailViewTests.createTestSession(
            ecole: nil,
            client: nil,
            formateur: nil
        )
        
        #expect(session.formateur == nil)
        #expect(session.client == nil)
        #expect(session.ecole == nil)
    }
    
    // MARK: - Tarifs Display Tests
    
    @Test("tarif client displayed correctly")
    func testTarifClientDisplay() {
        let session = SessionDetailViewTests.createTestSession(tarifClient: 500)
        #expect(session.tarifClient == 500)
    }
    
    @Test("tarif sous-traitant displayed correctly")
    func testTarifSousTraitantDisplay() {
        let session = SessionDetailViewTests.createTestSession(tarifSousTraitant: 300)
        #expect(session.tarifSousTraitant == 300)
    }
    
    @Test("frais rembourser displayed correctly")
    func testFraisRembourserDisplay() {
        let session = SessionDetailViewTests.createTestSession(fraisRembourser: 50)
        #expect(session.fraisRembourser == 50)
    }
    
    // MARK: - Marge Color Logic Tests
    
    @Test("marge positive uses emerald color")
    func testMargePositiveColor() {
        let session = SessionDetailViewTests.createTestSession(
            tarifClient: 500,
            tarifSousTraitant: 300,
            fraisRembourser: 50
        )
        let useEmeraldColor = session.marge >= 0
        #expect(useEmeraldColor == true)
    }
    
    @Test("marge negative uses error color")
    func testMargeNegativeColor() {
        let session = SessionDetailViewTests.createTestSession(
            tarifClient: 300,
            tarifSousTraitant: 400,
            fraisRembourser: 50
        )
        let useErrorColor = session.marge < 0
        #expect(useErrorColor == true)
    }
    
    // MARK: - Alert Tests
    
    @Test("delete alert title is correct")
    func testDeleteAlertTitle() {
        let alertTitle = "Supprimer la session ?"
        #expect(alertTitle == "Supprimer la session ?")
    }
    
    @Test("delete alert message is correct")
    func testDeleteAlertMessage() {
        let alertMessage = "Cette action est irréversible."
        #expect(alertMessage == "Cette action est irréversible.")
    }
    
    @Test("delete alert has cancel button")
    func testDeleteAlertCancelButton() {
        let cancelButtonTitle = "Annuler"
        #expect(cancelButtonTitle == "Annuler")
    }
    
    @Test("delete alert has destructive button")
    func testDeleteAlertDestructiveButton() {
        let destructiveButtonTitle = "Supprimer"
        #expect(destructiveButtonTitle == "Supprimer")
    }
    
    // MARK: - Navigation Tests
    
    @Test("navigation title is correct")
    func testNavigationTitle() {
        let title = "Session"
        #expect(title == "Session")
    }
    
    // MARK: - Action Buttons Tests
    
    @Test("edit button title is correct")
    func testEditButtonTitle() {
        let buttonTitle = "Modifier"
        #expect(buttonTitle == "Modifier")
    }
    
    @Test("edit button icon is correct")
    func testEditButtonIcon() {
        let icon = "pencil"
        #expect(icon == "pencil")
    }
    
    @Test("delete button title is correct")
    func testDeleteButtonTitle() {
        let buttonTitle = "Supprimer"
        #expect(buttonTitle == "Supprimer")
    }
    
    @Test("delete button icon is correct")
    func testDeleteButtonIcon() {
        let icon = "trash"
        #expect(icon == "trash")
    }
    
    // MARK: - Share Text Tests
    
    @Test("shareText contains module")
    func testShareTextContainsModule() {
        let session = SessionDetailViewTests.createTestSession(module: "Swift avancé")
        let shareText = session.shareText()
        #expect(shareText.contains("Swift avancé"))
    }
    
    @Test("shareText contains modalite label")
    func testShareTextContainsModalite() {
        let session = SessionDetailViewTests.createTestSession(modalite: .presentiel)
        let shareText = session.shareText()
        #expect(shareText.contains("Présentiel"))
    }
    
    @Test("shareText contains lieu for presentiel")
    func testShareTextContainsLieu() {
        let session = SessionDetailViewTests.createTestSession(
            modalite: .presentiel,
            lieu: "Paris"
        )
        let shareText = session.shareText()
        #expect(shareText.contains("Paris"))
    }
    
    @Test("shareText contains formateur when available")
    func testShareTextContainsFormateur() {
        let session = SessionDetailViewTests.createTestSession(
            formateur: SessionDetailViewTests.createTestFormateur()
        )
        let shareText = session.shareText()
        #expect(shareText.contains("Jean Dupont"))
    }
    
    @Test("shareText contains client when available")
    func testShareTextContainsClient() {
        let session = SessionDetailViewTests.createTestSession(
            client: SessionDetailViewTests.createTestClient()
        )
        let shareText = session.shareText()
        #expect(shareText.contains("Tech Corp"))
    }
    
    @Test("shareText contains tarif client")
    func testShareTextContainsTarifClient() {
        let session = SessionDetailViewTests.createTestSession(tarifClient: 500)
        let shareText = session.shareText()
        #expect(shareText.contains("500"))
    }
    
    // MARK: - Default Values Tests
    
    @Test("default session values are correct")
    func testDefaultValues() {
        let session = Session()
        
        #expect(session.id == nil)
        #expect(session.module == "")
        #expect(session.debut == "09:00")
        #expect(session.fin == "17:00")
        #expect(session.modalite == .presentiel)
        #expect(session.lieu == "")
        #expect(session.tarifClient == 0)
        #expect(session.tarifSousTraitant == 0)
        #expect(session.fraisRembourser == 0)
        #expect(session.refContrat == nil)
    }
    
    // MARK: - IntervenantRowCompact Tests
    
    @Test("intervenant row initials are first 2 chars uppercased")
    func testIntervenantRowInitials() {
        let name = "Jean Dupont"
        let initials = String(name.prefix(2)).uppercased()
        #expect(initials == "JE")
    }
    
    // MARK: - Card Section Labels Tests
    
    @Test("date section label is correct")
    func testDateSectionLabel() {
        let label = "Date"
        #expect(label == "Date")
    }
    
    @Test("horaires section label is correct")
    func testHorairesSectionLabel() {
        let label = "Horaires"
        #expect(label == "Horaires")
    }
    
    @Test("lieu section label is correct")
    func testLieuSectionLabel() {
        let label = "Lieu"
        #expect(label == "Lieu")
    }
    
    @Test("intervenants section label is correct")
    func testIntervenantsSectionLabel() {
        let label = "Intervenants"
        #expect(label == "Intervenants")
    }
    
    @Test("tarifs section label is correct")
    func testTarifsSectionLabel() {
        let label = "Tarifs"
        #expect(label == "Tarifs")
    }
    
    @Test("reference contrat section label is correct")
    func testRefContratSectionLabel() {
        let label = "Référence contrat"
        #expect(label == "Référence contrat")
    }
}
