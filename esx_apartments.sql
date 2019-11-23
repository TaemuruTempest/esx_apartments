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
	(NULL, 'LowEndApartment', 'Basic Apartment', 0, '254.79,-1013.30,28.37', '266.09,-1006.75,-101.64,354.79', NULL, NULL, NULL, NULL, 500, 400000, 50),
	(NULL, 'IntegrityWay', '4 Integrity Way', 0, '-47.64,-586.54,37.05,73.26', NULL, '-7.18,-574.56,36.85,332.53', '-16.36,-570.41,36.85,351.60', NULL, NULL, 0, 0, 0),
	(NULL, 'IntegrityWay', 'Apt. 28', 0, NULL, '-31.25,-595.24,79.13,242.75', NULL, NULL, NULL, NULL, 1500, 800000, 50),
	(NULL, 'IntegrityWay', 'Apt. 30', 0, NULL, '-18.51,-591.30,89.21,340.48', NULL, NULL, NULL, NULL, 1500, 800000, 50),
	(NULL, 'DellPerroHeights', 'Dell Perro Heights', 0, '-1447.85,-538.28,33.84,206.68', '-1469.11,-582.01,30.24,211.98', '-1465.03,-578.90,30.25', NULL, NULL, NULL, 0, 0, 0),
	(NULL, 'DellPerroHeights', 'Apt. 4', 0, NULL, '-1452.79,-539.82,73.14,30.58', NULL, NULL, NULL, NULL, 1500, 800000, 50),
	(NULL, 'DellPerroHeights', 'Apt. 7', 0, NULL, '-1450.07,-525.63,56.03,32.97', NULL, NULL, NULL, NULL, 1500, 800000, 50),
	(NULL, 'RichardMajestic', 'Richard Majestic, Apt 2', 0, '-937.06,-379.45,38.06,106.63', '-913.24,-365.58,113.37,114.09', '-888.86,-337.20,33.63,203.48', '-894.86,-340.55,33.63', NULL, NULL, 2000, 1000000, 50),
	(NULL, 'Tinsle Towers', 'Tinsle Towers, Apt 42', 0, '-614.54,45.53,42.69,179.3', '-603.76,58.89,97.3,86.34', '-619.29,60.74,42.84,97.25', '-619.60,52.14,42.84', NULL, NULL, 2000, 1000000, 50),
	(NULL, 'EclipseTowers', 'EclipseTowers, Apt 3', 0, '-777.00,318.5,84.76,175.99', '-784.56,323.8,211.1,265.24', '-800.42,333.24,84.8,176.06', '-791.81,331.53,84.8', NULL, NULL, 2500, 1200000, 50),
;

-- Houses
INSERT INTO `apartments_available` VALUES
	(NULL, '3655 Wild Oats Drive', '3655 Wild Oats Drive', 1, '-175.71,502.49,136.52,73.94', '-174.15,497.03,136.77,188.06', '-187.44,502.04,133.71,3.92', '-190.70,501.36,133.41', NULL, NULL, 3000, 1500000, 50),
	(NULL, '2044 North Conker Avenue', '2044 North Conker Avenue', 1, '346.97,441.08,146.80,293.58', '341.40,437.45,148.49,114.50', '357.39,439.25,144.58,301.02', '353.11,437.74,145.92', NULL, NULL, 3000, 1500000, 50),
	(NULL, '2045 North Conker Avenue', '2045 North Conker Avenue', 1, '373.01,428.08,144.78,72.91', '373.60,422.88,145.01,164.92', '394.45,430.93,142.34,353.77', '388.50,430.63,142.82', NULL, NULL, 3000, 1500000, 50),
	(NULL, '2862 Hillcrest Avenue', '2862 Hillcrest Avenue', 1, '-686.66,596.68,142.74,41.40', '-681.84,591.85,144.49,224.93', '-683.54,605.28,142.92,49.73', '-684.91,602.13,142.61', NULL, NULL, 3000, 1500000, 50),
	(NULL, '2868 Hillcrest Avenue', '2868 Hillcrest Avenue', 1, '-752.06,620.68,141.31,293.15', '-759.22,618.57,143.25,113.06', '-752.09,625.96,141.54,283.48', '-753.67,629.72,141.66', NULL, NULL, 3000, 1500000, 50),
	(NULL, '2874 Hillcrest Avenue', '2874 Hillcrest Avenue', 1, '-853.34,696.30,147.88,14.22', '-859.95,690.74,151.96,186.81', '-863.18,699.14,148.15,334.60', '-872.14,700.95,148.62', NULL, NULL, 3000, 1500000, 50),
	(NULL, '2677 Whispymound Drive', '2677 Whispymound Drive', 1, '119.30,564.55,183.06,6.17', '117.17,559.40,183.40,185.31', '131.30,568.90,182.43,351.48', '130.62,579.04,182.52', NULL, NULL, 3000, 1500000, 50),
	(NULL, '2133 Mad Wayne Thunder', '2133 Mad Wayne Thunder', 1, '-1294.49,455.13,96.52,11.75', '-1289.76,449.02,97.00,186.63', '-1298.02,456.73,96.51,343.88', '-1302.28,458.44,96.98', NULL, NULL, 3000, 1500000, 50),
;

-- Motels
INSERT INTO `apartments_available` VALUES
	(NULL, 'PinkCageMotel', 'PinkCage Motel', 2, '312.94,-218.45,54.22,340.15', NULL, NULL, NULL, NULL, NULL, 50, 0, 0),
	(NULL, 'PinkCageMotel', 'Room 1', 2, NULL, '151.44,-1007.49,-99.00,1.96', NULL, NULL, NULL, NULL, 50, 0, 0),
	(NULL, 'PinkCageMotel', 'Room 2', 2, NULL, '151.44,-1007.49,-99.00,1.96', NULL, NULL, NULL, NULL, 50, 0, 0),
	(NULL, 'PinkCageMotel', 'Room 3', 2, NULL, '151.44,-1007.49,-99.00,1.96', NULL, NULL, NULL, NULL, 50, 0, 0),
	(NULL, 'PinkCageMotel', 'Room 4', 2, NULL, '151.44,-1007.49,-99.00,1.96', NULL, NULL, NULL, NULL, 50, 0, 0),
	(NULL, 'PinkCageMotel', 'Room 5', 2, NULL, '151.44,-1007.49,-99.00,1.96', NULL, NULL, NULL, NULL, 50, 0, 0),
	(NULL, 'PinkCageMotel', 'Room 6', 2, NULL, '151.44,-1007.49,-99.00,1.96', NULL, NULL, NULL, NULL, 50, 0, 0),
	(NULL, 'PinkCageMotel', 'Room 7', 2, NULL, '151.44,-1007.49,-99.00,1.96', NULL, NULL, NULL, NULL, 50, 0, 0),
	(NULL, 'PinkCageMotel', 'Room 8', 2, NULL, '151.44,-1007.49,-99.00,1.96', NULL, NULL, NULL, NULL, 50, 0, 0),
	(NULL, 'PinkCageMotel', 'Room 9', 2, NULL, '151.44,-1007.49,-99.00,1.96', NULL, NULL, NULL, NULL, 50, 0, 0),
	(NULL, 'PinkCageMotel', 'Room 10', 2, NULL, '151.44,-1007.49,-99.00,1.96', NULL, NULL, NULL, NULL, 50, 0, 0),
	(NULL, 'BayviewLodge', 'Bayview Lodge', 2, '-683.05,5771.12,17.51,67.55', NULL, NULL, NULL, NULL, NULL, 30, 0, 0),
	(NULL, 'BayviewLodge', 'Room 1', 2, NULL, '151.44,-1007.49,-99.00,1.96', NULL, NULL, NULL, NULL, 30, 0, 0),
	(NULL, 'BayviewLodge', 'Room 2', 2, NULL, '151.44,-1007.49,-99.00,1.96', NULL, NULL, NULL, NULL, 30, 0, 0),
	(NULL, 'BayviewLodge', 'Room 3', 2, NULL, '151.44,-1007.49,-99.00,1.96', NULL, NULL, NULL, NULL, 30, 0, 0),
	(NULL, 'BayviewLodge', 'Room 4', 2, NULL, '151.44,-1007.49,-99.00,1.96', NULL, NULL, NULL, NULL, 30, 0, 0),
	(NULL, 'BayviewLodge', 'Room 5', 2, NULL, '151.44,-1007.49,-99.00,1.96', NULL, NULL, NULL, NULL, 30, 0, 0),
	(NULL, 'BayviewLodge', 'Room 6', 2, NULL, '151.44,-1007.49,-99.00,1.96', NULL, NULL, NULL, NULL, 30, 0, 0),
	(NULL, 'BayviewLodge', 'Room 7', 2, NULL, '151.44,-1007.49,-99.00,1.96', NULL, NULL, NULL, NULL, 30, 0, 0),
	(NULL, 'BayviewLodge', 'Room 8', 2, NULL, '151.44,-1007.49,-99.00,1.96', NULL, NULL, NULL, NULL, 30, 0, 0),
	(NULL, 'BayviewLodge', 'Room 9', 2, NULL, '151.44,-1007.49,-99.00,1.96', NULL, NULL, NULL, NULL, 30, 0, 0),
	(NULL, 'BayviewLodge', 'Room 10', 2, NULL, '151.44,-1007.49,-99.00,1.96', NULL, NULL, NULL, NULL, 30, 0, 0)
;

