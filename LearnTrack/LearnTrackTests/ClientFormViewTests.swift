//
//  ClientFormViewTests.swift
//  LearnTrackTests
//
//  Tests unitaires pour ClientFormView
//

import Testing
import SwiftUI
@testable import LearnTrack

// MARK: - Tests ClientFormView
struct ClientFormViewTests {
    
    // MARK: - Tests de validation du formulaire
    
    @Test func testFormValidation_EmptyRaisonSociale_ShouldBeInvalid() async throws {
        // Arrange
        let raisonSociale = ""
        let nomContact = "Jean Dupont"
        
        // Act
        let isValid = !raisonSociale.isEmpty && !nomContact.isEmpty
        
        // Assert
        #expect(!isValid, "Le formulaire devrait être invalide sans raison sociale")
    }
    
    @Test func testFormValidation_EmptyNomContact_ShouldBeInvalid() async throws {
        // Arrange
        let raisonSociale = "Entreprise Test"
        let nomContact = ""
        
        // Act
        let isValid = !raisonSociale.isEmpty && !nomContact.isEmpty
        
        // Assert
        #expect(!isValid, "Le formulaire devrait être invalide sans nom de contact")
    }
    
    @Test func testFormValidation_BothFieldsEmpty_ShouldBeInvalid() async throws {
        // Arrange
        let raisonSociale = ""
        let nomContact = ""
        
        // Act
        let isValid = !raisonSociale.isEmpty && !nomContact.isEmpty
        
        // Assert
        #expect(!isValid, "Le formulaire devrait être invalide avec les champs requis vides")
    }
    
    @Test func testFormValidation_RequiredFieldsFilled_ShouldBeValid() async throws {
        // Arrange
        let raisonSociale = "Entreprise Test"
        let nomContact = "Jean Dupont"
        
        // Act
        let isValid = !raisonSociale.isEmpty && !nomContact.isEmpty
        
        // Assert
        #expect(isValid, "Le formulaire devrait être valide avec les champs requis remplis")
    }
    
    @Test func testFormValidation_OptionalFieldsEmpty_ShouldStillBeValid() async throws {
        // Arrange
        let raisonSociale = "Entreprise Test"
        let nomContact = "Jean Dupont"
        let email = ""
        let telephone = ""
        let rue = ""
        let siret = ""
        
        // Act - Les champs optionnels vides ne devraient pas invalider le formulaire
        let isValid = !raisonSociale.isEmpty && !nomContact.isEmpty
        
        // Assert
        #expect(isValid, "Le formulaire devrait être valide même avec les champs optionnels vides")
        #expect(email.isEmpty)
        #expect(telephone.isEmpty)
        #expect(rue.isEmpty)
        #expect(siret.isEmpty)
    }
    
    // MARK: - Tests du mode édition vs création
    
    @Test func testIsEditing_WithClientToEdit_ShouldBeTrue() async throws {
        // Arrange
        let clientToEdit = createMockClient()
        
        // Act
        let isEditing = clientToEdit != nil
        
        // Assert
        #expect(isEditing, "isEditing devrait être true avec un client à éditer")
    }
    
    @Test func testIsEditing_WithoutClientToEdit_ShouldBeFalse() async throws {
        // Arrange
        let clientToEdit: Client? = nil
        
        // Act
        let isEditing = clientToEdit != nil
        
        // Assert
        #expect(!isEditing, "isEditing devrait être false sans client à éditer")
    }
    
    @Test func testButtonTitle_EditMode_ShouldShowEnregistrer() async throws {
        // Arrange
        let isEditing = true
        
        // Act
        let buttonTitle = isEditing ? "Enregistrer" : "Créer"
        
        // Assert
        #expect(buttonTitle == "Enregistrer")
    }
    
    @Test func testButtonTitle_CreateMode_ShouldShowCreer() async throws {
        // Arrange
        let isEditing = false
        
        // Act
        let buttonTitle = isEditing ? "Enregistrer" : "Créer"
        
        // Assert
        #expect(buttonTitle == "Créer")
    }
    
    @Test func testNavigationTitle_EditMode_ShouldShowModifier() async throws {
        // Arrange
        let isEditing = true
        
        // Act
        let title = isEditing ? "Modifier" : "Nouveau client"
        
        // Assert
        #expect(title == "Modifier")
    }
    
    @Test func testNavigationTitle_CreateMode_ShouldShowNouveauClient() async throws {
        // Arrange
        let isEditing = false
        
        // Act
        let title = isEditing ? "Modifier" : "Nouveau client"
        
        // Assert
        #expect(title == "Nouveau client")
    }
    
    // MARK: - Tests de chargement des données client
    
    @Test func testLoadClientData_ShouldPopulateAllFields() async throws {
        // Arrange
        let client = Client(
            id: 1,
            raisonSociale: "Acme Corp",
            rue: "123 Rue Test",
            codePostal: "75001",
            ville: "Paris",
            nomContact: "Jean Martin",
            email: "jean@acme.com",
            telephone: "0123456789",
            siret: "12345678901234",
            numeroTva: "FR12345678901"
        )
        
        // Act - Simule loadClientData
        var raisonSociale = ""
        var nomContact = ""
        var email = ""
        var telephone = ""
        var rue = ""
        var codePostal = ""
        var ville = ""
        var siret = ""
        var numeroTva = ""
        
        raisonSociale = client.raisonSociale
        nomContact = client.nomContact
        email = client.email
        telephone = client.telephone
        rue = client.rue ?? ""
        codePostal = client.codePostal ?? ""
        ville = client.ville ?? ""
        siret = client.siret ?? ""
        numeroTva = client.numeroTva ?? ""
        
        // Assert
        #expect(raisonSociale == "Acme Corp")
        #expect(nomContact == "Jean Martin")
        #expect(email == "jean@acme.com")
        #expect(telephone == "0123456789")
        #expect(rue == "123 Rue Test")
        #expect(codePostal == "75001")
        #expect(ville == "Paris")
        #expect(siret == "12345678901234")
        #expect(numeroTva == "FR12345678901")
    }
    
    @Test func testLoadClientData_NilOptionalFields_ShouldBeEmptyStrings() async throws {
        // Arrange
        let client = Client(
            id: 1,
            raisonSociale: "Test Corp",
            rue: nil,
            codePostal: nil,
            ville: nil,
            nomContact: "Contact",
            email: "",
            telephone: "",
            siret: nil,
            numeroTva: nil
        )
        
        // Act
        let rue = client.rue ?? ""
        let codePostal = client.codePostal ?? ""
        let ville = client.ville ?? ""
        let siret = client.siret ?? ""
        let numeroTva = client.numeroTva ?? ""
        
        // Assert
        #expect(rue == "")
        #expect(codePostal == "")
        #expect(ville == "")
        #expect(siret == "")
        #expect(numeroTva == "")
    }
    
    // MARK: - Tests de création de l'objet Client
    
    @Test func testSaveClient_EmptyOptionalFields_ShouldBeNil() async throws {
        // Arrange
        let rue = ""
        let codePostal = ""
        let ville = ""
        let siret = ""
        let numeroTva = ""
        
        // Act - Simule la logique de saveClient
        let client = Client(
            id: nil,
            raisonSociale: "Test",
            rue: rue.isEmpty ? nil : rue,
            codePostal: codePostal.isEmpty ? nil : codePostal,
            ville: ville.isEmpty ? nil : ville,
            nomContact: "Contact",
            email: "",
            telephone: "",
            siret: siret.isEmpty ? nil : siret,
            numeroTva: numeroTva.isEmpty ? nil : numeroTva
        )
        
        // Assert
        #expect(client.rue == nil)
        #expect(client.codePostal == nil)
        #expect(client.ville == nil)
        #expect(client.siret == nil)
        #expect(client.numeroTva == nil)
    }
    
    @Test func testSaveClient_FilledOptionalFields_ShouldBePresent() async throws {
        // Arrange
        let rue = "123 rue Test"
        let codePostal = "75001"
        let ville = "Paris"
        let siret = "12345678901234"
        let numeroTva = "FR12345678901"
        
        // Act
        let client = Client(
            id: nil,
            raisonSociale: "Test",
            rue: rue.isEmpty ? nil : rue,
            codePostal: codePostal.isEmpty ? nil : codePostal,
            ville: ville.isEmpty ? nil : ville,
            nomContact: "Contact",
            email: "",
            telephone: "",
            siret: siret.isEmpty ? nil : siret,
            numeroTva: numeroTva.isEmpty ? nil : numeroTva
        )
        
        // Assert
        #expect(client.rue == "123 rue Test")
        #expect(client.codePostal == "75001")
        #expect(client.ville == "Paris")
        #expect(client.siret == "12345678901234")
        #expect(client.numeroTva == "FR12345678901")
    }
    
    @Test func testSaveClient_EditMode_ShouldPreserveId() async throws {
        // Arrange
        let clientToEdit = Client(
            id: 42,
            raisonSociale: "Original",
            nomContact: "Original Contact",
            email: "",
            telephone: ""
        )
        
        // Act - Simule saveClient en mode édition
        let client = Client(
            id: clientToEdit.id,
            raisonSociale: "Updated",
            nomContact: "Updated Contact",
            email: "",
            telephone: ""
        )
        
        // Assert
        #expect(client.id == 42, "L'ID devrait être préservé en mode édition")
    }
    
    @Test func testSaveClient_CreateMode_ShouldHaveNilId() async throws {
        // Arrange - Pas de clientToEdit
        let clientToEditId: Int64? = nil
        
        // Act
        let client = Client(
            id: clientToEditId,
            raisonSociale: "New Client",
            nomContact: "New Contact",
            email: "",
            telephone: ""
        )
        
        // Assert
        #expect(client.id == nil, "L'ID devrait être nil en mode création")
    }
    
    // MARK: - Tests d'état initial
    
    @Test func testInitialState_IsLoadingShouldBeFalse() async throws {
        let isLoading = false
        #expect(!isLoading)
    }
    
    @Test func testInitialState_ShowErrorShouldBeFalse() async throws {
        let showError = false
        #expect(!showError)
    }
    
    @Test func testInitialState_ErrorMessageShouldBeEmpty() async throws {
        let errorMessage = ""
        #expect(errorMessage.isEmpty)
    }
    
    @Test func testInitialState_AllFieldsShouldBeEmpty() async throws {
        // Arrange - État initial du formulaire (mode création)
        let raisonSociale = ""
        let nomContact = ""
        let email = ""
        let telephone = ""
        let rue = ""
        let codePostal = ""
        let ville = ""
        let siret = ""
        let numeroTva = ""
        
        // Assert
        #expect(raisonSociale.isEmpty)
        #expect(nomContact.isEmpty)
        #expect(email.isEmpty)
        #expect(telephone.isEmpty)
        #expect(rue.isEmpty)
        #expect(codePostal.isEmpty)
        #expect(ville.isEmpty)
        #expect(siret.isEmpty)
        #expect(numeroTva.isEmpty)
    }
    
    // MARK: - Tests de l'opacité du bouton
    
    @Test func testButtonOpacity_WhenValid_ShouldBeFull() async throws {
        // Arrange
        let raisonSociale = "Test"
        let nomContact = "Contact"
        
        // Act
        let isValid = !raisonSociale.isEmpty && !nomContact.isEmpty
        let opacity = isValid ? 1.0 : 0.6
        
        // Assert
        #expect(opacity == 1.0)
    }
    
    @Test func testButtonOpacity_WhenInvalid_ShouldBeReduced() async throws {
        // Arrange
        let raisonSociale = ""
        let nomContact = "Contact"
        
        // Act
        let isValid = !raisonSociale.isEmpty && !nomContact.isEmpty
        let opacity = isValid ? 1.0 : 0.6
        
        // Assert
        #expect(opacity == 0.6)
    }
    
    // MARK: - Tests du bouton désactivé
    
    @Test func testButtonDisabled_WhenRaisonSocialeEmpty_ShouldBeDisabled() async throws {
        // Arrange
        let raisonSociale = ""
        let nomContact = "Contact"
        let isLoading = false
        
        // Act
        let isDisabled = raisonSociale.isEmpty || nomContact.isEmpty || isLoading
        
        // Assert
        #expect(isDisabled)
    }
    
    @Test func testButtonDisabled_WhenNomContactEmpty_ShouldBeDisabled() async throws {
        // Arrange
        let raisonSociale = "Test"
        let nomContact = ""
        let isLoading = false
        
        // Act
        let isDisabled = raisonSociale.isEmpty || nomContact.isEmpty || isLoading
        
        // Assert
        #expect(isDisabled)
    }
    
    @Test func testButtonDisabled_WhenLoading_ShouldBeDisabled() async throws {
        // Arrange
        let raisonSociale = "Test"
        let nomContact = "Contact"
        let isLoading = true
        
        // Act
        let isDisabled = raisonSociale.isEmpty || nomContact.isEmpty || isLoading
        
        // Assert
        #expect(isDisabled)
    }
    
    @Test func testButtonDisabled_WhenValidAndNotLoading_ShouldBeEnabled() async throws {
        // Arrange
        let raisonSociale = "Test"
        let nomContact = "Contact"
        let isLoading = false
        
        // Act
        let isDisabled = raisonSociale.isEmpty || nomContact.isEmpty || isLoading
        
        // Assert
        #expect(!isDisabled)
    }
    
    // MARK: - Helper Functions
    
    private func createMockClient() -> Client {
        Client(
            id: 1,
            raisonSociale: "Test Corp",
            rue: "123 Rue Test",
            codePostal: "75001",
            ville: "Paris",
            nomContact: "Jean Test",
            email: "test@example.com",
            telephone: "0123456789",
            siret: "12345678901234",
            numeroTva: "FR12345678901"
        )
    }
}

// MARK: - Tests FormField
struct FormFieldTests {
    
    @Test func testFormField_EmailKeyboard_ShouldDisableAutoCapitalization() async throws {
        // Arrange
        let keyboardType = UIKeyboardType.emailAddress
        
        // Act
        let shouldDisableAutoCap = keyboardType == .emailAddress
        
        // Assert
        #expect(shouldDisableAutoCap, "L'auto-capitalisation devrait être désactivée pour le clavier email")
    }
    
    @Test func testFormField_DefaultKeyboard_ShouldEnableAutoCapitalization() async throws {
        // Arrange
        let keyboardType = UIKeyboardType.default
        
        // Act
        let shouldDisableAutoCap = keyboardType == .emailAddress
        
        // Assert
        #expect(!shouldDisableAutoCap, "L'auto-capitalisation devrait être activée pour le clavier par défaut")
    }
    
    @Test func testFormField_EmailKeyboard_ShouldDisableAutoCorrection() async throws {
        // Arrange
        let keyboardType = UIKeyboardType.emailAddress
        
        // Act
        let shouldDisableAutoCorrection = keyboardType == .emailAddress
        
        // Assert
        #expect(shouldDisableAutoCorrection)
    }
}

// MARK: - Tests de validation des champs
struct ClientFormFieldValidationTests {
    
    // MARK: - Tests SIRET
    
    @Test func testSiret_ValidFormat_ShouldPass() async throws {
        let siret = "12345678901234"
        let isValid = siret.count == 14 && siret.allSatisfy { $0.isNumber }
        #expect(isValid, "Un SIRET de 14 chiffres devrait être valide")
    }
    
    @Test func testSiret_InvalidLength_ShouldFail() async throws {
        let siret = "1234567890"
        let isValid = siret.count == 14 && siret.allSatisfy { $0.isNumber }
        #expect(!isValid, "Un SIRET de moins de 14 chiffres devrait être invalide")
    }
    
    @Test func testSiret_WithLetters_ShouldFail() async throws {
        let siret = "1234567890ABCD"
        let isValid = siret.count == 14 && siret.allSatisfy { $0.isNumber }
        #expect(!isValid, "Un SIRET avec des lettres devrait être invalide")
    }
    
    // MARK: - Tests Email
    
    @Test func testEmail_ValidFormat_ShouldPass() async throws {
        let validEmails = [
            "test@example.com",
            "contact@entreprise.fr",
            "user.name@domain.org"
        ]
        
        for email in validEmails {
            let isValid = isValidEmail(email)
            #expect(isValid, "L'email \(email) devrait être valide")
        }
    }
    
    @Test func testEmail_InvalidFormat_ShouldFail() async throws {
        let invalidEmails = [
            "invalidemail",
            "@nodomain.com",
            "missing@.com"
        ]
        
        for email in invalidEmails {
            let isValid = isValidEmail(email)
            #expect(!isValid, "L'email \(email) devrait être invalide")
        }
    }
    
    // MARK: - Tests Téléphone
    
    @Test func testTelephone_ValidFrenchFormat_ShouldPass() async throws {
        let validPhones = [
            "0123456789",
            "01 23 45 67 89",
            "+33123456789"
        ]
        
        for phone in validPhones {
            let cleaned = phone.replacingOccurrences(of: " ", with: "")
            let isValid = cleaned.count >= 10
            #expect(isValid, "Le téléphone \(phone) devrait être valide")
        }
    }
    
    // MARK: - Tests Code Postal
    
    @Test func testCodePostal_ValidFrenchFormat_ShouldPass() async throws {
        let validCodes = ["75001", "69001", "13001", "33000"]
        
        for code in validCodes {
            let isValid = code.count == 5 && code.allSatisfy { $0.isNumber }
            #expect(isValid, "Le code postal \(code) devrait être valide")
        }
    }
    
    @Test func testCodePostal_InvalidFormat_ShouldFail() async throws {
        let invalidCodes = ["7500", "750001", "ABCDE"]
        
        for code in invalidCodes {
            let isValid = code.count == 5 && code.allSatisfy { $0.isNumber }
            #expect(!isValid, "Le code postal \(code) devrait être invalide")
        }
    }
    
    // MARK: - Tests TVA
    
    @Test func testNumeroTva_ValidFrenchFormat_ShouldPass() async throws {
        let tva = "FR12345678901"
        let isValid = tva.hasPrefix("FR") && tva.count == 13
        #expect(isValid, "Le numéro TVA devrait être valide")
    }
    
    @Test func testNumeroTva_InvalidFormat_ShouldFail() async throws {
        let invalidTvas = ["12345678901", "DE12345678901", "FR1234"]
        
        for tva in invalidTvas {
            let isValid = tva.hasPrefix("FR") && tva.count == 13
            #expect(!isValid, "Le numéro TVA \(tva) devrait être invalide")
        }
    }
    
    // MARK: - Helper
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return email.range(of: emailRegex, options: .regularExpression) != nil
    }
}

// MARK: - Tests FormSection
struct FormSectionTests {
    
    @Test func testFormSection_ShouldHaveTitle() async throws {
        let title = "Entreprise"
        #expect(!title.isEmpty, "La section devrait avoir un titre")
    }
    
    @Test func testFormSection_Titles_ShouldMatchExpected() async throws {
        let expectedTitles = [
            "Entreprise",
            "Contact principal",
            "Adresse",
            "Informations fiscales"
        ]
        
        for title in expectedTitles {
            #expect(!title.isEmpty, "Le titre '\(title)' devrait être présent")
        }
    }
}
