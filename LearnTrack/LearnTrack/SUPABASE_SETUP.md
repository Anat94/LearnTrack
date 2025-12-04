# Configuration Supabase pour LearnTrack iOS

## Tables SQL

### 1. Table `users`

```sql
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    role VARCHAR(20) DEFAULT 'user',
    supabase_user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- RLS
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own data"
    ON users FOR SELECT
    USING (auth.uid() = supabase_user_id);

CREATE POLICY "Admins can view all users"
    ON users FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM users
            WHERE supabase_user_id = auth.uid()
            AND role = 'admin'
        )
    );
```

### 2. Table `formateurs`

```sql
CREATE TABLE formateurs (
    id BIGSERIAL PRIMARY KEY,
    prenom VARCHAR(100) NOT NULL,
    nom VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL,
    telephone VARCHAR(20) NOT NULL,
    specialite TEXT,
    taux_horaire DECIMAL(10, 2) DEFAULT 0,
    exterieur SMALLINT DEFAULT 0,
    societe VARCHAR(255),
    siret VARCHAR(20),
    nda VARCHAR(50),
    rue TEXT,
    code_postal VARCHAR(10),
    ville VARCHAR(100),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- RLS
ALTER TABLE formateurs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can view formateurs"
    ON formateurs FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "Authenticated users can insert formateurs"
    ON formateurs FOR INSERT
    TO authenticated
    WITH CHECK (true);

CREATE POLICY "Authenticated users can update formateurs"
    ON formateurs FOR UPDATE
    TO authenticated
    USING (true);

CREATE POLICY "Admins can delete formateurs"
    ON formateurs FOR DELETE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM users
            WHERE supabase_user_id = auth.uid()
            AND role = 'admin'
        )
    );
```

### 3. Table `clients`

```sql
CREATE TABLE clients (
    id BIGSERIAL PRIMARY KEY,
    raison_sociale VARCHAR(255) NOT NULL,
    rue TEXT,
    code_postal VARCHAR(10),
    ville VARCHAR(100),
    nom_contact VARCHAR(150) NOT NULL,
    email VARCHAR(255) NOT NULL,
    telephone VARCHAR(20) NOT NULL,
    siret VARCHAR(20),
    numero_tva VARCHAR(20),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- RLS (identique à formateurs)
ALTER TABLE clients ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can view clients"
    ON clients FOR SELECT TO authenticated USING (true);

CREATE POLICY "Authenticated users can insert clients"
    ON clients FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY "Authenticated users can update clients"
    ON clients FOR UPDATE TO authenticated USING (true);

CREATE POLICY "Admins can delete clients"
    ON clients FOR DELETE TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM users
            WHERE supabase_user_id = auth.uid()
            AND role = 'admin'
        )
    );
```

### 4. Table `ecoles`

```sql
CREATE TABLE ecoles (
    id BIGSERIAL PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    rue TEXT,
    code_postal VARCHAR(10),
    ville VARCHAR(100),
    nom_contact VARCHAR(150) NOT NULL,
    email VARCHAR(255) NOT NULL,
    telephone VARCHAR(20) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- RLS (identique aux autres tables)
ALTER TABLE ecoles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can view ecoles"
    ON ecoles FOR SELECT TO authenticated USING (true);

CREATE POLICY "Authenticated users can insert ecoles"
    ON ecoles FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY "Authenticated users can update ecoles"
    ON ecoles FOR UPDATE TO authenticated USING (true);

CREATE POLICY "Admins can delete ecoles"
    ON ecoles FOR DELETE TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM users
            WHERE supabase_user_id = auth.uid()
            AND role = 'admin'
        )
    );
```

### 5. Table `sessions`

```sql
CREATE TABLE sessions (
    id BIGSERIAL PRIMARY KEY,
    module VARCHAR(500) NOT NULL,
    date DATE NOT NULL,
    debut TIME NOT NULL,
    fin TIME NOT NULL,
    modalite CHAR(1) CHECK (modalite IN ('P', 'D')),
    lieu TEXT,
    tarif_client DECIMAL(10, 2) DEFAULT 0,
    tarif_sous_traitant DECIMAL(10, 2) DEFAULT 0,
    frais_rembourser DECIMAL(10, 2) DEFAULT 0,
    ref_contrat VARCHAR(100),
    ecole_id BIGINT REFERENCES ecoles(id) ON DELETE SET NULL,
    client_id BIGINT REFERENCES clients(id) ON DELETE SET NULL,
    formateur_id BIGINT REFERENCES formateurs(id) ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Index pour les performances
CREATE INDEX idx_sessions_date ON sessions(date);
CREATE INDEX idx_sessions_formateur ON sessions(formateur_id);
CREATE INDEX idx_sessions_client ON sessions(client_id);

-- RLS
ALTER TABLE sessions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can view sessions"
    ON sessions FOR SELECT TO authenticated USING (true);

CREATE POLICY "Admins can insert sessions"
    ON sessions FOR INSERT TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM users
            WHERE supabase_user_id = auth.uid()
            AND role = 'admin'
        )
    );

CREATE POLICY "Admins can update sessions"
    ON sessions FOR UPDATE TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM users
            WHERE supabase_user_id = auth.uid()
            AND role = 'admin'
        )
    );

CREATE POLICY "Admins can delete sessions"
    ON sessions FOR DELETE TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM users
            WHERE supabase_user_id = auth.uid()
            AND role = 'admin'
        )
    );
```

## Triggers pour `updated_at`

```sql
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_formateurs_updated_at BEFORE UPDATE ON formateurs
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_clients_updated_at BEFORE UPDATE ON clients
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_ecoles_updated_at BEFORE UPDATE ON ecoles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_sessions_updated_at BEFORE UPDATE ON sessions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
```

## Données de test

```sql
-- Créer un utilisateur admin
INSERT INTO users (username, email, role, supabase_user_id, is_active)
VALUES ('Admin', 'admin@learntrack.com', 'admin', 'your-supabase-user-id', true);

-- Formateur de test
INSERT INTO formateurs (prenom, nom, email, telephone, specialite, taux_horaire, exterieur)
VALUES ('Jean', 'Dupont', 'jean.dupont@example.com', '06 12 34 56 78', 'Swift & iOS', 50.00, 0);

-- Client de test
INSERT INTO clients (raison_sociale, nom_contact, email, telephone, ville)
VALUES ('Acme Corp', 'Marie Martin', 'contact@acme.com', '01 23 45 67 89', 'Paris');

-- École de test
INSERT INTO ecoles (nom, nom_contact, email, telephone, ville)
VALUES ('École Supérieure', 'Pierre Durand', 'contact@ecole.fr', '01 45 67 89 01', 'Paris');

-- Session de test
INSERT INTO sessions (module, date, debut, fin, modalite, lieu, tarif_client, tarif_sous_traitant, frais_rembourser)
VALUES ('Formation Swift', '2025-12-15', '09:00', '17:00', 'P', 'Paris 15e', 1200.00, 800.00, 50.00);
```

## Configuration Supabase Auth

1. Aller dans Authentication > Providers
2. Activer Email provider
3. Configurer les URL de redirection :
   - `learntrack://auth-callback`
4. Paramètres Email :
   - Activer "Confirm email"
   - Personnaliser les templates d'email

## Variables d'environnement

Dans Xcode, créer un fichier `Config.xcconfig` :

```
SUPABASE_URL = https://votre-projet.supabase.co
SUPABASE_ANON_KEY = votre-anon-key
```

## Notes importantes

- ⚠️ Ne jamais commiter les clés API dans le code
- ✅ Toujours utiliser RLS pour la sécurité
- ✅ Tester les policies RLS avant le déploiement
- ✅ Activer 2FA sur le compte Supabase
