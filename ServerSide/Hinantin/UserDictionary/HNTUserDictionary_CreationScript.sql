-- DROP DATABASE IF EXISTS `HNTUserDictionary`;
-- CREATE DATABASE `HNTUserDictionary` CHARACTER SET UTF8 COLLATE utf8_spanish_ci;
USE `HNTUserDictionary`;

DROP TABLE IF EXISTS `TUserDictionary`;
CREATE TABLE `TUserDictionary` (
	`cpUserDictionaryId` INT(11) NOT NULL AUTO_INCREMENT,
	`cpSLang` VARCHAR(30) COLLATE 'utf8_spanish_ci' DEFAULT NULL,
	`cpEntry` VARCHAR(1000) COLLATE 'utf8_spanish_ci' DEFAULT NULL,
	`cpDate` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`cpUser` VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8_spanish_ci',
	PRIMARY KEY (`cpUserDictionaryId`)
)
COLLATE='utf8_spanish_ci'
ENGINE=InnoDB
AUTO_INCREMENT=0
COMMENT='User dictionary.';

DROP TABLE IF EXISTS `TCorrectEntry`;
CREATE TABLE `TCorrectEntry`
(
	`cpCorrectEntryId` INT(11) NOT NULL AUTO_INCREMENT,
	`cpCorrectEntry` VARCHAR(1000),
	`cpIncorrectEntryId` INT(11),
	`cpIncomingWord` VARCHAR(1000),
	`cpFrecuency` INT(11) NOT NULL DEFAULT '0',
	`cpSLang` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_spanish_ci',
	`cpDate` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`cpUser` VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8_spanish_ci',
	PRIMARY KEY (`cpCorrectEntryId`)
)
COLLATE='utf8_spanish_ci'
ENGINE=InnoDB
AUTO_INCREMENT=0
COMMENT='Correct entries.';

DROP TABLE IF EXISTS `TIncorrectEntry`;
CREATE TABLE `TIncorrectEntry` (
	`cpIncorrectEntryId` INT(11) NOT NULL AUTO_INCREMENT,
	`cpEntry` VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8_spanish_ci',
	`cpIsCorrect` TINYINT(1) NOT NULL DEFAULT '0',
	`cpFrecuency` INT(11) NOT NULL DEFAULT '0',
	`cpSLang` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_spanish_ci',
	`cpDate` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`cpUser` VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8_spanish_ci',
	PRIMARY KEY (`cpIncorrectEntryId`)
)
COLLATE='utf8_spanish_ci'
ENGINE=InnoDB
AUTO_INCREMENT=0
COMMENT='Incorrect entries.';

ALTER TABLE `TCorrectEntry` 
ADD CONSTRAINT `FK_cpIncorrectEntryId`
FOREIGN KEY (`cpIncorrectEntryId`) REFERENCES `TIncorrectEntry`(`cpIncorrectEntryId`)
ON UPDATE CASCADE
ON DELETE CASCADE;
