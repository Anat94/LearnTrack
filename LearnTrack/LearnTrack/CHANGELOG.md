# Changelog - LearnTrack iOS

Toutes les modifications notables de ce projet seront documentées dans ce fichier.

Le format est basé sur [Keep a Changelog](https://keepachangelog.com/fr/1.0.0/),
et ce projet adhère au [Semantic Versioning](https://semver.org/lang/fr/).

## [Non publié]

### À venir
- Mode hors-ligne avec synchronisation
- Notifications push
- Widget iOS
- Vue calendrier

## [1.0.0] - 2025-12-04

### ✨ Ajouté

#### Authentification
- Connexion avec email/mot de passe via Supabase Auth
- Persistance automatique de session
- Déconnexion sécurisée avec suppression des tokens
- Écran de réinitialisation de mot de passe
- Stockage sécurisé des tokens dans le Keychain
- Gestion des rôles utilisateur (admin/user)

#### Sessions de formation
- Liste des sessions avec recherche et filtres
- Filtre par mois (précédent, actuel, suivant)
- Vue détaillée d'une session avec toutes les informations
- Création de nouvelles sessions
- Modification de sessions existantes
- Suppression de sessions (admin uniquement)
- Partage de sessions via iOS Share Sheet (Discord, Mail, Messages, etc.)
- Badges visuels pour modalité (Présentiel/Distanciel)
- Calcul automatique de la marge
- Sélection de formateur, client et école via pickers

#### Formateurs
- Liste des formateurs avec recherche
- Filtre par type (Tous/Internes/Externes)
- Fiche détaillée avec avatar et informations complètes
- Actions rapides : Appeler, Email, SMS
- Création de nouveaux formateurs
- Modification de formateurs existants
- Suppression de formateurs (admin uniquement)
- Historique des sessions d'un formateur
- Badge visuel pour type (Interne/Externe)
- Ouverture de l'adresse dans Plans

#### Clients
- Liste des clients avec recherche
- Fiche détaillée avec informations complètes
- Actions rapides : Appeler, Email
- Création de nouveaux clients
- Modification de clients existants
- Suppression de clients (admin uniquement)
- Historique des sessions d'un client
- Statistiques : nombre de sessions et CA total
- Ouverture de l'adresse dans Plans

#### Écoles
- Liste des écoles avec recherche
- Fiche détaillée avec informations complètes
- Actions rapides : Appeler, Email
- Création de nouvelles écoles
- Modification d'écoles existantes
- Suppression d'écoles (admin uniquement)
- Ouverture de l'adresse dans Plans

#### Interface et UX
- Navigation avec TabBar (5 onglets)
- Design moderne avec gradients et couleurs cohérentes
- Support du mode sombre (Dark Mode)
- Barre de recherche réutilisable
- États vides avec messages et icônes
- Pull-to-refresh sur toutes les listes
- Animations fluides
- Interface responsive (iPhone et iPad)

#### Profil utilisateur
- Affichage des informations utilisateur
- Badge de rôle (Admin/Utilisateur)
- Toggle mode sombre
- Informations de version
- Déconnexion avec confirmation

#### Architecture
- Architecture MVVM (Model-View-ViewModel)
- ViewModels avec @Published pour réactivité
- Services réutilisables (Auth, Contact)
- Gestion d'erreurs typée
- Extensions Swift/SwiftUI utiles
- Code commenté et documenté

#### Sécurité
- Authentification JWT via Supabase
- Row Level Security (RLS) côté backend
- Stockage sécurisé dans Keychain iOS
- Communications HTTPS uniquement
- Validation des entrées utilisateur

### 🛠 Technique

#### Backend
- Intégration Supabase (PostgreSQL + Auth + Realtime)
- SDK supabase-swift officiel
- Requêtes async/await modernes
- Gestion automatique des tokens JWT

#### iOS
- Swift 5.9+
- SwiftUI pour l'interface
- iOS 16.0+ minimum
- Support iPhone et iPad
- Combine pour la réactivité
- async/await pour l'asynchrone

#### Outils de développement
- Xcode 15.0+
- Swift Package Manager pour les dépendances
- Git pour le versioning

### 📚 Documentation
- README.md complet
- QUICKSTART.md pour démarrer rapidement
- ARCHITECTURE.md détaillant la structure
- SUPABASE_SETUP.md pour la configuration backend
- DEVELOPMENT.md avec notes de développement
- TODO.md pour le suivi des tâches
- Commentaires dans le code

### 🐛 Corrigé
- (Première version - pas de bugs connus)

### 🔐 Sécurité
- Implémentation du Keychain pour stockage sécurisé
- RLS activé sur toutes les tables Supabase
- Validation côté client et serveur
- Gestion des permissions par rôle

## [0.1.0] - 2025-11-30

### Ajouté
- Structure initiale du projet
- Configuration de base

---

## Légende

- ✨ **Ajouté** : Nouvelles fonctionnalités
- 🔧 **Modifié** : Changements dans les fonctionnalités existantes
- 🗑️ **Déprécié** : Fonctionnalités bientôt supprimées
- ❌ **Supprimé** : Fonctionnalités supprimées
- 🐛 **Corrigé** : Corrections de bugs
- 🔐 **Sécurité** : Corrections de vulnérabilités

## Versioning

Ce projet utilise le Semantic Versioning :
- **MAJOR** : Changements incompatibles avec l'API
- **MINOR** : Ajout de fonctionnalités rétrocompatibles
- **PATCH** : Corrections de bugs rétrocompatibles

Exemple : 1.2.3
- 1 = Version majeure
- 2 = Fonctionnalités ajoutées
- 3 = Corrections de bugs
