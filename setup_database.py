# ============================================================
# SETUP — Création et peuplement de la base de données
# Projet : Analyse SQL Orange Burkina Faso
# Auteur : Franck SAWADOGO
# ============================================================

import sqlite3
import os

os.chdir(os.path.dirname(os.path.abspath(__file__)))

conn   = sqlite3.connect("orange_burkina.db")
cursor = conn.cursor()

# ── Création des tables ──────────────────────────────────────

cursor.execute("""
CREATE TABLE IF NOT EXISTS abonnes (
    id          INTEGER PRIMARY KEY,
    nom         TEXT    NOT NULL,
    ville       TEXT    NOT NULL,
    forfait     TEXT    NOT NULL,
    solde       REAL    DEFAULT 0,
    actif       INTEGER DEFAULT 1,
    appels_mois INTEGER DEFAULT 0,
    data_go     REAL    DEFAULT 0,
    anciennete  INTEGER DEFAULT 1
)
""")

cursor.execute("""
CREATE TABLE IF NOT EXISTS forfaits (
    id          INTEGER PRIMARY KEY,
    nom_forfait TEXT    NOT NULL UNIQUE,
    prix_fcfa   INTEGER NOT NULL,
    data_go     REAL    NOT NULL,
    appels_inclus INTEGER DEFAULT 0
)
""")

cursor.execute("""
CREATE TABLE IF NOT EXISTS transactions (
    id         INTEGER PRIMARY KEY,
    id_abonne  INTEGER NOT NULL,
    montant    INTEGER NOT NULL,
    type       TEXT    NOT NULL,
    mois       INTEGER NOT NULL,
    FOREIGN KEY (id_abonne) REFERENCES abonnes(id)
)
""")

cursor.execute("""
CREATE TABLE IF NOT EXISTS reclamations (
    id          INTEGER PRIMARY KEY,
    id_abonne   INTEGER NOT NULL,
    motif       TEXT    NOT NULL,
    statut      TEXT    DEFAULT 'En attente',
    mois        INTEGER NOT NULL,
    FOREIGN KEY (id_abonne) REFERENCES abonnes(id)
)
""")

# ── Insertion des forfaits ───────────────────────────────────

cursor.executemany("""
    INSERT OR IGNORE INTO forfaits VALUES (?, ?, ?, ?, ?)
""", [
    (1, "Orange Liberté",   1500,  2.0,  30),
    (2, "Orange Max 5Go",   3500,  5.0,  60),
    (3, "Orange Max 10Go",  6000, 10.0, 120),
    (4, "Orange Max 20Go", 10000, 20.0, 200),
])

# ── Insertion des abonnés ────────────────────────────────────

cursor.executemany("""
    INSERT OR IGNORE INTO abonnes VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
""", [
    (1,  "Aminata Ouedraogo", "Ouaga",     "Orange Max 5Go",  3750,  1, 45,  3.2, 24),
    (2,  "Seydou Traore",     "Bobo",      "Orange Liberté",  1200,  0, 12,  0.5,  6),
    (3,  "Mariam Sawadogo",   "Ouaga",     "Orange Max 10Go", 5000,  1, 67,  7.5, 18),
    (4,  "Ibrahim Kone",      "Koudougou", "Orange Liberté",     0,  1, 23,  1.2, 12),
    (5,  "Fatima Coulibaly",  "Bobo",      "Orange Max 5Go",     0,  0,  0,  0.0,  3),
    (6,  "Kofi Ouattara",     "Ouaga",     "Orange Max 10Go",12000,  1,102,  9.8, 48),
    (7,  "Salif Zongo",       "Banfora",   "Orange Liberté",  2500,  1, 34,  2.1, 15),
    (8,  "Amina Diallo",      "Ouaga",     "Orange Max 5Go",   650,  0,  8,  0.3,  2),
    (9,  "Adama Bambara",     "Ouaga",     "Orange Max 10Go", 9500,  1, 95,  9.1, 42),
    (10, "Safi Ouoba",        "Banfora",   "Orange Liberté",     0,  0,  0,  0.0,  1),
    (11, "Binta Kabore",      "Koudougou", "Orange Max 5Go",  4200,  1, 51,  3.9, 30),
    (12, "Moussa Tapsoba",    "Ouaga",     "Orange Max 10Go", 7800,  1, 88,  8.5, 36),
    (13, "Aissata Nana",      "Bobo",      "Orange Liberté",  1500,  1, 19,  0.8,  8),
    (14, "Rasmane Ilboudo",   "Koudougou", "Orange Max 5Go",  3100,  1, 42,  2.8, 20),
    (15, "Clarisse Toe",      "Banfora",   "Orange Max 10Go", 5800,  1, 73,  6.2, 28),
    (16, "Hamidou Sanon",     "Ouaga",     "Orange Max 20Go",15000,  1,120, 18.5, 52),
    (17, "Kadiatou Sana",     "Bobo",      "Orange Max 5Go",  3200,  1, 38,  2.8, 10),
    (18, "Rokia Bambara",     "Ouaga",     "Orange Max 10Go", 8900,  1, 91,  8.9, 33),
    (19, "Souleymane Compaore","Banfora",  "Orange Liberté",   800,  0,  5,  0.2,  2),
    (20, "Zeinabou Yameogo",  "Koudougou", "Orange Max 20Go",12500,  1,110, 17.8, 45),
])

# ── Insertion des transactions ───────────────────────────────

cursor.executemany("""
    INSERT OR IGNORE INTO transactions VALUES (?, ?, ?, ?, ?)
""", [
    (1,  1,  5000,  "envoi",    1),
    (2,  1,  2500,  "retrait",  2),
    (3,  3,  15000, "envoi",    1),
    (4,  3,  8000,  "retrait",  3),
    (5,  6,  25000, "envoi",    2),
    (6,  6,  10000, "envoi",    4),
    (7,  7,  3000,  "envoi",    1),
    (8,  9,  12000, "retrait",  4),
    (9,  11, 4500,  "envoi",    2),
    (10, 12, 18000, "envoi",    3),
    (11, 12, 7500,  "retrait",  5),
    (12, 15, 9000,  "envoi",    1),
    (13, 15, 3500,  "retrait",  5),
    (14, 16, 30000, "envoi",    2),
    (15, 16, 15000, "retrait",  4),
    (16, 16, 20000, "envoi",    6),
    (17, 18, 11000, "envoi",    3),
    (18, 20, 22000, "envoi",    1),
    (19, 20, 8000,  "retrait",  2),
])

# ── Insertion des réclamations ───────────────────────────────

cursor.executemany("""
    INSERT OR IGNORE INTO reclamations VALUES (?, ?, ?, ?, ?)
""", [
    (1,  2,  "Réseau indisponible",     "Résolu",      1),
    (2,  5,  "Solde débité incorrectement", "En attente", 2),
    (3,  8,  "Forfait non activé",      "Résolu",      1),
    (4,  10, "Problème de connexion",   "En attente",  3),
    (5,  13, "Réseau lent",             "En cours",    2),
    (6,  2,  "Coupure fréquente",       "Résolu",      4),
    (7,  4,  "Forfait non activé",      "En attente",  2),
])

conn.commit()
conn.close()

print("✅ Base de données créée : orange_burkina.db")
print("Tables : abonnes (20 lignes), forfaits (4), transactions (19), reclamations (7)")
