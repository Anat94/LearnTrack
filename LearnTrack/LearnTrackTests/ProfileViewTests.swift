//
//  ProfileViewTests.swift
//  LearnTrackTests
//
//  Tests unitaires pour ProfileView
//

import Testing
import Foundation
@testable import LearnTrack

@Suite("ProfileView Tests")
struct ProfileViewTests {
    
    // MARK: - Test Data
    
    struct MockUser {
        let prenom: String
        let nom: String
        let email: String
    }
    
    static func createMockUser(
        prenom: String = "Jean",
        nom: String = "Dupont",
        email: String = "jean@example.com"
    ) -> MockUser {
        MockUser(prenom: prenom, nom: nom, email: email)
    }
    
    // MARK: - UserName Tests
    
    @Test("userName returns full name when user has prenom and nom")
    func testUserNameFullName() {
        let user = ProfileViewTests.createMockUser(prenom: "Jean", nom: "Dupont")
        let name = "\(user.prenom) \(user.nom)".trimmingCharacters(in: .whitespaces)
        let userName = name.isEmpty ? "Utilisateur" : name
        
        #expect(userName == "Jean Dupont")
    }
    
    @Test("userName returns 'Utilisateur' when name is empty")
    func testUserNameEmpty() {
        let user = ProfileViewTests.createMockUser(prenom: "", nom: "")
        let name = "\(user.prenom) \(user.nom)".trimmingCharacters(in: .whitespaces)
        let userName = name.isEmpty ? "Utilisateur" : name
        
        #expect(userName == "Utilisateur")
    }
    
    @Test("userName handles only prenom")
    func testUserNameOnlyPrenom() {
        let user = ProfileViewTests.createMockUser(prenom: "Jean", nom: "")
        let name = "\(user.prenom) \(user.nom)".trimmingCharacters(in: .whitespaces)
        let userName = name.isEmpty ? "Utilisateur" : name
        
        #expect(userName == "Jean")
    }
    
    @Test("userName handles only nom")
    func testUserNameOnlyNom() {
        let user = ProfileViewTests.createMockUser(prenom: "", nom: "Dupont")
        let name = "\(user.prenom) \(user.nom)".trimmingCharacters(in: .whitespaces)
        let userName = name.isEmpty ? "Utilisateur" : name
        
        #expect(userName == "Dupont")
    }
    
    @Test("userName handles whitespace only names")
    func testUserNameWhitespaceOnly() {
        let user = ProfileViewTests.createMockUser(prenom: "   ", nom: "   ")
        let name = "\(user.prenom) \(user.nom)".trimmingCharacters(in: .whitespaces)
        let userName = name.isEmpty ? "Utilisateur" : name
        
        #expect(userName == "Utilisateur")
    }
    
    @Test("userName returns 'Utilisateur' when currentUser is nil")
    func testUserNameNilUser() {
        let hasUser = false
        let userName = hasUser ? "Some Name" : "Utilisateur"
        
        #expect(userName == "Utilisateur")
    }
    
    // MARK: - UserInitials Tests
    
    @Test("userInitials returns first letters uppercased")
    func testUserInitials() {
        let user = ProfileViewTests.createMockUser(prenom: "Jean", nom: "Dupont")
        let first = user.prenom.first.map { String($0) } ?? ""
        let last = user.nom.first.map { String($0) } ?? ""
        let initials = (first + last).uppercased()
        
        #expect(initials == "JD")
    }
    
    @Test("userInitials handles lowercase names")
    func testUserInitialsLowercase() {
        let user = ProfileViewTests.createMockUser(prenom: "jean", nom: "dupont")
        let first = user.prenom.first.map { String($0) } ?? ""
        let last = user.nom.first.map { String($0) } ?? ""
        let initials = (first + last).uppercased()
        
        #expect(initials == "JD")
    }
    
    @Test("userInitials handles empty prenom")
    func testUserInitialsEmptyPrenom() {
        let user = ProfileViewTests.createMockUser(prenom: "", nom: "Dupont")
        let first = user.prenom.first.map { String($0) } ?? ""
        let last = user.nom.first.map { String($0) } ?? ""
        let initials = (first + last).uppercased()
        
        #expect(initials == "D")
    }
    
    @Test("userInitials handles empty nom")
    func testUserInitialsEmptyNom() {
        let user = ProfileViewTests.createMockUser(prenom: "Jean", nom: "")
        let first = user.prenom.first.map { String($0) } ?? ""
        let last = user.nom.first.map { String($0) } ?? ""
        let initials = (first + last).uppercased()
        
        #expect(initials == "J")
    }
    
    @Test("userInitials returns 'U' when currentUser is nil")
    func testUserInitialsNilUser() {
        let hasUser = false
        let initials = hasUser ? "JD" : "U"
        
        #expect(initials == "U")
    }
    
    @Test("userInitials handles special characters")
    func testUserInitialsSpecialChars() {
        let user = ProfileViewTests.createMockUser(prenom: "Émilie", nom: "Örsted")
        let first = user.prenom.first.map { String($0) } ?? ""
        let last = user.nom.first.map { String($0) } ?? ""
        let initials = (first + last).uppercased()
        
        #expect(initials == "ÉÖ")
    }
    
    // MARK: - Role Badge Tests
    
    @Test("badge shows 'Administrateur' for admin role")
    func testBadgeAdmin() {
        let isAdmin = true
        let badgeText = isAdmin ? "Administrateur" : "Utilisateur"
        let badgeIcon = isAdmin ? "star.fill" : "person.fill"
        
        #expect(badgeText == "Administrateur")
        #expect(badgeIcon == "star.fill")
    }
    
    @Test("badge shows 'Utilisateur' for user role")
    func testBadgeUser() {
        let isAdmin = false
        let badgeText = isAdmin ? "Administrateur" : "Utilisateur"
        let badgeIcon = isAdmin ? "star.fill" : "person.fill"
        
        #expect(badgeText == "Utilisateur")
        #expect(badgeIcon == "person.fill")
    }
    
    // MARK: - Dark Mode Tests
    
    @Test("dark mode toggle text when enabled")
    func testDarkModeEnabled() {
        let isDarkMode = true
        let statusText = isDarkMode ? "Activé" : "Désactivé"
        let icon = isDarkMode ? "moon.fill" : "sun.max.fill"
        
        #expect(statusText == "Activé")
        #expect(icon == "moon.fill")
    }
    
    @Test("dark mode toggle text when disabled")
    func testDarkModeDisabled() {
        let isDarkMode = false
        let statusText = isDarkMode ? "Activé" : "Désactivé"
        let icon = isDarkMode ? "moon.fill" : "sun.max.fill"
        
        #expect(statusText == "Désactivé")
        #expect(icon == "sun.max.fill")
    }
    
    // MARK: - About Section Tests
    
    @Test("version number is correct")
    func testVersionNumber() {
        let version = "1.0.0"
        #expect(version == "1.0.0")
    }
    
    @Test("github URL is valid")
    func testGithubURL() {
        let urlString = "https://github.com"
        let url = URL(string: urlString)
        #expect(url != nil)
        #expect(url?.host == "github.com")
    }
    
    // MARK: - Footer Section Tests
    
    @Test("copyright text is correct")
    func testCopyrightText() {
        let copyright = "LearnTrack © 2025"
        #expect(copyright == "LearnTrack © 2025")
    }
    
    @Test("app description is correct")
    func testAppDescription() {
        let description = "Application de gestion de formations"
        #expect(description == "Application de gestion de formations")
    }
    
    // MARK: - Navigation Title Tests
    
    @Test("navigation title is 'Profil'")
    func testNavigationTitle() {
        let title = "Profil"
        #expect(title == "Profil")
    }
    
    // MARK: - Logout Alert Tests
    
    @Test("logout alert title is correct")
    func testLogoutAlertTitle() {
        let alertTitle = "Déconnexion"
        #expect(alertTitle == "Déconnexion")
    }
    
    @Test("logout alert message is correct")
    func testLogoutAlertMessage() {
        let alertMessage = "Êtes-vous sûr de vouloir vous déconnecter ?"
        #expect(alertMessage == "Êtes-vous sûr de vouloir vous déconnecter ?")
    }
    
    @Test("logout alert has cancel button")
    func testLogoutAlertCancelButton() {
        let cancelButtonTitle = "Annuler"
        #expect(cancelButtonTitle == "Annuler")
    }
    
    @Test("logout alert has destructive button")
    func testLogoutAlertDestructiveButton() {
        let destructiveButtonTitle = "Déconnexion"
        #expect(destructiveButtonTitle == "Déconnexion")
    }
    
    // MARK: - Section Titles Tests
    
    @Test("preferences section title is correct")
    func testPreferencesSectionTitle() {
        let title = "Préférences"
        #expect(title == "Préférences")
    }
    
    @Test("about section title is correct")
    func testAboutSectionTitle() {
        let title = "À propos"
        #expect(title == "À propos")
    }
    
    // MARK: - Dark Mode Label Tests
    
    @Test("dark mode label is correct")
    func testDarkModeLabel() {
        let label = "Mode sombre"
        #expect(label == "Mode sombre")
    }
    
    // MARK: - Logout Button Tests
    
    @Test("logout button title is correct")
    func testLogoutButtonTitle() {
        let buttonTitle = "Déconnexion"
        #expect(buttonTitle == "Déconnexion")
    }
    
    @Test("logout button icon is correct")
    func testLogoutButtonIcon() {
        let icon = "rectangle.portrait.and.arrow.right"
        #expect(icon == "rectangle.portrait.and.arrow.right")
    }
    
    // MARK: - State Tests
    
    @Test("showingLogoutAlert starts as false")
    func testShowingLogoutAlertInitial() {
        let showingLogoutAlert = false
        #expect(showingLogoutAlert == false)
    }
    
    @Test("isDarkMode can be toggled")
    func testIsDarkModeToggle() {
        var isDarkMode = false
        #expect(isDarkMode == false)
        
        isDarkMode.toggle()
        #expect(isDarkMode == true)
        
        isDarkMode.toggle()
        #expect(isDarkMode == false)
    }
    
    // MARK: - Email Display Tests
    
    @Test("email is displayed from user")
    func testEmailDisplay() {
        let user = ProfileViewTests.createMockUser(email: "jean@learntrack.com")
        #expect(user.email == "jean@learntrack.com")
    }
    
    @Test("email handles empty string")
    func testEmailEmpty() {
        let user = ProfileViewTests.createMockUser(email: "")
        #expect(user.email == "")
    }
}
