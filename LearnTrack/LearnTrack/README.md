# LearnTrack iOS

Application iOS native de gestion de formations, développée en Swift/SwiftUI avec Supabase comme backend.

## 📱 Fonctionnalités

### V1.0
- ✅ **Authentification** : Connexion sécurisée avec Supabase Auth
- ✅ **Gestion des Sessions** : CRUD complet avec filtres et recherche
- ✅ **Gestion des Formateurs** : Annuaire avec actions rapides (appel, email, SMS)
- ✅ **Gestion des Clients** : Base de données clients avec historique
- ✅ **Gestion des Écoles** : Annuaire des établissements partenaires
- ✅ **Partage** : Partage de sessions via Discord, Mail, Messages
- ✅ **Dark Mode** : Support du mode sombre
- ✅ **Accessibilité** : Support VoiceOver et Dynamic Type

## 🛠 Stack Technique

- **Langage** : Swift 5.9+
- **UI Framework** : SwiftUI
- **Architecture** : MVVM (Model-View-ViewModel)
- **Backend** : Supabase (PostgreSQL + Auth + Realtime)
- **iOS Version** : iOS 16.0+
- **Dépendances** :
  - supabase-swift (SDK officiel)

## 📂 Structure du Projet

```
LearnTrack/
├── App/
│   └── LearnTrackApp.swift          # Point d'entrée
├── Core/
│   ├── Network/
│   │   ├── SupabaseManager.swift   # Configuration Supabase
│   │   └── APIError.swift           # Gestion des erreurs
│   ├── Auth/
│   │   ├── AuthService.swift        # Service d'authentification
│   │   └── KeychainManager.swift    # Stockage sécurisé
│   └── Extensions/
│       └── Extensions.swift         # Extensions utiles
├── Features/
│   ├── Auth/
│   │   └── Views/
│   │       ├── LoginView.swift
│   │       └── ResetPasswordView.swift
│   ├── Sessions/
│   │   ├── Models/Session.swift
│   │   ├── ViewModels/SessionViewModel.swift
│   │   └── Views/
│   │       ├── SessionsListView.swift
│   │       ├── SessionDetailView.swift
│   │       └── SessionFormView.swift
│   ├── Formateurs/
│   │   ├── Models/Formateur.swift
│   │   ├── ViewModels/FormateurViewModel.swift
│   │   └── Views/
│   ├── Clients/
│   │   ├── Models/Client.swift
│   │   ├── ViewModels/ClientViewModel.swift
│   │   └── Views/
│   ├── Ecoles/
│   │   ├── Models/Ecole.swift
│   │   ├── ViewModels/EcoleViewModel.swift
│   │   └── Views/
│   └── Profile/
│       └── Views/ProfileView.swift
├── Shared/
│   ├── Components/
│   │   ├── SearchBar.swift
│   │   ├── EmptyStateView.swift
│   │   └── ShareSheet.swift
│   ├── Services/
│   │   └── ContactService.swift
│   └── Views/
│       └── MainTabView.swift
└── Resources/
    └── Assets.xcassets/
```

## 🚀 Installation

### Prérequis
- Xcode 15.0+
- iOS 16.0+
- Compte Supabase

### Étapes

1. **Cloner le repository**
```bash
git clone https://github.com/votre-username/learntrack-ios.git
cd learntrack-ios
```

2. **Installer les dépendances Swift Package Manager**

Dans Xcode :
- File > Add Package Dependencies
- Ajouter : `https://github.com/supabase/supabase-swift`

3. **Configuration Supabase**

Éditer `Core/Network/SupabaseManager.swift` :

```swift
let supabaseURL = URL(string: "https://votre-projet.supabase.co")!
let supabaseKey = "votre-anon-key"
```

4. **Créer les tables Supabase**

Exécuter les migrations SQL pour créer les tables :
- `sessions`
- `formateurs`
- `clients`
- `ecoles`
- `users`

Voir le cahier des charges pour le schéma complet.

5. **Configurer Row Level Security (RLS)**

Activer RLS sur toutes les tables et créer les policies appropriées.

6. **Lancer l'application**
```bash
# Ouvrir dans Xcode
open LearnTrack.xcodeproj

# Ou avec xcodebuild
xcodebuild -scheme LearnTrack -destination 'platform=iOS Simulator,name=iPhone 15' build
```

## 🔐 Sécurité

- **Authentification** : JWT tokens via Supabase Auth
- **Stockage sécurisé** : Tokens stockés dans le Keychain iOS
- **Row Level Security** : Activé côté Supabase
- **HTTPS uniquement** : Toutes les communications sont chiffrées

## 📝 Utilisation

### Connexion
1. Lancer l'application
2. Saisir email et mot de passe
3. Se connecter

### Créer une session
1. Onglet "Sessions"
2. Appuyer sur le bouton "+"
3. Remplir le formulaire
4. Enregistrer

### Contacter un formateur
1. Onglet "Formateurs"
2. Sélectionner un formateur
3. Utiliser les boutons d'action rapide (Appeler, Email, SMS)

### Partager une session
1. Aller sur le détail d'une session
2. Appuyer sur "Partager"
3. Choisir Discord, Mail, Messages, etc.

## 🧪 Tests

```bash
# Tests unitaires
xcodebuild test -scheme LearnTrack -destination 'platform=iOS Simulator,name=iPhone 15'

# Tests UI
# À venir
```

## 📱 Captures d'écran

[À ajouter après le développement]

## 🗺 Roadmap

### V1.1
- [ ] Mode hors-ligne avec synchronisation
- [ ] Notifications push
- [ ] Widget iOS
- [ ] Siri Shortcuts

### V1.2
- [ ] Vue calendrier
- [ ] Dashboard avec statistiques
- [ ] Gestion des prospects
- [ ] Scanner de cartes de visite

### V2.0
- [ ] Génération de contrats PDF
- [ ] Annonces Discord automatisées
- [ ] Signature électronique
- [ ] Apple Watch companion app

## 🤝 Contribution

Les contributions sont les bienvenues ! Merci de :

1. Fork le projet
2. Créer une branche (`git checkout -b feature/AmazingFeature`)
3. Commit les changements (`git commit -m 'Add AmazingFeature'`)
4. Push vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrir une Pull Request

## 📄 License

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.

## 👥 Auteurs

- Développé pour LearnTrack CRM
- Version mobile iOS

## 🙏 Remerciements

- Supabase pour l'excellent backend
- Apple pour SwiftUI
- La communauté open source

## 📧 Contact

Pour toute question : [votre-email@example.com]

---

**LearnTrack iOS** - Gérez vos formations en mobilité 📚📱
