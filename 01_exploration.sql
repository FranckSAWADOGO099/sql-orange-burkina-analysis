-- ============================================================
-- 01 - EXPLORATION DES DONNÉES
-- Projet : Analyse SQL Orange Burkina Faso
-- Concepts : SELECT, WHERE, ORDER BY, LIMIT, DISTINCT
-- ============================================================


-- ── 1. Aperçu général ───────────────────────────────────────

-- Tous les abonnés
SELECT * FROM abonnes;

-- Colonnes spécifiques
SELECT nom, ville, forfait, solde
FROM abonnes;

-- Colonnes avec alias
SELECT
    nom          AS "Nom de l'abonné",
    ville        AS "Ville",
    forfait      AS "Forfait souscrit",
    solde        AS "Solde (FCFA)"
FROM abonnes;

-- Colonnes calculées
SELECT
    nom,
    solde,
    ROUND(solde / 655.957, 2)  AS solde_euros,
    appels_mois * 12           AS appels_annuels_estimes,
    data_go * 1024             AS data_mb
FROM abonnes;


-- ── 2. Valeurs uniques ──────────────────────────────────────

-- Villes couvertes
SELECT DISTINCT ville
FROM abonnes
ORDER BY ville;

-- Forfaits disponibles
SELECT DISTINCT forfait
FROM abonnes
ORDER BY forfait;

-- Combinaisons ville + forfait
SELECT DISTINCT ville, forfait
FROM abonnes
ORDER BY ville, forfait;


-- ── 3. Filtrage avec WHERE ──────────────────────────────────

-- Abonnés actifs
SELECT nom, ville, solde
FROM abonnes
WHERE actif = 1;

-- Abonnés inactifs
SELECT nom, ville, solde, anciennete
FROM abonnes
WHERE actif = 0;

-- Abonnés de Ouagadougou
SELECT nom, ville, solde, forfait
FROM abonnes
WHERE ville = 'Ouaga';

-- Solde supérieur à 5000
SELECT nom, ville, solde
FROM abonnes
WHERE solde > 5000
ORDER BY solde DESC;

-- Forfait contenant "10Go"
SELECT nom, forfait, solde
FROM abonnes
WHERE forfait LIKE '%10Go%';

-- Solde entre 2000 et 6000
SELECT nom, ville, solde
FROM abonnes
WHERE solde BETWEEN 2000 AND 6000;

-- Abonnés de plusieurs villes
SELECT nom, ville, solde
FROM abonnes
WHERE ville IN ('Ouaga', 'Bobo', 'Banfora');


-- ── 4. Filtres combinés ─────────────────────────────────────

-- Actifs avec solde > 3000 et data > 3Go
SELECT nom, ville, solde, data_go
FROM abonnes
WHERE actif = 1
  AND solde > 3000
  AND data_go > 3;

-- Ouaga OU Banfora ET actif
SELECT nom, ville, solde
FROM abonnes
WHERE actif = 1
  AND ville IN ('Ouaga', 'Banfora');

-- Segment à risque : actifs avec solde < 1000
SELECT nom, ville, solde, anciennete
FROM abonnes
WHERE actif = 1
  AND solde < 1000;


-- ── 5. Tri et limitation ────────────────────────────────────

-- Top 5 par solde décroissant
SELECT nom, ville, solde
FROM abonnes
ORDER BY solde DESC
LIMIT 5;

-- Top 3 par appels
SELECT nom, ville, appels_mois
FROM abonnes
ORDER BY appels_mois DESC
LIMIT 3;

-- Abonnés les plus anciens (actifs)
SELECT nom, ville, anciennete, solde
FROM abonnes
WHERE actif = 1
ORDER BY anciennete DESC
LIMIT 5;

-- Tri alphabétique
SELECT nom, ville
FROM abonnes
ORDER BY nom ASC;

-- Tri par ville puis solde décroissant
SELECT nom, ville, solde
FROM abonnes
ORDER BY ville ASC, solde DESC;
