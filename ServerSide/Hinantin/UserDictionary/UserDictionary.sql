USE `HNTUserDictionary`;

DELIMITER //
DROP PROCEDURE IF EXISTS `SaveUserDictionaryEntry`;
CREATE PROCEDURE `SaveUserDictionaryEntry`
(
	IN IN_cpUserDictionaryId INT(11), 
	IN IN_cpSLang VARCHAR(30), 
	IN IN_cpEntry VARCHAR(1000), 
	IN IN_cpDate TIMESTAMP, 
	IN IN_cpUser VARCHAR(50) 
)
BEGIN 
    DECLARE TMP_cpFrecuency INT DEFAULT 0;
    IF NOT EXISTS(SELECT * FROM `TUserDictionary` WHERE `cpEntry` = IN_cpEntry AND `cpSLang` = IN_cpSLang) THEN 
    BEGIN
	INSERT INTO `TUserDictionary` (`cpSLang`, `cpEntry`, `cpDate`, `cpUser`) 
		VALUES (IN_cpSLang, IN_cpEntry, CURRENT_TIMESTAMP, IN_cpUser);
	-- Returning the primary key of the last inserted record.
	SELECT AUTO_INCREMENT FROM information_schema.tables WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'TUserDictionary';
    END;
    ELSE
	SELECT `cpUserDictionaryId` FROM `TUserDictionary` WHERE `cpEntry` = IN_cpEntry AND `cpSLang` = IN_cpSLang;
    END IF;
END //

DELIMITER ;

DELIMITER //
DROP PROCEDURE IF EXISTS `DeleteUserDictionaryEntry`;
CREATE PROCEDURE `DeleteUserDictionaryEntry`
(
	IN IN_cpSLang VARCHAR(30), 
	IN IN_cpEntry VARCHAR(1000) 
)
BEGIN
    DELETE FROM `TUserDictionary` WHERE `cpSLang` = IN_cpSLang AND `cpEntry` = IN_cpEntry;
END //

DELIMITER ;

DROP FUNCTION IF EXISTS `DoesUserDictionaryContainEntry`;
DELIMITER //
CREATE FUNCTION `DoesUserDictionaryContainEntry`(IN_cpEntry VARCHAR(1000)) RETURNS TINYINT(1)
BEGIN
  DECLARE ENTRY_EXIST TINYINT(1) DEFAULT 0;

  IF NOT EXISTS(SELECT * FROM `TUserDictionary` WHERE `cpEntry` = IN_cpEntry) THEN 
  BEGIN
    SET ENTRY_EXIST := 1;
  END;
  ELSE
    SET ENTRY_EXIST := 0;
  END IF;

  RETURN ENTRY_EXIST;
END //
DELIMITER ;
