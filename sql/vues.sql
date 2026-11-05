USE projet_freyja;


-- VUE 1 : DETAILS DES VETEMENTS
CREATE OR REPLACE VIEW vue_vetements_details AS
SELECT
    v.id_vetement,
    v.nom AS nom_vetement,
    v.marque,
    v.taille,
    v.photo_url,
    v.date_ajout,

    c.nom AS categorie,
    co.nom AS couleur,
    co.code_hex,
    s.nom AS style,

    u.id_utilisateur,
    u.prenom,
    u.nom AS nom_proprietaire

FROM vetement v

INNER JOIN utilisateur u
    ON v.id_utilisateur = u.id_utilisateur

INNER JOIN categorie c
    ON v.id_categorie = c.id_categorie

INNER JOIN couleur co
    ON v.id_couleur = co.id_couleur

INNER JOIN style s
    ON v.id_style = s.id_style;


-- VUE 2 : PROFILS DES UTILISATEURS Afficher les informations de profil et les tailles

CREATE OR REPLACE VIEW vue_profils_utilisateurs AS
SELECT
    u.id_utilisateur,
    u.prenom,
    u.nom,
    u.email,

    p.taille_cm,
    p.taille_haut,
    p.taille_bas,
    p.pointure

FROM utilisateur u

INNER JOIN profil p
    ON u.id_utilisateur = p.id_utilisateur;

-- VUE 3 : ANNONCES DETAILLEES Afficher les vêtements proposés à la vente

CREATE OR REPLACE VIEW vue_annonces_details AS
SELECT
    a.id_annonce,
    v.id_vetement,
    v.nom AS nom_vetement,
    v.marque,

    c.nom AS categorie,

    u.prenom AS prenom_vendeur,
    u.nom AS nom_vendeur,

    a.prix,
    a.etat,
    a.statut,
    a.date_publication

FROM annonce a

INNER JOIN vetement v
    ON a.id_vetement = v.id_vetement

INNER JOIN utilisateur u
    ON v.id_utilisateur = u.id_utilisateur

INNER JOIN categorie c
    ON v.id_categorie = c.id_categorie;


-- VUE 4 : STATISTIQUES PAR CATEGORIE
-- Utilisation de GROUP BY et de fonctions d'agregation
-- COUNT : nombre de vêtements et d'annonces
-- SUM   : valeur totale des annonces actives
-- AVG   : prix moyen des annonces actives

CREATE OR REPLACE VIEW vue_stats_categories AS
SELECT
    c.id_categorie,
    c.nom AS categorie,

    COUNT(DISTINCT v.id_vetement) AS nombre_vetements,

    COUNT(DISTINCT a.id_annonce) AS nombre_annonces_actives,

    SUM(a.prix) AS valeur_totale_annonces,

    AVG(a.prix) AS prix_moyen

FROM categorie c

LEFT JOIN vetement v
    ON c.id_categorie = v.id_categorie

LEFT JOIN annonce a
    ON v.id_vetement = a.id_vetement
    AND a.statut = 'active'

GROUP BY
    c.id_categorie,
    c.nom;


-- VUE 5 : STATISTIQUES DES TENUES PAR STYLE
-- Affiche le nombre de tenues et de pièces par style Utilisation de GROUP BY, COUNT et SUM

CREATE OR REPLACE VIEW vue_stats_tenues AS
SELECT
    s.id_style,
    s.nom AS style,

    COUNT(DISTINCT t.id_tenue) AS nombre_tenues,

    COUNT(tp.id_tenue_piece) AS nombre_pieces,

    SUM(
        CASE
            WHEN tp.id_vetement IS NOT NULL THEN 1
            ELSE 0
        END
    ) AS pieces_possedees,

    SUM(
        CASE
            WHEN tp.id_annonce IS NOT NULL THEN 1
            ELSE 0
        END
    ) AS pieces_a_acheter

FROM style s

LEFT JOIN tenue t
    ON s.id_style = t.id_style

LEFT JOIN tenue_piece tp
    ON t.id_tenue = tp.id_tenue

GROUP BY
    s.id_style,
    s.nom;


-- VUE 6 : STATISTIQUES DES DRESSINGS PAR UTILISATEUR
-- Affiche le nombre de vêtements et de catégories
-- Utilisation de GROUP BY et de COUNT

CREATE OR REPLACE VIEW vue_stats_utilisateurs AS
SELECT
    u.id_utilisateur,
    u.prenom,
    u.nom,

    COUNT(v.id_vetement) AS nombre_vetements,

    COUNT(DISTINCT c.id_categorie) AS nombre_categories

FROM utilisateur u

LEFT JOIN vetement v
    ON u.id_utilisateur = v.id_utilisateur

LEFT JOIN categorie c
    ON v.id_categorie = c.id_categorie

GROUP BY
    u.id_utilisateur,
    u.prenom,
    u.nom;