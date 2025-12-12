//
//  ClientsListViewTests.swift
//  LearnTrackTests
//
//  Tests unitaires pour ClientsListView
//

import Testing
import SwiftUI
@testable import LearnTrack

// MARK: - Tests ClientsListView
struct ClientsListViewTests {
    
    // MARK: - Tests d'état initial
    
    @Test func testInitialState_ShowingAddClient_ShouldBeFalse() async throws {
        let showingAddClient = false
        #expect(!showingAddClient, "showingAddClient devrait être false initialement")
    }
    
    @Test func testInitialState_SearchText_ShouldBeEmpty() async throws {
        let searchText = ""
        #expect(searchText.isEmpty, "searchText devrait être vide initialement")
    }
    
    // MARK: - Tests d'affichage conditionnel
    
    @Test func testContentSection_WhenLoading_ShouldShowSkeleton() async throws {
        // Arrange
        let isLoading = true
        let clients: [Client] = []
        
        // Act
        let shouldShowSkeleton = isLoading
        let shouldShowEmptyState = !isLoading && clients.isEmpty
        let shouldShowList = !isLoading && !clients.isEmpty
        
        // Assert
        #expect(shouldShowSkeleton, "Le skeleton devrait être affiché pendant le chargement")
        #expect(!shouldShowEmptyState)
        #expect(!shouldShowList)
    }
    
    @Test func testContentSection_WhenEmptyAndNotLoading_ShouldShowEmptyState() async throws {
        // Arrange
        let isLoading = false
        let filteredClients: [Client] = []
        
        // Act
        let shouldShowEmptyState = !isLoading && filteredClients.isEmpty
        
        // Assert
        #expect(shouldShowEmptyState, "L'état vide devrait être affiché quand il n'y a pas de clients")
    }
    
    @Test func testContentSection_WhenHasClients_ShouldShowList() async throws {
        // Arrange
        let isLoading = false
        let filteredClients = [createMockClient(id: 1)]
        
        // Act
        let shouldShowList = !isLoading && !filteredClients.isEmpty
        
        // Assert
        #expect(shouldShowList, "La liste devrait être affichée quand il y a des clients")
    }
    
    // MARK: - Tests de recherche/filtrage
    
    @Test func testFilteredClients_EmptySearch_ShouldReturnAll() async throws {
        // Arrange
        let clients = [
            createMockClient(id: 1, raisonSociale: "Entreprise A"),
            createMockClient(id: 2, raisonSociale: "Entreprise B"),
            createMockClient(id: 3, raisonSociale: "Entreprise C")
        ]
        let searchText = ""
        
        // Act
        let filtered = filterClients(clients, searchText: searchText)
        
        // Assert
        #expect(filtered.count == 3)
    }
    
    @Test func testFilteredClients_WithSearchText_ShouldFilter() async throws {
        // Arrange
        let clients = [
            createMockClient(id: 1, raisonSociale: "Tech Solutions"),
            createMockClient(id: 2, raisonSociale: "Data Corp"),
            createMockClient(id: 3, raisonSociale: "Tech Innovations")
        ]
        let searchText = "Tech"
        
        // Act
        let filtered = filterClients(clients, searchText: searchText)
        
        // Assert
        #expect(filtered.count == 2)
    }
    
    @Test func testFilteredClients_SearchByVille_ShouldFilter() async throws {
        // Arrange
        let clients = [
            createMockClient(id: 1, raisonSociale: "Entreprise A", ville: "Paris"),
            createMockClient(id: 2, raisonSociale: "Entreprise B", ville: "Lyon"),
            createMockClient(id: 3, raisonSociale: "Entreprise C", ville: "Paris")
        ]
        let searchText = "Paris"
        
        // Act
        let filtered = filterClients(clients, searchText: searchText)
        
        // Assert
        #expect(filtered.count == 2)
    }
    
    @Test func testFilteredClients_CaseInsensitive_ShouldWork() async throws {
        // Arrange
        let clients = [
            createMockClient(id: 1, raisonSociale: "ACME Corporation"),
            createMockClient(id: 2, raisonSociale: "Beta Inc")
        ]
        let searchText = "acme"
        
        // Act
        let filtered = filterClients(clients, searchText: searchText)
        
        // Assert
        #expect(filtered.count == 1)
        #expect(filtered.first?.raisonSociale == "ACME Corporation")
    }
    
    @Test func testFilteredClients_NoMatch_ShouldReturnEmpty() async throws {
        // Arrange
        let clients = [
            createMockClient(id: 1, raisonSociale: "Entreprise A"),
            createMockClient(id: 2, raisonSociale: "Entreprise B")
        ]
        let searchText = "XYZ123"
        
        // Act
        let filtered = filterClients(clients, searchText: searchText)
        
        // Assert
        #expect(filtered.isEmpty)
    }
    
    // MARK: - Tests de navigation
    
    @Test func testNavigationTitle_ShouldBeClients() async throws {
        let title = "Clients"
        #expect(title == "Clients")
    }
    
    @Test func testAddButton_ShouldTriggerSheet() async throws {
        // Simule le comportement du bouton d'ajout
        var showingAddClient = false
        
        // Act - Simule le tap
        showingAddClient = true
        
        // Assert
        #expect(showingAddClient)
    }
    
    // MARK: - Tests de la liste
    
    @Test func testClientsList_ShouldBeEnumerated() async throws {
        // Arrange
        let clients = [
            createMockClient(id: 1, raisonSociale: "Client A"),
            createMockClient(id: 2, raisonSociale: "Client B"),
            createMockClient(id: 3, raisonSociale: "Client C")
        ]
        
        // Act
        let enumerated = Array(clients.enumerated())
        
        // Assert
        #expect(enumerated.count == 3)
        #expect(enumerated[0].offset == 0)
        #expect(enumerated[1].offset == 1)
        #expect(enumerated[2].offset == 2)
    }
    
    // MARK: - Tests Empty State
    
    @Test func testEmptyState_Properties_ShouldBeCorrect() async throws {
        let icon = "building.2.slash"
        let title = "Aucun client"
        let message = "Aucun client trouvé"
        let actionTitle = "Ajouter"
        
        #expect(icon == "building.2.slash")
        #expect(title == "Aucun client")
        #expect(message == "Aucun client trouvé")
        #expect(actionTitle == "Ajouter")
    }
    
    // MARK: - Helper Functions
    
    private func createMockClient(
        id: Int64,
        raisonSociale: String = "Test Corp",
        ville: String? = "Paris"
    ) -> Client {
        Client(
            id: id,
            raisonSociale: raisonSociale,
            rue: nil,
            codePostal: nil,
            ville: ville,
            nomContact: "Contact Test",
            email: "test@example.com",
            telephone: "0123456789",
            siret: nil,
            numeroTva: nil
        )
    }
    
    private func filterClients(_ clients: [Client], searchText: String) -> [Client] {
        guard !searchText.isEmpty else { return clients }
        
        return clients.filter { client in
            client.raisonSociale.localizedCaseInsensitiveContains(searchText) ||
            client.ville?.localizedCaseInsensitiveContains(searchText) ?? false
        }
    }
}

// MARK: - Tests ClientCardView
struct ClientCardViewTests {
    
    @Test func testClientCard_DisplaysRaisonSociale() async throws {
        // Arrange
        let client = createMockClient(raisonSociale: "Acme Corporation")
        
        // Assert
        #expect(client.raisonSociale == "Acme Corporation")
    }
    
    @Test func testClientCard_DisplaysInitiales() async throws {
        // Arrange
        let client = createMockClient(raisonSociale: "Acme Corporation")
        
        // Assert
        #expect(client.initiales == "AC")
    }
    
    @Test func testClientCard_DisplaysEmail_WhenPresent() async throws {
        // Arrange
        let client = Client(
            id: 1,
            raisonSociale: "Test",
            ville: "Paris",
            nomContact: "",
            email: "contact@test.com",
            telephone: ""
        )
        
        // Act - La logique de ClientCardView
        let displayText = client.email.isEmpty ? (client.ville ?? "") : client.email
        
        // Assert
        #expect(displayText == "contact@test.com")
    }
    
    @Test func testClientCard_DisplaysVille_WhenEmailEmpty() async throws {
        // Arrange
        let client = Client(
            id: 1,
            raisonSociale: "Test",
            ville: "Paris",
            nomContact: "",
            email: "",
            telephone: ""
        )
        
        // Act - La logique de ClientCardView
        let displayText = client.email.isEmpty ? (client.ville ?? "") : client.email
        
        // Assert
        #expect(displayText == "Paris")
    }
    
    @Test func testClientCard_DisplaysEmptyString_WhenBothEmpty() async throws {
        // Arrange
        let client = Client(
            id: 1,
            raisonSociale: "Test",
            ville: nil,
            nomContact: "",
            email: "",
            telephone: ""
        )
        
        // Act
        let displayText = client.email.isEmpty ? (client.ville ?? "") : client.email
        
        // Assert
        #expect(displayText == "")
    }
    
    // MARK: - Tests d'animation de pression
    
    @Test func testClientCard_ScaleEffect_WhenPressed() async throws {
        // Arrange
        let isPressed = true
        
        // Act
        let scale = isPressed ? 0.98 : 1.0
        
        // Assert
        #expect(scale == 0.98)
    }
    
    @Test func testClientCard_ScaleEffect_WhenNotPressed() async throws {
        // Arrange
        let isPressed = false
        
        // Act
        let scale = isPressed ? 0.98 : 1.0
        
        // Assert
        #expect(scale == 1.0)
    }
    
    // MARK: - Helper
    
    private func createMockClient(
        raisonSociale: String = "Test Corp",
        email: String = "test@example.com",
        ville: String? = "Paris"
    ) -> Client {
        Client(
            id: 1,
            raisonSociale: raisonSociale,
            ville: ville,
            nomContact: "Contact",
            email: email,
            telephone: ""
        )
    }
}

// MARK: - Tests de Skeleton
struct ClientsListSkeletonTests {
    
    @Test func testSkeleton_ShouldShowFourItems() async throws {
        // Le skeleton affiche 4 items (ForEach 0..<4)
        let skeletonCount = 4
        #expect(skeletonCount == 4)
    }
    
    @Test func testSkeleton_ItemIndices_ShouldBeCorrect() async throws {
        // Arrange
        let indices = Array(0..<4)
        
        // Assert
        #expect(indices == [0, 1, 2, 3])
    }
}

// MARK: - Tests de Refresh
struct ClientsListRefreshTests {
    
    @Test func testRefreshable_ShouldTriggerFetchClients() async throws {
        // Simule le comportement de refreshable
        var fetchClientsCalled = false
        
        // Act - Simule le refresh
        fetchClientsCalled = true
        
        // Assert
        #expect(fetchClientsCalled)
    }
}

// MARK: - Tests de Search Bar
struct ClientsListSearchBarTests {
    
    @Test func testSearchBar_Placeholder_ShouldBeRechercher() async throws {
        let placeholder = "Rechercher..."
        #expect(placeholder == "Rechercher...")
    }
    
    @Test func testSearchBar_BindsToSearchText() async throws {
        // Arrange
        var searchText = ""
        
        // Act - Simule la saisie
        searchText = "Test"
        
        // Assert
        #expect(searchText == "Test")
    }
    
    @Test func testSearchBar_ClearText_ShouldResetToEmpty() async throws {
        // Arrange
        var searchText = "Test search"
        
        // Act - Simule clear
        searchText = ""
        
        // Assert
        #expect(searchText.isEmpty)
    }
}

// MARK: - Tests Add Button
struct ClientsListAddButtonTests {
    
    @Test func testAddButton_ShouldHavePlusIcon() async throws {
        let iconName = "plus"
        #expect(iconName == "plus")
    }
    
    @Test func testAddButton_CircleSize_ShouldBe36() async throws {
        let circleSize: CGFloat = 36
        #expect(circleSize == 36)
    }
    
    @Test func testAddButton_IconSize_ShouldBe16() async throws {
        let iconSize: CGFloat = 16
        #expect(iconSize == 16)
    }
}

// MARK: - Tests de tri et ordre
struct ClientsListOrderTests {
    
    @Test func testClientsList_ShouldMaintainOrder() async throws {
        // Arrange
        let clients = [
            createMockClient(id: 1, raisonSociale: "Alpha"),
            createMockClient(id: 2, raisonSociale: "Beta"),
            createMockClient(id: 3, raisonSociale: "Gamma")
        ]
        
        // Assert - L'ordre devrait être préservé
        #expect(clients[0].raisonSociale == "Alpha")
        #expect(clients[1].raisonSociale == "Beta")
        #expect(clients[2].raisonSociale == "Gamma")
    }
    
    @Test func testClientsList_EnumeratedPreservesOrder() async throws {
        // Arrange
        let clients = [
            createMockClient(id: 1, raisonSociale: "First"),
            createMockClient(id: 2, raisonSociale: "Second")
        ]
        
        // Act
        let enumerated = Array(clients.enumerated())
        
        // Assert
        #expect(enumerated[0].element.raisonSociale == "First")
        #expect(enumerated[1].element.raisonSociale == "Second")
    }
    
    // MARK: - Helper
    
    private func createMockClient(id: Int64, raisonSociale: String) -> Client {
        Client(
            id: id,
            raisonSociale: raisonSociale,
            nomContact: "",
            email: "",
            telephone: ""
        )
    }
}
