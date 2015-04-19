USE `HNTUserDictionary`;

DELIMITER //
DROP PROCEDURE IF EXISTS `SaveIncorrectEntry`;
CREATE PROCEDURE `SaveIncorrectEntry`
(
	IN IN_cpIncorrectEntryId INT, 
	IN IN_cpEntry VARCHAR(1000), 
	IN IN_cpIsCorrect VARCHAR(100), 
	IN IN_cpFrecuency INT, 
	IN IN_cpSLang VARCHAR(30), 
	IN IN_cpDate TIMESTAMP, 
	IN IN_cpUser VARCHAR(200) 
)
BEGIN 
    DECLARE TMP_cpFrecuency INT DEFAULT 0;
    IF NOT EXISTS(SELECT * FROM `TIncorrectEntry` WHERE `cpEntry` = IN_cpEntry AND `cpSLang` = IN_cpSLang) THEN 
    BEGIN
	INSERT INTO `TIncorrectEntry` (`cpEntry`, `cpIsCorrect`, `cpFrecuency`, `cpSLang`, `cpDate`, `cpUser`) 
		VALUES (IN_cpEntry, IN_cpIsCorrect, 1, IN_cpSLang, CURRENT_TIMESTAMP, IN_cpUser);
	-- Returning the primary key of the last inserted record.
	SELECT AUTO_INCREMENT FROM information_schema.tables WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'TIncorrectEntry';
    END;
    ELSE
	SELECT `cpFrecuency` INTO TMP_cpFrecuency FROM `TIncorrectEntry` WHERE `cpEntry` = IN_cpEntry AND `cpSLang` = IN_cpSLang;
	SET TMP_cpFrecuency := TMP_cpFrecuency + 1; 
	UPDATE `TIncorrectEntry` SET `cpFrecuency` = TMP_cpFrecuency, `cpDate` = CURRENT_TIMESTAMP WHERE `cpEntry` = IN_cpEntry AND `cpSLang` = IN_cpSLang;
    END IF;
END //

DELIMITER ;

