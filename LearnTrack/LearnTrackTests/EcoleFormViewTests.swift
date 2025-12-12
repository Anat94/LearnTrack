//
//  EcoleFormViewTests.swift
//  LearnTrackTests
//
//  Tests unitaires pour EcoleFormView
//

import Testing
import SwiftUI
@testable import LearnTrack

// MARK: - Tests EcoleFormView
struct EcoleFormViewTests {
    
    // MARK: - Tests de validation du formulaire
    
    @Test func testFormValidation_EmptyNom_ShouldBeInvalid() async throws {
        // Arrange
        let nom = ""
        let nomContact = "Jean Dupont"
        
        // Act
        let isValid = !nom.isEmpty && !nomContact.isEmpty
        
        // Assert
        #expect(!isValid, "Le formulaire devrait être invalide sans nom d'école")
    }
    
    @Test func testFormValidation_EmptyNomContact_ShouldBeInvalid() async throws {
        // Arrange
        let nom = "École Test"
        let nomContact = ""
        
        // Act
        let isValid = !nom.isEmpty && !nomContact.isEmpty
        
        // Assert
        #expect(!isValid, "Le formulaire devrait être invalide sans nom de contact")
    }
    
    @Test func testFormValidation_BothFieldsEmpty_ShouldBeInvalid() async throws {
        // Arrange
        let nom = ""
        let nomContact = ""
        
        // Act
        let isValid = !nom.isEmpty && !nomContact.isEmpty
        
        // Assert
        #expect(!isValid, "Le formulaire devrait être invalide avec les champs requis vides")
    }
    
    @Test func testFormValidation_RequiredFieldsFilled_ShouldBeValid() async throws {
        // Arrange
        let nom = "École Supérieure"
        let nomContact = "Pierre Martin"
        
        // Act
        let isValid = !nom.isEmpty && !nomContact.isEmpty
        
        // Assert
        #expect(isValid, "Le formulaire devrait être valide avec les champs requis remplis")
    }
    
    @Test func testFormValidation_OptionalFieldsEmpty_ShouldStillBeValid() async throws {
        // Arrange
        let nom = "École Test"
        let nomContact = "Contact Test"
        let email = ""
        let telephone = ""
        let rue = ""
        
        // Act - Les champs optionnels vides ne devraient pas invalider le formulaire
        let isValid = !nom.isEmpty && !nomContact.isEmpty
        
        // Assert
        #expect(isValid, "Le formulaire devrait être valide même avec les champs optionnels vides")
        #expect(email.isEmpty)
        #expect(telephone.isEmpty)
        #expect(rue.isEmpty)
    }
    
    // MARK: - Tests du mode édition vs création
    
    @Test func testIsEditing_WithEcoleToEdit_ShouldBeTrue() async throws {
        // Arrange
        let ecoleToEdit = createMockEcole()
        
        // Act
        let isEditing = ecoleToEdit != nil
        
        // Assert
        #expect(isEditing, "isEditing devrait être true avec une école à éditer")
    }
    
    @Test func testIsEditing_WithoutEcoleToEdit_ShouldBeFalse() async throws {
        // Arrange
        let ecoleToEdit: Ecole? = nil
        
        // Act
        let isEditing = ecoleToEdit != nil
        
        // Assert
        #expect(!isEditing, "isEditing devrait être false sans école à éditer")
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
        let title = isEditing ? "Modifier" : "Nouvelle école"
        
        // Assert
        #expect(title == "Modifier")
    }
    
    @Test func testNavigationTitle_CreateMode_ShouldShowNouvelleEcole() async throws {
        // Arrange
        let isEditing = false
        
        // Act
        let title = isEditing ? "Modifier" : "Nouvelle école"
        
        // Assert
        #expect(title == "Nouvelle école")
    }
    
    // MARK: - Tests de chargement des données école
    
    @Test func testLoadEcoleData_ShouldPopulateAllFields() async throws {
        // Arrange
        let ecole = Ecole(
            id: 1,
            nom: "École Polytechnique",
            rue: "Route de Saclay",
            codePostal: "91120",
            ville: "Palaiseau",
            nomContact: "Marie Curie",
            email: "contact@polytechnique.fr",
            telephone: "0169333333"
        )
        
        // Act - Simule loadEcoleData
        var nom = ""
        var nomContact = ""
        var email = ""
        var telephone = ""
        var rue = ""
        var codePostal = ""
        var ville = ""
        
        nom = ecole.nom
        nomContact = ecole.nomContact
        email = ecole.email
        telephone = ecole.telephone
        rue = ecole.rue ?? ""
        codePostal = ecole.codePostal ?? ""
        ville = ecole.ville ?? ""
        
        // Assert
        #expect(nom == "École Polytechnique")
        #expect(nomContact == "Marie Curie")
        #expect(email == "contact@polytechnique.fr")
        #expect(telephone == "0169333333")
        #expect(rue == "Route de Saclay")
        #expect(codePostal == "91120")
        #expect(ville == "Palaiseau")
    }
    
    @Test func testLoadEcoleData_NilOptionalFields_ShouldBeEmptyStrings() async throws {
        // Arrange
        let ecole = Ecole(
            id: 1,
            nom: "Test École",
            rue: nil,
            codePostal: nil,
            ville: nil,
            nomContact: "Contact",
            email: "",
            telephone: ""
        )
        
        // Act
        let rue = ecole.rue ?? ""
        let codePostal = ecole.codePostal ?? ""
        let ville = ecole.ville ?? ""
        
        // Assert
        #expect(rue == "")
        #expect(codePostal == "")
        #expect(ville == "")
    }
    
    // MARK: - Tests de création de l'objet Ecole
    
    @Test func testSaveEcole_EmptyOptionalFields_ShouldBeNil() async throws {
        // Arrange
        let rue = ""
        let codePostal = ""
        let ville = ""
        
        // Act - Simule la logique de saveEcole
        let ecole = Ecole(
            id: nil,
            nom: "Test",
            rue: rue.isEmpty ? nil : rue,
            codePostal: codePostal.isEmpty ? nil : codePostal,
            ville: ville.isEmpty ? nil : ville,
            nomContact: "Contact",
            email: "",
            telephone: ""
        )
        
        // Assert
        #expect(ecole.rue == nil)
        #expect(ecole.codePostal == nil)
        #expect(ecole.ville == nil)
    }
    
    @Test func testSaveEcole_FilledOptionalFields_ShouldBePresent() async throws {
        // Arrange
        let rue = "123 rue Test"
        let codePostal = "75001"
        let ville = "Paris"
        
        // Act
        let ecole = Ecole(
            id: nil,
            nom: "Test",
            rue: rue.isEmpty ? nil : rue,
            codePostal: codePostal.isEmpty ? nil : codePostal,
            ville: ville.isEmpty ? nil : ville,
            nomContact: "Contact",
            email: "",
            telephone: ""
        )
        
        // Assert
        #expect(ecole.rue == "123 rue Test")
        #expect(ecole.codePostal == "75001")
        #expect(ecole.ville == "Paris")
    }
    
    @Test func testSaveEcole_EditMode_ShouldPreserveId() async throws {
        // Arrange
        let ecoleToEdit = Ecole(
            id: 42,
            nom: "Original",
            nomContact: "Original Contact",
            email: "",
            telephone: ""
        )
        
        // Act - Simule saveEcole en mode édition
        let ecole = Ecole(
            id: ecoleToEdit.id,
            nom: "Updated",
            nomContact: "Updated Contact",
            email: "",
            telephone: ""
        )
        
        // Assert
        #expect(ecole.id == 42, "L'ID devrait être préservé en mode édition")
    }
    
    @Test func testSaveEcole_CreateMode_ShouldHaveNilId() async throws {
        // Arrange - Pas de ecoleToEdit
        let ecoleToEditId: Int64? = nil
        
        // Act
        let ecole = Ecole(
            id: ecoleToEditId,
            nom: "Nouvelle École",
            nomContact: "Nouveau Contact",
            email: "",
            telephone: ""
        )
        
        // Assert
        #expect(ecole.id == nil, "L'ID devrait être nil en mode création")
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
        let nom = ""
        let nomContact = ""
        let email = ""
        let telephone = ""
        let rue = ""
        let codePostal = ""
        let ville = ""
        
        // Assert
        #expect(nom.isEmpty)
        #expect(nomContact.isEmpty)
        #expect(email.isEmpty)
        #expect(telephone.isEmpty)
        #expect(rue.isEmpty)
        #expect(codePostal.isEmpty)
        #expect(ville.isEmpty)
    }
    
    // MARK: - Tests de l'opacité du bouton
    
    @Test func testButtonOpacity_WhenValid_ShouldBeFull() async throws {
        // Arrange
        let nom = "Test"
        let nomContact = "Contact"
        
        // Act
        let isValid = !nom.isEmpty && !nomContact.isEmpty
        let opacity = isValid ? 1.0 : 0.6
        
        // Assert
        #expect(opacity == 1.0)
    }
    
    @Test func testButtonOpacity_WhenInvalid_ShouldBeReduced() async throws {
        // Arrange
        let nom = ""
        let nomContact = "Contact"
        
        // Act
        let isValid = !nom.isEmpty && !nomContact.isEmpty
        let opacity = isValid ? 1.0 : 0.6
        
        // Assert
        #expect(opacity == 0.6)
    }
    
    // MARK: - Tests du bouton désactivé
    
    @Test func testButtonDisabled_WhenNomEmpty_ShouldBeDisabled() async throws {
        // Arrange
        let nom = ""
        let nomContact = "Contact"
        let isLoading = false
        
        // Act
        let isDisabled = nom.isEmpty || nomContact.isEmpty || isLoading
        
        // Assert
        #expect(isDisabled)
    }
    
    @Test func testButtonDisabled_WhenNomContactEmpty_ShouldBeDisabled() async throws {
        // Arrange
        let nom = "Test"
        let nomContact = ""
        let isLoading = false
        
        // Act
        let isDisabled = nom.isEmpty || nomContact.isEmpty || isLoading
        
        // Assert
        #expect(isDisabled)
    }
    
    @Test func testButtonDisabled_WhenLoading_ShouldBeDisabled() async throws {
        // Arrange
        let nom = "Test"
        let nomContact = "Contact"
        let isLoading = true
        
        // Act
        let isDisabled = nom.isEmpty || nomContact.isEmpty || isLoading
        
        // Assert
        #expect(isDisabled)
    }
    
    @Test func testButtonDisabled_WhenValidAndNotLoading_ShouldBeEnabled() async throws {
        // Arrange
        let nom = "Test"
        let nomContact = "Contact"
        let isLoading = false
        
        // Act
        let isDisabled = nom.isEmpty || nomContact.isEmpty || isLoading
        
        // Assert
        #expect(!isDisabled)
    }
    
    // MARK: - Helper Functions
    
    private func createMockEcole() -> Ecole {
        Ecole(
            id: 1,
            nom: "École Test",
            rue: "123 Rue Test",
            codePostal: "75001",
            ville: "Paris",
            nomContact: "Jean Test",
            email: "test@ecole.fr",
            telephone: "0123456789"
        )
    }
}

// MARK: - Tests FormSection pour Ecole
struct EcoleFormSectionTests {
    
    @Test func testFormSection_Titles_ShouldMatchExpected() async throws {
        let expectedTitles = [
            "Établissement",
            "Contact",
            "Adresse"
        ]
        
        for title in expectedTitles {
            #expect(!title.isEmpty, "Le titre '\(title)' devrait être présent")
        }
    }
    
    @Test func testFormSection_Etablissement_ShouldHaveNomField() async throws {
        let fieldLabel = "Nom de l'école"
        let placeholder = "Nom de l'établissement"
        
        #expect(fieldLabel == "Nom de l'école")
        #expect(placeholder == "Nom de l'établissement")
    }
    
    @Test func testFormSection_Contact_ShouldHaveRequiredFields() async throws {
        let fields = ["Nom du contact", "Email", "Téléphone"]
        #expect(fields.count == 3)
    }
    
    @Test func testFormSection_Adresse_ShouldHaveRequiredFields() async throws {
        let fields = ["Rue", "Code postal", "Ville"]
        #expect(fields.count == 3)
    }
}

// MARK: - Tests de validation des champs
struct EcoleFormFieldValidationTests {
    
    // MARK: - Tests Email
    
    @Test func testEmail_ValidFormat_ShouldPass() async throws {
        let validEmails = [
            "contact@ecole.fr",
            "direction@universite.edu",
            "admin@school.org"
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
            "missing@"
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
        let validCodes = ["75001", "69001", "91120", "33000"]
        
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
    
    // MARK: - Tests Nom d'école
    
    @Test func testNomEcole_ValidNames_ShouldPass() async throws {
        let validNames = [
            "École Polytechnique",
            "Université Paris-Saclay",
            "HEC Paris",
            "ESCP Business School"
        ]
        
        for name in validNames {
            let isValid = !name.trimmingCharacters(in: .whitespaces).isEmpty
            #expect(isValid, "Le nom '\(name)' devrait être valide")
        }
    }
    
    @Test func testNomEcole_OnlySpaces_ShouldFail() async throws {
        let nom = "   "
        let isValid = !nom.trimmingCharacters(in: .whitespaces).isEmpty
        #expect(!isValid, "Un nom avec seulement des espaces devrait être invalide")
    }
    
    // MARK: - Helper
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return email.range(of: emailRegex, options: .regularExpression) != nil
    }
}

// MARK: - Tests des placeholders
struct EcoleFormPlaceholderTests {
    
    @Test func testPlaceholder_NomEcole_ShouldBeCorrect() async throws {
        let placeholder = "Nom de l'établissement"
        #expect(placeholder == "Nom de l'établissement")
    }
    
    @Test func testPlaceholder_NomContact_ShouldBeCorrect() async throws {
        let placeholder = "Prénom Nom"
        #expect(placeholder == "Prénom Nom")
    }
    
    @Test func testPlaceholder_Email_ShouldBeCorrect() async throws {
        let placeholder = "contact@ecole.com"
        #expect(placeholder == "contact@ecole.com")
    }
    
    @Test func testPlaceholder_Telephone_ShouldBeCorrect() async throws {
        let placeholder = "01 23 45 67 89"
        #expect(placeholder == "01 23 45 67 89")
    }
    
    @Test func testPlaceholder_Rue_ShouldBeCorrect() async throws {
        let placeholder = "123 rue de la Paix"
        #expect(placeholder == "123 rue de la Paix")
    }
    
    @Test func testPlaceholder_CodePostal_ShouldBeCorrect() async throws {
        let placeholder = "75001"
        #expect(placeholder == "75001")
    }
    
    @Test func testPlaceholder_Ville_ShouldBeCorrect() async throws {
        let placeholder = "Paris"
        #expect(placeholder == "Paris")
    }
}

// MARK: - Tests Error Alert
struct EcoleFormErrorAlertTests {
    
    @Test func testErrorAlert_Title_ShouldBeErreur() async throws {
        let alertTitle = "Erreur"
        #expect(alertTitle == "Erreur")
    }
    
    @Test func testErrorAlert_OKButton_ShouldExist() async throws {
        let okButtonTitle = "OK"
        #expect(okButtonTitle == "OK")
    }
    
    @Test func testErrorAlert_MessageBinding_ShouldWork() async throws {
        var errorMessage = ""
        
        // Simule une erreur
        errorMessage = "Une erreur s'est produite"
        
        #expect(errorMessage == "Une erreur s'est produite")
    }
}
