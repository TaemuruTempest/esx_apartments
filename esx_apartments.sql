USE `essentialmode`;

CREATE TABLE `apartments_available` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(100) NOT NULL,
	`label` VARCHAR(255) NOT NULL,
	`kind` INT(1) DEFAULT 0,
	`enter_marker` VARCHAR(255) DEFAULT NULL,
	`exit_marker` VARCHAR(255) DEFAULT NULL,
	`tp_inside` VARCHAR(255) DEFAULT NULL,
	`tp_outside` VARCHAR(255) DEFAULT NULL,
	`garage_get` VARCHAR(255) DEFAULT NULL,
	`garage_put` VARCHAR(255) DEFAULT NULL,
	`ipl` VARCHAR(100) DEFAULT NULL,
	`room_menu` VARCHAR(255) DEFAULT NULL,
	`price_rent` INT(11) DEFAULT 0,
	`price_buy` INT(11) DEFAULT 0,
	PRIMARY KEY (`id`)
);

INSERT INTO `apartments_available` VALUES
	(1, 'LowEndApartment', 'Basic Apartment', 0, '254.79,-1013.30,29.27', '266.09,-1006.75,-100.74', '265.91,-1005.05,-99.56', '254.79,-1013.30,29.27', NULL, NULL, NULL, NULL, 500, 400000)
;
