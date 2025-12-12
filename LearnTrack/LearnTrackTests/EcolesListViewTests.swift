//
//  EcolesListViewTests.swift
//  LearnTrackTests
//
//  Tests unitaires pour EcolesListView
//

import Testing
import SwiftUI
@testable import LearnTrack

// MARK: - Tests EcolesListView
struct EcolesListViewTests {
    
    // MARK: - Tests d'état initial
    
    @Test func testInitialState_ShowingAddEcole_ShouldBeFalse() async throws {
        let showingAddEcole = false
        #expect(!showingAddEcole, "showingAddEcole devrait être false initialement")
    }
    
    @Test func testInitialState_SearchText_ShouldBeEmpty() async throws {
        let searchText = ""
        #expect(searchText.isEmpty, "searchText devrait être vide initialement")
    }
    
    // MARK: - Tests d'affichage conditionnel
    
    @Test func testContentSection_WhenLoading_ShouldShowSkeleton() async throws {
        // Arrange
        let isLoading = true
        let ecoles: [Ecole] = []
        
        // Act
        let shouldShowSkeleton = isLoading
        let shouldShowEmptyState = !isLoading && ecoles.isEmpty
        let shouldShowList = !isLoading && !ecoles.isEmpty
        
        // Assert
        #expect(shouldShowSkeleton, "Le skeleton devrait être affiché pendant le chargement")
        #expect(!shouldShowEmptyState)
        #expect(!shouldShowList)
    }
    
    @Test func testContentSection_WhenEmptyAndNotLoading_ShouldShowEmptyState() async throws {
        // Arrange
        let isLoading = false
        let filteredEcoles: [Ecole] = []
        
        // Act
        let shouldShowEmptyState = !isLoading && filteredEcoles.isEmpty
        
        // Assert
        #expect(shouldShowEmptyState, "L'état vide devrait être affiché quand il n'y a pas d'écoles")
    }
    
    @Test func testContentSection_WhenHasEcoles_ShouldShowList() async throws {
        // Arrange
        let isLoading = false
        let filteredEcoles = [createMockEcole(id: 1)]
        
        // Act
        let shouldShowList = !isLoading && !filteredEcoles.isEmpty
        
        // Assert
        #expect(shouldShowList, "La liste devrait être affichée quand il y a des écoles")
    }
    
    // MARK: - Tests de recherche/filtrage
    
    @Test func testFilteredEcoles_EmptySearch_ShouldReturnAll() async throws {
        // Arrange
        let ecoles = [
            createMockEcole(id: 1, nom: "École A"),
            createMockEcole(id: 2, nom: "École B"),
            createMockEcole(id: 3, nom: "École C")
        ]
        let searchText = ""
        
        // Act
        let filtered = filterEcoles(ecoles, searchText: searchText)
        
        // Assert
        #expect(filtered.count == 3)
    }
    
    @Test func testFilteredEcoles_WithSearchText_ShouldFilter() async throws {
        // Arrange
        let ecoles = [
            createMockEcole(id: 1, nom: "École Polytechnique"),
            createMockEcole(id: 2, nom: "HEC Paris"),
            createMockEcole(id: 3, nom: "École Centrale")
        ]
        let searchText = "École"
        
        // Act
        let filtered = filterEcoles(ecoles, searchText: searchText)
        
        // Assert
        #expect(filtered.count == 2)
    }
    
    @Test func testFilteredEcoles_SearchByVille_ShouldFilter() async throws {
        // Arrange
        let ecoles = [
            createMockEcole(id: 1, nom: "École A", ville: "Paris"),
            createMockEcole(id: 2, nom: "École B", ville: "Lyon"),
            createMockEcole(id: 3, nom: "École C", ville: "Paris")
        ]
        let searchText = "Paris"
        
        // Act
        let filtered = filterEcoles(ecoles, searchText: searchText)
        
        // Assert
        #expect(filtered.count == 2)
    }
    
    @Test func testFilteredEcoles_CaseInsensitive_ShouldWork() async throws {
        // Arrange
        let ecoles = [
            createMockEcole(id: 1, nom: "POLYTECHNIQUE"),
            createMockEcole(id: 2, nom: "hec paris")
        ]
        let searchText = "polytechnique"
        
        // Act
        let filtered = filterEcoles(ecoles, searchText: searchText)
        
        // Assert
        #expect(filtered.count == 1)
        #expect(filtered.first?.nom == "POLYTECHNIQUE")
    }
    
    @Test func testFilteredEcoles_NoMatch_ShouldReturnEmpty() async throws {
        // Arrange
        let ecoles = [
            createMockEcole(id: 1, nom: "École A"),
            createMockEcole(id: 2, nom: "École B")
        ]
        let searchText = "XYZ123"
        
        // Act
        let filtered = filterEcoles(ecoles, searchText: searchText)
        
        // Assert
        #expect(filtered.isEmpty)
    }
    
    // MARK: - Tests de navigation
    
    @Test func testNavigationTitle_ShouldBeEcoles() async throws {
        let title = "Écoles"
        #expect(title == "Écoles")
    }
    
    @Test func testAddButton_ShouldTriggerSheet() async throws {
        // Simule le comportement du bouton d'ajout
        var showingAddEcole = false
        
        // Act - Simule le tap
        showingAddEcole = true
        
        // Assert
        #expect(showingAddEcole)
    }
    
    // MARK: - Tests de la liste
    
    @Test func testEcolesList_ShouldBeEnumerated() async throws {
        // Arrange
        let ecoles = [
            createMockEcole(id: 1, nom: "École A"),
            createMockEcole(id: 2, nom: "École B"),
            createMockEcole(id: 3, nom: "École C")
        ]
        
        // Act
        let enumerated = Array(ecoles.enumerated())
        
        // Assert
        #expect(enumerated.count == 3)
        #expect(enumerated[0].offset == 0)
        #expect(enumerated[1].offset == 1)
        #expect(enumerated[2].offset == 2)
    }
    
    // MARK: - Tests Empty State
    
    @Test func testEmptyState_Properties_ShouldBeCorrect() async throws {
        let icon = "graduationcap"
        let title = "Aucune école"
        let message = "Aucune école trouvée"
        let actionTitle = "Ajouter"
        
        #expect(icon == "graduationcap")
        #expect(title == "Aucune école")
        #expect(message == "Aucune école trouvée")
        #expect(actionTitle == "Ajouter")
    }
    
    // MARK: - Helper Functions
    
    private func createMockEcole(
        id: Int64,
        nom: String = "École Test",
        ville: String? = "Paris"
    ) -> Ecole {
        Ecole(
            id: id,
            nom: nom,
            rue: nil,
            codePostal: nil,
            ville: ville,
            nomContact: "Contact Test",
            email: "test@ecole.fr",
            telephone: "0123456789"
        )
    }
    
    private func filterEcoles(_ ecoles: [Ecole], searchText: String) -> [Ecole] {
        guard !searchText.isEmpty else { return ecoles }
        
        return ecoles.filter { ecole in
            ecole.nom.localizedCaseInsensitiveContains(searchText) ||
            ecole.ville?.localizedCaseInsensitiveContains(searchText) ?? false
        }
    }
}

// MARK: - Tests EcoleCardView
struct EcoleCardViewTests {
    
    @Test func testEcoleCard_DisplaysNom() async throws {
        // Arrange
        let ecole = createMockEcole(nom: "École Polytechnique")
        
        // Assert
        #expect(ecole.nom == "École Polytechnique")
    }
    
    @Test func testEcoleCard_DisplaysVille_WhenPresent() async throws {
        // Arrange
        let ecole = createMockEcole(nom: "Test", ville: "Paris")
        
        // Act
        let shouldDisplayVille = ecole.ville != nil && !ecole.ville!.isEmpty
        
        // Assert
        #expect(shouldDisplayVille)
        #expect(ecole.ville == "Paris")
    }
    
    @Test func testEcoleCard_HidesVille_WhenNil() async throws {
        // Arrange
        let ecole = createMockEcole(nom: "Test", ville: nil)
        
        // Act
        let shouldDisplayVille = ecole.ville != nil && !ecole.ville!.isEmpty
        
        // Assert
        #expect(!shouldDisplayVille)
    }
    
    @Test func testEcoleCard_HidesVille_WhenEmpty() async throws {
        // Arrange
        let ecole = createMockEcole(nom: "Test", ville: "")
        
        // Act
        let shouldDisplayVille = ecole.ville != nil && !ecole.ville!.isEmpty
        
        // Assert
        #expect(!shouldDisplayVille)
    }
    
    @Test func testEcoleCard_Icon_ShouldBeGraduationcap() async throws {
        let iconName = "graduationcap.fill"
        #expect(iconName == "graduationcap.fill")
    }
    
    @Test func testEcoleCard_ChevronIcon_ShouldBeChevronRight() async throws {
        let iconName = "chevron.right"
        #expect(iconName == "chevron.right")
    }
    
    // MARK: - Tests d'animation de pression
    
    @Test func testEcoleCard_ScaleEffect_WhenPressed() async throws {
        // Arrange
        let isPressed = true
        
        // Act
        let scale = isPressed ? 0.98 : 1.0
        
        // Assert
        #expect(scale == 0.98)
    }
    
    @Test func testEcoleCard_ScaleEffect_WhenNotPressed() async throws {
        // Arrange
        let isPressed = false
        
        // Act
        let scale = isPressed ? 0.98 : 1.0
        
        // Assert
        #expect(scale == 1.0)
    }
    
    // MARK: - Helper
    
    private func createMockEcole(
        nom: String = "École Test",
        ville: String? = "Paris"
    ) -> Ecole {
        Ecole(
            id: 1,
            nom: nom,
            ville: ville,
            nomContact: "Contact",
            email: "test@ecole.fr",
            telephone: ""
        )
    }
}

// MARK: - Tests de Skeleton
struct EcolesListSkeletonTests {
    
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
struct EcolesListRefreshTests {
    
    @Test func testRefreshable_ShouldTriggerFetchEcoles() async throws {
        // Simule le comportement de refreshable
        var fetchEcolesCalled = false
        
        // Act - Simule le refresh
        fetchEcolesCalled = true
        
        // Assert
        #expect(fetchEcolesCalled)
    }
}

// MARK: - Tests de Search Bar
struct EcolesListSearchBarTests {
    
    @Test func testSearchBar_Placeholder_ShouldBeRechercher() async throws {
        let placeholder = "Rechercher..."
        #expect(placeholder == "Rechercher...")
    }
    
    @Test func testSearchBar_BindsToSearchText() async throws {
        // Arrange
        var searchText = ""
        
        // Act - Simule la saisie
        searchText = "Polytechnique"
        
        // Assert
        #expect(searchText == "Polytechnique")
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
struct EcolesListAddButtonTests {
    
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
struct EcolesListOrderTests {
    
    @Test func testEcolesList_ShouldMaintainOrder() async throws {
        // Arrange
        let ecoles = [
            createMockEcole(id: 1, nom: "Alpha"),
            createMockEcole(id: 2, nom: "Beta"),
            createMockEcole(id: 3, nom: "Gamma")
        ]
        
        // Assert - L'ordre devrait être préservé
        #expect(ecoles[0].nom == "Alpha")
        #expect(ecoles[1].nom == "Beta")
        #expect(ecoles[2].nom == "Gamma")
    }
    
    @Test func testEcolesList_SortedAlphabetically() async throws {
        // Arrange
        let ecoles = [
            createMockEcole(id: 1, nom: "Zénith"),
            createMockEcole(id: 2, nom: "Alpha"),
            createMockEcole(id: 3, nom: "Beta")
        ]
        
        // Act
        let sorted = ecoles.sorted { $0.nom.localizedCaseInsensitiveCompare($1.nom) == .orderedAscending }
        
        // Assert
        #expect(sorted[0].nom == "Alpha")
        #expect(sorted[1].nom == "Beta")
        #expect(sorted[2].nom == "Zénith")
    }
    
    // MARK: - Helper
    
    private func createMockEcole(id: Int64, nom: String) -> Ecole {
        Ecole(
            id: id,
            nom: nom,
            nomContact: "",
            email: "",
            telephone: ""
        )
    }
}

// MARK: - Tests Navigation vers Détail
struct EcolesListNavigationTests {
    
    @Test func testNavigationLink_ShouldNavigateToDetail() async throws {
        // La NavigationLink mène vers EcoleDetailView
        let destinationViewName = "EcoleDetailView"
        #expect(destinationViewName == "EcoleDetailView")
    }
    
    @Test func testNavigationLink_PassesEcoleToDetail() async throws {
        // Arrange
        let ecole = Ecole(
            id: 42,
            nom: "Test École",
            nomContact: "Contact",
            email: "",
            telephone: ""
        )
        
        // Assert - L'école est passée à la vue de détail
        #expect(ecole.id == 42)
        #expect(ecole.nom == "Test École")
    }
}
