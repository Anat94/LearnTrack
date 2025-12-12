//
//  FormateurViewModelTests.swift
//  LearnTrackTests
//
//  Tests unitaires pour FormateurViewModel
//

import XCTest
@testable import LearnTrack

@MainActor
class FormateurViewModelTests: XCTestCase {
    
    var viewModel: FormateurViewModel!
    var mockService: MockAPIService!
    
    override func setUp() {
        super.setUp()
        mockService = MockAPIService()
        viewModel = FormateurViewModel(service: mockService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }
    
    func testFetchFormateurs_Success() async {
        // Given
        let f1 = APIFormateur(id: 1, nom: "Dupont", prenom: "Jean", email: "jean@test.com", telephone: nil, specialites: ["Swift"], tarifJournalier: 500.0, adresse: nil, ville: nil, codePostal: nil, notes: nil, actif: true)
        mockService.formateurs = [f1]
        
        // When
        await viewModel.fetchFormateurs()
        
        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.formateurs.count, 1)
        XCTAssertEqual(viewModel.formateurs.first?.nom, "Dupont")
    }
    
    func testCreateFormateur() async throws {
        // Given
        let newFormateur = Formateur(prenom: "Alice", nom: "Martin", email: "alice@test.com", tarifJournalier: 450)
        
        // When
        try await viewModel.createFormateur(newFormateur)
        
        // Then
        XCTAssertEqual(mockService.formateurs.count, 1)
        XCTAssertEqual(mockService.formateurs.first?.nom, "Martin")
        XCTAssertEqual(mockService.formateurs.first?.tarifJournalier, 450.0)
    }
    
    func testFilterFormateurs() async {
        // Given
        let f1 = APIFormateur(id: 1, nom: "Dupont", prenom: "Jean", email: "jean@test.com", telephone: nil, specialites: ["Swift"], tarifJournalier: 500.0, adresse: nil, ville: nil, codePostal: nil, notes: nil, actif: true) // Interne (mock default logic)
        // Note: Mock logic for 'exterieur' relies on ExtrasStore which is hard to mock purely here without further refactoring, 
        // but we can test search text filtering.
        
        mockService.formateurs = [f1]
        await viewModel.fetchFormateurs()
        
        // When
        viewModel.searchText = "Swift"
        
        // Then
        XCTAssertEqual(viewModel.filteredFormateurs.count, 1)
        
        // When
        viewModel.searchText = "Java"
        
        // Then
        XCTAssertEqual(viewModel.filteredFormateurs.count, 0)
    }
}
