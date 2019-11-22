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

-- Generic Apartments
INSERT INTO `apartments_available` VALUES
	(NULL, 'LowEndApartment', 'Basic Apartment', 0, '254.79,-1013.30,29.27', '266.09,-1006.75,-100.74,354.79', NULL, NULL, NULL, NULL, 500, 400000, 50),
	(NULL, 'IntegrityWay', '4 Integrity Way', 0, '-47.64,-586.54,37.95,73.26', NULL, NULL, NULL, NULL, NULL, 0, 0, 0),
	(NULL, 'IntegrityWay', 'Apt. 28', 0, NULL, '-31.25,-595.24,80.03,242.75', NULL, NULL, NULL, NULL, 1500, 800000, 50),
	(NULL, 'IntegrityWay', 'Apt. 30', 0, NULL, '-18.51,-591.30,90.11,340.48', NULL, NULL, NULL, NULL, 1500, 800000, 50),
	(NULL, 'DellPerroHeights', 'Dell Perro Heights', 0, '-1447.85,-538.28,34.74,206.68', NULL, NULL, NULL, NULL, NULL, 0, 0, 0),
	(NULL, 'DellPerroHeights', 'Apt. 4', 0, NULL, '-1452.79,-539.82,74.04,30.58', NULL, NULL, NULL, NULL, 1500, 800000, 50),
	(NULL, 'DellPerroHeights', 'Apt. 7', 0, NULL, '-1450.07,-525.63,56.93,32.97', NULL, NULL, NULL, NULL, 1500, 800000, 50),
;
