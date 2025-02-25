/* Water Contimation Project */

CREATE TABLE `ZIPCODES` (
  `zipcode` Char(5),
  `zipcode_type` Varchar(8),
  `city` Varchar(100),
  `state` Varchar(2),
  `estimated_population` Integer,
  `total_wages` Integer,
  PRIMARY KEY (`zipcode`)
);

CREATE TABLE `VIOLATIONS` (
  `violation_id` Varchar(7),
  `supplier_id` Varchar(7),
  `supplier_name` Varchar(999),
  `contaminant` Varchar(75),
  `average_measurement` Decimal(8,2),
  `max_measurement` Decimal(8,2),
  `measurement_unit` Varchar(7),
  `health_limit_exceeded` Char(1),
  `legal_limit_exceeded` Char(1),
  `zipcode` Char(5),
  PRIMARY KEY (`contaminant_id`),
  FOREIGN KEY (`zipcode`) REFERENCES `ZIPCODES`(`zipcode`)
);

commit;

describe VIOLATIONS;
describe ZIPCODES;



/* Find all distinct suppliers in any violation that exceeded the health limit, and show whether the legal limit was also exceeded */

SELECT DISTINCT supplier_name, health_limit_exceeded, legal_limit_exceeded
FROM VIOLATIONS
WHERE health_limit_exceeded = 'Y';



/* Find all distinct suppliers in any violation that exceeded the health limit AND the legal limit */

SELECT DISTINCT supplier_name, health_limit_exceeded, legal_limit_exceeded
FROM VIOLATIONS
WHERE health_limit_exceeded = 'Y' AND legal_limit_exceeded = 'Y';



/* Show all zipcodes and city names in Massachusetts with a population of more than 2000, also show the city population */

SELECT zipcode, city, estimated_population, total_wages
FROM ZIPCODES
WHERE state = 'MA' AND estimated_population > 2000;



/* Show all contaminants found in MA (Massachusetts) */

SELECT distinct VIOLATIONS.contaminant
FROM VIOLATIONS 
JOIN ZIPCODES ON VIOLATIONS.zipcode = ZIPCODES.zipcode
WHERE ZIPCODES.state = 'MA';



/* Show the city name and the zipcodes of the cities where the health limit is exceeded */

SELECT distinct ZIPCODES.city, ZIPCODES.state
FROM VIOLATIONS 
JOIN ZIPCODES ON VIOLATIONS.zipcode = ZIPCODES.zipcode
WHERE VIOLATIONS.health_limit_exceeded = 'Y';



/* Average wages of cities where the legal limit is exceeded */

SELECT AVG(ZIPCODES.total_wages) AS avg_wages
FROM VIOLATIONS
JOIN ZIPCODES ON VIOLATIONS.zipcode = ZIPCODES.zipcode
WHERE VIOLATIONS.legal_limit_exceeded = 'Y';