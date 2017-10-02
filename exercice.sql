
-- -------------------------
-- PROSTOCK-PRATIQUE PART 1
-- -------------------------

-- Exercice 1
SET @nb_lignes = 0;

DELIMITER //
CREATE FUNCTION test2 ()
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE result INTEGER;
  
  SELECT COUNT(id) INTO result 
  FROM employe;
  
  SET @nb_lignes := result;

  RETURN result;

END//

SELECT @nb_lignes


-- Exercice 2
DELIMITER //
CREATE FUNCTION moyenne (dep VARCHAR(30))
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
  DECLARE result DECIMAL(10, 2);
    
  IF (dep != "") THEN
    SELECT SUM(salaire) / COUNT(id) INTO result
    FROM employe
    WHERE nom_departement = dep;
  ELSE
    SELECT SUM(salaire) / COUNT(id) INTO result
    FROM employe;
  END IF;

  RETURN result;
END//


-- Exercice 3
DELIMITER //
CREATE PROCEDURE miracle (dep VARCHAR(30))
BEGIN
  UPDATE employe
  SET 
    salaire = salaire * 2
  WHERE nom_departement = dep AND
        salaire < moyenne("");

  SELECT * FROM employe;
END //
DELIMITER;



-- -------------------------
-- PROSTOCK-PRATIQUE PART 2
-- -------------------------

-- Exercice 4
DELIMITER //
CREATE PROCEDURE total_salaires ()
BEGIN
  DECLARE n INT DEFAULT 0;
  DECLARE i INT DEFAULT 0;

  DECLARE result INT DEFAULT 0;
  
  SELECT COUNT(*) FROM employe INTO n;
  
  SET i = 0;
  WHILE i < n DO 
    SELECT (salaire + result) INTO result
    FROM employe LIMIT i, 1;

    SET i = i + 1;
  END WHILE;
  
  SELECT result;
END //


-- Exercice 5
DELIMITER //
CREATE PROCEDURE total_salaires_2 ()
BEGIN
  DECLARE a INT DEFAULT 0;
  DECLARE total INT DEFAULT 0;
  
  DECLARE done BOOLEAN DEFAULT false;
  DECLARE salaire_cursor CURSOR FOR
    SELECT salaire 
    FROM employe;
    
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = true;
    
  OPEN salaire_cursor;
  
  REPEAT
    
    FETCH salaire_cursor INTO a;
    
    IF done = false THEN
      SET total = total + a;
    END IF;
  
  UNTIL done END REPEAT;
  
  SELECT total;
END //


-- Exercice 6
DROP PROCEDURE IF EXISTS construire_departements;
DELIMITER //
CREATE PROCEDURE construire_departements ()
BEGIN
  DECLARE a VARCHAR(30) DEFAULT 0;
  DECLARE done BOOLEAN DEFAULT false;

  DECLARE nb_dep_cursor CURSOR FOR
    SELECT nom
    FROM departement
    GROUP BY nom;
    
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = true;

  DELETE FROM departement;
  
  OPEN nb_dep_cursor;

  REPEAT
    FETCH nb_dep_cursor INTO a;
    
    IF done = false THEN
      INSERT INTO departement (
          nom,
          taille
      )
      VALUES (a, (SELECT COUNT(*) FROM employe WHERE nom_departement = a));
    END IF;
  UNTIL done END REPEAT;
  
  SELECT * FROM departement;
END //






