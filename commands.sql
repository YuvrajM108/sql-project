-- SELECT basics

-- Introducing the world table of countries
SELECT population FROM world
WHERE name = 'Germany';

-- Scandinavia
SELECT name, population FROM world
WHERE name IN ('Sweden', 'Norway', 'Denmark');

-- Just the right size
SELECT name, area FROM world
WHERE area BETWEEN 200000 AND 250000;

-- SELECT from WORLD

-- Introduction
SELECT name, continent, population FROM world;

-- Large Countries
SELECT name
FROM world
WHERE population >= 200000000;

-- Per capita GDP
SELECT name, (gdp/population) AS per_capacita_GDP
FROM world
WHERE population >= 200000000;

-- South America In millions
SELECT name, (population/1000000) AS pop_in_M
FROM world
WHERE continent = 'South America';

-- France, Germany, Italy
SELECT name, population
FROM world
WHERE name = 'France' OR name = 'Germany' OR name = 'Italy';

-- United
SELECT name
FROM world
WHERE name LIKE '%United%';

-- Two ways to be big
SELECT name, population, area
FROM world
WHERE area > 3000000 OR population > 250000000;

-- One or the other (but not both)
SELECT name, population, area
FROM world
WHERE area > 3000000 XOR population > 250000000;

-- Rounding
SELECT name, ROUND(population/1000000, 2) AS pop_in_M, ROUND(gdp/1000000000, 2) AS gdp_in_B
FROM world
WHERE continent = 'South America';

-- Trillion dollar economies
SELECT name, ROUND(gdp/population, -3) AS pc_GDP
FROM world
WHERE gdp >= 1000000000000;

-- Name and capital have the same length
SELECT name, capital
FROM world
WHERE LENGTH(name) = LENGTH(capital);

-- Matching name capital
SELECT name, capital
FROM world
WHERE LEFT(name,1) = LEFT(capital,1) AND name != capital;

-- All the vowels
SELECT name
FROM world
WHERE name LIKE '%a%'
AND name LIKE '%e%'
AND name LIKE '%i%'
AND name LIKE '%o%'
AND name LIKE '%u%'
AND name NOT LIKE '% %';

-- SELECT from Noble Tutorial

-- Winners from 1950
SELECT yr, subject, winner
FROM nobel
WHERE yr = 1950;

-- 1962 Literature
SELECT winner
FROM nobel
WHERE yr = 1962
AND subject = 'Literature';

-- Albert Einstein
SELECT yr, subject
FROM nobel
WHERE winner = 'Albert Einstein';

-- Recent Peace Prizes
SELECT winner
FROM nobel
WHERE subject = 'Peace' AND yr >= 2000;

-- Literature in 1980's
SELECT yr, subject, winner
FROM nobel
WHERE subject = 'Literature' AND yr >= 1980 AND yr <= 1989;

-- Only Presidents
SELECT * FROM nobel
 WHERE winner IN ('Theodore Roosevelt',
                  'Woodrow Wilson',
                  'Jimmy Carter',
                  'Barack Obama');

-- John
SELECT winner
FROM nobel
WHERE winner LIKE 'John %';

-- Chemistry and Physics from different years
SELECT yr, subject, winner
FROM nobel
WHERE (yr = 1980 AND subject = 'Physics') OR (yr = 1984 AND subject = 'Chemistry');

-- Exclude Chemists and Medics
SELECT yr, subject, winner
FROM nobel
WHERE yr = 1980 AND subject != 'Chemistry' AND subject != 'Medicine';

-- Early Medicine, Late Literature
SELECT yr, subject, winner
FROM nobel
WHERE (subject = 'Medicine' AND yr < 1910) OR (subject = 'Literature' AND yr >= 2004);

-- Umlaut
SELECT *
FROM nobel
WHERE winner = 'Peter Grünberg';

-- Apostrophe
SELECT *
FROM nobel
WHERE winner = 'Eugene O''Neill';

-- Knights of the realm
SELECT winner, yr, subject
FROM nobel
WHERE winner LIKE 'Sir%'
ORDER BY yr DESC, winner;

-- Chemistry and Physics last
SELECT winner, subject
FROM nobel
WHERE yr=1984
ORDER BY subject IN ('Physics','Chemistry'), subject, winner;