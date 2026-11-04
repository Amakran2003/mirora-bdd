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

