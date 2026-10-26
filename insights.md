# Insights & Recommandations - Orange Burkina Faso

## Résumé exécutif

Analyse complète de 20 abonnés fictifs d'un opérateur télécom burkinabè.
Pipeline SQL complet : exploration → agrégations → jointures →
sous-requêtes → manipulation des données.

---

## KPIs principaux

| Indicateur | Valeur |
|---|---|
| Total abonnés | 20 |
| Abonnés actifs | 15 (75%) |
| Abonnés inactifs | 5 (25%) |
| Solde moyen | ~5 200 FCFA |
| Solde total | ~104 000 FCFA |
| Volume Orange Money | ~263 500 FCFA |

---

## Insight 1 - Ouagadougou domine le marché

Ouaga concentre 8 abonnés sur 20 et le solde total le plus élevé
de toutes les villes. Les abonnés de Ouaga ont en moyenne
plus d'appels et plus de consommation data.

**Recommandation :** Concentrer les efforts d'acquisition
et d'upselling sur Ouagadougou avant d'étendre aux autres villes.

---

## Insight 2 - 25% d'abonnés inactifs

5 abonnés sur 20 sont inactifs. Ils ont tous un solde très faible
(proche de 0) et une ancienneté courte (moins de 6 mois).

**Recommandation :** Programme de réactivation ciblé avec
une offre promotionnelle pour les abonnés inactifs
de moins de 6 mois d'ancienneté.

---

## Insight 3 - Corrélation appels / data

Les abonnés avec les forfaits les plus élevés (Max 10Go, Max 20Go)
appellent plus et consomment plus de data. Ce ne sont pas
deux comportements indépendants - ils reflètent l'engagement
global de l'abonné.

**Recommandation :** Créer des offres combinées appels + data
pour encourager les abonnés Orange Liberté à monter en gamme.

---

## Insight 4 - Orange Money concentré chez les Premium

Les abonnés Orange Max 20Go et Max 10Go génèrent 80%
du volume total des transactions Orange Money malgré
leur nombre réduit.

**Recommandation :** Développer des incitations spécifiques
Orange Money pour les abonnés des forfaits inférieurs
afin d'élargir la base d'utilisateurs actifs.

---

## Insight 5 - Réclamations concentrées chez les inactifs

La majorité des réclamations non résolues concernent
des abonnés inactifs avec des problèmes de réseau
ou de forfait non activé.

**Recommandation :** Résoudre les réclamations en attente
en priorité — un problème non résolu est souvent
la première cause d'inactivité.

---

## Structure de la base de données

```
orange_burkina.db
│
├── abonnes (20 lignes)
│   id | nom | ville | forfait | solde | actif
│   appels_mois | data_go | anciennete
│
├── forfaits (4 lignes)
│   id | nom_forfait | prix_fcfa | data_go | appels_inclus
│
├── transactions (19 lignes)
│   id | id_abonne | montant | type | mois
│
└── reclamations (7 lignes)
    id | id_abonne | motif | statut | mois
```
