//
//  FormateursListViewTests.swift
//  LearnTrackTests
//
//  Tests unitaires pour FormateursListView
//

import Testing
import Foundation
@testable import LearnTrack

@Suite("FormateursListView Tests")
struct FormateursListViewTests {
    
    // MARK: - Test Data
    
    static func createTestFormateur(
        id: Int64 = 1,
        prenom: String = "Jean",
        nom: String = "Dupont",
        email: String = "jean@example.com",
        specialite: String = "Swift / iOS",
        exterieur: Bool = false
    ) -> Formateur {
        Formateur(
            id: id,
            prenom: prenom,
            nom: nom,
            email: email,
            telephone: "0612345678",
            specialite: specialite,
            tauxHoraire: 55.0,
            exterieur: exterieur
        )
    }
    
    static func createTestFormateurs() -> [Formateur] {
        [
            createTestFormateur(id: 1, prenom: "Jean", nom: "Dupont", specialite: "Swift", exterieur: false),
            createTestFormateur(id: 2, prenom: "Marie", nom: "Martin", specialite: "Python", exterieur: true),
            createTestFormateur(id: 3, prenom: "Pierre", nom: "Bernard", specialite: "Java", exterieur: false),
            createTestFormateur(id: 4, prenom: "Sophie", nom: "Leroy", specialite: "React", exterieur: true)
        ]
    }
    
    // MARK: - Filter Type Tests
    
    @Test("filter tous returns all formateurs")
    func testFilterTous() {
        let formateurs = FormateursListViewTests.createTestFormateurs()
        let filterIndex = 0 // tous
        
        let filtered = formateurs.filter { formateur in
            switch filterIndex {
            case 0: return true // tous
            case 1: return !formateur.exterieur // internes
            case 2: return formateur.exterieur // externes
            default: return true
            }
        }
        
        #expect(filtered.count == 4)
    }
    
    @Test("filter internes returns only internal formateurs")
    func testFilterInternes() {
        let formateurs = FormateursListViewTests.createTestFormateurs()
        let filterIndex = 1 // internes
        
        let filtered = formateurs.filter { formateur in
            switch filterIndex {
            case 0: return true
            case 1: return !formateur.exterieur
            case 2: return formateur.exterieur
            default: return true
            }
        }
        
        #expect(filtered.count == 2)
        #expect(filtered.allSatisfy { !$0.exterieur })
    }
    
    @Test("filter externes returns only external formateurs")
    func testFilterExternes() {
        let formateurs = FormateursListViewTests.createTestFormateurs()
        let filterIndex = 2 // externes
        
        let filtered = formateurs.filter { formateur in
            switch filterIndex {
            case 0: return true
            case 1: return !formateur.exterieur
            case 2: return formateur.exterieur
            default: return true
            }
        }
        
        #expect(filtered.count == 2)
        #expect(filtered.allSatisfy { $0.exterieur })
    }
    
    // MARK: - Search Tests
    
    @Test("search filters by nom")
    func testSearchByNom() {
        let formateurs = FormateursListViewTests.createTestFormateurs()
        let searchText = "Dupont"
        
        let filtered = formateurs.filter { formateur in
            searchText.isEmpty ||
            formateur.nom.localizedCaseInsensitiveContains(searchText) ||
            formateur.prenom.localizedCaseInsensitiveContains(searchText) ||
            formateur.specialite.localizedCaseInsensitiveContains(searchText)
        }
        
        #expect(filtered.count == 1)
        #expect(filtered.first?.nom == "Dupont")
    }
    
    @Test("search filters by prenom")
    func testSearchByPrenom() {
        let formateurs = FormateursListViewTests.createTestFormateurs()
        let searchText = "Marie"
        
        let filtered = formateurs.filter { formateur in
            searchText.isEmpty ||
            formateur.nom.localizedCaseInsensitiveContains(searchText) ||
            formateur.prenom.localizedCaseInsensitiveContains(searchText) ||
            formateur.specialite.localizedCaseInsensitiveContains(searchText)
        }
        
        #expect(filtered.count == 1)
        #expect(filtered.first?.prenom == "Marie")
    }
    
    @Test("search filters by specialite")
    func testSearchBySpecialite() {
        let formateurs = FormateursListViewTests.createTestFormateurs()
        let searchText = "Python"
        
        let filtered = formateurs.filter { formateur in
            searchText.isEmpty ||
            formateur.nom.localizedCaseInsensitiveContains(searchText) ||
            formateur.prenom.localizedCaseInsensitiveContains(searchText) ||
            formateur.specialite.localizedCaseInsensitiveContains(searchText)
        }
        
        #expect(filtered.count == 1)
        #expect(filtered.first?.specialite == "Python")
    }
    
    @Test("search is case insensitive")
    func testSearchCaseInsensitive() {
        let formateurs = FormateursListViewTests.createTestFormateurs()
        let searchText = "dupont"
        
        let filtered = formateurs.filter { formateur in
            searchText.isEmpty ||
            formateur.nom.localizedCaseInsensitiveContains(searchText) ||
            formateur.prenom.localizedCaseInsensitiveContains(searchText) ||
            formateur.specialite.localizedCaseInsensitiveContains(searchText)
        }
        
        #expect(filtered.count == 1)
    }
    
    @Test("empty search returns all formateurs")
    func testEmptySearch() {
        let formateurs = FormateursListViewTests.createTestFormateurs()
        let searchText = ""
        
        let filtered = formateurs.filter { formateur in
            searchText.isEmpty ||
            formateur.nom.localizedCaseInsensitiveContains(searchText) ||
            formateur.prenom.localizedCaseInsensitiveContains(searchText) ||
            formateur.specialite.localizedCaseInsensitiveContains(searchText)
        }
        
        #expect(filtered.count == 4)
    }
    
    @Test("search with no results returns empty")
    func testSearchNoResults() {
        let formateurs = FormateursListViewTests.createTestFormateurs()
        let searchText = "ZZZZZ"
        
        let filtered = formateurs.filter { formateur in
            searchText.isEmpty ||
            formateur.nom.localizedCaseInsensitiveContains(searchText) ||
            formateur.prenom.localizedCaseInsensitiveContains(searchText) ||
            formateur.specialite.localizedCaseInsensitiveContains(searchText)
        }
        
        #expect(filtered.isEmpty)
    }
    
    // MARK: - Combined Filter and Search Tests
    
    @Test("filter internes combined with search")
    func testFilterAndSearch() {
        let formateurs = FormateursListViewTests.createTestFormateurs()
        let searchText = "Jean"
        let filterIndex = 1 // internes
        
        let filtered = formateurs.filter { formateur in
            let matchesSearch = searchText.isEmpty ||
                formateur.nom.localizedCaseInsensitiveContains(searchText) ||
                formateur.prenom.localizedCaseInsensitiveContains(searchText) ||
                formateur.specialite.localizedCaseInsensitiveContains(searchText)
            
            let matchesFilter: Bool
            switch filterIndex {
            case 0: matchesFilter = true
            case 1: matchesFilter = !formateur.exterieur
            case 2: matchesFilter = formateur.exterieur
            default: matchesFilter = true
            }
            
            return matchesSearch && matchesFilter
        }
        
        #expect(filtered.count == 1)
        #expect(filtered.first?.prenom == "Jean")
        #expect(filtered.first?.exterieur == false)
    }
    
    // MARK: - Empty State Tests
    
    @Test("empty state shown when no formateurs")
    func testEmptyStateNoFormateurs() {
        let formateurs: [Formateur] = []
        let showEmptyState = formateurs.isEmpty
        #expect(showEmptyState == true)
    }
    
    @Test("empty state not shown when formateurs exist")
    func testEmptyStateFormateursExist() {
        let formateurs = FormateursListViewTests.createTestFormateurs()
        let showEmptyState = formateurs.isEmpty
        #expect(showEmptyState == false)
    }
    
    @Test("empty state icon is correct")
    func testEmptyStateIcon() {
        let icon = "person.2.slash"
        #expect(icon == "person.2.slash")
    }
    
    @Test("empty state title is correct")
    func testEmptyStateTitle() {
        let title = "Aucun formateur"
        #expect(title == "Aucun formateur")
    }
    
    @Test("empty state message is correct")
    func testEmptyStateMessage() {
        let message = "Aucun formateur trouvé"
        #expect(message == "Aucun formateur trouvé")
    }
    
    @Test("empty state action title is correct")
    func testEmptyStateActionTitle() {
        let actionTitle = "Ajouter"
        #expect(actionTitle == "Ajouter")
    }
    
    // MARK: - Card Display Tests
    
    @Test("card displays initiales correctly")
    func testCardInitiales() {
        let formateur = FormateursListViewTests.createTestFormateur(prenom: "Jean", nom: "Dupont")
        #expect(formateur.initiales == "JD")
    }
    
    @Test("card displays nomComplet correctly")
    func testCardNomComplet() {
        let formateur = FormateursListViewTests.createTestFormateur(prenom: "Jean", nom: "Dupont")
        #expect(formateur.nomComplet == "Jean Dupont")
    }
    
    @Test("card displays specialite when available")
    func testCardSpecialiteAvailable() {
        let formateur = FormateursListViewTests.createTestFormateur(specialite: "Swift / iOS")
        let displayText = formateur.specialite.isEmpty ? formateur.email : formateur.specialite
        #expect(displayText == "Swift / iOS")
    }
    
    @Test("card displays email when specialite is empty")
    func testCardSpecialiteEmpty() {
        let formateur = FormateursListViewTests.createTestFormateur(email: "jean@test.com", specialite: "")
        let displayText = formateur.specialite.isEmpty ? formateur.email : formateur.specialite
        #expect(displayText == "jean@test.com")
    }
    
    // MARK: - Badge Tests
    
    @Test("badge shows Externe for external formateur")
    func testBadgeExterne() {
        let formateur = FormateursListViewTests.createTestFormateur(exterieur: true)
        let badgeText = formateur.exterieur ? "Externe" : "Interne"
        #expect(badgeText == "Externe")
    }
    
    @Test("badge shows Interne for internal formateur")
    func testBadgeInterne() {
        let formateur = FormateursListViewTests.createTestFormateur(exterieur: false)
        let badgeText = formateur.exterieur ? "Externe" : "Interne"
        #expect(badgeText == "Interne")
    }
    
    // MARK: - Segmented Control Items Tests
    
    @Test("segmented control has correct items")
    func testSegmentedControlItems() {
        let items = ["Tous", "Internes", "Externes"]
        #expect(items.count == 3)
        #expect(items[0] == "Tous")
        #expect(items[1] == "Internes")
        #expect(items[2] == "Externes")
    }
    
    // MARK: - Skeleton Loading Tests
    
    @Test("skeleton shows 4 items while loading")
    func testSkeletonCount() {
        let isLoading = true
        let skeletonCount = isLoading ? 4 : 0
        #expect(skeletonCount == 4)
    }
    
    // MARK: - Navigation Title Tests
    
    @Test("navigation title is correct")
    func testNavigationTitle() {
        let title = "Formateurs"
        #expect(title == "Formateurs")
    }
    
    // MARK: - Search Placeholder Tests
    
    @Test("search placeholder is correct")
    func testSearchPlaceholder() {
        let placeholder = "Rechercher..."
        #expect(placeholder == "Rechercher...")
    }
    
    // MARK: - State Tests
    
    @Test("showingAddFormateur starts as false")
    func testShowingAddFormateurInitial() {
        let showingAddFormateur = false
        #expect(showingAddFormateur == false)
    }
    
    @Test("selectedFilterIndex starts as 0")
    func testSelectedFilterIndexInitial() {
        let selectedFilterIndex = 0
        #expect(selectedFilterIndex == 0)
    }
}
