-- =====================================================================
-- Mirora - 01_create_tables.sql
-- MySQL 8.0.16+ (les CHECK ne sont appliquées qu'à partir de cette version)
-- À exécuter sur la base projet_ déjà sélectionnée (pas de CREATE DATABASE)
-- Dans DbVisualizer : "Execute as script" (Alt+X)
-- =====================================================================

-- Réexécutable : on supprime dans l'ordre inverse des dépendances
DROP TABLE IF EXISTS tenue_piece;
DROP TABLE IF EXISTS tenue;
DROP TABLE IF EXISTS annonce;
DROP TABLE IF EXISTS vetement;
DROP TABLE IF EXISTS style;
DROP TABLE IF EXISTS couleur;
DROP TABLE IF EXISTS categorie;
DROP TABLE IF EXISTS profil;
DROP TABLE IF EXISTS utilisateur;

-- ---------------------------------------------------------------------
-- utilisateur : compte
-- ---------------------------------------------------------------------
CREATE TABLE utilisateur (
    id_utilisateur   INT AUTO_INCREMENT PRIMARY KEY,
    nom              VARCHAR(50)  NOT NULL,
    prenom           VARCHAR(50)  NOT NULL,
    email            VARCHAR(100) NOT NULL,
    mot_de_passe     VARCHAR(255) NOT NULL,
    date_inscription DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_utilisateur_email UNIQUE (email),
    CONSTRAINT chk_utilisateur_email CHECK (email LIKE '%_@_%.__%')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------
-- profil : taille et tailles habituelles (1 profil par utilisateur)
-- ---------------------------------------------------------------------
CREATE TABLE profil (
    id_profil      INT AUTO_INCREMENT PRIMARY KEY,
    id_utilisateur INT         NOT NULL,
    taille_cm      SMALLINT    NOT NULL,
    taille_haut    VARCHAR(5)  NOT NULL,
    taille_bas     VARCHAR(5)  NOT NULL,
    pointure       TINYINT     NOT NULL,
    CONSTRAINT uq_profil_utilisateur UNIQUE (id_utilisateur),
    CONSTRAINT chk_profil_taille_cm  CHECK (taille_cm BETWEEN 100 AND 230),
    CONSTRAINT chk_profil_haut       CHECK (taille_haut IN ('XS','S','M','L','XL','XXL')),
    CONSTRAINT chk_profil_pointure   CHECK (pointure BETWEEN 30 AND 50),
    CONSTRAINT fk_profil_utilisateur FOREIGN KEY (id_utilisateur)
        REFERENCES utilisateur(id_utilisateur) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------
-- Tables de référence : categorie, couleur, style
-- ---------------------------------------------------------------------
CREATE TABLE categorie (
    id_categorie INT AUTO_INCREMENT PRIMARY KEY,
    nom          VARCHAR(30) NOT NULL,
    CONSTRAINT uq_categorie_nom UNIQUE (nom)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE couleur (
    id_couleur INT AUTO_INCREMENT PRIMARY KEY,
    nom        VARCHAR(30) NOT NULL,
    code_hex   CHAR(7)     NOT NULL,
    CONSTRAINT uq_couleur_nom UNIQUE (nom),
    CONSTRAINT chk_couleur_hex CHECK (code_hex REGEXP '^#[0-9A-Fa-f]{6}$')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE style (
    id_style INT AUTO_INCREMENT PRIMARY KEY,
    nom      VARCHAR(30) NOT NULL,
    CONSTRAINT uq_style_nom UNIQUE (nom)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------
-- vetement : toutes les pièces de tous les dressings
-- Un vêtement appartient à un seul utilisateur.
-- ---------------------------------------------------------------------
CREATE TABLE vetement (
    id_vetement    INT AUTO_INCREMENT PRIMARY KEY,
    id_utilisateur INT          NOT NULL,
    id_categorie   INT          NOT NULL,
    id_couleur     INT          NOT NULL,
    id_style       INT          NOT NULL,
    nom            VARCHAR(80)  NOT NULL,
    marque         VARCHAR(50)  NOT NULL,
    taille         VARCHAR(10)  NOT NULL,
    photo_url      VARCHAR(255) NOT NULL,
    date_ajout     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_vetement_utilisateur FOREIGN KEY (id_utilisateur)
        REFERENCES utilisateur(id_utilisateur),
    CONSTRAINT fk_vetement_categorie FOREIGN KEY (id_categorie)
        REFERENCES categorie(id_categorie),
    CONSTRAINT fk_vetement_couleur FOREIGN KEY (id_couleur)
        REFERENCES couleur(id_couleur),
    CONSTRAINT fk_vetement_style FOREIGN KEY (id_style)
        REFERENCES style(id_style)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------
-- annonce : une pièce mise en vente
-- - prix strictement positif
-- - au plus UNE annonce active par vêtement (index unique sur colonne
--   générée : vaut id_vetement si statut = 'active', sinon NULL ;
--   MySQL autorise plusieurs NULL dans un index UNIQUE)
-- ---------------------------------------------------------------------
CREATE TABLE annonce (
    id_annonce       INT AUTO_INCREMENT PRIMARY KEY,
    id_vetement      INT           NOT NULL,
    prix             DECIMAL(8,2)  NOT NULL,
    etat             VARCHAR(10)   NOT NULL,
    statut           VARCHAR(10)   NOT NULL DEFAULT 'active',
    date_publication DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    vetement_actif   INT GENERATED ALWAYS AS
        (CASE WHEN statut = 'active' THEN id_vetement ELSE NULL END) STORED,
    CONSTRAINT uq_annonce_une_active UNIQUE (vetement_actif),
    CONSTRAINT chk_annonce_prix   CHECK (prix > 0),
    CONSTRAINT chk_annonce_etat   CHECK (etat IN ('neuf','tres_bon','bon','correct')),
    CONSTRAINT chk_annonce_statut CHECK (statut IN ('active','vendue','retiree')),
    CONSTRAINT fk_annonce_vetement FOREIGN KEY (id_vetement)
        REFERENCES vetement(id_vetement)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------
-- tenue : une tenue proposée à un utilisateur
-- ---------------------------------------------------------------------
CREATE TABLE tenue (
    id_tenue       INT AUTO_INCREMENT PRIMARY KEY,
    id_utilisateur INT         NOT NULL,
    id_style       INT         NOT NULL,
    nom            VARCHAR(80) NOT NULL,
    occasion       VARCHAR(50) NOT NULL,
    date_creation  DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_tenue_utilisateur FOREIGN KEY (id_utilisateur)
        REFERENCES utilisateur(id_utilisateur) ON DELETE CASCADE,
    CONSTRAINT fk_tenue_style FOREIGN KEY (id_style)
        REFERENCES style(id_style)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------
-- tenue_piece : pièces d'une tenue
-- Une pièce est SOIT un vêtement du dressing (id_vetement),
--               SOIT une annonce d'un autre utilisateur (id_annonce).
-- Note MySQL : pas d'ON DELETE/UPDATE sur id_vetement / id_annonce car
-- ces colonnes sont utilisées dans un CHECK.
-- ---------------------------------------------------------------------
CREATE TABLE tenue_piece (
    id_tenue_piece INT AUTO_INCREMENT PRIMARY KEY,
    id_tenue       INT NOT NULL,
    id_vetement    INT NULL,
    id_annonce     INT NULL,
    CONSTRAINT uq_tenue_vetement UNIQUE (id_tenue, id_vetement),
    CONSTRAINT uq_tenue_annonce  UNIQUE (id_tenue, id_annonce),
    CONSTRAINT chk_piece_source CHECK (
        (id_vetement IS NOT NULL AND id_annonce IS NULL)
        OR (id_vetement IS NULL AND id_annonce IS NOT NULL)
    ),
    CONSTRAINT fk_piece_tenue FOREIGN KEY (id_tenue)
        REFERENCES tenue(id_tenue) ON DELETE CASCADE,
    CONSTRAINT fk_piece_vetement FOREIGN KEY (id_vetement)
        REFERENCES vetement(id_vetement),
    CONSTRAINT fk_piece_annonce FOREIGN KEY (id_annonce)
        REFERENCES annonce(id_annonce)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
