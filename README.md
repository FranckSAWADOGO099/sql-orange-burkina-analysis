# 🗄️ Analyse SQL — Orange Burkina Faso

Projet d'analyse de données réalisé avec **SQL** et **Python**,
simulant le travail d'un data analyst junior dans un opérateur télécom burkinabè.

---

## 🎯 Objectif

Analyser une base de données relationnelle d'abonnés fictifs d'Orange Burkina Faso
pour produire des insights business actionnables :

- Explorer et comprendre la structure des données
- Calculer les KPIs clés de l'activité télécom
- Segmenter les abonnés par valeur et comportement
- Analyser les transactions Orange Money
- Identifier les abonnés à risque et formuler des recommandations

---

## 🗂️ Structure du projet

```
sql-orange-burkina-analysis/
│
├── data/
│   └── setup_database.py       # Création et peuplement de la base SQLite
│
├── scripts/
│   ├── 01_exploration.sql      # SELECT, WHERE, ORDER BY, LIMIT, DISTINCT
│   ├── 02_aggregations.sql     # COUNT, SUM, AVG, GROUP BY, HAVING
│   ├── 03_jointures.sql        # INNER JOIN, LEFT JOIN, jointures multiples
│   ├── 04_sous_requetes.sql    # Subqueries dans WHERE, SELECT, FROM
│   └── 05_manipulation.sql     # INSERT, UPDATE, DELETE
│
├── analyse_complete.py         # Pipeline Python + SQL complet
├── insights.md                 # Insights et recommandations business
└── README.md
```

---

## 🛠️ Compétences SQL démontrées

| Concept | Détail |
|---|---|
| **SELECT & Filtrage** | `SELECT`, `WHERE`, `LIKE`, `IN`, `BETWEEN`, `IS NULL` |
| **Tri & Limitation** | `ORDER BY`, `LIMIT`, `OFFSET`, `DISTINCT` |
| **Agrégations** | `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`, `ROUND` |
| **Groupements** | `GROUP BY` simple et multi-colonnes, `HAVING` |
| **Jointures** | `INNER JOIN`, `LEFT JOIN`, jointures sur 3 et 4 tables |
| **Sous-requêtes** | Dans `WHERE`, `SELECT`, `FROM`, avec `IN`, `NOT IN`, `EXISTS` |
| **Manipulation** | `INSERT`, `UPDATE`, `DELETE`, `COALESCE`, `CASE WHEN` |
| **Python + SQL** | `pd.read_sql()`, `sqlite3`, pipeline d'analyse complet |

---

## 📁 Description de la base de données

### Table `abonnes`
| Colonne | Type | Description |
|---|---|---|
| id | INTEGER | Identifiant unique |
| nom | TEXT | Nom de l'abonné |
| ville | TEXT | Ville de résidence |
| forfait | TEXT | Forfait souscrit |
| solde | REAL | Solde en FCFA |
| actif | INTEGER | 1 = actif, 0 = inactif |
| appels_mois | INTEGER | Appels ce mois |
| data_go | REAL | Data consommée en Go |
| anciennete | INTEGER | Ancienneté en mois |

### Table `forfaits`
| Colonne | Type | Description |
|---|---|---|
| id | INTEGER | Identifiant |
| nom_forfait | TEXT | Nom commercial |
| prix_fcfa | INTEGER | Prix mensuel en FCFA |
| data_go | REAL | Data incluse en Go |
| appels_inclus | INTEGER | Appels inclus |

### Table `transactions`
| Colonne | Type | Description |
|---|---|---|
| id | INTEGER | Identifiant |
| id_abonne | INTEGER | Référence abonné |
| montant | INTEGER | Montant en FCFA |
| type | TEXT | envoi ou retrait |
| mois | INTEGER | Mois de la transaction |

### Table `reclamations`
| Colonne | Type | Description |
|---|---|---|
| id | INTEGER | Identifiant |
| id_abonne | INTEGER | Référence abonné |
| motif | TEXT | Motif de la réclamation |
| statut | TEXT | En attente / En cours / Résolu |
| mois | INTEGER | Mois de la réclamation |

---

## 🚀 Comment exécuter le projet

### Prérequis
```
Python 3.12+
pandas
sqlite3 (inclus dans Python)
```

### Installation
```bash
git clone https://github.com/FranckSAWADOGO099/sql-orange-burkina-analysis.git
cd sql-orange-burkina-analysis
pip install pandas
```

### Étape 1 — Créer la base de données
```bash
cd data
python setup_database.py
```

### Étape 2 — Lancer l'analyse complète
```bash
cd ..
python analyse_complete.py
```

### Étape 3 — Explorer les scripts SQL
Ouvre les fichiers dans le dossier `scripts/` avec
**DB Browser for SQLite** (téléchargeable sur [sqlitebrowser.org](https://sqlitebrowser.org))
ou exécute-les directement depuis Python avec `pd.read_sql()`.

---

## 📈 Résultats principaux

### Segmentation des abonnés actifs
| Segment | Critère | Abonnés |
|---|---|---|
| Premium | solde ≥ 8 000 FCFA | 4 |
| Standard | solde 3 000–8 000 FCFA | 6 |
| Faible | solde 1 000–3 000 FCFA | 3 |
| Critique | solde < 1 000 FCFA | 2 |

### Performance par ville
| Ville | Abonnés | Solde moyen | Taux actifs |
|---|---|---|---|
| Ouaga | 8 | ~6 950 FCFA | 75% |
| Koudougou | 4 | ~3 950 FCFA | 100% |
| Banfora | 4 | ~2 775 FCFA | 50% |
| Bobo | 4 | ~1 475 FCFA | 50% |

---

## 💡 Insights clés

1. **Ouaga domine** — 8 abonnés, solde total le plus élevé
   → Concentrer l'acquisition et l'upselling sur Ouaga

2. **25% d'inactifs** — tous avec solde faible et ancienneté courte
   → Programme de réactivation ciblé

3. **Corrélation appels/data** — les gros utilisateurs font les deux
   → Offres combinées pour encourager la montée en gamme

4. **Orange Money concentré chez les Premium**
   → Incitations spécifiques pour les forfaits inférieurs

5. **Réclamations = signal d'inactivité**
   → Traiter les réclamations en priorité pour réduire le churn

---

## 👤 Auteur

**Franck SAWADOGO**
Étudiant GEI — IST Ouagadougou
En formation Data Analytics — Python · SQL · Power BI
Objectif : Data Analyst junior dans le secteur télécom au Burkina Faso

🔗 [GitHub](https://github.com/FranckSAWADOGO099)
🔗 [LinkedIn](https://www.linkedin.com/in/franck-sawadogo)

---

## 📚 Technologies utilisées

![Python](https://img.shields.io/badge/Python-3.12-blue)
![SQLite](https://img.shields.io/badge/SQLite-3-lightblue)
![Pandas](https://img.shields.io/badge/Pandas-2.0-green)
![SQL](https://img.shields.io/badge/SQL-Intermediate-orange)
