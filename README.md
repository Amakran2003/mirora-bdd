<a id="readme-top"></a>

<div align="center">

<h1>Mirora</h1>

<p>
  <strong>Dressing intelligent, marketplace entre utilisateurs et essayage virtuel par IA.</strong><br>
  Base de données relationnelle MySQL · Projet du cours « Bases de données » · EFREI Paris
</p>

<p>
  <img src="https://img.shields.io/badge/MySQL-8.0-4479A1?style=flat-square&logo=mysql&logoColor=white" alt="MySQL 8.0">
  <img src="https://img.shields.io/badge/statut-en%20cours-c2573a?style=flat-square" alt="Statut : en cours">
  <img src="https://img.shields.io/badge/remise-11%2F11%2F2026-24211e?style=flat-square" alt="Remise : 11/11/2026">
  <img src="https://img.shields.io/badge/EFREI-Bases%20de%20donn%C3%A9es-6f8467?style=flat-square" alt="EFREI : Bases de données">
</p>

<p>
  <a href="docs/Mirora_Specifications_fonctionnelles_v1.pdf"><strong>Spécifications fonctionnelles</strong></a>
  ·
  <a href="#modèle-de-données">Modèle de données</a>
  ·
  <a href="sql/">Scripts SQL</a>
  ·
  <a href="#équipe">Équipe</a>
</p>

</div>

<br>

<details>
  <summary><strong>Sommaire</strong></summary>
  <ol>
    <li><a href="#à-propos">À propos</a></li>
    <li><a href="#le-besoin-métier">Le besoin métier</a></li>
    <li><a href="#modèle-de-données">Modèle de données</a></li>
    <li><a href="#vues">Vues</a></li>
    <li><a href="#structure-du-dépôt">Structure du dépôt</a></li>
    <li><a href="#installation">Installation</a></li>
    <li><a href="#livrables">Livrables</a></li>
    <li><a href="#planning">Planning</a></li>
    <li><a href="#contribuer">Contribuer</a></li>
    <li><a href="#équipe">Équipe</a></li>
  </ol>
</details>

<br>

## À propos

Mirora est une application mobile qui part de **ce que tu as déjà dans ton dressing**.

Chaque vêtement est pris en photo et annoté (catégorie, couleur, style, taille). L'application propose ensuite des tenues avec ces pièces. Quand il manque une pièce pour compléter une tenue, Mirora la cherche **chez les autres utilisateurs** qui la revendent. Enfin, l'essayage virtuel génère une image de l'utilisateur portant la tenue complète, avant tout achat.

Ce dépôt contient la **base de données MySQL** qui porte ce fonctionnement : dressings, annonces, tenues, et les vues qui permettent d'exploiter ces données.

> L'idée et le produit Mirora sont portés par **Chahd Loussaief**.

<p align="right">(<a href="#readme-top">retour en haut</a>)</p>

## Le besoin métier

| Problème | Réponse Mirora |
| --- | --- |
| On ne sait pas combiner ce qu'on possède déjà | Des tenues générées à partir du dressing |
| Les applis mode poussent à tout racheter | La pièce manquante vient d'abord de la seconde main |
| Revendre prend du temps | Mise en vente en un clic, la pièce est déjà photographiée et décrite |
| On achète sans savoir comment ça rendra sur soi | Essayage virtuel par IA |

Le détail (personas, parcours utilisateur, fonctionnalités, règles de gestion, schémas) est dans les [spécifications fonctionnelles](docs/Mirora_Specifications_fonctionnelles_v1.pdf).

<p align="right">(<a href="#readme-top">retour en haut</a>)</p>

## Modèle de données

Le MCD / MLD complet est disponible dans [`docs/`](docs/).

| Table | Rôle |
| --- | --- |
| `utilisateur` | Compte de l'utilisateur |
| `profil` | Taille et tailles habituelles (haut, bas, pointure) |
| `categorie` | Haut, bas, chaussures, veste, chaussettes, accessoire |
| `couleur` | Couleurs des pièces |
| `style` | Casual, chic, sport, streetwear |
| `vetement` | Toutes les pièces de tous les dressings (photo, propriétaire, attributs, taille) |
| `annonce` | Une pièce mise en vente (prix, état, statut) |
| `tenue` | Une tenue proposée à un utilisateur (occasion, style) |
| `tenue_piece` | Les pièces qui composent une tenue |

**Principales règles métier**

- Un vêtement appartient à un seul utilisateur.
- Un vêtement n'est visible par les autres que s'il a une annonce active.
- Un vêtement a au plus une annonce active, et le prix d'une annonce est strictement positif.
- Une pièce de tenue appartient soit au propriétaire de la tenue (dans son dressing), soit à un autre utilisateur via une annonce (à acheter).

<p align="right">(<a href="#readme-top">retour en haut</a>)</p>

## Vues

| Vue | Type | Ce qu'elle montre |
| --- | --- | --- |
| `v_tenues_detail` | Détaillée | Chaque tenue avec ses pièces, en indiquant si la pièce est déjà dans le dressing ou à acheter, avec le vendeur et le prix |
| `v_stats_tenues` | Agrégée | Par tenue : nombre de pièces possédées, nombre de pièces à acheter, coût total pour compléter la tenue |

Chaque vue interroge au moins trois tables. La vue agrégée utilise `GROUP BY` et au moins deux fonctions d'agrégation.

<p align="right">(<a href="#readme-top">retour en haut</a>)</p>

## Structure du dépôt

```
mirora-bdd/
├── docs/
│   ├── Mirora_Specifications_fonctionnelles_v1.pdf
│   └── modele_donnees.png
├── sql/
│   ├── 01_create_tables.sql
│   ├── 02_insert_data.sql
│   └── 03_views.sql
└── README.md
```

<p align="right">(<a href="#readme-top">retour en haut</a>)</p>

## Installation

**Prérequis** : MySQL 8.0 ou plus, et un client SQL (DbVisualizer, MySQL Workbench ou la ligne de commande).

1. Cloner le dépôt
   ```sh
   git clone <url-du-depot>
   cd mirora-bdd
   ```
2. Exécuter les scripts **dans l'ordre**
   ```sh
   mysql -h <hote> -u <utilisateur> -p <base> < sql/01_create_tables.sql
   mysql -h <hote> -u <utilisateur> -p <base> < sql/02_insert_data.sql
   mysql -h <hote> -u <utilisateur> -p <base> < sql/03_views.sql
   ```
3. Vérifier les vues
   ```sql
   SELECT * FROM v_tenues_detail;
   SELECT * FROM v_stats_tenues;
   ```

Dans DbVisualizer : ouvrir chaque fichier, puis l'exécuter en tant que script, dans le même ordre.

<p align="right">(<a href="#readme-top">retour en haut</a>)</p>

## Livrables

**Par e-mail**

- [ ] Document présentant le besoin métier
- [ ] Modèle de données
- [ ] Précisions et justifications (optionnel)

**Sur la base `projet_` du serveur MySQL**

- [ ] Au moins quatre tables, reliées par des clés étrangères
- [ ] Contraintes nécessaires au besoin métier
- [ ] Au moins deux lignes de données par table
- [ ] Une vue détaillée (trois tables minimum, sans agrégation)
- [ ] Une vue agrégée (trois tables minimum, `GROUP BY` et deux fonctions d'agrégation)
- [ ] Chaque vue renvoie au moins deux lignes

<p align="right">(<a href="#readme-top">retour en haut</a>)</p>

## Planning

| Date | Étape | Responsable |
| --- | --- | --- |
| 03/11 | Thème, répartition, création du dépôt | Abderrazaq |
| 05/11 | Modèle de données | Abderrazaq, Chahd |
| 07/11 | Document besoin métier | Abderrazaq, Chahd |
| 08/11 | Tables, contraintes et données | Khaled |
| 09/11 | Vues et mise en ligne sur le serveur | Nabil |
| 10/11 | Vérification commune | Toute l'équipe |
| 11/11 | Remise finale | Abderrazaq |

<p align="right">(<a href="#readme-top">retour en haut</a>)</p>

## Contribuer

1. Créer une branche depuis `main`
   ```sh
   git checkout -b feat/nom-de-la-tache
   ```
2. Faire des commits courts et clairs
   ```sh
   git commit -m "ajout des contraintes sur la table annonce"
   ```
3. Pousser la branche et ouvrir une pull request
   ```sh
   git push origin feat/nom-de-la-tache
   ```
4. Une autre personne de l'équipe relit avant la fusion dans `main`.

<p align="right">(<a href="#readme-top">retour en haut</a>)</p>

## Équipe

| Membre | Rôle |
| --- | --- |
| **Chahd Loussaief** | Porteuse du projet, besoin métier, modèle de données |
| **Abderrazaq Makran** | Besoin métier, modèle de données, dépôt et documentation, remise |
| **Khaled** | Création des tables, contraintes, jeu de données |
| **Saied Nabil** | Vues, déploiement sur le serveur, tests |

<p align="right">(<a href="#readme-top">retour en haut</a>)</p>
