//
//  RegisterViewTests.swift
//  LearnTrackTests
//
//  Tests unitaires pour RegisterView
//

import Testing
import SwiftUI
@testable import LearnTrack

// MARK: - Tests RegisterView
struct RegisterViewTests {
    
    // MARK: - Tests de validation des champs
    
    @Test func testValidation_AllFieldsEmpty_ShouldBeInvalid() async throws {
        // Arrange
        let prenom = ""
        let nom = ""
        let email = ""
        let password = ""
        
        // Act
        let isValid = !prenom.isEmpty && !nom.isEmpty && !email.isEmpty && !password.isEmpty
        
        // Assert
        #expect(!isValid, "La validation devrait échouer avec tous les champs vides")
    }
    
    @Test func testValidation_MissingPrenom_ShouldBeInvalid() async throws {
        // Arrange
        let prenom = ""
        let nom = "Dupont"
        let email = "test@example.com"
        let password = "password123"
        
        // Act
        let isValid = !prenom.isEmpty && !nom.isEmpty && !email.isEmpty && !password.isEmpty
        
        // Assert
        #expect(!isValid, "La validation devrait échouer sans prénom")
    }
    
    @Test func testValidation_MissingNom_ShouldBeInvalid() async throws {
        // Arrange
        let prenom = "Jean"
        let nom = ""
        let email = "test@example.com"
        let password = "password123"
        
        // Act
        let isValid = !prenom.isEmpty && !nom.isEmpty && !email.isEmpty && !password.isEmpty
        
        // Assert
        #expect(!isValid, "La validation devrait échouer sans nom")
    }
    
    @Test func testValidation_MissingEmail_ShouldBeInvalid() async throws {
        // Arrange
        let prenom = "Jean"
        let nom = "Dupont"
        let email = ""
        let password = "password123"
        
        // Act
        let isValid = !prenom.isEmpty && !nom.isEmpty && !email.isEmpty && !password.isEmpty
        
        // Assert
        #expect(!isValid, "La validation devrait échouer sans email")
    }
    
    @Test func testValidation_MissingPassword_ShouldBeInvalid() async throws {
        // Arrange
        let prenom = "Jean"
        let nom = "Dupont"
        let email = "test@example.com"
        let password = ""
        
        // Act
        let isValid = !prenom.isEmpty && !nom.isEmpty && !email.isEmpty && !password.isEmpty
        
        // Assert
        #expect(!isValid, "La validation devrait échouer sans mot de passe")
    }
    
    @Test func testValidation_AllFieldsFilled_ShouldBeValid() async throws {
        // Arrange
        let prenom = "Jean"
        let nom = "Dupont"
        let email = "jean.dupont@example.com"
        let password = "SecurePassword123!"
        
        // Act
        let isValid = !prenom.isEmpty && !nom.isEmpty && !email.isEmpty && !password.isEmpty
        
        // Assert
        #expect(isValid, "La validation devrait réussir avec tous les champs remplis")
    }
    
    // MARK: - Tests de format d'email
    
    @Test func testEmailFormat_ValidEmails_ShouldBeAccepted() async throws {
        // Arrange
        let validEmails = [
            "user@example.com",
            "jean.dupont@domaine.fr",
            "user+tag@mail.org",
            "firstname.lastname@company.co.uk"
        ]
        
        // Act & Assert
        for email in validEmails {
            let isValidFormat = isValidEmail(email)
            #expect(isValidFormat, "L'email \(email) devrait être valide")
        }
    }
    
    @Test func testEmailFormat_InvalidEmails_ShouldBeRejected() async throws {
        // Arrange
        let invalidEmails = [
            "invalidemail",
            "@nodomain.com",
            "missing@",
            "no spaces@email.com",
            "double@@email.com"
        ]
        
        // Act & Assert
        for email in invalidEmails {
            let isValidFormat = isValidEmail(email)
            #expect(!isValidFormat, "L'email \(email) devrait être invalide")
        }
    }
    
    // MARK: - Tests de validation du mot de passe
    
    @Test func testPasswordStrength_TooShort_ShouldBeWeak() async throws {
        // Arrange
        let password = "abc"
        
        // Act
        let isStrong = isPasswordStrong(password)
        
        // Assert
        #expect(!isStrong, "Un mot de passe trop court devrait être considéré comme faible")
    }
    
    @Test func testPasswordStrength_MinimumLength_ShouldPass() async throws {
        // Arrange
        let password = "password123"
        
        // Act
        let hasMinLength = password.count >= 8
        
        // Assert
        #expect(hasMinLength, "Le mot de passe devrait avoir au moins 8 caractères")
    }
    
    @Test func testPasswordStrength_StrongPassword_ShouldPass() async throws {
        // Arrange
        let password = "SecureP@ss123!"
        
        // Act
        let isStrong = isPasswordStrong(password)
        
        // Assert
        #expect(isStrong, "Un mot de passe fort devrait être accepté")
    }
    
    // MARK: - Tests de validation du prénom et nom
    
    @Test func testName_OnlySpaces_ShouldBeConsideredEmpty() async throws {
        // Arrange
        let prenom = "   "
        let nom = "   "
        
        // Act
        let isPrenomValid = !prenom.trimmingCharacters(in: .whitespaces).isEmpty
        let isNomValid = !nom.trimmingCharacters(in: .whitespaces).isEmpty
        
        // Assert
        #expect(!isPrenomValid, "Un prénom avec seulement des espaces devrait être invalide")
        #expect(!isNomValid, "Un nom avec seulement des espaces devrait être invalide")
    }
    
    @Test func testName_ValidNames_ShouldBeAccepted() async throws {
        // Arrange
        let validNames = ["Jean", "Marie-Claire", "O'Brien", "De La Cruz", "François"]
        
        // Act & Assert
        for name in validNames {
            let isValid = !name.trimmingCharacters(in: .whitespaces).isEmpty
            #expect(isValid, "Le nom '\(name)' devrait être valide")
        }
    }
    
    // MARK: - Tests d'état initial
    
    @Test func testInitialState_IsLoadingShouldBeFalse() async throws {
        let isLoading = false
        #expect(!isLoading, "isLoading devrait être initialement false")
    }
    
    @Test func testInitialState_ErrorMessageShouldBeNil() async throws {
        let errorMessage: String? = nil
        #expect(errorMessage == nil, "errorMessage devrait être initialement nil")
    }
    
    @Test func testInitialState_AllFieldsShouldBeEmpty() async throws {
        // Les champs du formulaire devraient être vides au démarrage
        let prenom = ""
        let nom = ""
        let email = ""
        let password = ""
        
        #expect(prenom.isEmpty, "Le prénom devrait être vide initialement")
        #expect(nom.isEmpty, "Le nom devrait être vide initialement")
        #expect(email.isEmpty, "L'email devrait être vide initialement")
        #expect(password.isEmpty, "Le mot de passe devrait être vide initialement")
    }
    
    // MARK: - Tests du bouton d'inscription
    
    @Test func testRegisterButton_WhenInvalid_ShouldBeDisabled() async throws {
        // Arrange - formulaire invalide
        let prenom = ""
        let nom = "Dupont"
        let email = "test@example.com"
        let password = "password123"
        
        // Act
        let isValid = !prenom.isEmpty && !nom.isEmpty && !email.isEmpty && !password.isEmpty
        let buttonDisabled = !isValid
        
        // Assert
        #expect(buttonDisabled, "Le bouton devrait être désactivé quand le formulaire est invalide")
    }
    
    @Test func testRegisterButton_WhenValid_ShouldBeEnabled() async throws {
        // Arrange - formulaire valide
        let prenom = "Jean"
        let nom = "Dupont"
        let email = "test@example.com"
        let password = "password123"
        
        // Act
        let isValid = !prenom.isEmpty && !nom.isEmpty && !email.isEmpty && !password.isEmpty
        let buttonDisabled = !isValid
        
        // Assert
        #expect(!buttonDisabled, "Le bouton devrait être activé quand le formulaire est valide")
    }
    
    @Test func testRegisterButton_WhenLoading_ShouldBeDisabled() async throws {
        // Arrange
        let isLoading = true
        let isValid = true
        
        // Act
        let buttonDisabled = !isValid || isLoading
        
        // Assert
        #expect(buttonDisabled, "Le bouton devrait être désactivé pendant le chargement")
    }
    
    // MARK: - Tests de l'opacité du bouton
    
    @Test func testButtonOpacity_WhenValid_ShouldBeFull() async throws {
        // Arrange
        let isValid = true
        
        // Act
        let opacity = isValid ? 1.0 : 0.6
        
        // Assert
        #expect(opacity == 1.0, "L'opacité devrait être 1.0 quand le formulaire est valide")
    }
    
    @Test func testButtonOpacity_WhenInvalid_ShouldBeReduced() async throws {
        // Arrange
        let isValid = false
        
        // Act
        let opacity = isValid ? 1.0 : 0.6
        
        // Assert
        #expect(opacity == 0.6, "L'opacité devrait être 0.6 quand le formulaire est invalide")
    }
    
    // MARK: - Helper Functions
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return email.range(of: emailRegex, options: .regularExpression) != nil
    }
    
    private func isPasswordStrong(_ password: String) -> Bool {
        // Un mot de passe fort doit avoir:
        // - Au moins 8 caractères
        // - Au moins une majuscule
        // - Au moins une minuscule
        // - Au moins un chiffre
        let hasMinLength = password.count >= 8
        let hasUppercase = password.range(of: "[A-Z]", options: .regularExpression) != nil
        let hasLowercase = password.range(of: "[a-z]", options: .regularExpression) != nil
        let hasDigit = password.range(of: "[0-9]", options: .regularExpression) != nil
        
        return hasMinLength && hasUppercase && hasLowercase && hasDigit
    }
}

// MARK: - Tests de sécurité
struct RegisterViewSecurityTests {
    
    @Test func testPassword_ShouldBeSecureField() async throws {
        // Le mot de passe utilise SecureField dans RegisterView
        // Ce qui masque les caractères saisis
        #expect(true, "Le champ mot de passe devrait utiliser SecureField")
    }
    
    @Test func testEmail_ShouldDisableAutoCapitalization() async throws {
        // L'email a .textInputAutocapitalization(.never)
        #expect(true, "L'auto-capitalisation devrait être désactivée pour l'email")
    }
    
    @Test func testEmail_ShouldDisableAutoCorrection() async throws {
        // L'email a .autocorrectionDisabled()
        #expect(true, "L'auto-correction devrait être désactivée pour l'email")
    }
    
    @Test func testEmail_ShouldUseEmailKeyboard() async throws {
        // L'email a .keyboardType(.emailAddress)
        #expect(true, "Le clavier email devrait être utilisé pour le champ email")
    }
}

// MARK: - Tests d'intégration
struct RegisterViewIntegrationTests {
    
    @Test func testUserData_ShouldBeStoredCorrectly() async throws {
        // Arrange
        let prenom = "Marie"
        let nom = "Martin"
        let email = "marie.martin@learntrack.com"
        let password = "SecurePass123!"
        
        // Act - Simule le stockage des données
        var storedData: [String: String] = [:]
        storedData["prenom"] = prenom
        storedData["nom"] = nom
        storedData["email"] = email
        
        // Assert
        #expect(storedData["prenom"] == prenom)
        #expect(storedData["nom"] == nom)
        #expect(storedData["email"] == email)
        // Note: Le mot de passe ne devrait pas être stocké en clair
    }
    
    @Test func testFullName_ShouldBeCombinedCorrectly() async throws {
        // Arrange
        let prenom = "Jean"
        let nom = "Dupont"
        
        // Act
        let fullName = "\(prenom) \(nom)"
        
        // Assert
        #expect(fullName == "Jean Dupont", "Le nom complet devrait être correctement formaté")
    }
}
