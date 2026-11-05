-- =====================================================================
-- Mirora - 02_insert_data.sql
-- À exécuter APRÈS 01_create_tables.sql (ordre = respect des FK)
-- =====================================================================

-- ---------------------------------------------------------------------
-- utilisateur (5)
-- ---------------------------------------------------------------------
INSERT INTO utilisateur (nom, prenom, email, mot_de_passe) VALUES
('Martin',  'Léa',     'lea.martin@mirora.fr',     '$2b$10$hashfictif_lea'),
('Benali',  'Yanis',   'yanis.benali@mirora.fr',   '$2b$10$hashfictif_yanis'),
('Dubois',  'Camille', 'camille.dubois@mirora.fr', '$2b$10$hashfictif_camille'),
('Rossi',   'Sofia',   'sofia.rossi@mirora.fr',    '$2b$10$hashfictif_sofia'),
('Lefèvre', 'Hugo',    'hugo.lefevre@mirora.fr',   '$2b$10$hashfictif_hugo');

-- ---------------------------------------------------------------------
-- profil (1 par utilisateur)
-- ---------------------------------------------------------------------
INSERT INTO profil (id_utilisateur, taille_cm, taille_haut, taille_bas, pointure) VALUES
(1, 168, 'M', '38', 38),
(2, 180, 'L', '42', 43),
(3, 165, 'S', '36', 37),
(4, 170, 'M', '38', 38),
(5, 183, 'L', '42', 44);

-- ---------------------------------------------------------------------
-- categorie (6)
-- ---------------------------------------------------------------------
INSERT INTO categorie (nom) VALUES
('Haut'),          -- 1
('Bas'),           -- 2
('Chaussures'),    -- 3
('Veste'),         -- 4
('Chaussettes'),   -- 5
('Accessoire');    -- 6

-- ---------------------------------------------------------------------
-- couleur (8)
-- ---------------------------------------------------------------------
INSERT INTO couleur (nom, code_hex) VALUES
('Noir',   '#000000'),  -- 1
('Blanc',  '#FFFFFF'),  -- 2
('Bleu',   '#1F4E9C'),  -- 3
('Rouge',  '#C0392B'),  -- 4
('Vert',   '#2E7D32'),  -- 5
('Beige',  '#D9C7A3'),  -- 6
('Gris',   '#808080'),  -- 7
('Marron', '#6D4C41');  -- 8

-- ---------------------------------------------------------------------
-- style (4)
-- ---------------------------------------------------------------------
INSERT INTO style (nom) VALUES
('Casual'),      -- 1
('Chic'),        -- 2
('Sport'),       -- 3
('Streetwear');  -- 4

-- ---------------------------------------------------------------------
-- vetement (21)
-- (id_utilisateur, id_categorie, id_couleur, id_style, nom, marque, taille, photo_url)
-- ---------------------------------------------------------------------
INSERT INTO vetement (id_utilisateur, id_categorie, id_couleur, id_style, nom, marque, taille, photo_url) VALUES
-- Léa (1)
(1, 1, 2, 1, 'T-shirt blanc basique',       'Uniqlo',    'M',     'photos/lea_tshirt_blanc.jpg'),      -- 1
(1, 2, 3, 1, 'Jean droit bleu',             'Levi''s',   '38',    'photos/lea_jean_bleu.jpg'),         -- 2
(1, 3, 2, 1, 'Baskets blanches',            'Adidas',    '38',    'photos/lea_baskets_blanches.jpg'),  -- 3
(1, 4, 1, 2, 'Blazer noir',                 'Zara',      'M',     'photos/lea_blazer_noir.jpg'),       -- 4
(1, 5, 7, 3, 'Chaussettes grises',          'Decathlon', '36-40', 'photos/lea_chaussettes_grises.jpg'),-- 5
-- Yanis (2)
(2, 1, 1, 4, 'Hoodie noir',                 'Nike',      'L',     'photos/yanis_hoodie_noir.jpg'),     -- 6
(2, 2, 7, 3, 'Jogging gris',                'Nike',      'L',     'photos/yanis_jogging_gris.jpg'),    -- 7
(2, 3, 4, 4, 'Sneakers rouges',             'Puma',      '43',    'photos/yanis_sneakers_rouges.jpg'), -- 8
(2, 4, 5, 3, 'Veste de survêtement verte',  'Adidas',    'L',     'photos/yanis_veste_verte.jpg'),     -- 9
-- Camille (3)
(3, 1, 2, 2, 'Chemise blanche',             'Zara',      'S',     'photos/camille_chemise_blanche.jpg'),-- 10
(3, 2, 6, 2, 'Pantalon tailleur beige',     'Mango',     '36',    'photos/camille_pantalon_beige.jpg'),-- 11
(3, 3, 1, 2, 'Escarpins noirs',             'Mango',     '37',    'photos/camille_escarpins_noirs.jpg'),-- 12
(3, 4, 6, 2, 'Trench beige',                'Sandro',    'S',     'photos/camille_trench_beige.jpg'),  -- 13
-- Sofia (4)
(4, 1, 8, 1, 'Pull marron',                 'H&M',       'M',     'photos/sofia_pull_marron.jpg'),     -- 14
(4, 2, 1, 1, 'Jean noir',                   'Levi''s',   '38',    'photos/sofia_jean_noir.jpg'),       -- 15
(4, 3, 8, 1, 'Bottines marron',             'Zara',      '38',    'photos/sofia_bottines_marron.jpg'), -- 16
(4, 6, 4, 1, 'Écharpe rouge',               'Pimkie',    'Unique','photos/sofia_echarpe_rouge.jpg'),   -- 17
-- Hugo (5)
(5, 1, 1, 4, 'T-shirt noir',                'Carhartt',  'L',     'photos/hugo_tshirt_noir.jpg'),      -- 18
(5, 2, 5, 4, 'Pantalon cargo vert',         'Dickies',   'L',     'photos/hugo_cargo_vert.jpg'),       -- 19
(5, 4, 3, 1, 'Veste en jean bleue',         'Levi''s',   'L',     'photos/hugo_veste_jean.jpg'),       -- 20
(5, 6, 8, 2, 'Ceinture marron',             'Zara',      'Unique','photos/hugo_ceinture_marron.jpg');  -- 21

-- ---------------------------------------------------------------------
-- annonce (7) : 5 actives, 1 retirée, 1 vendue
-- (id_vetement, prix, etat, statut)
-- ---------------------------------------------------------------------
INSERT INTO annonce (id_vetement, prix, etat, statut) VALUES
(8,  45.00, 'tres_bon', 'active'),   -- 1 : sneakers rouges de Yanis
(4,  35.00, 'bon',      'active'),   -- 2 : blazer noir de Léa
(13, 80.00, 'tres_bon', 'active'),   -- 3 : trench beige de Camille
(15, 22.00, 'bon',      'active'),   -- 4 : jean noir de Sofia
(19, 35.00, 'bon',      'active'),   -- 5 : cargo vert de Hugo
(7,  20.00, 'bon',      'retiree'),  -- 6 : jogging gris de Yanis
(5,   8.00, 'neuf',     'vendue');   -- 7 : chaussettes grises de Léa

-- ---------------------------------------------------------------------
-- tenue (6)
-- (id_utilisateur, id_style, nom, occasion)
-- ---------------------------------------------------------------------
INSERT INTO tenue (id_utilisateur, id_style, nom, occasion) VALUES
(1, 1, 'Casual du samedi',       'Sortie en ville'),    -- 1 (Léa)
(1, 2, 'Look bureau',            'Travail'),            -- 2 (Léa)
(2, 4, 'Streetwear du week-end', 'Sortie entre amis'),  -- 3 (Yanis)
(3, 2, 'Chic parisien',          'Dîner'),              -- 4 (Camille)
(4, 1, 'Automne cosy',           'Balade'),             -- 5 (Sofia)
(5, 1, 'Casual jean',            'Sortie en ville');    -- 6 (Hugo)

-- ---------------------------------------------------------------------
-- tenue_piece
-- (id_tenue, id_vetement, id_annonce) : un seul des deux est renseigné
-- ---------------------------------------------------------------------
INSERT INTO tenue_piece (id_tenue, id_vetement, id_annonce) VALUES
-- Tenue 1 (Léa) : 2 pièces possédées + 1 à acheter (sneakers de Yanis)
(1, 1,    NULL),
(1, 2,    NULL),
(1, NULL, 1),
-- Tenue 2 (Léa) : 3 pièces possédées, rien à acheter
(2, 1,    NULL),
(2, 2,    NULL),
(2, 3,    NULL),
-- Tenue 3 (Yanis) : 2 pièces possédées + 1 à acheter (cargo de Hugo)
(3, 6,    NULL),
(3, 9,    NULL),
(3, NULL, 5),
-- Tenue 4 (Camille) : 3 pièces possédées + 1 à acheter (blazer de Léa)
(4, 10,   NULL),
(4, 11,   NULL),
(4, 12,   NULL),
(4, NULL, 2),
-- Tenue 5 (Sofia) : 3 pièces possédées + 1 à acheter (trench de Camille)
(5, 14,   NULL),
(5, 16,   NULL),
(5, 17,   NULL),
(5, NULL, 3),
-- Tenue 6 (Hugo) : 3 pièces possédées + 1 à acheter (jean noir de Sofia)
(6, 18,   NULL),
(6, 20,   NULL),
(6, 21,   NULL),
(6, NULL, 4);

-- ---------------------------------------------------------------------
-- Vérification rapide : nombre de lignes par table
-- ---------------------------------------------------------------------
SELECT 'utilisateur' AS table_name, COUNT(*) AS nb FROM utilisateur
UNION ALL SELECT 'profil',      COUNT(*) FROM profil
UNION ALL SELECT 'categorie',   COUNT(*) FROM categorie
UNION ALL SELECT 'couleur',     COUNT(*) FROM couleur
UNION ALL SELECT 'style',       COUNT(*) FROM style
UNION ALL SELECT 'vetement',    COUNT(*) FROM vetement
UNION ALL SELECT 'annonce',     COUNT(*) FROM annonce
UNION ALL SELECT 'tenue',       COUNT(*) FROM tenue
UNION ALL SELECT 'tenue_piece', COUNT(*) FROM tenue_piece;
