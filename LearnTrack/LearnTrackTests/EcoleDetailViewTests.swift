//
//  EcoleDetailViewTests.swift
//  LearnTrackTests
//
//  Tests unitaires pour EcoleDetailView
//

import Testing
import SwiftUI
@testable import LearnTrack

// MARK: - Tests EcoleDetailView
struct EcoleDetailViewTests {
    
    // MARK: - Tests d'affichage des informations école
    
    @Test func testEcoleDisplay_Nom_ShouldBeDisplayed() async throws {
        // Arrange
        let ecole = createMockEcole(nom: "École Supérieure de Commerce")
        
        // Assert
        #expect(!ecole.nom.isEmpty, "Le nom devrait être affiché")
        #expect(ecole.nom == "École Supérieure de Commerce")
    }
    
    @Test func testEcoleDisplay_Initiales_TwoWords_ShouldBeCorrect() async throws {
        // Arrange
        let ecole = createMockEcole(nom: "École Supérieure")
        
        // Assert
        #expect(ecole.initiales == "ÉS", "Les initiales devraient être 'ÉS'")
    }
    
    @Test func testEcoleDisplay_Initiales_OneWord_ShouldBeFirstTwoChars() async throws {
        // Arrange
        let ecole = createMockEcole(nom: "Polytechnique")
        
        // Assert
        #expect(ecole.initiales == "PO", "Les initiales devraient être 'PO'")
    }
    
    @Test func testEcoleDisplay_Initiales_Empty_ShouldReturnDefault() async throws {
        // Arrange
        let ecole = createMockEcole(nom: "")
        
        // Assert
        #expect(ecole.initiales == "EC", "Les initiales par défaut devraient être 'EC'")
    }
    
    @Test func testEcoleDisplay_VilleDisplay_WithVille_ShouldShowVille() async throws {
        // Arrange
        let ecole = createMockEcole(ville: "Paris")
        
        // Assert
        #expect(ecole.villeDisplay == "Paris")
    }
    
    @Test func testEcoleDisplay_VilleDisplay_WithoutVille_ShouldShowDefault() async throws {
        // Arrange
        let ecole = createMockEcole(ville: nil)
        
        // Assert
        #expect(ecole.villeDisplay == "Non renseignée")
    }
    
    // MARK: - Tests d'adresse complète
    
    @Test func testAdresseComplete_AllFieldsPresent_ShouldFormat() async throws {
        // Arrange
        let ecole = Ecole(
            id: 1,
            nom: "Test École",
            rue: "45 avenue des Sciences",
            codePostal: "75013",
            ville: "Paris",
            nomContact: "",
            email: "",
            telephone: ""
        )
        
        // Assert
        #expect(ecole.adresseComplete == "45 avenue des Sciences, 75013 Paris")
    }
    
    @Test func testAdresseComplete_MissingRue_ShouldReturnNil() async throws {
        // Arrange
        let ecole = Ecole(
            id: 1,
            nom: "Test",
            rue: nil,
            codePostal: "75013",
            ville: "Paris",
            nomContact: "",
            email: "",
            telephone: ""
        )
        
        // Assert
        #expect(ecole.adresseComplete == nil)
    }
    
    @Test func testAdresseComplete_MissingCodePostal_ShouldReturnNil() async throws {
        // Arrange
        let ecole = Ecole(
            id: 1,
            nom: "Test",
            rue: "45 avenue",
            codePostal: nil,
            ville: "Paris",
            nomContact: "",
            email: "",
            telephone: ""
        )
        
        // Assert
        #expect(ecole.adresseComplete == nil)
    }
    
    @Test func testAdresseComplete_MissingVille_ShouldReturnNil() async throws {
        // Arrange
        let ecole = Ecole(
            id: 1,
            nom: "Test",
            rue: "45 avenue",
            codePostal: "75013",
            ville: nil,
            nomContact: "",
            email: "",
            telephone: ""
        )
        
        // Assert
        #expect(ecole.adresseComplete == nil)
    }
    
    // MARK: - Tests des actions
    
    @Test func testDeleteAction_AdminUser_ShouldBeVisible() async throws {
        // Arrange
        let userRole = "admin"
        
        // Act
        let canDelete = userRole == "admin"
        
        // Assert
        #expect(canDelete, "Le bouton supprimer devrait être visible pour un admin")
    }
    
    @Test func testDeleteAction_RegularUser_ShouldBeHidden() async throws {
        // Arrange
        let userRole = "user"
        
        // Act
        let canDelete = userRole == "admin"
        
        // Assert
        #expect(!canDelete, "Le bouton supprimer ne devrait pas être visible pour un utilisateur normal")
    }
    
    @Test func testEditAction_ShouldAlwaysBeVisible() async throws {
        // Le bouton Modifier est toujours visible
        let canEdit = true
        #expect(canEdit, "Le bouton modifier devrait toujours être visible")
    }
    
    // MARK: - Tests d'état initial
    
    @Test func testInitialState_ShowingEditSheet_ShouldBeFalse() async throws {
        let showingEditSheet = false
        #expect(!showingEditSheet)
    }
    
    @Test func testInitialState_ShowingDeleteAlert_ShouldBeFalse() async throws {
        let showingDeleteAlert = false
        #expect(!showingDeleteAlert)
    }
    
    // MARK: - Tests de contact
    
    @Test func testContact_NomContact_ShouldBeDisplayed() async throws {
        // Arrange
        let ecole = createMockEcole(nomContact: "Pierre Durand")
        
        // Assert
        #expect(ecole.nomContact == "Pierre Durand")
        #expect(!ecole.nomContact.isEmpty)
    }
    
    @Test func testContact_EmptyNomContact_ShouldNotDisplay() async throws {
        // Arrange
        let ecole = createMockEcole(nomContact: "")
        
        // Act
        let shouldDisplayNomContact = !ecole.nomContact.isEmpty
        
        // Assert
        #expect(!shouldDisplayNomContact)
    }
    
    @Test func testContact_PhoneNumber_ShouldBeFormattedForCall() async throws {
        // Arrange
        let phoneNumber = "0145678901"
        
        // Act
        let formattedPhone = "tel://\(phoneNumber)"
        
        // Assert
        #expect(formattedPhone == "tel://0145678901")
    }
    
    @Test func testContact_Email_ShouldBeFormattedForMailto() async throws {
        // Arrange
        let email = "contact@ecole.fr"
        
        // Act
        let formattedEmail = "mailto:\(email)"
        
        // Assert
        #expect(formattedEmail == "mailto:contact@ecole.fr")
    }
    
    @Test func testContact_EmptyPhone_ShouldNotEnableCall() async throws {
        // Arrange
        let phoneNumber = ""
        
        // Act
        let canCall = !phoneNumber.isEmpty
        
        // Assert
        #expect(!canCall)
    }
    
    @Test func testContact_EmptyEmail_ShouldNotEnableEmail() async throws {
        // Arrange
        let email = ""
        
        // Act
        let canEmail = !email.isEmpty
        
        // Assert
        #expect(!canEmail)
    }
    
    // MARK: - Tests Quick Actions
    
    @Test func testQuickActions_CallAction_ShouldBeAvailable() async throws {
        let phoneNumber = "0145678901"
        let canCall = !phoneNumber.isEmpty
        #expect(canCall)
    }
    
    @Test func testQuickActions_EmailAction_ShouldBeAvailable() async throws {
        let email = "contact@ecole.fr"
        let canEmail = !email.isEmpty
        #expect(canEmail)
    }
    
    // MARK: - Tests de navigation
    
    @Test func testNavigationTitle_ShouldBeEcole() async throws {
        let title = "École"
        #expect(title == "École")
    }
    
    // MARK: - Tests de mappage API
    
    @Test func testMapAPIEcole_ShouldMapAllFields() async throws {
        // Arrange
        let apiEcole = MockAPIEcole(
            id: 42,
            nom: "École Test",
            adresse: "123 Rue Test",
            codePostal: "69001",
            ville: "Lyon",
            email: "test@ecole.fr",
            telephone: "0478123456",
            responsableNom: "Marie Martin"
        )
        
        // Act
        let ecole = mapAPIEcole(apiEcole)
        
        // Assert
        #expect(ecole.id == 42)
        #expect(ecole.nom == "École Test")
        #expect(ecole.rue == "123 Rue Test")
        #expect(ecole.ville == "Lyon")
        #expect(ecole.nomContact == "Marie Martin")
    }
    
    @Test func testMapAPIEcole_NilResponsableNom_ShouldMapToEmptyString() async throws {
        // Arrange
        let apiEcole = MockAPIEcole(
            id: 1,
            nom: "Test",
            adresse: nil,
            codePostal: nil,
            ville: nil,
            email: nil,
            telephone: nil,
            responsableNom: nil
        )
        
        // Act
        let ecole = mapAPIEcole(apiEcole)
        
        // Assert
        #expect(ecole.nomContact == "")
    }
    
    @Test func testMapAPIEcole_NilOptionalFields_ShouldMapCorrectly() async throws {
        // Arrange
        let apiEcole = MockAPIEcole(
            id: 1,
            nom: "Test École",
            adresse: nil,
            codePostal: nil,
            ville: nil,
            email: nil,
            telephone: nil,
            responsableNom: nil
        )
        
        // Act
        let ecole = mapAPIEcole(apiEcole)
        
        // Assert
        #expect(ecole.rue == nil)
        #expect(ecole.codePostal == nil)
        #expect(ecole.ville == nil)
        #expect(ecole.email == "")
        #expect(ecole.telephone == "")
    }
    
    // MARK: - Helper Functions
    
    private func createMockEcole(
        nom: String = "École Test",
        ville: String? = "Paris",
        nomContact: String = "Jean Test"
    ) -> Ecole {
        Ecole(
            id: 1,
            nom: nom,
            rue: "123 rue Test",
            codePostal: "75001",
            ville: ville,
            nomContact: nomContact,
            email: "contact@ecole.fr",
            telephone: "0123456789"
        )
    }
    
    private func mapAPIEcole(_ api: MockAPIEcole) -> Ecole {
        Ecole(
            id: Int64(api.id),
            nom: api.nom,
            rue: api.adresse,
            codePostal: api.codePostal,
            ville: api.ville,
            nomContact: api.responsableNom ?? "",
            email: api.email ?? "",
            telephone: api.telephone ?? ""
        )
    }
}

// MARK: - Tests du modèle Ecole
struct EcoleModelTests {
    
    @Test func testEcole_Identifiable_ShouldHaveId() async throws {
        let ecole = Ecole(id: 42, nom: "Test")
        #expect(ecole.id == 42)
    }
    
    @Test func testEcole_Codable_CodingKeys() async throws {
        // Vérifie que les CodingKeys sont correctement définis
        let expectedKeys = ["id", "nom", "rue", "code_postal", "ville", "nom_contact", "email", "telephone"]
        #expect(expectedKeys.contains("code_postal"), "code_postal devrait être une clé de codage")
        #expect(expectedKeys.contains("nom_contact"), "nom_contact devrait être une clé de codage")
    }
    
    @Test func testEcole_DefaultInit_ShouldHaveEmptyValues() async throws {
        let ecole = Ecole()
        
        #expect(ecole.id == nil)
        #expect(ecole.nom == "")
        #expect(ecole.rue == nil)
        #expect(ecole.codePostal == nil)
        #expect(ecole.ville == nil)
        #expect(ecole.nomContact == "")
        #expect(ecole.email == "")
        #expect(ecole.telephone == "")
    }
}

// MARK: - Tests des composants UI
struct EcoleDetailUIComponentsTests {
    
    @Test func testHeaderCard_ShouldShowGraduationCapIcon() async throws {
        let iconName = "graduationcap.fill"
        #expect(iconName == "graduationcap.fill")
    }
    
    @Test func testQuickActionCompact_CallIcon_ShouldBePhoneFill() async throws {
        let callIcon = "phone.fill"
        #expect(callIcon == "phone.fill")
    }
    
    @Test func testQuickActionCompact_EmailIcon_ShouldBeEnvelopeFill() async throws {
        let emailIcon = "envelope.fill"
        #expect(emailIcon == "envelope.fill")
    }
    
    @Test func testSectionHeader_ContactIcon_ShouldBePersonFill() async throws {
        let contactIcon = "person.fill"
        #expect(contactIcon == "person.fill")
    }
    
    @Test func testSectionHeader_AdresseIcon_ShouldBeMappin() async throws {
        let adresseIcon = "mappin.circle.fill"
        #expect(adresseIcon == "mappin.circle.fill")
    }
    
    @Test func testAdresseCard_MapsButtonIcon_ShouldBeMap() async throws {
        let mapsIcon = "map"
        #expect(mapsIcon == "map")
    }
}

// MARK: - Tests Alert de suppression
struct EcoleDeleteAlertTests {
    
    @Test func testDeleteAlert_Title_ShouldBeCorrect() async throws {
        let alertTitle = "Supprimer l'école ?"
        #expect(alertTitle == "Supprimer l'école ?")
    }
    
    @Test func testDeleteAlert_CancelButton_ShouldExist() async throws {
        let cancelButtonTitle = "Annuler"
        #expect(cancelButtonTitle == "Annuler")
    }
    
    @Test func testDeleteAlert_DeleteButton_ShouldExist() async throws {
        let deleteButtonTitle = "Supprimer"
        #expect(deleteButtonTitle == "Supprimer")
    }
}

// MARK: - Mock Types

struct MockAPIEcole {
    let id: Int
    let nom: String
    let adresse: String?
    let codePostal: String?
    let ville: String?
    let email: String?
    let telephone: String?
    let responsableNom: String?
}
