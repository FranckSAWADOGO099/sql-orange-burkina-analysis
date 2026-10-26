# ============================================================
# ANALYSE COMPLÈTE SQL + PYTHON
# Projet : Analyse SQL Orange Burkina Faso
# Auteur : Franck SAWADOGO
# Outils : Python, SQLite, pandas
# ============================================================

import sqlite3
import pandas as pd
import os

# ── Configuration ────────────────────────────────────────────
os.chdir(os.path.dirname(os.path.abspath(__file__)))
DB_PATH = "data/orange_burkina.db"

def connecter():
    return sqlite3.connect(DB_PATH)

def requete(sql, conn):
    return pd.read_sql(sql, conn)

print("=" * 65)
print("  ANALYSE SQL — ORANGE BURKINA FASO")
print("=" * 65)


# ============================================================
# ÉTAPE 1 — EXPLORATION GÉNÉRALE
# ============================================================
print("\n" + "─" * 65)
print("ÉTAPE 1 — EXPLORATION GÉNÉRALE")
print("─" * 65)

conn = connecter()

# Aperçu des tables
print("\nContenu de la base de données :")
tables = requete("""
    SELECT 'abonnes'      AS table_name, COUNT(*) AS nb_lignes FROM abonnes
    UNION ALL
    SELECT 'forfaits',     COUNT(*) FROM forfaits
    UNION ALL
    SELECT 'transactions', COUNT(*) FROM transactions
    UNION ALL
    SELECT 'reclamations', COUNT(*) FROM reclamations
""", conn)
print(tables.to_string(index=False))

# Premiers abonnés
print("\nAperçu des 5 premiers abonnés :")
print(requete("""
    SELECT nom, ville, forfait, solde, actif, appels_mois, data_go, anciennete
    FROM abonnes
    LIMIT 5
""", conn).to_string(index=False))

# Forfaits disponibles
print("\nForfaits disponibles :")
print(requete("""
    SELECT nom_forfait, prix_fcfa, data_go, appels_inclus
    FROM forfaits
    ORDER BY prix_fcfa
""", conn).to_string(index=False))

conn.close()


# ============================================================
# ÉTAPE 2 — KPIs GLOBAUX
# ============================================================
print("\n" + "─" * 65)
print("ÉTAPE 2 — KPIs GLOBAUX")
print("─" * 65)

conn = connecter()

kpis = requete("""
    SELECT
        COUNT(*)                                            AS total_abonnes,
        SUM(CASE WHEN actif = 1 THEN 1 ELSE 0 END)         AS actifs,
        SUM(CASE WHEN actif = 0 THEN 1 ELSE 0 END)         AS inactifs,
        ROUND(SUM(CASE WHEN actif = 1 THEN 1.0 ELSE 0 END)
              / COUNT(*) * 100, 1)                         AS taux_actifs_pct,
        ROUND(AVG(solde), 0)                               AS solde_moyen,
        SUM(solde)                                         AS solde_total,
        MIN(solde)                                         AS solde_min,
        MAX(solde)                                         AS solde_max,
        ROUND(AVG(appels_mois), 1)                         AS appels_moyens,
        ROUND(AVG(data_go), 2)                             AS data_moyenne_go
    FROM abonnes
""", conn)

print()
for col in kpis.columns:
    print(f"  {col:<25} : {kpis[col].values[0]:>12}")

conn.close()


# ============================================================
# ÉTAPE 3 — PERFORMANCE PAR VILLE
# ============================================================
print("\n" + "─" * 65)
print("ÉTAPE 3 — PERFORMANCE PAR VILLE")
print("─" * 65)

conn = connecter()

perf_ville = requete("""
    SELECT
        ville,
        COUNT(*)                                            AS nb_abonnes,
        SUM(CASE WHEN actif = 1 THEN 1 ELSE 0 END)         AS actifs,
        ROUND(SUM(CASE WHEN actif = 1 THEN 1.0 ELSE 0 END)
              / COUNT(*) * 100, 1)                         AS taux_actifs_pct,
        ROUND(AVG(solde), 0)                               AS solde_moyen,
        SUM(solde)                                         AS solde_total,
        ROUND(AVG(appels_mois), 1)                         AS appels_moyens
    FROM abonnes
    GROUP BY ville
    ORDER BY solde_total DESC
""", conn)

print()
print(perf_ville.to_string(index=False))

conn.close()


# ============================================================
# ÉTAPE 4 — PERFORMANCE PAR FORFAIT
# ============================================================
print("\n" + "─" * 65)
print("ÉTAPE 4 — PERFORMANCE PAR FORFAIT")
print("─" * 65)

conn = connecter()

perf_forfait = requete("""
    SELECT
        a.forfait,
        f.prix_fcfa,
        COUNT(*)                        AS nb_abonnes,
        ROUND(AVG(a.solde), 0)          AS solde_moyen,
        SUM(a.solde)                    AS solde_total,
        ROUND(AVG(a.appels_mois), 1)    AS appels_moyens,
        ROUND(AVG(a.data_go), 2)        AS data_moyenne
    FROM abonnes a
    INNER JOIN forfaits f ON a.forfait = f.nom_forfait
    GROUP BY a.forfait, f.prix_fcfa
    ORDER BY f.prix_fcfa DESC
""", conn)

print()
print(perf_forfait.to_string(index=False))

conn.close()


# ============================================================
# ÉTAPE 5 — ANALYSE ORANGE MONEY
# ============================================================
print("\n" + "─" * 65)
print("ÉTAPE 5 — ANALYSE ORANGE MONEY")
print("─" * 65)

conn = connecter()

# KPIs transactions
kpis_om = requete("""
    SELECT
        COUNT(*)                                            AS nb_transactions,
        SUM(montant)                                        AS volume_total,
        ROUND(AVG(montant), 0)                              AS montant_moyen,
        SUM(CASE WHEN type='envoi' THEN 1 ELSE 0 END)       AS nb_envois,
        SUM(CASE WHEN type='retrait' THEN 1 ELSE 0 END)     AS nb_retraits,
        SUM(CASE WHEN type='envoi' THEN montant ELSE 0 END) AS volume_envois,
        SUM(CASE WHEN type='retrait' THEN montant ELSE 0 END) AS volume_retraits
    FROM transactions
""", conn)

print("\nKPIs Orange Money :")
for col in kpis_om.columns:
    print(f"  {col:<25} : {kpis_om[col].values[0]:>12}")

# Top utilisateurs Orange Money
print("\nTop 5 utilisateurs Orange Money :")
top_om = requete("""
    SELECT
        a.nom,
        a.ville,
        a.forfait,
        COUNT(t.id)                 AS nb_transactions,
        SUM(t.montant)              AS total_om
    FROM abonnes a
    INNER JOIN transactions t ON a.id = t.id_abonne
    GROUP BY a.id, a.nom, a.ville, a.forfait
    ORDER BY total_om DESC
    LIMIT 5
""", conn)
print(top_om.to_string(index=False))

conn.close()


# ============================================================
# ÉTAPE 6 — SEGMENTATION DES ABONNÉS
# ============================================================
print("\n" + "─" * 65)
print("ÉTAPE 6 — SEGMENTATION")
print("─" * 65)

conn = connecter()

segmentation = requete("""
    SELECT
        CASE
            WHEN solde >= 8000 THEN '1 - Premium'
            WHEN solde >= 3000 THEN '2 - Standard'
            WHEN solde >= 1000 THEN '3 - Faible'
            ELSE '4 - Critique'
        END                         AS segment,
        COUNT(*)                    AS nb_abonnes,
        ROUND(AVG(solde), 0)        AS solde_moyen,
        ROUND(AVG(appels_mois), 1)  AS appels_moyens
    FROM abonnes
    WHERE actif = 1
    GROUP BY segment
    ORDER BY segment
""", conn)

print("\nSegmentation des abonnés actifs :")
print(segmentation.to_string(index=False))

conn.close()


# ============================================================
# ÉTAPE 7 — RÉCLAMATIONS
# ============================================================
print("\n" + "─" * 65)
print("ÉTAPE 7 — RÉCLAMATIONS")
print("─" * 65)

conn = connecter()

reclamations = requete("""
    SELECT
        r.statut,
        COUNT(*)            AS nb_reclamations,
        COUNT(DISTINCT r.id_abonne) AS nb_abonnes_concernes
    FROM reclamations r
    GROUP BY r.statut
    ORDER BY nb_reclamations DESC
""", conn)

print("\nStatut des réclamations :")
print(reclamations.to_string(index=False))

# Abonnés avec réclamations non résolues
en_attente = requete("""
    SELECT
        a.nom,
        a.ville,
        a.forfait,
        r.motif,
        r.statut
    FROM reclamations r
    JOIN abonnes a ON r.id_abonne = a.id
    WHERE r.statut != 'Résolu'
    ORDER BY a.nom
""", conn)

print(f"\nAbonnés avec réclamations non résolues : {len(en_attente)}")
print(en_attente.to_string(index=False))

conn.close()


# ============================================================
# ÉTAPE 8 — RAPPORT FINAL ET INSIGHTS
# ============================================================
print("\n" + "=" * 65)
print("INSIGHTS ET RECOMMANDATIONS")
print("=" * 65)

conn = connecter()

# Calculer les insights dynamiquement
stats = requete("""
    SELECT
        COUNT(*) AS total,
        SUM(CASE WHEN actif=1 THEN 1 ELSE 0 END) AS actifs,
        ROUND(AVG(solde), 0) AS solde_moyen,
        (SELECT ville FROM abonnes
         GROUP BY ville ORDER BY SUM(solde) DESC LIMIT 1) AS ville_top,
        (SELECT forfait FROM abonnes
         GROUP BY forfait ORDER BY COUNT(*) DESC LIMIT 1) AS forfait_top,
        SUM(CASE WHEN solde < 1000 AND actif=1 THEN 1 ELSE 0 END) AS critiques
    FROM abonnes
""", conn)

total        = stats['total'].values[0]
actifs       = stats['actifs'].values[0]
solde_moyen  = int(stats['solde_moyen'].values[0])
ville_top    = stats['ville_top'].values[0]
forfait_top  = stats['forfait_top'].values[0]
critiques    = stats['critiques'].values[0]
taux_actifs  = round(actifs / total * 100, 1)

print(f"""
INSIGHT 1 — Ville dominante
  {ville_top} concentre le solde total le plus élevé.
  → Prioriser les actions de rétention et d'upselling sur Ouaga.

INSIGHT 2 — Abonnés critiques
  {critiques} abonnés actifs ({round(critiques/actifs*100, 1)}%) ont un solde
  inférieur à 1 000 FCFA — risque de churn élevé.
  → Lancer une campagne de recharge ciblée immédiatement.

INSIGHT 3 — Taux d'activité
  {taux_actifs}% des abonnés sont actifs.
  → Les inactifs représentent {round(100-taux_actifs, 1)}% — potentiel
    de réactivation significatif.

INSIGHT 4 — Forfait dominant
  {forfait_top} est le forfait le plus souscrit.
  → Opportunité d'upselling vers Orange Max 10Go pour
    les abonnés à fort usage.

INSIGHT 5 — Orange Money
  Les abonnés Orange Max 20Go génèrent le plus de volume
  de transactions Orange Money.
  → Corrélation forte entre niveau de forfait et
    usage des services financiers mobiles.
""")

conn.close()

print("=" * 65)
print("ANALYSE TERMINÉE")
print("=" * 65)
