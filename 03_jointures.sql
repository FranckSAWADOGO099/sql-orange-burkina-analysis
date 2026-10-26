-- ============================================================
-- 03 - JOINTURES
-- Projet : Analyse SQL Orange Burkina Faso
-- Concepts : INNER JOIN, LEFT JOIN, jointures multiples
-- ============================================================


-- ── 1. INNER JOIN — abonnés + forfaits ──────────────────────

-- Abonnés avec détails de leur forfait
SELECT
    a.nom,
    a.ville,
    a.solde,
    f.nom_forfait,
    f.prix_fcfa    AS prix_mensuel,
    f.data_go      AS data_incluse
FROM abonnes a
INNER JOIN forfaits f
    ON a.forfait = f.nom_forfait
ORDER BY a.solde DESC;

-- Écart entre solde et prix du forfait
SELECT
    a.nom,
    a.ville,
    a.solde,
    f.prix_fcfa                    AS prix_forfait,
    a.solde - f.prix_fcfa          AS ecart_solde_prix,
    CASE
        WHEN a.solde >= f.prix_fcfa THEN 'Peut payer son forfait'
        ELSE 'Solde insuffisant'
    END AS statut_paiement
FROM abonnes a
INNER JOIN forfaits f
    ON a.forfait = f.nom_forfait
WHERE a.actif = 1
ORDER BY ecart_solde_prix DESC;


-- ── 2. LEFT JOIN — abonnés + transactions ───────────────────

-- Tous les abonnés avec leurs transactions
SELECT
    a.nom,
    a.ville,
    t.montant,
    t.type,
    t.mois
FROM abonnes a
LEFT JOIN transactions t
    ON a.id = t.id_abonne
ORDER BY a.nom, t.mois;

-- Abonnés sans aucune transaction
SELECT
    a.nom,
    a.ville,
    a.solde,
    a.forfait
FROM abonnes a
LEFT JOIN transactions t
    ON a.id = t.id_abonne
WHERE t.id IS NULL
ORDER BY a.nom;

-- Total Orange Money par abonné
SELECT
    a.nom,
    a.ville,
    COUNT(t.id)                  AS nb_transactions,
    COALESCE(SUM(t.montant), 0)  AS total_om,
    COALESCE(
        SUM(CASE WHEN t.type = 'envoi'
            THEN t.montant ELSE 0 END), 0)  AS total_envois,
    COALESCE(
        SUM(CASE WHEN t.type = 'retrait'
            THEN t.montant ELSE 0 END), 0)  AS total_retraits
FROM abonnes a
LEFT JOIN transactions t
    ON a.id = t.id_abonne
GROUP BY a.id, a.nom, a.ville
ORDER BY total_om DESC;


-- ── 3. Jointure 3 tables ────────────────────────────────────

-- Abonnés + forfaits + transactions
SELECT
    a.nom,
    a.ville,
    f.nom_forfait,
    f.prix_fcfa,
    a.solde,
    COUNT(t.id)                  AS nb_transactions,
    COALESCE(SUM(t.montant), 0)  AS total_orange_money
FROM abonnes a
INNER JOIN forfaits f
    ON a.forfait = f.nom_forfait
LEFT JOIN transactions t
    ON a.id = t.id_abonne
GROUP BY a.id, a.nom, a.ville, f.nom_forfait, f.prix_fcfa, a.solde
ORDER BY total_orange_money DESC;


-- ── 4. Jointure 4 tables ────────────────────────────────────

-- Rapport complet : abonnés + forfaits + transactions + réclamations
SELECT
    a.nom,
    a.ville,
    f.nom_forfait                AS forfait,
    f.prix_fcfa                  AS prix_forfait,
    a.solde,
    COUNT(DISTINCT t.id)         AS nb_transactions,
    COALESCE(SUM(t.montant), 0)  AS total_om,
    COUNT(DISTINCT r.id)         AS nb_reclamations,
    CASE
        WHEN COUNT(DISTINCT r.id) = 0 THEN 'Satisfait'
        WHEN COUNT(DISTINCT r.id) = 1 THEN 'Une réclamation'
        ELSE 'Réclamations multiples'
    END                          AS statut_satisfaction
FROM abonnes a
INNER JOIN forfaits f
    ON a.forfait = f.nom_forfait
LEFT JOIN transactions t
    ON a.id = t.id_abonne
LEFT JOIN reclamations r
    ON a.id = r.id_abonne
WHERE a.actif = 1
GROUP BY a.id, a.nom, a.ville,
         f.nom_forfait, f.prix_fcfa, a.solde
ORDER BY a.solde DESC;


-- ── 5. Analyse de rentabilité par forfait ───────────────────

SELECT
    f.nom_forfait,
    f.prix_fcfa,
    COUNT(DISTINCT a.id)           AS nb_abonnes,
    COUNT(t.id)                    AS nb_transactions,
    COALESCE(SUM(t.montant), 0)    AS volume_total_om,
    ROUND(COALESCE(AVG(t.montant), 0), 0) AS montant_moyen_transaction
FROM forfaits f
LEFT JOIN abonnes a
    ON f.nom_forfait = a.forfait
LEFT JOIN transactions t
    ON a.id = t.id_abonne
GROUP BY f.id, f.nom_forfait, f.prix_fcfa
ORDER BY volume_total_om DESC;


-- ── 6. Rapport décisionnel complet ──────────────────────────

SELECT
    a.nom,
    a.ville,
    f.nom_forfait                           AS forfait,
    f.prix_fcfa                             AS prix_forfait,
    a.solde,
    a.anciennete,
    COUNT(DISTINCT t.id)                    AS nb_transactions,
    COALESCE(SUM(t.montant), 0)             AS total_om,
    CASE
        WHEN a.solde >= 8000 THEN 'Premium'
        WHEN a.solde >= 3000 THEN 'Standard'
        WHEN a.solde >= 1000 THEN 'Faible'
        ELSE 'Critique'
    END                                     AS segment_solde,
    CASE
        WHEN COUNT(DISTINCT t.id) >= 3 THEN 'Très actif OM'
        WHEN COUNT(DISTINCT t.id) >= 1 THEN 'Actif OM'
        ELSE 'Inactif OM'
    END                                     AS segment_om
FROM abonnes a
INNER JOIN forfaits f
    ON a.forfait = f.nom_forfait
LEFT JOIN transactions t
    ON a.id = t.id_abonne
WHERE a.actif = 1
GROUP BY a.id, a.nom, a.ville, a.solde, a.anciennete,
         f.nom_forfait, f.prix_fcfa
ORDER BY a.solde DESC;
