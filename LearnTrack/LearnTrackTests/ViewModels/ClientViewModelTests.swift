//
//  ClientViewModelTests.swift
//  LearnTrackTests
//
//  Tests unitaires pour ClientViewModel
//

import XCTest
@testable import LearnTrack

@MainActor
class ClientViewModelTests: XCTestCase {
    
    var viewModel: ClientViewModel!
    var mockService: MockAPIService!
    
    override func setUp() {
        super.setUp()
        mockService = MockAPIService()
        viewModel = ClientViewModel(service: mockService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }
    
    func testFetchClients_Success() async {
        // Given
        let c1 = APIClient(id: 1, nom: "TechCorp", email: "contact@tech.com", telephone: nil, adresse: "1 Rue Tech", ville: "TechCity", codePostal: "12345", siret: "123", contactNom: "CEO", contactEmail: nil, contactTelephone: nil, notes: nil, actif: true)
        mockService.clients = [c1]
        
        // When
        await viewModel.fetchClients()
        
        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.clients.count, 1)
        XCTAssertEqual(viewModel.clients.first?.raisonSociale, "TechCorp")
    }
    
    func testCreateClient() async throws {
        // Given
        let newClient = Client(raisonSociale: "NewCorp", rue: "Street", codePostal: "00000", ville: "BetaCity", nomContact: "Boss", email: "boss@newcorp.com", telephone: "0000", siret: "999")
        
        // When
        try await viewModel.createClient(newClient)
        
        // Then
        XCTAssertEqual(mockService.clients.count, 1)
        XCTAssertEqual(mockService.clients.first?.nom, "NewCorp")
    }
    
    func testDeleteClient() async throws {
        // Given
        let c1 = APIClient(id: 1, nom: "TechCorp", email: "contact@tech.com", telephone: nil, adresse: nil, ville: nil, codePostal: nil, siret: nil, contactNom: nil, contactEmail: nil, contactTelephone: nil, notes: nil, actif: true)
        mockService.clients = [c1]
        await viewModel.fetchClients()
        
        guard let clientToDelete = viewModel.clients.first else { XCTFail(); return }
        
        // When
        try await viewModel.deleteClient(clientToDelete)
        
        // Then
        XCTAssertTrue(mockService.clients.isEmpty)
        XCTAssertTrue(viewModel.clients.isEmpty)
    }
}
