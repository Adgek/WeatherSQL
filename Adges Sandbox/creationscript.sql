DROP DATABASE `WeatherDB`;
/* Create or use database*/
CREATE DATABASE `WeatherDB`;

USE `WeatherDB`;


CREATE TABLE `Agent` (
  `aid` char(3) NOT NULL,
  `aname` varchar(15),
  `city` varchar(20),
  `percent` int,
  PRIMARY KEY (`aid`)
  );

/* Seed the Agent Table */
LOCK TABLES `Agent` WRITE;

insert into `Agent`(`aid`,`aname`,`city`,`percent`) 
	values ('a01','Smith','Hamilton','6'),
	('a02','Jones','Barrie','6'),
	('a03','Brown','Windsor','7'),
	('a04','Gray','Hamilton','6'),
	('a05','Otasi','Ottawa','5'),
	('a06','Smith','Toronto','5'),
	('a07','Chan','Kingston','5'),
	('a08','Oliver','Ottawa','6');

UNLOCK TABLES;