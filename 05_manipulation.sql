-- ============================================================
-- 05 - MANIPULATION DES DONNÉES
-- Projet : Analyse SQL Orange Burkina Faso
-- Concepts : INSERT, UPDATE, DELETE, transactions
-- ============================================================


-- ── 1. INSERT — ajouter des abonnés ─────────────────────────

-- Ajouter un seul abonné
INSERT OR IGNORE INTO abonnes
    (id, nom, ville, forfait, solde, actif,
     appels_mois, data_go, anciennete)
VALUES
    (21, 'Nouveau Abonné Test', 'Ouaga',
     'Orange Liberté', 2000, 1, 20, 1.5, 1);

-- Vérifier l'ajout
SELECT * FROM abonnes WHERE id = 21;


-- ── 2. INSERT multiple ──────────────────────────────────────

-- Ajouter plusieurs abonnés
INSERT OR IGNORE INTO abonnes
    (id, nom, ville, forfait, solde, actif,
     appels_mois, data_go, anciennete)
VALUES
    (22, 'Abonné Test Bobo',   'Bobo',    'Orange Max 5Go', 3500, 1, 35, 2.5, 5),
    (23, 'Abonné Test Banfora','Banfora', 'Orange Max 5Go', 1500, 0,  8, 0.5, 2);

-- Vérifier
SELECT * FROM abonnes WHERE id IN (21, 22, 23);


-- ── 3. UPDATE — modifier des données ────────────────────────

-- Recharger le solde d'un abonné
UPDATE abonnes
SET solde = 5000
WHERE id = 21;

-- Vérifier
SELECT id, nom, solde FROM abonnes WHERE id = 21;

-- Activer un abonné inactif
UPDATE abonnes
SET actif = 1
WHERE id = 23;

-- Mettre à jour plusieurs colonnes d'un coup
UPDATE abonnes
SET
    solde      = 4500,
    actif      = 1,
    anciennete = 6
WHERE id = 22;

-- Augmenter le solde de tous les abonnés de Ouaga de 500 FCFA
UPDATE abonnes
SET solde = solde + 500
WHERE ville = 'Ouaga'
  AND actif = 1;

-- Vérifier les changements
SELECT nom, ville, solde
FROM abonnes
WHERE ville = 'Ouaga' AND actif = 1
ORDER BY solde DESC;


-- ── 4. DELETE — supprimer des données ───────────────────────

-- Supprimer les abonnés de test
DELETE FROM abonnes
WHERE nom LIKE '%Test%';

-- Vérifier
SELECT COUNT(*) AS total FROM abonnes;

-- Supprimer les réclamations résolues de plus de 3 mois
DELETE FROM reclamations
WHERE statut = 'Résolu'
  AND mois <= 2;


-- ── 5. INSERT dans transactions ─────────────────────────────

-- Ajouter une transaction
INSERT OR IGNORE INTO transactions
    (id, id_abonne, montant, type, mois)
VALUES
    (20, 6, 35000, 'envoi', 7);

-- Vérifier
SELECT
    a.nom,
    t.montant,
    t.type,
    t.mois
FROM transactions t
JOIN abonnes a ON t.id_abonne = a.id
WHERE t.id = 20;


-- ── 6. INSERT dans réclamations ─────────────────────────────

INSERT OR IGNORE INTO reclamations
    (id, id_abonne, motif, statut, mois)
VALUES
    (8, 17, 'Service client non disponible', 'En attente', 6);


-- ── 7. UPDATE statut réclamation ────────────────────────────

UPDATE reclamations
SET statut = 'Résolu'
WHERE id = 8;

-- Vérifier
SELECT * FROM reclamations WHERE id = 8;


-- ── 8. Résumé final de la base après modifications ──────────

SELECT 'abonnes'      AS table_name, COUNT(*) AS nb_lignes FROM abonnes
UNION ALL
SELECT 'forfaits',     COUNT(*) FROM forfaits
UNION ALL
SELECT 'transactions', COUNT(*) FROM transactions
UNION ALL
SELECT 'reclamations', COUNT(*) FROM reclamations;
