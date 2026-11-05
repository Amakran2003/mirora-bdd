-- =====================================================================
-- Mirora - 01b_triggers_optionnel.sql
-- OPTIONNEL : règle métier "pièce de tenue" que CHECK/FK ne peuvent pas porter.
-- À exécuter après 01_create_tables.sql (avant ou après 02_insert_data.sql).
-- Dans DbVisualizer : Execute as script (Alt+X). Si DELIMITER est refusé,
-- remplacer "DELIMITER //" par "@delimiter //" et "DELIMITER ;" par "@delimiter ;".
--
-- Règle : une pièce de tenue est
--   - soit un vêtement du dressing du PROPRIÉTAIRE de la tenue,
--   - soit une annonce ACTIVE d'un AUTRE utilisateur.
-- =====================================================================

DROP TRIGGER IF EXISTS trg_tenue_piece_regles;

DELIMITER //
CREATE TRIGGER trg_tenue_piece_regles
BEFORE INSERT ON tenue_piece
FOR EACH ROW
BEGIN
    DECLARE v_proprio_tenue INT;
    DECLARE v_proprio_piece INT;
    DECLARE v_statut        VARCHAR(10);

    SELECT id_utilisateur INTO v_proprio_tenue
    FROM tenue WHERE id_tenue = NEW.id_tenue;

    IF NEW.id_vetement IS NOT NULL THEN
        SELECT id_utilisateur INTO v_proprio_piece
        FROM vetement WHERE id_vetement = NEW.id_vetement;

        IF v_proprio_piece <> v_proprio_tenue THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Ce vêtement n''appartient pas au propriétaire de la tenue';
        END IF;

    ELSEIF NEW.id_annonce IS NOT NULL THEN
        SELECT v.id_utilisateur, a.statut INTO v_proprio_piece, v_statut
        FROM annonce a
        JOIN vetement v ON v.id_vetement = a.id_vetement
        WHERE a.id_annonce = NEW.id_annonce;

        IF v_statut <> 'active' THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'L''annonce n''est pas active';
        END IF;

        IF v_proprio_piece = v_proprio_tenue THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Une annonce de son propre dressing ne peut pas être "à acheter"';
        END IF;
    END IF;
END//
DELIMITER ;
