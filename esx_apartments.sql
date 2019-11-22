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
	(NULL, 'RichardMajestic', 'Richard Majestic, Apt 2', 0, '-937.06,-379.45,38.96,106.63', '-913.24,-365.58,114.27,114.09', NULL, NULL, NULL, NULL, 2000, 1000000, 50),
	(NULL, 'Tinsle Towers', 'Tinsle Towers, Apt 42', 0, '-614.54,45.53,43.59,179.3', '-603.76,58.89,98.2,86.34', NULL, NULL, NULL, NULL, 2000, 1000000, 50),
	(NULL, 'EclipseTowers', 'EclipseTowers, Apt 3', 0, '-777.00,318.5,85.66,175.99', '-784.56,323.8,212.0,265.24', NULL, NULL, NULL, NULL, 2500, 1200000, 50),
;

-- Houses
INSERT INTO `apartments_available` VALUES
	(NULL, '3655 Wild Oats Drive', '3655 Wild Oats Drive', 1, '-175.71,502.49,137.42,73.94', '-174.15,497.03,137.67,188.06', NULL, NULL, NULL, NULL, 3000, 1500000, 50),
	(NULL, '2044 North Conker Avenue', '2044 North Conker Avenue', 1, '346.97,441.08,147.70,293.58', '341.40,437.45,149.39,114.50', NULL, NULL, NULL, NULL, 3000, 1500000, 50),
	(NULL, '2045 North Conker Avenue', '2045 North Conker Avenue', 1, '373.01,428.08,145.68,72.91', '373.60,422.88,145.91,164.92', NULL, NULL, NULL, NULL, 3000, 1500000, 50),
	(NULL, '2862 Hillcrest Avenue', '2862 Hillcrest Avenue', 1, '-686.66,596.68,143.64,41.40', '-681.84,591.85,145.39,224.93', NULL, NULL, NULL, NULL, 3000, 1500000, 50),
	(NULL, '2868 Hillcrest Avenue', '2868 Hillcrest Avenue', 1, '-752.06,620.68,142.21,293.15', '-759.22,618.57,144.15,113.06', NULL, NULL, NULL, NULL, 3000, 1500000, 50),
	(NULL, '2874 Hillcrest Avenue', '2874 Hillcrest Avenue', 1, '-853.34,696.30,148.78,14.22', '-859.95,690.74,152.86,186.81', NULL, NULL, NULL, NULL, 3000, 1500000, 50),
	(NULL, '2677 Whispymound Drive', '2677 Whispymound Drive', 1, '119.30,564.55,183.96,6.17', '117.17,559.40,184.3,185.31', NULL, NULL, NULL, NULL, 3000, 1500000, 50),
	(NULL, '2133 Mad Wayne Thunder', '2133 Mad Wayne Thunder', 1, '-1294.49,455.13,97.42,11.75', '-1289.76,449.02,97.9,186.63', NULL, NULL, NULL, NULL, 3000, 1500000, 50),
;
