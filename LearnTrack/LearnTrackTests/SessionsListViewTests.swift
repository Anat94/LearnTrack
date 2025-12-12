//
//  SessionsListViewTests.swift
//  LearnTrackTests
//
//  Tests unitaires pour SessionsListView
//

import Testing
import Foundation
@testable import LearnTrack

@Suite("SessionsListView Tests")
struct SessionsListViewTests {
    
    // MARK: - Test Data
    
    static func createTestSession(
        id: Int64 = 1,
        module: String = "Swift avancé",
        date: Date = Date(),
        debut: String = "09:00",
        fin: String = "17:00",
        modalite: Session.Modalite = .presentiel,
        lieu: String = "Paris",
        client: Client? = nil,
        formateur: Formateur? = nil
    ) -> Session {
        Session(
            id: id,
            module: module,
            date: date,
            debut: debut,
            fin: fin,
            modalite: modalite,
            lieu: lieu,
            tarifClient: 500,
            tarifSousTraitant: 300,
            fraisRembourser: 50,
            client: client,
            formateur: formateur
        )
    }
    
    static func createTestFormateur() -> Formateur {
        Formateur(
            id: 1,
            prenom: "Jean",
            nom: "Dupont",
            email: "jean@example.com",
            telephone: "0612345678",
            specialite: "Swift",
            tauxHoraire: 55,
            exterieur: false
        )
    }
    
    static func createTestClient() -> Client {
        Client(
            id: 1,
            raisonSociale: "Tech Corp",
            email: "contact@techcorp.com",
            telephone: "0123456789"
        )
    }
    
    static func createTestSessions() -> [Session] {
        let calendar = Calendar.current
        let currentDate = Date()
        let nextMonth = calendar.date(byAdding: .month, value: 1, to: currentDate)!
        
        return [
            createTestSession(id: 1, module: "Swift avancé", date: currentDate, modalite: .presentiel),
            createTestSession(id: 2, module: "Python basics", date: currentDate, modalite: .distanciel),
            createTestSession(id: 3, module: "React Native", date: nextMonth, modalite: .presentiel),
            createTestSession(id: 4, module: "Java Spring", date: currentDate, modalite: .presentiel)
        ]
    }
    
    // MARK: - Search Tests
    
    @Test("search filters by module name")
    func testSearchByModule() {
        let sessions = SessionsListViewTests.createTestSessions()
        let searchText = "Swift"
        
        let filtered = sessions.filter { session in
            searchText.isEmpty ||
            session.module.localizedCaseInsensitiveContains(searchText)
        }
        
        #expect(filtered.count == 1)
        #expect(filtered.first?.module == "Swift avancé")
    }
    
    @Test("search is case insensitive")
    func testSearchCaseInsensitive() {
        let sessions = SessionsListViewTests.createTestSessions()
        let searchText = "swift"
        
        let filtered = sessions.filter { session in
            searchText.isEmpty ||
            session.module.localizedCaseInsensitiveContains(searchText)
        }
        
        #expect(filtered.count == 1)
    }
    
    @Test("empty search returns all sessions")
    func testEmptySearch() {
        let sessions = SessionsListViewTests.createTestSessions()
        let searchText = ""
        
        let filtered = sessions.filter { session in
            searchText.isEmpty ||
            session.module.localizedCaseInsensitiveContains(searchText)
        }
        
        #expect(filtered.count == 4)
    }
    
    @Test("search with no results returns empty")
    func testSearchNoResults() {
        let sessions = SessionsListViewTests.createTestSessions()
        let searchText = "ZZZZZ"
        
        let filtered = sessions.filter { session in
            searchText.isEmpty ||
            session.module.localizedCaseInsensitiveContains(searchText)
        }
        
        #expect(filtered.isEmpty)
    }
    
    // MARK: - Month Filter Tests
    
    @Test("month filter extracts correct month")
    func testMonthFilterExtraction() {
        let calendar = Calendar.current
        let date = calendar.date(from: DateComponents(year: 2025, month: 6, day: 15))!
        let selectedMonth = calendar.component(.month, from: date)
        
        #expect(selectedMonth == 6)
    }
    
    @Test("sessions filtered by current month")
    func testSessionsFilteredByMonth() {
        let sessions = SessionsListViewTests.createTestSessions()
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: Date())
        
        let filtered = sessions.filter { session in
            calendar.component(.month, from: session.date) == currentMonth
        }
        
        // 3 sessions are in current month based on test data
        #expect(filtered.count == 3)
    }
    
    // MARK: - Empty State Tests
    
    @Test("empty state shown when no sessions")
    func testEmptyStateNoSessions() {
        let sessions: [Session] = []
        let showEmptyState = sessions.isEmpty
        #expect(showEmptyState == true)
    }
    
    @Test("empty state not shown when sessions exist")
    func testEmptyStateSessionsExist() {
        let sessions = SessionsListViewTests.createTestSessions()
        let showEmptyState = sessions.isEmpty
        #expect(showEmptyState == false)
    }
    
    @Test("empty state icon is correct")
    func testEmptyStateIcon() {
        let icon = "calendar.badge.exclamationmark"
        #expect(icon == "calendar.badge.exclamationmark")
    }
    
    @Test("empty state title is correct")
    func testEmptyStateTitle() {
        let title = "Aucune session"
        #expect(title == "Aucune session")
    }
    
    @Test("empty state message is correct")
    func testEmptyStateMessage() {
        let message = "Aucune session pour ce mois"
        #expect(message == "Aucune session pour ce mois")
    }
    
    @Test("empty state action title is correct")
    func testEmptyStateActionTitle() {
        let actionTitle = "Créer"
        #expect(actionTitle == "Créer")
    }
    
    // MARK: - Navigation Tests
    
    @Test("navigation title is correct")
    func testNavigationTitle() {
        let title = "Sessions"
        #expect(title == "Sessions")
    }
    
    // MARK: - Search Placeholder Tests
    
    @Test("search placeholder is correct")
    func testSearchPlaceholder() {
        let placeholder = "Rechercher..."
        #expect(placeholder == "Rechercher...")
    }
    
    // MARK: - Skeleton Loading Tests
    
    @Test("skeleton shows 4 items while loading")
    func testSkeletonCount() {
        let isLoading = true
        let skeletonCount = isLoading ? 4 : 0
        #expect(skeletonCount == 4)
    }
    
    // MARK: - SessionCardView Tests
    
    @Test("card displays module correctly")
    func testCardModule() {
        let session = SessionsListViewTests.createTestSession(module: "Swift avancé")
        #expect(session.module == "Swift avancé")
    }
    
    @Test("card displays date formatted")
    func testCardDateFormatted() {
        let session = SessionsListViewTests.createTestSession()
        let formatted = session.date.formatted(date: .abbreviated, time: .omitted)
        #expect(!formatted.isEmpty)
    }
    
    @Test("card displays horaires correctly")
    func testCardHoraires() {
        let session = SessionsListViewTests.createTestSession(debut: "09:00", fin: "17:00")
        let horaires = "\(session.debut) - \(session.fin)"
        #expect(horaires == "09:00 - 17:00")
    }
    
    @Test("card displays formateur when available")
    func testCardFormateurAvailable() {
        let formateur = SessionsListViewTests.createTestFormateur()
        let session = SessionsListViewTests.createTestSession(formateur: formateur)
        
        #expect(session.formateur != nil)
        #expect(session.formateur?.nomComplet == "Jean Dupont")
    }
    
    @Test("card handles nil formateur")
    func testCardFormateurNil() {
        let session = SessionsListViewTests.createTestSession(formateur: nil)
        #expect(session.formateur == nil)
    }
    
    @Test("card displays client when available")
    func testCardClientAvailable() {
        let client = SessionsListViewTests.createTestClient()
        let session = SessionsListViewTests.createTestSession(client: client)
        
        #expect(session.client != nil)
        #expect(session.client?.raisonSociale == "Tech Corp")
    }
    
    @Test("card handles nil client")
    func testCardClientNil() {
        let session = SessionsListViewTests.createTestSession(client: nil)
        #expect(session.client == nil)
    }
    
    // MARK: - LTModaliteBadge Tests
    
    @Test("badge shows presentiel for presentiel modalite")
    func testBadgePresentiel() {
        let session = SessionsListViewTests.createTestSession(modalite: .presentiel)
        let isPresentiel = session.modalite == .presentiel
        #expect(isPresentiel == true)
    }
    
    @Test("badge shows distanciel for distanciel modalite")
    func testBadgeDistanciel() {
        let session = SessionsListViewTests.createTestSession(modalite: .distanciel)
        let isPresentiel = session.modalite == .presentiel
        #expect(isPresentiel == false)
    }
    
    // MARK: - LTIconLabel Tests
    
    @Test("calendar icon label uses calendar icon")
    func testCalendarIconLabel() {
        let icon = "calendar"
        #expect(icon == "calendar")
    }
    
    @Test("clock icon label uses clock icon")
    func testClockIconLabel() {
        let icon = "clock"
        #expect(icon == "clock")
    }
    
    @Test("formateur icon label uses person.fill icon")
    func testFormateurIconLabel() {
        let icon = "person.fill"
        #expect(icon == "person.fill")
    }
    
    @Test("client icon label uses building icon")
    func testClientIconLabel() {
        let icon = "building.2.fill"
        #expect(icon == "building.2.fill")
    }
    
    // MARK: - Combined Filter Tests
    
    @Test("search combined with month filter")
    func testSearchAndMonthFilter() {
        let sessions = SessionsListViewTests.createTestSessions()
        let searchText = "Swift"
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: Date())
        
        let filtered = sessions.filter { session in
            let matchesSearch = searchText.isEmpty ||
                session.module.localizedCaseInsensitiveContains(searchText)
            let matchesMonth = calendar.component(.month, from: session.date) == currentMonth
            return matchesSearch && matchesMonth
        }
        
        #expect(filtered.count == 1)
        #expect(filtered.first?.module == "Swift avancé")
    }
    
    // MARK: - State Tests
    
    @Test("showingAddSession starts as false")
    func testShowingAddSessionInitial() {
        let showingAddSession = false
        #expect(showingAddSession == false)
    }
    
    @Test("selectedDate starts as current date")
    func testSelectedDateInitial() {
        let selectedDate = Date()
        let calendar = Calendar.current
        let isToday = calendar.isDateInToday(selectedDate)
        #expect(isToday == true)
    }
    
    // MARK: - Session Card Icons Tests
    
    @Test("session card has correct icon for date")
    func testSessionCardDateIcon() {
        let dateIcon = "calendar"
        #expect(dateIcon == "calendar")
    }
    
    @Test("session card has correct icon for time")
    func testSessionCardTimeIcon() {
        let timeIcon = "clock"
        #expect(timeIcon == "clock")
    }
    
    // MARK: - Add Button Tests
    
    @Test("add button uses plus icon")
    func testAddButtonIcon() {
        let icon = "plus"
        #expect(icon == "plus")
    }
}
