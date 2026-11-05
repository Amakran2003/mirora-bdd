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