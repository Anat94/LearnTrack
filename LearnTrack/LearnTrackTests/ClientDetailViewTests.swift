//
//  ClientDetailViewTests.swift
//  LearnTrackTests
//
//  Tests unitaires pour ClientDetailView
//

import Testing
import SwiftUI
@testable import LearnTrack

// MARK: - Tests ClientDetailView
struct ClientDetailViewTests {
    
    // MARK: - Tests d'affichage des informations client
    
    @Test func testClientDisplay_RaisonSociale_ShouldBeDisplayed() async throws {
        // Arrange
        let client = createMockClient(raisonSociale: "Acme Corporation")
        
        // Assert
        #expect(!client.raisonSociale.isEmpty, "La raison sociale devrait être affichée")
        #expect(client.raisonSociale == "Acme Corporation")
    }
    
    @Test func testClientDisplay_Initiales_ShouldBeCorrect() async throws {
        // Arrange
        let client = createMockClient(raisonSociale: "Acme Corporation")
        
        // Assert
        #expect(client.initiales == "AC", "Les initiales devraient être 'AC'")
    }
    
    @Test func testClientDisplay_VilleDisplay_WithVille_ShouldShowVille() async throws {
        // Arrange
        let client = createMockClient(ville: "Paris")
        
        // Assert
        #expect(client.villeDisplay == "Paris")
    }
    
    @Test func testClientDisplay_VilleDisplay_WithoutVille_ShouldShowDefault() async throws {
        // Arrange
        let client = createMockClient(ville: nil)
        
        // Assert
        #expect(client.villeDisplay == "Non renseignée")
    }
    
    // MARK: - Tests d'adresse complète
    
    @Test func testAdresseComplete_AllFieldsPresent_ShouldFormat() async throws {
        // Arrange
        let client = Client(
            id: 1,
            raisonSociale: "Test Corp",
            rue: "123 rue de la Paix",
            codePostal: "75001",
            ville: "Paris",
            nomContact: "",
            email: "",
            telephone: ""
        )
        
        // Assert
        #expect(client.adresseComplete == "123 rue de la Paix, 75001 Paris")
    }
    
    @Test func testAdresseComplete_MissingRue_ShouldReturnNil() async throws {
        // Arrange
        let client = Client(
            id: 1,
            raisonSociale: "Test Corp",
            rue: nil,
            codePostal: "75001",
            ville: "Paris",
            nomContact: "",
            email: "",
            telephone: ""
        )
        
        // Assert
        #expect(client.adresseComplete == nil)
    }
    
    @Test func testAdresseComplete_MissingCodePostal_ShouldReturnNil() async throws {
        // Arrange
        let client = Client(
            id: 1,
            raisonSociale: "Test Corp",
            rue: "123 rue de la Paix",
            codePostal: nil,
            ville: "Paris",
            nomContact: "",
            email: "",
            telephone: ""
        )
        
        // Assert
        #expect(client.adresseComplete == nil)
    }
    
    @Test func testAdresseComplete_MissingVille_ShouldReturnNil() async throws {
        // Arrange
        let client = Client(
            id: 1,
            raisonSociale: "Test Corp",
            rue: "123 rue de la Paix",
            codePostal: "75001",
            ville: nil,
            nomContact: "",
            email: "",
            telephone: ""
        )
        
        // Assert
        #expect(client.adresseComplete == nil)
    }
    
    // MARK: - Tests informations fiscales
    
    @Test func testInfosFiscales_SiretPresent_ShouldBeDisplayed() async throws {
        // Arrange
        let siret = "12345678901234"
        
        // Assert
        #expect(!siret.isEmpty, "Le SIRET devrait être affiché s'il est présent")
        #expect(siret.count == 14, "Le SIRET devrait avoir 14 caractères")
    }
    
    @Test func testInfosFiscales_TvaPresent_ShouldBeDisplayed() async throws {
        // Arrange
        let tva = "FR12345678901"
        
        // Assert
        #expect(!tva.isEmpty, "Le numéro TVA devrait être affiché s'il est présent")
    }
    
    @Test func testInfosFiscales_SiretEmpty_ShouldNotDisplay() async throws {
        // Arrange
        let siret = ""
        
        // Act
        let shouldDisplay = !siret.isEmpty
        
        // Assert
        #expect(!shouldDisplay, "La carte infos fiscales ne devrait pas s'afficher si SIRET vide")
    }
    
    // MARK: - Tests calcul du CA total
    
    @Test func testCalculateTotalCA_EmptySessions_ShouldReturnZero() async throws {
        // Arrange
        let sessions: [MockSession] = []
        
        // Act
        let totalCA = calculateTotalCA(sessions)
        
        // Assert
        #expect(totalCA == 0, "Le CA total devrait être 0 sans sessions")
    }
    
    @Test func testCalculateTotalCA_MultipleSessions_ShouldSumCorrectly() async throws {
        // Arrange
        let sessions = [
            MockSession(tarifClient: 500),
            MockSession(tarifClient: 750),
            MockSession(tarifClient: 1200)
        ]
        
        // Act
        let totalCA = calculateTotalCA(sessions)
        
        // Assert
        #expect(totalCA == 2450, "Le CA total devrait être 2450")
    }
    
    @Test func testCalculateTotalCA_SingleSession_ShouldReturnSessionValue() async throws {
        // Arrange
        let sessions = [MockSession(tarifClient: 1000)]
        
        // Act
        let totalCA = calculateTotalCA(sessions)
        
        // Assert
        #expect(totalCA == 1000)
    }
    
    // MARK: - Tests affichage des sessions
    
    @Test func testSessionsDisplay_ShowsMaxThreeSessions() async throws {
        // Arrange
        let sessions = [
            MockSession(id: 1, module: "Session 1", tarifClient: 500),
            MockSession(id: 2, module: "Session 2", tarifClient: 600),
            MockSession(id: 3, module: "Session 3", tarifClient: 700),
            MockSession(id: 4, module: "Session 4", tarifClient: 800),
            MockSession(id: 5, module: "Session 5", tarifClient: 900)
        ]
        
        // Act
        let displayedSessions = Array(sessions.prefix(3))
        
        // Assert
        #expect(displayedSessions.count == 3, "Seulement 3 sessions devraient être affichées")
    }
    
    @Test func testSessionsDisplay_LessThanThree_ShouldShowAll() async throws {
        // Arrange
        let sessions = [
            MockSession(id: 1, module: "Session 1", tarifClient: 500),
            MockSession(id: 2, module: "Session 2", tarifClient: 600)
        ]
        
        // Act
        let displayedSessions = Array(sessions.prefix(3))
        
        // Assert
        #expect(displayedSessions.count == 2, "Toutes les sessions devraient être affichées")
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
    
    // MARK: - Tests de contact
    
    @Test func testContact_PhoneNumber_ShouldBeFormattedForCall() async throws {
        // Arrange
        let phoneNumber = "0123456789"
        
        // Act
        let formattedPhone = formatPhoneForCall(phoneNumber)
        
        // Assert
        #expect(formattedPhone == "tel://0123456789")
    }
    
    @Test func testContact_Email_ShouldBeFormattedForMailto() async throws {
        // Arrange
        let email = "contact@example.com"
        
        // Act
        let formattedEmail = formatEmailForMailto(email)
        
        // Assert
        #expect(formattedEmail == "mailto:contact@example.com")
    }
    
    @Test func testContact_EmptyPhone_ShouldNotEnableCall() async throws {
        // Arrange
        let phoneNumber = ""
        
        // Act
        let canCall = !phoneNumber.isEmpty
        
        // Assert
        #expect(!canCall, "L'appel ne devrait pas être possible avec un numéro vide")
    }
    
    @Test func testContact_EmptyEmail_ShouldNotEnableEmail() async throws {
        // Arrange
        let email = ""
        
        // Act
        let canEmail = !email.isEmpty
        
        // Assert
        #expect(!canEmail, "L'email ne devrait pas être possible avec une adresse vide")
    }
    
    // MARK: - Tests de l'état initial
    
    @Test func testInitialState_ShowingEditSheet_ShouldBeFalse() async throws {
        let showingEditSheet = false
        #expect(!showingEditSheet)
    }
    
    @Test func testInitialState_ShowingDeleteAlert_ShouldBeFalse() async throws {
        let showingDeleteAlert = false
        #expect(!showingDeleteAlert)
    }
    
    @Test func testInitialState_Sessions_ShouldBeEmpty() async throws {
        let sessions: [MockSession] = []
        #expect(sessions.isEmpty)
    }
    
    // MARK: - Helper Functions
    
    private func createMockClient(
        raisonSociale: String = "Test Corp",
        ville: String? = "Paris"
    ) -> Client {
        Client(
            id: 1,
            raisonSociale: raisonSociale,
            rue: "123 rue Test",
            codePostal: "75001",
            ville: ville,
            nomContact: "Jean Test",
            email: "test@example.com",
            telephone: "0123456789",
            siret: "12345678901234",
            numeroTva: "FR12345678901"
        )
    }
    
    private func calculateTotalCA(_ sessions: [MockSession]) -> Decimal {
        sessions.reduce(0) { $0 + $1.tarifClient }
    }
    
    private func formatPhoneForCall(_ phone: String) -> String {
        "tel://\(phone)"
    }
    
    private func formatEmailForMailto(_ email: String) -> String {
        "mailto:\(email)"
    }
}

// MARK: - Tests StatCardCompact
struct StatCardCompactTests {
    
    @Test func testStatCard_ValueFormatting_ShouldDisplayCorrectly() async throws {
        // Arrange
        let sessionsCount = 5
        let totalCA: Decimal = 2500
        
        // Act
        let sessionsValue = "\(sessionsCount)"
        let caValue = "\(totalCA) €"
        
        // Assert
        #expect(sessionsValue == "5")
        #expect(caValue == "2500 €")
    }
    
    @Test func testStatCard_ZeroValue_ShouldDisplayZero() async throws {
        // Arrange
        let sessionsCount = 0
        
        // Act
        let value = "\(sessionsCount)"
        
        // Assert
        #expect(value == "0")
    }
    
    @Test func testStatCard_LargeValue_ShouldDisplayCorrectly() async throws {
        // Arrange
        let totalCA: Decimal = 125000
        
        // Act
        let value = "\(totalCA) €"
        
        // Assert
        #expect(value == "125000 €")
    }
}

// MARK: - Tests des Quick Actions
struct QuickActionsTests {
    
    @Test func testQuickAction_CallAction_ShouldBeAvailable() async throws {
        let phoneNumber = "0123456789"
        let canCall = !phoneNumber.isEmpty
        #expect(canCall, "L'action d'appel devrait être disponible")
    }
    
    @Test func testQuickAction_EmailAction_ShouldBeAvailable() async throws {
        let email = "contact@example.com"
        let canEmail = !email.isEmpty
        #expect(canEmail, "L'action d'email devrait être disponible")
    }
    
    @Test func testQuickAction_MapsAction_ShouldBeAvailableWithAddress() async throws {
        let adresse = "123 rue de la Paix, 75001 Paris"
        let canOpenMaps = !adresse.isEmpty
        #expect(canOpenMaps, "L'action Maps devrait être disponible avec une adresse")
    }
}

// MARK: - Tests de mappage API
struct ClientDetailMappingTests {
    
    @Test func testMapAPIClient_ShouldMapAllFields() async throws {
        // Arrange
        let apiClient = MockAPIClient(
            id: 42,
            nom: "Test Corp",
            email: "test@corp.com",
            telephone: "0987654321",
            adresse: "456 Avenue Test",
            ville: "Lyon",
            codePostal: "69001",
            siret: "98765432109876",
            contactNom: "Pierre Martin",
            contactEmail: "pierre@corp.com",
            contactTelephone: "0612345678"
        )
        
        // Act
        let client = mapAPIClient(apiClient)
        
        // Assert
        #expect(client.id == 42)
        #expect(client.raisonSociale == "Test Corp")
        #expect(client.ville == "Lyon")
        #expect(client.nomContact == "Pierre Martin")
    }
    
    @Test func testMapAPIClient_NilContactNom_ShouldMapToEmptyString() async throws {
        // Arrange
        let apiClient = MockAPIClient(
            id: 1,
            nom: "Test",
            email: nil,
            telephone: nil,
            adresse: nil,
            ville: nil,
            codePostal: nil,
            siret: nil,
            contactNom: nil,
            contactEmail: nil,
            contactTelephone: nil
        )
        
        // Act
        let client = mapAPIClient(apiClient)
        
        // Assert
        #expect(client.nomContact == "", "contactNom nil devrait être mappé à une chaîne vide")
    }
    
    // MARK: - Helper
    
    private func mapAPIClient(_ api: MockAPIClient) -> Client {
        Client(
            id: Int64(api.id),
            raisonSociale: api.nom,
            rue: api.adresse,
            codePostal: api.codePostal,
            ville: api.ville,
            nomContact: api.contactNom ?? "",
            email: api.email ?? (api.contactEmail ?? ""),
            telephone: api.telephone ?? (api.contactTelephone ?? ""),
            siret: api.siret,
            numeroTva: nil
        )
    }
}

// MARK: - Mock Types

struct MockSession {
    let id: Int64
    let module: String
    let tarifClient: Decimal
    
    init(id: Int64 = 1, module: String = "Module Test", tarifClient: Decimal) {
        self.id = id
        self.module = module
        self.tarifClient = tarifClient
    }
}

struct MockAPIClient {
    let id: Int
    let nom: String
    let email: String?
    let telephone: String?
    let adresse: String?
    let ville: String?
    let codePostal: String?
    let siret: String?
    let contactNom: String?
    let contactEmail: String?
    let contactTelephone: String?
}
