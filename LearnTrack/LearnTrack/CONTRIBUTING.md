# Contributing to LearnTrack iOS

Merci de votre intérêt pour contribuer à LearnTrack iOS ! 🎉

## 🤝 Comment contribuer

### Rapporter un bug

Si vous trouvez un bug, veuillez créer une issue avec :

1. **Titre clair** : Résumé du problème
2. **Description détaillée** :
   - Étapes pour reproduire
   - Comportement attendu
   - Comportement observé
   - Version iOS et modèle d'appareil
   - Captures d'écran si possible
3. **Logs** : Console Xcode si disponible

**Template** :
```markdown
### Description
[Décrivez le bug]

### Étapes pour reproduire
1. Aller sur...
2. Cliquer sur...
3. Voir l'erreur

### Comportement attendu
[Ce qui devrait se passer]

### Comportement observé
[Ce qui se passe réellement]

### Environnement
- iOS: 17.0
- Appareil: iPhone 15 Pro
- Version app: 1.0.0

### Logs
```
[Logs de la console]
```
```

### Proposer une fonctionnalité

Pour proposer une nouvelle fonctionnalité :

1. Vérifiez qu'elle n'existe pas déjà dans les issues
2. Créez une issue avec le label `enhancement`
3. Décrivez :
   - Le problème que ça résout
   - Comment vous imaginez la solution
   - Des exemples d'utilisation
   - Des captures d'écran ou wireframes si pertinent

### Contribuer au code

#### 1. Fork et clone

```bash
# Fork le repo sur GitHub
# Puis clone votre fork
git clone https://github.com/VOTRE-USERNAME/learntrack-ios.git
cd learntrack-ios
```

#### 2. Créer une branche

```bash
git checkout -b feature/ma-super-fonctionnalite
# ou
git checkout -b bugfix/correction-bug-xyz
```

**Convention de nommage des branches** :
- `feature/nom-feature` : Nouvelle fonctionnalité
- `bugfix/nom-bug` : Correction de bug
- `docs/sujet` : Documentation
- `refactor/sujet` : Refactoring
- `test/sujet` : Ajout de tests

#### 3. Développer

- Suivez les conventions de code (voir ci-dessous)
- Écrivez des tests si applicable
- Commentez le code complexe
- Mettez à jour la documentation si nécessaire

#### 4. Commit

Utilisez des messages de commit clairs suivant la convention :

```bash
git commit -m "feat: Add session export to PDF"
git commit -m "fix: Fix crash when session has no formateur"
git commit -m "docs: Update README with new setup instructions"
```

**Types de commits** :
- `feat` : Nouvelle fonctionnalité
- `fix` : Correction de bug
- `docs` : Documentation uniquement
- `style` : Formatage (pas de changement de code)
- `refactor` : Refactoring (ni bug ni feature)
- `test` : Ajout ou modification de tests
- `chore` : Maintenance (deps, config, etc.)
- `perf` : Amélioration des performances

#### 5. Push et Pull Request

```bash
git push origin feature/ma-super-fonctionnalite
```

Puis créez une Pull Request sur GitHub avec :

**Titre** : Résumé clair de ce que fait la PR

**Description** :
```markdown
## Description
[Décrivez les changements]

## Type de changement
- [ ] Bug fix
- [ ] Nouvelle fonctionnalité
- [ ] Breaking change
- [ ] Documentation

## Tests effectués
- [ ] Tests unitaires
- [ ] Tests UI
- [ ] Tests manuels sur iPhone
- [ ] Tests manuels sur iPad

## Checklist
- [ ] Le code suit les conventions du projet
- [ ] J'ai commenté le code complexe
- [ ] J'ai mis à jour la documentation
- [ ] Mes changements ne génèrent pas de warnings
- [ ] J'ai ajouté des tests
- [ ] Tous les tests passent
```

## 📝 Conventions de code

### Swift Style Guide

Nous suivons le [Swift Style Guide](https://google.github.io/swift/) de Google.

#### Indentation
- 4 espaces (pas de tabs)
- Accolades ouvrantes sur la même ligne

```swift
// ✅ Bon
func fetchSessions() {
    // code
}

// ❌ Mauvais
func fetchSessions()
{
    // code
}
```

#### Nommage

```swift
// ✅ Classes, Structs, Enums : PascalCase
class SessionViewModel { }
struct Session { }
enum Modalite { }

// ✅ Variables, functions : camelCase
var sessionsList: [Session] = []
func fetchSessions() { }

// ✅ Constants : camelCase
let maxRetryCount = 3

// ✅ Acronymes : Toujours en majuscule au début, sinon en minuscule
let userID: String  // Pas userId
let urlString: String  // Pas URLString
```

#### Organisation

```swift
// MARK: - Type Definition
struct Session: Codable {
    // MARK: - Properties
    let id: Int64?
    var module: String
    
    // MARK: - Computed Properties
    var displayDate: String {
        // ...
    }
    
    // MARK: - Methods
    func shareText() -> String {
        // ...
    }
}
```

#### SwiftUI

```swift
// ✅ Utilisez des computed properties pour des vues complexes
var body: some View {
    VStack {
        headerView
        contentView
        footerView
    }
}

private var headerView: some View {
    // ...
}

// ✅ Extrayez les vues réutilisables
struct SessionCard: View {
    let session: Session
    
    var body: some View {
        // ...
    }
}
```

### Documentation

```swift
/// Charge toutes les sessions depuis Supabase
/// 
/// Cette fonction effectue une requête asynchrone pour récupérer
/// toutes les sessions avec leurs relations (formateur, client, école).
///
/// - Throws: `APIError` si la requête échoue
/// - Returns: Void (met à jour `@Published var sessions`)
func fetchSessions() async throws {
    // ...
}
```

### Tests

```swift
// Nommage : test + Description du comportement
func testFetchSessionsReturnsNonEmptyArray() async throws {
    // Given (Arrange)
    let viewModel = SessionViewModel()
    
    // When (Act)
    await viewModel.fetchSessions()
    
    // Then (Assert)
    XCTAssertFalse(viewModel.sessions.isEmpty)
}
```

## 🧪 Tests

### Exécuter les tests

```bash
# Tous les tests
xcodebuild test -scheme LearnTrack -destination 'platform=iOS Simulator,name=iPhone 15'

# Tests unitaires uniquement
xcodebuild test -scheme LearnTrackTests

# Tests UI uniquement
xcodebuild test -scheme LearnTrackUITests
```

### Écrire des tests

- Un test par comportement
- Arrange-Act-Assert (Given-When-Then)
- Tests indépendants et répétables
- Mock les dépendances externes

## 📦 Dépendances

Avant d'ajouter une nouvelle dépendance :

1. Vérifiez qu'elle est vraiment nécessaire
2. Vérifiez qu'elle est maintenue activement
3. Vérifiez la license (compatible MIT)
4. Discutez-en dans une issue

## 🔍 Code Review

Les Pull Requests seront reviewées sur :

- ✅ Respect des conventions de code
- ✅ Tests (unitaires et UI si applicable)
- ✅ Documentation à jour
- ✅ Pas de régression
- ✅ Performance acceptable
- ✅ Sécurité (pas de credentials exposés)
- ✅ Accessibilité (VoiceOver, Dynamic Type)

## 🎯 Priorités

Les contributions les plus appréciées :

1. 🐛 Corrections de bugs
2. 📝 Améliorations de documentation
3. ✨ Fonctionnalités du TODO.md
4. 🧪 Ajout de tests
5. ♿ Améliorations d'accessibilité
6. 🌍 Traductions (futur)

## ❓ Questions

Pour toute question :

1. Consultez la documentation (README, QUICKSTART, etc.)
2. Cherchez dans les issues existantes
3. Créez une nouvelle issue avec le label `question`

## 📜 Code de conduite

Ce projet adhère au [Contributor Covenant](https://www.contributor-covenant.org/).

**En résumé** :
- Soyez respectueux et professionnel
- Accueillez les nouveaux contributeurs
- Acceptez les critiques constructives
- Focusez sur ce qui est mieux pour la communauté

## 📄 License

En contribuant, vous acceptez que vos contributions soient sous la même license que le projet (MIT).

## 🙏 Remerciements

Merci à tous les contributeurs qui rendent ce projet meilleur ! ❤️

---

**Happy Contributing! 🚀**
