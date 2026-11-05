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


-- VUE 7 : DETAILS DES TRANSACTIONS
-- Afficher les achats, les vendeurs et les acheteurs

CREATE OR REPLACE VIEW vue_transactions_details AS
SELECT
    tr.id_transaction,
    tr.date_transaction,
    tr.montant,
    tr.commission,

    a.id_annonce,
    a.etat AS etat_vetement,

    v.id_vetement,
    v.nom AS nom_vetement,
    v.marque,

    c.nom AS categorie,

    vendeur.id_utilisateur AS id_vendeur,
    vendeur.prenom AS prenom_vendeur,
    vendeur.nom AS nom_vendeur,

    acheteur.id_utilisateur AS id_acheteur,
    acheteur.prenom AS prenom_acheteur,
    acheteur.nom AS nom_acheteur

FROM `transaction` tr

INNER JOIN annonce a
    ON tr.id_annonce = a.id_annonce

INNER JOIN vetement v
    ON a.id_vetement = v.id_vetement

INNER JOIN categorie c
    ON v.id_categorie = c.id_categorie

INNER JOIN utilisateur vendeur
    ON v.id_utilisateur = vendeur.id_utilisateur

INNER JOIN utilisateur acheteur
    ON tr.id_acheteur = acheteur.id_utilisateur;


-- VUE 8 : DETAILS DES ESSAYAGES VIRTUELS
-- Afficher les essayages générés pour chaque utilisateur

CREATE OR REPLACE VIEW vue_essayages_details AS
SELECT
    e.id_essayage,
    e.image_generee_url,
    e.date_essayage,

    t.id_tenue,
    t.nom AS nom_tenue,
    t.occasion,

    s.nom AS style,

    u.id_utilisateur,
    u.prenom,
    u.nom AS nom_utilisateur

FROM essayage e

INNER JOIN tenue t
    ON e.id_tenue = t.id_tenue

INNER JOIN style s
    ON t.id_style = s.id_style

INNER JOIN utilisateur u
    ON t.id_utilisateur = u.id_utilisateur;


-- VUE 9 : COMPATIBILITE DES COULEURS
-- Afficher les associations de couleurs compatibles

CREATE OR REPLACE VIEW vue_compatibilites_couleurs AS
SELECT
    cc.id_couleur_1,
    c1.nom AS couleur_1,
    c1.code_hex AS code_hex_1,

    cc.id_couleur_2,
    c2.nom AS couleur_2,
    c2.code_hex AS code_hex_2

FROM compatibilite_couleur cc

INNER JOIN couleur c1
    ON cc.id_couleur_1 = c1.id_couleur

INNER JOIN couleur c2
    ON cc.id_couleur_2 = c2.id_couleur;
-- VUE 10 : STATISTIQUES DES TRANSACTIONS PAR VENDEUR
-- Afficher le nombre de ventes, le montant total et le montant moyen
-- Utilisation de GROUP BY et de fonctions d'agregation
-- COUNT : nombre de transactions
-- SUM   : montant total des ventes
-- AVG   : montant moyen des ventes

CREATE OR REPLACE VIEW vue_stats_transactions_vendeurs AS
SELECT
    u.id_utilisateur,
    u.prenom,
    u.nom,

    COUNT(tr.id_transaction) AS nombre_ventes,

    SUM(tr.montant) AS montant_total_ventes,

    AVG(tr.montant) AS montant_moyen_ventes,

    SUM(tr.commission) AS commissions_totales

FROM utilisateur u

INNER JOIN vetement v
    ON u.id_utilisateur = v.id_utilisateur

INNER JOIN annonce a
    ON v.id_vetement = a.id_vetement

INNER JOIN `transaction` tr
    ON a.id_annonce = tr.id_annonce

GROUP BY
    u.id_utilisateur,
    u.prenom,
    u.nom;


-- VUE 11 : STATISTIQUES DES ESSAYAGES PAR UTILISATEUR ET PAR STYLE
-- Afficher le nombre d'essayages et de tenues essayées
-- Utilisation de GROUP BY et de fonctions d'agregation
-- COUNT : nombre d'essayages
-- COUNT DISTINCT : nombre de tenues différentes essayées

CREATE OR REPLACE VIEW vue_stats_essayages AS
SELECT
    u.id_utilisateur,
    u.prenom,
    u.nom,

    s.id_style,
    s.nom AS style,

    COUNT(e.id_essayage) AS nombre_essayages,

    COUNT(DISTINCT t.id_tenue) AS nombre_tenues_essayees

FROM utilisateur u

INNER JOIN tenue t
    ON u.id_utilisateur = t.id_utilisateur

INNER JOIN style s
    ON t.id_style = s.id_style

LEFT JOIN essayage e
    ON t.id_tenue = e.id_tenue

GROUP BY
    u.id_utilisateur,
    u.prenom,
    u.nom,
    s.id_style,
    s.nom;


-- VUE 12 : PHOTOS DES UTILISATEURS
-- Afficher les photos et les informations de profil

CREATE OR REPLACE VIEW vue_photos_utilisateurs AS
SELECT
    ph.id_photo,
    ph.url,
    ph.angle,
    ph.date_photo,
    ph.consentement,

    u.id_utilisateur,
    u.prenom,
    u.nom,
    u.email,

    p.taille_cm,
    p.taille_haut,
    p.taille_bas,
    p.pointure

FROM photo_utilisateur ph

INNER JOIN utilisateur u
    ON ph.id_utilisateur = u.id_utilisateur

INNER JOIN profil p
    ON u.id_utilisateur = p.id_utilisateur;
