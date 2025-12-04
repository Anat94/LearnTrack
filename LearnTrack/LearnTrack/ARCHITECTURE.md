# 🏗️ Architecture - LearnTrack iOS

## Vue d'ensemble

LearnTrack iOS suit une **architecture MVVM (Model-View-ViewModel)** pour une séparation claire des responsabilités, une meilleure testabilité et une maintenance facilitée.

## 📐 Diagramme de l'architecture

```
┌─────────────────────────────────────────────────────────────┐
│                         VIEWS (SwiftUI)                      │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │ SessionsList │  │ FormateurList│  │ ClientsList  │      │
│  │     View     │  │     View     │  │     View     │      │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘      │
└─────────┼──────────────────┼──────────────────┼─────────────┘
          │                  │                  │
          ▼                  ▼                  ▼
┌─────────────────────────────────────────────────────────────┐
│                      VIEWMODELS                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   Session    │  │  Formateur   │  │   Client     │      │
│  │  ViewModel   │  │  ViewModel   │  │  ViewModel   │      │
│  │ @Published   │  │ @Published   │  │ @Published   │      │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘      │
└─────────┼──────────────────┼──────────────────┼─────────────┘
          │                  │                  │
          └──────────────────┼──────────────────┘
                             ▼
┌─────────────────────────────────────────────────────────────┐
│                       SERVICES                               │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │    Auth      │  │   Contact    │  │  Supabase    │      │
│  │   Service    │  │   Service    │  │   Manager    │      │
│  └──────┬───────┘  └──────────────┘  └──────┬───────┘      │
└─────────┼──────────────────────────────────────┼─────────────┘
          │                                      │
          ▼                                      ▼
┌─────────────────────────────────────────────────────────────┐
│                       DATA LAYER                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   Keychain   │  │   Supabase   │  │    Models    │      │
│  │   Manager    │  │     SDK      │  │   (Codable)  │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└─────────────────────────────────────────────────────────────┘
```

## 🎯 Principes de conception

### 1. **Separation of Concerns**
Chaque couche a une responsabilité unique :
- **Views** : Interface utilisateur uniquement
- **ViewModels** : Logique de présentation et état
- **Services** : Logique métier et appels réseau
- **Models** : Structures de données

### 2. **Unidirectional Data Flow**
```
User Action → View → ViewModel → Service → API
                ↑         ↑
                └─────────┘
              @Published State
```

### 3. **Dependency Injection**
Les ViewModels reçoivent leurs dépendances via injection :
```swift
class SessionViewModel: ObservableObject {
    private let supabase = SupabaseManager.shared.client
    // Peut être injecté pour les tests
}
```

## 📦 Structure des dossiers détaillée

```
LearnTrack/
│
├── App/                                    # Point d'entrée
│   └── LearnTrackApp.swift                # @main, configuration initiale
│
├── Core/                                   # Fondations de l'app
│   ├── Network/
│   │   ├── SupabaseManager.swift         # Singleton, configuration API
│   │   └── APIError.swift                # Erreurs typées
│   ├── Auth/
│   │   ├── AuthService.swift             # Gestion authentification
│   │   └── KeychainManager.swift         # Stockage sécurisé tokens
│   └── Extensions/
│       └── Extensions.swift              # Extensions Swift/SwiftUI
│
├── Features/                              # Modules par fonctionnalité
│   ├── Auth/
│   │   └── Views/
│   │       ├── LoginView.swift
│   │       └── ResetPasswordView.swift
│   │
│   ├── Sessions/
│   │   ├── Models/
│   │   │   └── Session.swift            # Struct Codable
│   │   ├── ViewModels/
│   │   │   └── SessionViewModel.swift   # @Published, async/await
│   │   └── Views/
│   │       ├── SessionsListView.swift
│   │       ├── SessionDetailView.swift
│   │       └── SessionFormView.swift
│   │
│   ├── Formateurs/                       # Structure identique
│   ├── Clients/                          # Structure identique
│   ├── Ecoles/                           # Structure identique
│   └── Profile/
│       └── Views/
│           └── ProfileView.swift
│
├── Shared/                                # Composants réutilisables
│   ├── Components/
│   │   ├── SearchBar.swift
│   │   ├── EmptyStateView.swift
│   │   └── ShareSheet.swift
│   ├── Services/
│   │   └── ContactService.swift
│   └── Views/
│       └── MainTabView.swift            # Navigation principale
│
└── Resources/
    └── Assets.xcassets/
        ├── AppIcon.appiconset/
        └── AccentColor.colorset/
```

## 🔄 Flux de données détaillé

### Exemple : Créer une session

```swift
// 1. USER ACTION (View)
Button("Créer") {
    saveSession()  // Appel à la fonction
}

// 2. VIEW → VIEWMODEL
private func saveSession() {
    Task {
        try await viewModel.createSession(session)
    }
}

// 3. VIEWMODEL → SERVICE
func createSession(_ session: Session) async throws {
    // Appel à Supabase
    try await supabase
        .from("sessions")
        .insert(session)
        .execute()
    
    // Recharger les données
    await fetchSessions()
}

// 4. SERVICE → API (Supabase)
// HTTP POST vers Supabase

// 5. API → SERVICE → VIEWMODEL
// Réponse traitée, données décodées

// 6. VIEWMODEL → VIEW (via @Published)
@Published var sessions: [Session] = []
// SwiftUI redessine automatiquement la vue
```

## 🧩 Composants clés

### Views (SwiftUI)

**Responsabilités** :
- Afficher les données
- Capturer les actions utilisateur
- Réagir aux changements d'état (`@Published`)

**Caractéristiques** :
```swift
struct SessionsListView: View {
    @StateObject private var viewModel = SessionViewModel()
    
    var body: some View {
        // UI uniquement, pas de logique métier
    }
}
```

### ViewModels

**Responsabilités** :
- Gérer l'état de la vue
- Orchestrer les appels aux services
- Transformer les données pour la vue

**Caractéristiques** :
```swift
@MainActor  // Assure que les mises à jour UI sont sur le main thread
class SessionViewModel: ObservableObject {
    @Published var sessions: [Session] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchSessions() async { ... }
}
```

### Services

**Responsabilités** :
- Appels API
- Logique métier complexe
- Interaction avec le système (Keychain, Contacts, etc.)

**Caractéristiques** :
```swift
class ContactService {
    static let shared = ContactService()
    
    func call(phoneNumber: String) { ... }
    func sendEmail(to: String) { ... }
}
```

### Models

**Responsabilités** :
- Représenter les données
- Sérialisation/Désérialisation (Codable)
- Computed properties

**Caractéristiques** :
```swift
struct Session: Codable, Identifiable {
    let id: Int64?
    var module: String
    // ...
    
    var displayDate: String { ... }  // Computed property
}
```

## 🔐 Gestion de la sécurité

### 1. Authentication Flow

```
Launch → Check Token (Keychain) → Valid? → MainTabView
                 ↓                    ↓
                 └──── Invalid ───────┴→ LoginView
```

### 2. Token Storage

```swift
// Sauvegarde sécurisée
KeychainManager.shared.save(token, forKey: "access_token")

// Récupération
if let token = KeychainManager.shared.get("access_token") {
    // Utiliser le token
}
```

### 3. Row Level Security (RLS)

Géré côté Supabase, l'app envoie simplement le JWT :
```swift
supabase.auth.session.accessToken  // Automatique avec le SDK
```

## 🧪 Testabilité

### Tests unitaires des ViewModels

```swift
final class SessionViewModelTests: XCTestCase {
    var viewModel: SessionViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = SessionViewModel()
    }
    
    func testFetchSessions() async throws {
        await viewModel.fetchSessions()
        XCTAssertFalse(viewModel.sessions.isEmpty)
    }
}
```

### Tests UI

```swift
final class SessionsUITests: XCTestCase {
    func testCreateSession() {
        let app = XCUIApplication()
        app.launch()
        
        app.buttons["plus.circle.fill"].tap()
        // ... test du formulaire
    }
}
```

## 🎨 Patterns utilisés

### 1. **Singleton** (avec précaution)
```swift
class SupabaseManager {
    static let shared = SupabaseManager()
    private init() {}
}
```

### 2. **Observer Pattern** (Combine)
```swift
@Published var sessions: [Session] = []
// Les vues s'abonnent automatiquement
```

### 3. **Repository Pattern** (implicite)
```swift
// Le ViewModel agit comme un repository
class SessionViewModel {
    func fetchSessions() { ... }
    func createSession() { ... }
}
```

### 4. **Dependency Injection**
```swift
struct SessionFormView: View {
    @ObservedObject var viewModel: SessionViewModel  // Injecté
}
```

## 🚀 Optimisations

### 1. **Async/Await**
```swift
func fetchSessions() async {
    // Code asynchrone moderne et lisible
}
```

### 2. **@MainActor**
```swift
@MainActor
class SessionViewModel: ObservableObject {
    // Garantit les mises à jour UI sur le main thread
}
```

### 3. **Task Cancellation**
```swift
.task {
    await viewModel.fetchSessions()
}
// Annulation automatique quand la vue disparaît
```

## 📊 Performance

### Lazy Loading
```swift
List {
    ForEach(sessions) { session in
        // SwiftUI charge les cellules à la demande
    }
}
```

### Caching (futur)
```swift
// SwiftData ou Core Data pour cache local
@Query var sessions: [Session]
```

## 🔮 Évolutions futures

1. **Modularisation** : Extraire les features en Swift Packages
2. **SwiftData** : Remplacer la logique de cache par SwiftData
3. **TCA (The Composable Architecture)** : Pour une architecture encore plus structurée
4. **Realtime** : Intégrer Supabase Realtime pour la sync temps réel

---

**Cette architecture garantit** :
- ✅ Code maintenable et évolutif
- ✅ Tests faciles à écrire
- ✅ Séparation claire des responsabilités
- ✅ Performance optimale
- ✅ Expérience utilisateur fluide
