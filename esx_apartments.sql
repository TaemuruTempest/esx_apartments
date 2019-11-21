USE `essentialmode`;

CREATE TABLE `apartments_available` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(100) NOT NULL,
	`label` VARCHAR(255) NOT NULL,
	`kind` INT(1) DEFAULT 0,
	`enter_marker` VARCHAR(255) DEFAULT NULL,
	`exit_marker` VARCHAR(255) DEFAULT NULL,
	`garage_get` VARCHAR(255) DEFAULT NULL,
	`garage_put` VARCHAR(255) DEFAULT NULL,
	`ipl` VARCHAR(100) DEFAULT NULL,
	`room_menu` VARCHAR(255) DEFAULT NULL,
	`price_rent` INT(11) DEFAULT 0,
	`price_buy` INT(11) DEFAULT 0,
	`sell_back` INT(11) DEFAULT 50,
	PRIMARY KEY (`id`)
);

CREATE TABLE `apartments_owned` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `apartment_id` INT(11) NOT NULL,
  `owner` VARCHAR(50) NOT NULL,
  `price` INT(11) NOT NULL,
  `rented` TINYINT(1) NOT NULL,
  PRIMARY KEY (`id`)
);

ALTER TABLE `users`
  ADD COLUMN `apartment_id` INT(11) NULL
;

INSERT INTO `apartments_available` VALUES
	(1, 'LowEndApartment', 'Basic Apartment', 0, '254.79,-1013.30,29.27', '266.09,-1006.75,-100.74,354.79', NULL, NULL, NULL, NULL, 500, 400000, 50)
;
