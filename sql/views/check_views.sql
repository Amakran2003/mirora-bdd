-- 1. Vérifier les 6 vues
USE projet_freyja;

SHOW FULL TABLES
WHERE Table_type = 'VIEW';


--2. Tester les vues détaillées
SELECT * FROM vue_vetements_details;
SELECT * FROM vue_profils_utilisateurs;
SELECT * FROM vue_annonces_details;


--3. Tester les vues statistiques
SELECT * FROM vue_stats_categories;
SELECT * FROM vue_stats_tenues;
SELECT * FROM vue_stats_utilisateurs;


--4. Vérifier le nombre de résultats dans chaque vue
SELECT 'vue_vetements_details' AS vue, COUNT(*) AS total
FROM vue_vetements_details

UNION ALL

SELECT 'vue_profils_utilisateurs', COUNT(*)
FROM vue_profils_utilisateurs

UNION ALL

SELECT 'vue_annonces_details', COUNT(*)
FROM vue_annonces_details

UNION ALL

SELECT 'vue_stats_categories', COUNT(*)
FROM vue_stats_categories

UNION ALL

SELECT 'vue_stats_tenues', COUNT(*)
FROM vue_stats_tenues

UNION ALL

SELECT 'vue_stats_utilisateurs', COUNT(*)
FROM vue_stats_utilisateurs;

-- 5. Tester les nouvelles vues détaillées
SELECT * FROM vue_transactions_details;
SELECT * FROM vue_essayages_details;
SELECT * FROM vue_compatibilites_couleurs;
SELECT * FROM vue_photos_utilisateurs;


-- 6. Tester les nouvelles vues statistiques
SELECT * FROM vue_stats_transactions_vendeurs;
SELECT * FROM vue_stats_essayages;


-- 7. Vérifier le nombre de résultats dans les nouvelles vues
SELECT 'vue_transactions_details' AS vue, COUNT(*) AS total
FROM vue_transactions_details

UNION ALL

SELECT 'vue_essayages_details', COUNT(*)
FROM vue_essayages_details

UNION ALL

SELECT 'vue_compatibilites_couleurs', COUNT(*)
FROM vue_compatibilites_couleurs

UNION ALL

SELECT 'vue_stats_transactions_vendeurs', COUNT(*)
FROM vue_stats_transactions_vendeurs

UNION ALL

SELECT 'vue_stats_essayages', COUNT(*)
FROM vue_stats_essayages

UNION ALL

SELECT 'vue_photos_utilisateurs', COUNT(*)
FROM vue_photos_utilisateurs;


-- Afficher les vêtements avec leurs catégories et propriétaires
SELECT
    nom_vetement,
    categorie,
    couleur,
    style,
    nom_proprietaire
FROM vue_vetements_details;


-- Afficher les annonces avec leurs vendeurs et leurs prix
SELECT
    nom_vetement,
    prenom_vendeur,
    nom_vendeur,
    prix,
    statut
FROM vue_annonces_details;


-- Afficher les transactions avec les acheteurs et les vendeurs
SELECT
    id_transaction,
    nom_vetement,
    nom_acheteur,
    nom_vendeur,
    montant
FROM vue_transactions_details;


-- Classer les catégories par nombre de vêtements
SELECT
    categorie,
    nombre_vetements
FROM vue_stats_categories
ORDER BY nombre_vetements DESC;


-- Classer les utilisateurs par nombre de vêtements
SELECT
    prenom,
    nom,
    nombre_vetements
FROM vue_stats_utilisateurs
ORDER BY nombre_vetements DESC;


-- Classer les vendeurs par montant total des ventes
SELECT
    prenom,
    nom,
    nombre_ventes,
    montant_total_ventes
FROM vue_stats_transactions_vendeurs
ORDER BY montant_total_ventes DESC;



-- Afficher uniquement les annonces actives
SELECT *
FROM vue_annonces_details
WHERE statut = 'active';


-- Afficher les essayages d'un style précis
SELECT *
FROM vue_essayages_details
WHERE style = 'Casual';

-- Afficher les catégories sans vêtements
SELECT *
FROM vue_stats_categories
WHERE nombre_vetements = 0;

-- Afficher les utilisateurs ayant réalisé au moins un essayage
SELECT
    prenom,
    nom,
    style,
    nombre_essayages
FROM vue_stats_essayages
WHERE nombre_essayages > 0;

-- Afficher uniquement les photos avec consentement
SELECT
    id_photo,
    prenom,
    nom,
    angle,
    consentement
FROM vue_photos_utilisateurs
WHERE consentement = 1;