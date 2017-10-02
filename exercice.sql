
-- -------------------------
-- PROSTOCK-PRATIQUE PART 1
-- -------------------------

-- Exercice 1
SET @nb_lignes = 0;

DROP FUNCTION IF EXISTS test2;
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
DROP FUNCTION IF EXISTS moyenne
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
DROP PROCEDURE IF EXISTS miracle;
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



-- -------------------------
-- PROSTOCK-PRATIQUE PART 2
-- -------------------------

-- Exercice 4
DROP PROCEDURE IF EXISTS total_salaires;
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
  
  SELECT CONCAT('Total : ', result, ' de ', n, ' salaires');
END //


-- Exercice 5
DROP PROCEDURE IF EXISTS total_salaires_2;
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

DROP PROCEDURE IF EXISTS insert_empl;
DELIMITER //
CREATE PROCEDURE insert_empl(nb_empl INT)
BEGIN
  DECLARE id INT DEFAULT 0;
  WHILE id < nb_empl DO
	
	INSERT INTO employe (no ,nom ,salaire, nom_departement) VALUES (2, ' ' , 1.0, 'departement_1');
    set id = id +1;
  END WHILE;
    
END //

-- Exercice 6







-- Exercice 7
DELIMITER //
DROP PROCEDURE IF EXISTS update_salaires //
CREATE PROCEDURE update_salaires ()
BEGIN
  DECLARE n INT DEFAULT 0;
  DECLARE i INT DEFAULT 0;
  DECLARE emp_id INT DEFAULT 0;
  
  SELECT COUNT(*) FROM employe INTO n;
  
  SET i = 0;
  WHILE i < n DO 
  
	-- Select id from ith row
	SELECT id INTO emp_id
    FROM employe LIMIT i, 1;
	
    -- Update corresponding line
    UPDATE employe
    SET salaire = salaire * 1.05
	WHERE id = emp_id;

    SET i = i + 1;
  END WHILE;
END //