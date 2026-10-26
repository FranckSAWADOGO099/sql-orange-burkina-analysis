-- ============================================================
-- 02 - AGRÉGATIONS ET GROUPEMENTS
-- Projet : Analyse SQL Orange Burkina Faso
-- Concepts : COUNT, SUM, AVG, MIN, MAX, GROUP BY, HAVING
-- ============================================================


-- ── 1. Fonctions d'agrégation globales ──────────────────────

-- KPIs principaux
SELECT
    COUNT(*)                                        AS total_abonnes,
    SUM(CASE WHEN actif = 1 THEN 1 ELSE 0 END)     AS total_actifs,
    SUM(CASE WHEN actif = 0 THEN 1 ELSE 0 END)     AS total_inactifs,
    ROUND(
        SUM(CASE WHEN actif = 1 THEN 1.0 ELSE 0 END)
        / COUNT(*) * 100, 1)                        AS taux_actifs_pct,
    ROUND(AVG(solde), 0)                            AS solde_moyen,
    SUM(solde)                                      AS solde_total,
    MIN(solde)                                      AS solde_min,
    MAX(solde)                                      AS solde_max,
    ROUND(AVG(appels_mois), 1)                      AS appels_moyens,
    ROUND(AVG(data_go), 2)                          AS data_moyenne_go
FROM abonnes;

-- KPIs sur les transactions
SELECT
    COUNT(*)                                        AS nb_transactions,
    SUM(montant)                                    AS volume_total,
    ROUND(AVG(montant), 0)                          AS montant_moyen,
    MIN(montant)                                    AS montant_min,
    MAX(montant)                                    AS montant_max,
    SUM(CASE WHEN type = 'envoi'
        THEN 1 ELSE 0 END)                          AS nb_envois,
    SUM(CASE WHEN type = 'retrait'
        THEN 1 ELSE 0 END)                          AS nb_retraits,
    SUM(CASE WHEN type = 'envoi'
        THEN montant ELSE 0 END)                    AS volume_envois,
    SUM(CASE WHEN type = 'retrait'
        THEN montant ELSE 0 END)                    AS volume_retraits
FROM transactions;


-- ── 2. GROUP BY simple ──────────────────────────────────────

-- Abonnés par ville
SELECT
    ville,
    COUNT(*) AS nb_abonnes
FROM abonnes
GROUP BY ville
ORDER BY nb_abonnes DESC;

-- Abonnés par forfait
SELECT
    forfait,
    COUNT(*) AS nb_abonnes
FROM abonnes
GROUP BY forfait
ORDER BY nb_abonnes DESC;

-- Performance par ville
SELECT
    ville,
    COUNT(*)              AS nb_abonnes,
    ROUND(AVG(solde), 0)  AS solde_moyen,
    SUM(solde)            AS solde_total,
    MAX(solde)            AS solde_max,
    ROUND(AVG(appels_mois), 1) AS appels_moyens
FROM abonnes
GROUP BY ville
ORDER BY solde_total DESC;

-- Performance par forfait
SELECT
    forfait,
    COUNT(*)              AS nb_abonnes,
    ROUND(AVG(solde), 0)  AS solde_moyen,
    SUM(solde)            AS solde_total,
    ROUND(AVG(data_go), 2) AS data_moyenne
FROM abonnes
GROUP BY forfait
ORDER BY solde_moyen DESC;


-- ── 3. GROUP BY avec WHERE ──────────────────────────────────

-- Performance par ville (actifs uniquement)
SELECT
    ville,
    COUNT(*)              AS nb_actifs,
    ROUND(AVG(solde), 0)  AS solde_moyen_actifs,
    SUM(solde)            AS solde_total_actifs
FROM abonnes
WHERE actif = 1
GROUP BY ville
ORDER BY solde_total_actifs DESC;

-- Appels moyens par forfait (actifs seulement)
SELECT
    forfait,
    ROUND(AVG(appels_mois), 1) AS appels_moyens,
    ROUND(AVG(data_go), 2)     AS data_moyenne
FROM abonnes
WHERE actif = 1
GROUP BY forfait
ORDER BY appels_moyens DESC;


-- ── 4. GROUP BY sur plusieurs colonnes ──────────────────────

-- Abonnés par ville et par statut
SELECT
    ville,
    actif,
    COUNT(*)             AS nb_abonnes,
    ROUND(AVG(solde), 0) AS solde_moyen
FROM abonnes
GROUP BY ville, actif
ORDER BY ville, actif DESC;

-- Transactions par type et par mois
SELECT
    mois,
    type,
    COUNT(*)       AS nb_transactions,
    SUM(montant)   AS volume
FROM transactions
GROUP BY mois, type
ORDER BY mois, type;


-- ── 5. HAVING — filtrer les groupes ─────────────────────────

-- Villes avec plus de 3 abonnés
SELECT
    ville,
    COUNT(*) AS nb_abonnes
FROM abonnes
GROUP BY ville
HAVING COUNT(*) > 3
ORDER BY nb_abonnes DESC;

-- Forfaits avec solde moyen > 4000
SELECT
    forfait,
    COUNT(*)             AS nb_abonnes,
    ROUND(AVG(solde), 0) AS solde_moyen
FROM abonnes
GROUP BY forfait
HAVING AVG(solde) > 4000
ORDER BY solde_moyen DESC;

-- Villes actives avec taux d'actifs > 70%
SELECT
    ville,
    COUNT(*) AS total,
    SUM(CASE WHEN actif = 1 THEN 1 ELSE 0 END) AS actifs,
    ROUND(
        SUM(CASE WHEN actif = 1 THEN 1.0 ELSE 0 END)
        / COUNT(*) * 100, 1) AS taux_actifs_pct
FROM abonnes
GROUP BY ville
HAVING taux_actifs_pct > 70
ORDER BY taux_actifs_pct DESC;


-- ── 6. Rapport complet par ville ────────────────────────────

SELECT
    ville,
    COUNT(*)                                        AS total_abonnes,
    SUM(CASE WHEN actif = 1 THEN 1 ELSE 0 END)     AS actifs,
    ROUND(
        SUM(CASE WHEN actif = 1 THEN 1.0 ELSE 0 END)
        / COUNT(*) * 100, 1)                        AS taux_actifs_pct,
    ROUND(AVG(solde), 0)                            AS solde_moyen,
    SUM(solde)                                      AS solde_total,
    ROUND(AVG(appels_mois), 1)                      AS appels_moyens,
    ROUND(AVG(data_go), 2)                          AS data_moyenne
FROM abonnes
GROUP BY ville
ORDER BY solde_total DESC;
