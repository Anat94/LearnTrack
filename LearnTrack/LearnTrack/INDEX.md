# 📑 Index des fichiers - LearnTrack iOS

Ce document liste tous les fichiers créés pour le projet LearnTrack iOS.

## 📊 Statistiques

- **Total fichiers Swift** : 42 fichiers
- **Total fichiers documentation** : 10 fichiers
- **Total lignes de code** : ~5000 lignes
- **Modules** : 7 modules principaux

---

## 📱 Code Source Swift (42 fichiers)

### App (1 fichier)
```
App/
└── LearnTrackApp.swift                    # Point d'entrée de l'application
```

### Core (5 fichiers)
```
Core/
├── Network/
│   ├── SupabaseManager.swift             # Configuration Supabase
│   └── APIError.swift                     # Gestion des erreurs API
├── Auth/
│   ├── AuthService.swift                  # Service d'authentification
│   └── KeychainManager.swift              # Stockage sécurisé tokens
└── Extensions/
    └── Extensions.swift                   # Extensions Swift/SwiftUI
```

### Features - Auth (2 fichiers)
```
Features/Auth/
└── Views/
    ├── LoginView.swift                    # Écran de connexion
    └── ResetPasswordView.swift            # Réinitialisation mot de passe
```

### Features - Sessions (7 fichiers)
```
Features/Sessions/
├── Models/
│   └── Session.swift                      # Modèle de données Session
├── ViewModels/
│   └── SessionViewModel.swift             # ViewModel Sessions
└── Views/
    ├── SessionsListView.swift             # Liste des sessions
    ├── SessionDetailView.swift            # Détail d'une session
    └── SessionFormView.swift              # Formulaire création/édition
```

### Features - Formateurs (7 fichiers)
```
Features/Formateurs/
├── Models/
│   └── Formateur.swift                    # Modèle de données Formateur
├── ViewModels/
│   └── FormateurViewModel.swift           # ViewModel Formateurs
└── Views/
    ├── FormateursListView.swift           # Liste des formateurs
    ├── FormateurDetailView.swift          # Détail d'un formateur
    └── FormateurFormView.swift            # Formulaire création/édition
```

### Features - Clients (7 fichiers)
```
Features/Clients/
├── Models/
│   └── Client.swift                       # Modèle de données Client
├── ViewModels/
│   └── ClientViewModel.swift              # ViewModel Clients
└── Views/
    ├── ClientsListView.swift              # Liste des clients
    ├── ClientDetailView.swift             # Détail d'un client
    └── ClientFormView.swift               # Formulaire création/édition
```

### Features - Écoles (7 fichiers)
```
Features/Ecoles/
├── Models/
│   └── Ecole.swift                        # Modèle de données École
├── ViewModels/
│   └── EcoleViewModel.swift               # ViewModel Écoles
└── Views/
    ├── EcolesListView.swift               # Liste des écoles
    ├── EcoleDetailView.swift              # Détail d'une école
    └── EcoleFormView.swift                # Formulaire création/édition
```

### Features - Profile (1 fichier)
```
Features/Profile/
└── Views/
    └── ProfileView.swift                  # Écran de profil utilisateur
```

### Shared - Components (3 fichiers)
```
Shared/Components/
├── SearchBar.swift                        # Barre de recherche réutilisable
├── EmptyStateView.swift                   # Vue pour états vides
└── ShareSheet.swift                       # Wrapper UIActivityViewController
```

### Shared - Services (1 fichier)
```
Shared/Services/
└── ContactService.swift                   # Service actions contact (appel, email)
```

### Shared - Views (1 fichier)
```
Shared/Views/
└── MainTabView.swift                      # Navigation principale (TabBar)
```

### Root (1 fichier)
```
ContentView.swift                          # Vue de contenu (wrapper)
```

---

## 📚 Documentation (10 fichiers)

```
Documentation/
├── README.md                              # Vue d'ensemble du projet
├── QUICKSTART.md                          # Guide de démarrage rapide
├── ARCHITECTURE.md                        # Architecture détaillée
├── SUPABASE_SETUP.md                      # Configuration Supabase
├── DEVELOPMENT.md                         # Notes de développement
├── TODO.md                                # Suivi des tâches
├── CHANGELOG.md                           # Historique des versions
├── CONTRIBUTING.md                        # Guide de contribution
├── PROJECT_SUMMARY.md                     # Résumé du projet
└── INDEX.md                               # Ce fichier
```

---

## 🔧 Configuration (2 fichiers)

```
Configuration/
├── .gitignore                             # Fichiers à ignorer par Git
└── LICENSE                                # Licence MIT
```

---

## 📂 Détails par catégorie

### Modèles de données (5 fichiers)
1. `Session.swift` - Structure des sessions de formation
2. `Formateur.swift` - Structure des formateurs
3. `Client.swift` - Structure des clients
4. `Ecole.swift` - Structure des écoles
5. `User.swift` - Structure des utilisateurs (dans AuthService.swift)

### ViewModels (5 fichiers)
1. `SessionViewModel.swift` - Logique sessions
2. `FormateurViewModel.swift` - Logique formateurs
3. `ClientViewModel.swift` - Logique clients
4. `EcoleViewModel.swift` - Logique écoles
5. `AuthService.swift` - Logique authentification

### Vues principales (15 fichiers)
1. **Auth** : LoginView, ResetPasswordView
2. **Sessions** : List, Detail, Form
3. **Formateurs** : List, Detail, Form
4. **Clients** : List, Detail, Form
5. **Écoles** : List, Detail, Form
6. **Profile** : ProfileView
7. **Navigation** : MainTabView

### Composants réutilisables (3 fichiers)
1. `SearchBar.swift` - Recherche
2. `EmptyStateView.swift` - États vides
3. `ShareSheet.swift` - Partage

### Services (3 fichiers)
1. `AuthService.swift` - Authentification
2. `ContactService.swift` - Actions contact
3. `SupabaseManager.swift` - API Backend

### Utilitaires (3 fichiers)
1. `KeychainManager.swift` - Stockage sécurisé
2. `APIError.swift` - Gestion d'erreurs
3. `Extensions.swift` - Extensions Swift

---

## 🎨 Assets (2 dossiers)

```
Assets.xcassets/
├── AppIcon.appiconset/
│   └── Contents.json                      # Configuration icône app
└── AccentColor.colorset/
    └── Contents.json                      # Couleur d'accentuation
```

---

## 🗂 Organisation par fonctionnalité

### Module Sessions (7 fichiers)
- Model, ViewModel, 3 Views (List, Detail, Form)
- **Fonctionnalités** : CRUD, Recherche, Filtres, Partage

### Module Formateurs (7 fichiers)
- Model, ViewModel, 3 Views (List, Detail, Form)
- **Fonctionnalités** : CRUD, Actions contact, Historique

### Module Clients (7 fichiers)
- Model, ViewModel, 3 Views (List, Detail, Form)
- **Fonctionnalités** : CRUD, Actions contact, Statistiques

### Module Écoles (7 fichiers)
- Model, ViewModel, 3 Views (List, Detail, Form)
- **Fonctionnalités** : CRUD, Actions contact

### Module Auth (3 fichiers)
- Service, 2 Views (Login, Reset)
- **Fonctionnalités** : Login, Logout, Reset password

### Module Core (5 fichiers)
- Network, Auth, Extensions
- **Fonctionnalités** : API, Sécurité, Utilitaires

### Module Shared (5 fichiers)
- Components, Services, Views
- **Fonctionnalités** : Composants réutilisables

---

## 📊 Répartition du code

| Catégorie | Nombre de fichiers | % |
|-----------|-------------------|---|
| Views | 15 | 36% |
| ViewModels | 5 | 12% |
| Models | 5 | 12% |
| Services | 3 | 7% |
| Components | 3 | 7% |
| Core | 5 | 12% |
| App | 1 | 2% |
| Documentation | 10 | 24% |

---

## 🔍 Fichiers clés à connaître

### Pour démarrer
1. **LearnTrackApp.swift** - Point d'entrée
2. **SupabaseManager.swift** - Configuration API (⚠️ À configurer)
3. **MainTabView.swift** - Navigation principale

### Pour l'authentification
1. **AuthService.swift** - Gestion auth
2. **LoginView.swift** - Interface login
3. **KeychainManager.swift** - Sécurité

### Pour les sessions
1. **Session.swift** - Modèle
2. **SessionViewModel.swift** - Logique
3. **SessionsListView.swift** - Interface

### Pour la documentation
1. **README.md** - Vue d'ensemble
2. **QUICKSTART.md** - Guide rapide
3. **ARCHITECTURE.md** - Structure du projet

---

## 📱 Taille du projet

```
Total estimé :
- Swift code : ~4500 lignes
- Documentation : ~2500 lignes
- Total : ~7000 lignes
```

---

## 🎯 Navigation rapide

### Je veux...

**Comprendre l'architecture**
→ Lire `ARCHITECTURE.md`

**Démarrer rapidement**
→ Suivre `QUICKSTART.md`

**Configurer Supabase**
→ Lire `SUPABASE_SETUP.md`

**Ajouter une fonctionnalité**
→ Lire `CONTRIBUTING.md` + `TODO.md`

**Débugger un problème**
→ Lire `DEVELOPMENT.md`

**Voir le code d'authentification**
→ Ouvrir `Core/Auth/AuthService.swift`

**Voir une liste**
→ Ouvrir n'importe quel `*ListView.swift`

**Voir un formulaire**
→ Ouvrir n'importe quel `*FormView.swift`

---

## ✅ Checklist de vérification

Avant de commencer, vérifiez que vous avez :

- [ ] Tous les fichiers Swift (42 fichiers)
- [ ] Toute la documentation (10 fichiers)
- [ ] Les fichiers de configuration (2 fichiers)
- [ ] Le dossier Assets configuré
- [ ] Xcode 15.0+ installé
- [ ] Un compte Supabase créé

---

## 🚀 Prochaines étapes

1. **Lire** `QUICKSTART.md`
2. **Configurer** Supabase
3. **Éditer** `SupabaseManager.swift`
4. **Installer** les dépendances
5. **Lancer** l'application
6. **Tester** les fonctionnalités
7. **Développer** de nouvelles features !

---

**LearnTrack iOS - Index complet**
Version 1.0.0 - Décembre 2025

Projet créé avec ❤️ et SwiftUI
