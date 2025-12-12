//
//  EcoleViewModelTests.swift
//  LearnTrackTests
//
//  Tests unitaires pour EcoleViewModel
//

import XCTest
@testable import LearnTrack

@MainActor
class EcoleViewModelTests: XCTestCase {
    
    var viewModel: EcoleViewModel!
    var mockService: MockAPIService!
    
    override func setUp() {
        super.setUp()
        mockService = MockAPIService()
        viewModel = EcoleViewModel(service: mockService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }
    
    func testFetchEcoles_Success() async {
        // Given
        let e1 = APIEcole(id: 1, nom: "ESN Academy", adresse: "Rue Code", ville: "Paris", codePostal: "75000", telephone: nil, email: "contact@esn.com", responsableNom: "Director", capacite: 30, notes: nil, actif: true)
        mockService.ecoles = [e1]
        
        // When
        await viewModel.fetchEcoles()
        
        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.ecoles.count, 1)
        XCTAssertEqual(viewModel.ecoles.first?.nom, "ESN Academy")
    }
    
    func testCreateEcole() async throws {
        // Given
        let newEcole = Ecole(nom: "New School", rue: "Avenue", codePostal: "69000", ville: "Lyon", nomContact: "Headmaster", email: "contact@newschool.com", telephone: "0102030405")
        
        // When
        try await viewModel.createEcole(newEcole)
        
        // Then
        XCTAssertEqual(mockService.ecoles.count, 1)
        XCTAssertEqual(mockService.ecoles.first?.nom, "New School")
    }
    
    func testDeleteEcole() async throws {
        // Given
        let e1 = APIEcole(id: 1, nom: "ESN Academy", adresse: nil, ville: nil, codePostal: nil, telephone: nil, email: nil, responsableNom: nil, capacite: nil, notes: nil, actif: true)
        mockService.ecoles = [e1]
        await viewModel.fetchEcoles()
        
        guard let ecoleToDelete = viewModel.ecoles.first else { XCTFail(); return }
        
        // When
        try await viewModel.deleteEcole(ecoleToDelete)
        
        // Then
        XCTAssertTrue(mockService.ecoles.isEmpty)
        XCTAssertTrue(viewModel.ecoles.isEmpty)
    }
}
