# TODO List - LearnTrack iOS

## ✅ Fait (V1.0)

### Architecture & Configuration
- [x] Structure MVVM du projet
- [x] Configuration Supabase
- [x] KeychainManager pour le stockage sécurisé
- [x] Gestion des erreurs API

### Authentification
- [x] LoginView avec design moderne
- [x] AuthService avec Supabase Auth
- [x] Persistance de session
- [x] Déconnexion sécurisée
- [x] Réinitialisation mot de passe

### Modèles de données
- [x] Session avec toutes les propriétés
- [x] Formateur avec type interne/externe
- [x] Client avec infos fiscales
- [x] École avec coordonnées
- [x] User avec rôles

### Sessions
- [x] SessionsListView avec recherche et filtres
- [x] SessionDetailView avec toutes les infos
- [x] SessionFormView pour CRUD
- [x] Partage de sessions (Share Sheet)
- [x] Filtre par mois
- [x] Badges modalité (P/D)

### Formateurs
- [x] FormateursListView avec recherche
- [x] FormateurDetailView avec actions contact
- [x] FormateurFormView pour CRUD
- [x] Filtre interne/externe
- [x] Historique des sessions
- [x] Actions rapides (appel, email, SMS)

### Clients
- [x] ClientsListView avec recherche
- [x] ClientDetailView avec statistiques
- [x] ClientFormView pour CRUD
- [x] Historique des sessions
- [x] Calcul du CA total
- [x] Ouverture dans Plans

### Écoles
- [x] EcolesListView avec recherche
- [x] EcoleDetailView
- [x] EcoleFormView pour CRUD
- [x] Actions contact

### UI/UX
- [x] MainTabView avec 5 onglets
- [x] SearchBar réutilisable
- [x] EmptyStateView pour états vides
- [x] ShareSheet pour partage
- [x] ProfileView avec déconnexion
- [x] Support Dark Mode
- [x] Design moderne et cohérent

### Services
- [x] ContactService (appel, email, SMS, Maps)
- [x] ViewModels pour toutes les entités

## 🔧 À Faire (Avant Release)

### Tests
- [ ] Tests unitaires des ViewModels
- [ ] Tests des services
- [ ] Tests UI des parcours principaux
- [ ] Tests de sécurité (Keychain)

### Configuration Projet
- [ ] Configurer les credentials Supabase réels
- [ ] Ajouter les icônes de l'app (AppIcon)
- [ ] Configurer le Bundle ID
- [ ] Ajouter un écran de lancement (LaunchScreen)

### Documentation
- [ ] Commenter le code complexe
- [ ] Compléter le README avec screenshots
- [ ] Documenter les variables d'environnement
- [ ] Guide de déploiement App Store

### Optimisations
- [ ] Optimiser les requêtes Supabase
- [ ] Ajouter un cache local (optionnel)
- [ ] Pagination pour les grandes listes
- [ ] Gestion des erreurs réseau améliorée

### App Store
- [ ] Préparer les screenshots
- [ ] Rédiger la description App Store
- [ ] Politique de confidentialité
- [ ] Conditions d'utilisation

## 🚀 Roadmap Future (V1.1+)

### V1.1 - Améliorations UX
- [ ] Mode hors-ligne avec synchronisation
- [ ] Notifications push (rappels de sessions)
- [ ] Widget iOS (prochaines sessions)
- [ ] Siri Shortcuts
- [ ] Recherche Spotlight
- [ ] Haptic feedback

### V1.2 - Fonctionnalités métier
- [ ] Vue calendrier mensuel/hebdomadaire
- [ ] Dashboard avec KPIs
- [ ] Gestion des prospects
- [ ] Scanner de cartes de visite
- [ ] Export PDF des récapitulatifs
- [ ] Import/Export de données

### V2.0 - Fonctionnalités avancées
- [ ] Génération de contrats PDF
- [ ] Annonces Discord automatisées
- [ ] Signature électronique
- [ ] Intégration calendrier iOS (sync bidirectionnelle)
- [ ] Multi-entreprises
- [ ] Apple Watch companion app
- [ ] iPad split-view optimisée

### Technique
- [ ] Migration vers SwiftData (iOS 17+)
- [ ] Realtime avec Supabase Realtime
- [ ] CI/CD avec GitHub Actions
- [ ] Fastlane pour automatisation
- [ ] Analytics (Firebase ou Amplitude)

## 🐛 Bugs Connus

- Aucun pour le moment

## 💡 Idées

- [ ] Mode présentation pour projeter les sessions
- [ ] Thèmes de couleur personnalisables
- [ ] Statistiques détaillées par formateur
- [ ] Graphiques de CA mensuel/annuel
- [ ] Gestion des absences formateurs
- [ ] Système de notation des formateurs
- [ ] Chat intégré avec les formateurs
- [ ] Géolocalisation des formateurs disponibles
- [ ] Suggestions de formateurs par IA
- [ ] Templates d'emails personnalisables

## 📝 Notes

- Penser à configurer les credentials Supabase avant le premier lancement
- Tester sur plusieurs tailles d'écran (SE, Pro Max, iPad)
- Vérifier l'accessibilité (VoiceOver, Dynamic Type)
- Tester en conditions réelles (mauvaise connexion, etc.)

---

Dernière mise à jour : 4 décembre 2025
