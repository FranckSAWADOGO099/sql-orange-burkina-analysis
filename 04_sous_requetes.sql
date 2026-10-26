-- ============================================================
-- 04 - SOUS-REQUÊTES
-- Projet : Analyse SQL Orange Burkina Faso
-- Concepts : Subqueries dans WHERE, SELECT, FROM
-- ============================================================


-- ── 1. Sous-requête dans WHERE ───────────────────────────────

-- Abonnés avec solde supérieur à la moyenne
SELECT nom, ville, solde
FROM abonnes
WHERE solde > (SELECT AVG(solde) FROM abonnes)
ORDER BY solde DESC;

-- Abonnés avec plus d'appels que la moyenne
SELECT nom, ville, appels_mois
FROM abonnes
WHERE appels_mois > (SELECT AVG(appels_mois) FROM abonnes)
ORDER BY appels_mois DESC;

-- Abonnés sur le forfait le plus cher
SELECT nom, ville, forfait, solde
FROM abonnes
WHERE forfait = (
    SELECT nom_forfait
    FROM forfaits
    ORDER BY prix_fcfa DESC
    LIMIT 1
);


-- ── 2. Sous-requête avec IN ──────────────────────────────────

-- Abonnés qui ont fait au moins une transaction
SELECT nom, ville, solde
FROM abonnes
WHERE id IN (
    SELECT DISTINCT id_abonne
    FROM transactions
)
ORDER BY nom;

-- Abonnés sans aucune transaction
SELECT nom, ville, solde
FROM abonnes
WHERE id NOT IN (
    SELECT DISTINCT id_abonne
    FROM transactions
)
ORDER BY nom;

-- Abonnés qui ont fait au moins un envoi
SELECT nom, ville, solde
FROM abonnes
WHERE id IN (
    SELECT DISTINCT id_abonne
    FROM transactions
    WHERE type = 'envoi'
)
ORDER BY nom;

-- Abonnés qui n'ont jamais fait de retrait
SELECT nom, ville, solde
FROM abonnes
WHERE id NOT IN (
    SELECT DISTINCT id_abonne
    FROM transactions
    WHERE type = 'retrait'
)
ORDER BY nom;


-- ── 3. Sous-requête dans SELECT ──────────────────────────────

-- Afficher chaque abonné avec la moyenne globale et l'écart
SELECT
    nom,
    ville,
    solde,
    ROUND((SELECT AVG(solde) FROM abonnes), 0)  AS moyenne_globale,
    ROUND(solde - (SELECT AVG(solde) FROM abonnes), 0) AS ecart_moyenne
FROM abonnes
ORDER BY ecart_moyenne DESC;

-- Rang de chaque abonné par solde dans sa ville
SELECT
    a.nom,
    a.ville,
    a.solde,
    (SELECT COUNT(*)
     FROM abonnes b
     WHERE b.ville = a.ville
       AND b.solde > a.solde) + 1 AS rang_dans_ville
FROM abonnes a
ORDER BY a.ville, rang_dans_ville;


-- ── 4. Sous-requête dans FROM (table dérivée) ───────────────

-- Catégoriser les villes par solde moyen
SELECT
    ville,
    nb_abonnes,
    solde_moyen,
    CASE
        WHEN solde_moyen >= 6000 THEN 'Haute valeur'
        WHEN solde_moyen >= 3000 THEN 'Valeur moyenne'
        ELSE 'À surveiller'
    END AS categorie_ville
FROM (
    SELECT
        ville,
        COUNT(*)             AS nb_abonnes,
        ROUND(AVG(solde), 0) AS solde_moyen
    FROM abonnes
    GROUP BY ville
) AS stats_ville
ORDER BY solde_moyen DESC;

-- Top abonnés Orange Money par ville
SELECT
    ville,
    nb_abonnes_om,
    volume_total,
    ROUND(volume_total * 1.0 / nb_abonnes_om, 0) AS volume_moyen_par_abonne
FROM (
    SELECT
        a.ville,
        COUNT(DISTINCT a.id)         AS nb_abonnes_om,
        COALESCE(SUM(t.montant), 0)  AS volume_total
    FROM abonnes a
    LEFT JOIN transactions t
        ON a.id = t.id_abonne
    GROUP BY a.ville
    HAVING SUM(t.montant) > 0
) AS om_par_ville
ORDER BY volume_total DESC;


-- ── 5. Analyse avancée ──────────────────────────────────────

-- Abonnés dont le solde est inférieur au minimum des Orange Max 10Go
SELECT nom, ville, forfait, solde
FROM abonnes
WHERE solde < (
    SELECT MIN(solde)
    FROM abonnes
    WHERE forfait = 'Orange Max 10Go'
)
ORDER BY solde;

-- Villes avec au moins un abonné Premium (solde >= 8000)
SELECT DISTINCT ville
FROM abonnes a
WHERE EXISTS (
    SELECT 1
    FROM abonnes b
    WHERE b.ville = a.ville
      AND b.solde >= 8000
)
ORDER BY ville;

-- Abonnés avec des réclamations non résolues
SELECT nom, ville, forfait, solde
FROM abonnes
WHERE id IN (
    SELECT DISTINCT id_abonne
    FROM reclamations
    WHERE statut != 'Résolu'
)
ORDER BY nom;
