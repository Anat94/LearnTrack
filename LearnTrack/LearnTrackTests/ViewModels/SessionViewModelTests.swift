//
//  SessionViewModelTests.swift
//  LearnTrackTests
//
//  Tests unitaires pour SessionViewModel
//

import XCTest
@testable import LearnTrack

@MainActor
class SessionViewModelTests: XCTestCase {
    
    var viewModel: SessionViewModel!
    var mockService: MockAPIService!
    
    override func setUp() {
        super.setUp()
        mockService = MockAPIService()
        viewModel = SessionViewModel(service: mockService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }
    
    func testFetchSessions_Success() async {
        // Given
        let session = APISession(id: 1, titre: "Formation Swift", description: "Desc", dateDebut: "2023-10-01", dateFin: "2023-10-02", heureDebut: "09:00", heureFin: "17:00", clientId: nil, ecoleId: nil, formateurId: nil, nbParticipants: 10, statut: "PLANIFIEE", prix: 1000.0, notes: nil)
        mockService.sessions = [session]
        
        // When
        await viewModel.fetchSessions()
        
        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.sessions.count, 1)
        XCTAssertEqual(viewModel.sessions.first?.module, "Formation Swift")
    }
    
    func testFetchSessions_Failure() async {
        // Given
        mockService.shouldFail = true
        mockService.mockError = APIError.serverError("500")
        
        // When
        await viewModel.fetchSessions()
        
        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.sessions.isEmpty)
    }
    
    func testCreateSession() async throws {
        // Given
        let newSession = Session(module: "New Session", date: Date(), debut: "09:00", fin: "17:00", modalite: .presentiel, lieu: "Paris", tarifClient: 500, tarifSousTraitant: 300, fraisRembourser: 0, refContrat: nil)
        
        // When
        try await viewModel.createSession(newSession)
        
        // Then
        XCTAssertEqual(mockService.sessions.count, 1)
        XCTAssertEqual(mockService.sessions.first?.titre, "New Session")
    }
    
    func testDeleteSession() async throws {
        // Given
        let session = APISession(id: 1, titre: "Delete Me", description: nil, dateDebut: "2023-10-01", dateFin: "2023-10-01", heureDebut: "09:00", heureFin: "17:00", clientId: nil, ecoleId: nil, formateurId: nil, nbParticipants: nil, statut: nil, prix: nil, notes: nil)
        mockService.sessions = [session]
        await viewModel.fetchSessions() // Load into VM
        
        guard let sessionToDelete = viewModel.sessions.first else {
            XCTFail("Should have a session to delete")
            return
        }
        
        // When
        try await viewModel.deleteSession(sessionToDelete)
        
        // Then
        XCTAssertTrue(mockService.sessions.isEmpty)
        XCTAssertTrue(viewModel.sessions.isEmpty)
    }
    
    func testFilterSessions_Search() async {
        // Given
        let s1 = APISession(id: 1, titre: "Swift Basics", description: nil, dateDebut: "2023-10-01", dateFin: "2023-10-01", heureDebut: "09:00", heureFin: "17:00", clientId: nil, ecoleId: nil, formateurId: nil, nbParticipants: nil, statut: nil, prix: nil, notes: nil)
        let s2 = APISession(id: 2, titre: "Advanced Python", description: nil, dateDebut: "2023-10-02", dateFin: "2023-10-02", heureDebut: "09:00", heureFin: "17:00", clientId: nil, ecoleId: nil, formateurId: nil, nbParticipants: nil, statut: nil, prix: nil, notes: nil)
        mockService.sessions = [s1, s2]
        await viewModel.fetchSessions()
        
        // Check date for month filtering
        let month = Calendar.current.component(.month, from: DateFormatter().date(from: "2023-10-01")!)
        viewModel.selectedMonth = month
        
        // When
        viewModel.searchText = "Swift"
        
        // Then
        XCTAssertEqual(viewModel.filteredSessions.count, 1)
        XCTAssertEqual(viewModel.filteredSessions.first?.module, "Swift Basics")
    }
}
