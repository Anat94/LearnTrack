# 📝 Notes de Développement - LearnTrack iOS

## ⚠️ Important à savoir avant de commencer

### 1. Configuration Supabase obligatoire

**AVANT** de lancer l'app, vous **DEVEZ** configurer vos credentials Supabase dans :
```
Core/Network/SupabaseManager.swift
```

Sinon, l'app plantera au démarrage.

### 2. Dépendances Swift Package Manager

L'app nécessite le package **supabase-swift**. Xcode devrait le télécharger automatiquement, mais si ce n'est pas le cas :

```
File > Add Package Dependencies
URL: https://github.com/supabase/supabase-swift
Version: 2.0.0+
```

### 3. Base de données Supabase

Vous devez créer les tables dans Supabase **avant** d'utiliser l'app. Suivez `SUPABASE_SETUP.md`.

## 🎯 Points d'entrée du code

### Démarrage de l'app
```swift
LearnTrackApp.swift → vérifie l'authentification → LoginView ou MainTabView
```

### Navigation principale
```swift
MainTabView.swift → 5 onglets (TabView)
```

### Authentification
```swift
Core/Auth/AuthService.swift → Singleton partagé
```

### Configuration API
```swift
Core/Network/SupabaseManager.swift → Singleton Supabase
```

## 🔧 Commandes Xcode utiles

### Nettoyage
```
Cmd + Shift + K → Clean Build Folder
```

### Build et Run
```
Cmd + R → Build et lancer
```

### Tester
```
Cmd + U → Run tests
```

### Formater le code
```
Ctrl + I → Indenter la sélection
```

## 📱 Simulateurs recommandés

- **iPhone 15 Pro** (recommandé) - Écran moyen
- **iPhone SE (3rd gen)** - Petit écran
- **iPhone 15 Pro Max** - Grand écran
- **iPad Pro 12.9"** - Tablette

## 🐛 Debugging

### Logs Supabase
Activez les logs détaillés :
```swift
// Dans SupabaseManager.swift
client.auth.debug = true
```

### Logs réseau
Utilisez le Network Link Conditioner dans Xcode pour simuler une mauvaise connexion.

### Breakpoints utiles
- `AuthService.signIn()` → Vérifier l'authentification
- `SessionViewModel.fetchSessions()` → Vérifier les requêtes
- `KeychainManager.save()` → Vérifier le stockage

## 🔒 Sécurité - Checklist

- [ ] Ne **JAMAIS** commiter les credentials Supabase
- [ ] Utiliser des variables d'environnement pour les clés
- [ ] Activer RLS sur toutes les tables Supabase
- [ ] Vérifier les permissions avant chaque action sensible
- [ ] Utiliser HTTPS uniquement
- [ ] Stocker les tokens dans le Keychain uniquement

## 📚 Conventions de code

### Nommage

**Fichiers** :
- PascalCase : `SessionListView.swift`
- Suffixes : `View`, `ViewModel`, `Service`, `Manager`

**Variables** :
- camelCase : `var sessionsList = []`
- Descriptif : `isLoading` plutôt que `loading`

**Fonctions** :
- camelCase : `func fetchSessions()`
- Verbes d'action : `fetch`, `create`, `update`, `delete`

### Organisation du code

```swift
// MARK: - Properties
@Published var sessions: [Session] = []

// MARK: - Initialization
init() { ... }

// MARK: - Public Methods
func fetchSessions() { ... }

// MARK: - Private Methods
private func handleError() { ... }
```

### Comments

```swift
// Commentaire simple pour une ligne

/// Documentation pour une fonction
/// - Parameter id: L'identifiant de la session
/// - Returns: La session trouvée
func getSession(by id: Int64) -> Session? {
    // Implémentation
}
```

## 🧪 Tests

### Structure des tests

```
LearnTrackTests/
├── ViewModels/
│   ├── SessionViewModelTests.swift
│   ├── FormateurViewModelTests.swift
│   └── ...
├── Services/
│   ├── AuthServiceTests.swift
│   └── ContactServiceTests.swift
└── Models/
    └── SessionTests.swift
```

### Exemple de test

```swift
import XCTest
@testable import LearnTrack

final class SessionViewModelTests: XCTestCase {
    var sut: SessionViewModel!  // System Under Test
    
    override func setUp() {
        super.setUp()
        sut = SessionViewModel()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testFetchSessions() async throws {
        // Given
        let initialCount = sut.sessions.count
        
        // When
        await sut.fetchSessions()
        
        // Then
        XCTAssertGreaterThan(sut.sessions.count, initialCount)
    }
}
```

## 🎨 Personnalisation

### Couleurs

Modifiez `Assets.xcassets/AccentColor.colorset/Contents.json` :
```json
{
  "colors" : [
    {
      "color" : {
        "color-space" : "srgb",
        "components" : {
          "red" : "0.000",
          "green" : "0.478",
          "blue" : "1.000"
        }
      }
    }
  ]
}
```

### Icône de l'app

Remplacez les images dans `Assets.xcassets/AppIcon.appiconset/`

Tailles requises :
- 1024x1024 (App Store)
- 60x60, 120x120, 180x180 (iPhone)
- 76x76, 152x152 (iPad)

Utilisez https://appicon.co pour générer toutes les tailles.

## 📦 Dépendances et versions

### Swift Package Manager

```
supabase-swift: 2.0.0+
├── Dependencies:
│   ├── swift-http-types
│   ├── swift-concurrency-extras
│   └── ...
```

Pour mettre à jour :
```
File > Packages > Update to Latest Package Versions
```

## 🚀 Déploiement

### TestFlight

1. Archive l'app : `Product > Archive`
2. Upload vers App Store Connect
3. Créer une build externe
4. Inviter des testeurs

### App Store

1. Créer une fiche dans App Store Connect
2. Screenshots (obligatoires) :
   - 6.5" iPhone (1242 x 2688)
   - 5.5" iPhone (1242 x 2208)
   - 12.9" iPad (2048 x 2732)
3. Description, mots-clés, catégorie
4. Soumission pour review

## 🔄 Git Workflow

### Branches

```
main → Production
develop → Développement
feature/nom-feature → Nouvelles fonctionnalités
bugfix/nom-bug → Corrections de bugs
```

### Commits

```bash
git commit -m "feat: Add session sharing feature"
git commit -m "fix: Fix crash on empty sessions list"
git commit -m "docs: Update README with setup instructions"
```

Types de commits :
- `feat` : Nouvelle fonctionnalité
- `fix` : Correction de bug
- `docs` : Documentation
- `style` : Formatage
- `refactor` : Refactoring
- `test` : Tests
- `chore` : Maintenance

## 📊 Métriques de code

### Complexité acceptable

- Fonctions : < 20 lignes
- Fichiers : < 300 lignes
- Cyclomatic complexity : < 10

### Tools utiles

- SwiftLint : Pour l'analyse statique
- SwiftFormat : Pour le formatage automatique

Installer :
```bash
brew install swiftlint swiftformat
```

## 🎓 Ressources d'apprentissage

### Documentation officielle
- [Swift.org](https://swift.org)
- [SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui)
- [Supabase Docs](https://supabase.com/docs)

### Livres recommandés
- "SwiftUI by Tutorials" - Ray Wenderlich
- "iOS Programming: The Big Nerd Ranch Guide"

### Chaînes YouTube
- Paul Hudson (Hacking with Swift)
- Sean Allen
- Stewart Lynch

## 💡 Tips & Tricks

### SwiftUI Preview

```swift
#Preview {
    SessionsListView()
        .environmentObject(AuthService.shared)
}
```

### Quick Debug

```swift
// Print en développement uniquement
#if DEBUG
print("DEBUG: \(sessions.count) sessions")
#endif
```

### Conditional Compilation

```swift
#if DEBUG
let supabaseURL = "https://dev.supabase.co"
#else
let supabaseURL = "https://prod.supabase.co"
#endif
```

## 🆘 FAQ

### Q: L'app ne compile pas
**R**: Clean Build Folder (Cmd+Shift+K) puis relancez

### Q: Supabase ne répond pas
**R**: Vérifiez l'URL et la clé, testez depuis Postman

### Q: Les données ne s'affichent pas
**R**: Vérifiez les RLS policies dans Supabase

### Q: Comment débugger les requêtes réseau ?
**R**: Utilisez l'onglet Network dans Instruments

### Q: L'app est lente
**R**: Profilez avec Instruments (Cmd+I) → Time Profiler

## 📞 Support

### En cas de problème

1. Consultez les logs Xcode
2. Vérifiez la console Supabase
3. Relisez QUICKSTART.md
4. Cherchez dans la documentation
5. Créez une issue sur GitHub

### Contributions

Pull requests bienvenues ! Voir CONTRIBUTING.md (à créer)

---

**Happy Coding! 🚀**

Dernière mise à jour : 4 décembre 2025
