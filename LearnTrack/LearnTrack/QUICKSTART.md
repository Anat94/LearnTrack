# Guide de Démarrage Rapide - LearnTrack iOS

## 🎯 Objectif
Ce guide vous permet de configurer et lancer l'application LearnTrack iOS en quelques minutes.

## 📋 Prérequis

- ✅ macOS Ventura (13.0) ou supérieur
- ✅ Xcode 15.0 ou supérieur
- ✅ Compte développeur Apple (gratuit suffit pour simulateur)
- ✅ Compte Supabase (gratuit : https://supabase.com)

## 🚀 Installation en 5 étapes

### Étape 1 : Créer un projet Supabase

1. Allez sur https://supabase.com
2. Créez un compte ou connectez-vous
3. Cliquez sur "New Project"
4. Configurez :
   - **Name** : LearnTrack
   - **Database Password** : (générez un mot de passe fort)
   - **Region** : Europe (West) - pour la France
5. Attendez que le projet soit prêt (~2 minutes)

### Étape 2 : Configurer la base de données

1. Dans Supabase, allez dans "SQL Editor"
2. Copiez-collez le contenu de `SUPABASE_SETUP.md`
3. Exécutez les scripts SQL dans l'ordre :
   - Tables
   - RLS Policies
   - Triggers
   - Données de test (optionnel)

### Étape 3 : Récupérer les credentials

1. Dans Supabase, allez dans "Settings" > "API"
2. Notez :
   - **Project URL** : `https://xxxxx.supabase.co`
   - **anon/public key** : `eyJhbGciOiJIUzI1NiIsInR5cCI6...`

### Étape 4 : Configurer l'application iOS

1. Ouvrez `LearnTrack.xcodeproj` dans Xcode
2. Éditez `Core/Network/SupabaseManager.swift`
3. Remplacez les valeurs :

```swift
let supabaseURL = URL(string: "https://xxxxx.supabase.co")!
let supabaseKey = "votre-anon-key-ici"
```

### Étape 5 : Installer les dépendances

1. Dans Xcode : **File** > **Add Package Dependencies**
2. Ajoutez : `https://github.com/supabase/supabase-swift`
3. Version : **2.0.0** ou supérieure
4. Cliquez sur **Add Package**

## ▶️ Lancer l'application

1. Sélectionnez le simulateur : **iPhone 15 Pro** (recommandé)
2. Appuyez sur **Cmd + R** ou cliquez sur le bouton **Play**
3. L'application se lance !

## 🔐 Créer un compte utilisateur

### Option 1 : Via Supabase Dashboard (Recommandé)

1. Dans Supabase, allez dans **Authentication** > **Users**
2. Cliquez sur **Add user** > **Create new user**
3. Remplissez :
   - **Email** : admin@learntrack.com
   - **Password** : Test123456!
   - **Auto Confirm User** : ✅ Activé
4. Ensuite, dans **SQL Editor**, créez l'entrée dans la table users :

```sql
INSERT INTO users (username, email, role, supabase_user_id, is_active)
VALUES (
    'Admin Test',
    'admin@learntrack.com',
    'admin',
    'REMPLACER-PAR-LE-UUID-DU-USER',
    true
);
```

### Option 2 : S'inscrire dans l'app (si activé)

Si vous avez activé les inscriptions dans Supabase :
1. Lancez l'app
2. Créez un compte
3. Vérifiez votre email
4. Connectez-vous

## ✅ Vérification

Après connexion, vous devriez voir :
- ✅ 5 onglets en bas (Sessions, Formateurs, Clients, Écoles, Profil)
- ✅ Interface en français
- ✅ Données de test (si vous les avez insérées)

## 🎨 Tester les fonctionnalités

### Créer une session
1. Onglet **Sessions**
2. Appuyer sur **+**
3. Remplir le formulaire
4. **Créer**

### Ajouter un formateur
1. Onglet **Formateurs**
2. Appuyer sur **+**
3. Remplir les informations
4. **Créer**

### Partager une session
1. Ouvrir une session
2. Appuyer sur **Partager**
3. Choisir Discord, Mail, etc.

## 🐛 Résolution de problèmes

### Erreur : "Cannot connect to Supabase"
- ✅ Vérifiez l'URL et la clé dans `SupabaseManager.swift`
- ✅ Vérifiez votre connexion Internet
- ✅ Vérifiez que le projet Supabase est actif

### Erreur : "Authentication failed"
- ✅ Vérifiez que l'utilisateur existe dans Supabase Auth
- ✅ Vérifiez que l'entrée existe dans la table `users`
- ✅ Vérifiez que `supabase_user_id` correspond

### Erreur : "Permission denied"
- ✅ Vérifiez que les RLS policies sont bien créées
- ✅ Vérifiez que l'utilisateur a le bon rôle

### L'app plante au lancement
- ✅ Nettoyez le build : **Cmd + Shift + K**
- ✅ Relancez : **Cmd + R**
- ✅ Vérifiez les logs Xcode

## 📱 Tester sur un appareil réel

1. Connectez votre iPhone via USB
2. Dans Xcode, sélectionnez votre iPhone
3. **Signing & Capabilities** :
   - Team : Sélectionnez votre compte Apple
   - Bundle ID : Changez en `com.votreprenom.learntrack`
4. Sur l'iPhone : **Réglages** > **Général** > **VPN et gestion des appareils** > Faire confiance
5. Lancez l'app !

## 📊 Données de test

Pour avoir des données de test rapidement :

```sql
-- Formateurs
INSERT INTO formateurs (prenom, nom, email, telephone, specialite, taux_horaire, exterieur) VALUES
('Jean', 'Dupont', 'jean.dupont@example.com', '06 12 34 56 78', 'Swift & iOS', 50.00, 0),
('Marie', 'Martin', 'marie.martin@example.com', '06 98 76 54 32', 'Python & Data', 55.00, 1);

-- Clients
INSERT INTO clients (raison_sociale, nom_contact, email, telephone, ville) VALUES
('Acme Corp', 'Pierre Durand', 'contact@acme.com', '01 23 45 67 89', 'Paris'),
('Tech Solutions', 'Sophie Bernard', 'info@techsol.fr', '01 45 67 89 01', 'Lyon');

-- Écoles
INSERT INTO ecoles (nom, nom_contact, email, telephone, ville) VALUES
('École Supérieure', 'Paul Petit', 'contact@ecole.fr', '01 45 67 89 01', 'Paris');

-- Sessions
INSERT INTO sessions (module, date, debut, fin, modalite, lieu, tarif_client, tarif_sous_traitant, frais_rembourser, formateur_id, client_id) VALUES
('Formation Swift Avancé', '2025-12-15', '09:00', '17:00', 'P', 'Paris 15e', 1200.00, 800.00, 50.00, 1, 1),
('Introduction à SwiftUI', '2025-12-20', '09:00', '17:00', 'D', 'À distance', 1000.00, 700.00, 0.00, 1, 2);
```

## 🎓 Prochaines étapes

Une fois l'app fonctionnelle :

1. **Personnalisez** : Modifiez les couleurs, l'icône de l'app
2. **Testez** : Essayez toutes les fonctionnalités
3. **Ajoutez des données** : Créez vos vrais formateurs et clients
4. **Explorez** : Regardez le code dans différents modules
5. **Contribuez** : Ajoutez des fonctionnalités (voir TODO.md)

## 📚 Documentation

- `README.md` : Vue d'ensemble du projet
- `SUPABASE_SETUP.md` : Configuration détaillée Supabase
- `TODO.md` : Fonctionnalités à venir
- Code commenté dans chaque fichier

## 💬 Support

En cas de problème :
1. Consultez les logs Xcode
2. Vérifiez la console Supabase
3. Relisez ce guide
4. Ouvrez une issue sur GitHub

## 🎉 Félicitations !

Vous avez maintenant une application iOS complète de gestion de formations ! 

**Enjoy coding! 🚀📱**

---

**Note** : Cette application est fournie à des fins éducatives et doit être adaptée selon vos besoins spécifiques avant un usage en production.
