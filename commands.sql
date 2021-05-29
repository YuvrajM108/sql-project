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

-- SELECT within SELECT

-- Bigger than Russia
SELECT name FROM world
  WHERE population >
     (SELECT population FROM world
      WHERE name='Russia');

-- Richer than UK
SELECT name
FROM world
WHERE (gdp/population) > 
    (SELECT (gdp/population) FROM world 
    WHERE name = 'United Kingdom') AND continent = 'Europe';

-- Neighbours of Argentina or Australia
SELECT name, continent
FROM world
WHERE continent = (SELECT continent FROM world WHERE name = 'Argentina') 
OR continent = (SELECT continent FROM world WHERE name = 'Australia')
ORDER BY name;

-- Between Canada and Poland
SELECT name
FROM world
WHERE population > (SELECT population FROM world WHERE name = 'Canada') 
AND population < (SELECT population FROM world WHERE name = 'Poland');

-- Percentages of Germany
SELECT name, CONCAT(ROUND(population/(SELECT population FROM world 
WHERE name = 'Germany') * 100), '%') AS percentage
FROM world
WHERE continent = 'Europe';

-- Bigger than every country in Europe
SELECT name
FROM world
WHERE gdp > ALL(SELECT gdp 
                FROM world 
                WHERE continent = 'Europe' AND gdp IS NOT NULL);

-- Largest in each continent
SELECT continent, name, area FROM world x
  WHERE area >= ALL
    (SELECT area FROM world y
        WHERE y.continent=x.continent
          AND area>0);

-- First country of each continent (alphabetically)
SELECT continent, name
FROM world x
WHERE name = (SELECT name FROM world y
              WHERE y.continent = x.continent
              ORDER BY name LIMIT 1);

-- 9
SELECT name, continent, population
FROM world
WHERE continent = ANY (SELECT continent
FROM world a
WHERE 25000000 >= ALL (SELECT population FROM world b WHERE a.continent = b.continent));

-- 10
SELECT name, continent
FROM world x
WHERE population > ALL (SELECT (3*population) FROM world y 
WHERE x.continent = y.continent AND x.name != y.name);

-- SUM and COUNT

-- Total world population
SELECT SUM(population)
FROM world;

-- List of continents
SELECT DISTINCT continent
FROM world;

-- GDP of Africa
SELECT SUM(gdp)
FROM world
WHERE continent = 'Africa';

-- Count the big countries
SELECT COUNT(name)
FROM world
WHERE area >= 1000000;

-- Baltic states population
SELECT SUM(population)
FROM world
WHERE name IN ('Estonia', 'Latvia', 'Lithuania');

-- Counting the countries of each continent
SELECT continent, COUNT(name)
FROM world
GROUP BY continent;

-- Counting big countries in each continent
SELECT continent, COUNT(name)
FROM world
WHERE population >= 10000000
GROUP BY continent;

-- Counting big continents
SELECT continent
FROM world
GROUP BY continent
HAVING SUM(population) >= 100000000;

-- The JOIN operation

-- 1
SELECT matchid, player FROM goal 
WHERE teamid = 'GER';

-- 2
SELECT id,stadium,team1,team2
FROM game
WHERE id = 1012;

-- 3
SELECT goal.player, goal.teamid, game.stadium, game.mdate
FROM game JOIN goal ON (game.id=goal.matchid)
WHERE goal.teamid = 'GER';

-- 4
SELECT game.team1, game.team2, goal.player
FROM game JOIN goal ON (game.id=goal.matchid)
WHERE goal.player LIKE 'Mario%';

-- 5
SELECT goal.player, goal.teamid, eteam.coach, goal.gtime
FROM goal JOIN eteam ON goal.teamid=eteam.id
WHERE goal.gtime<=10;

-- 6
SELECT game.mdate, eteam.teamname
FROM game JOIN eteam ON (game.team1=eteam.id)
WHERE eteam.coach = 'Fernando Santos';

-- 7
SELECT goal.player
FROM goal JOIN game ON goal.matchid=game.id
WHERE game.stadium = 'National Stadium, Warsaw';

-- 8
SELECT DISTINCT goal.player
FROM goal JOIN game ON goal.matchid = game.id 
WHERE goal.teamid != 'GER' AND (game.team1='GER' OR game.team2='GER');

-- 10
SELECT game.stadium, COUNT(goal.matchid)
FROM game JOIN goal ON game.id = goal.matchid
GROUP BY game.stadium;

-- 11
SELECT goal.matchid, game.mdate, COUNT(goal.matchid)
FROM game JOIN goal ON goal.matchid = game.id 
WHERE (team1 = 'POL' OR team2 = 'POL')
GROUP BY goal.matchid, game.mdate;

-- 12
SELECT goal.matchid, game.mdate, COUNT(goal.matchid)
FROM game JOIN goal ON goal.matchid = game.id
WHERE goal.teamid = 'GER'
GROUP BY goal.matchid, game.mdate;

-- 13
SELECT mdate,
  team1,
  SUM(CASE WHEN teamid=team1 THEN 1 ELSE 0 END) score1,
  team2,
  SUM (CASE WHEN teamid=team2 THEN 1 ELSE 0 END) score2
  FROM game LEFT JOIN goal ON matchid = id
  GROUP BY mdate, matchid, team1, team2
  ORDER BY mdate, matchid, team1, team2;

-- More JOIN operations

-- 1962 movies
SELECT id, title
FROM movie
WHERE yr=1962;

-- When was Citizen Kane released?
SELECT yr
FROM movie
WHERE title = 'Citizen Kane';

-- Star Trek movies
SELECT id, title, yr
FROM movie
WHERE title LIKE 'Star Trek%';

-- id for actor Glenn Close
SELECT id
FROM actor
WHERE name = 'Glenn Close';

-- id for Casablanca
SELECT id
FROM movie
WHERE title = 'Casablanca';

-- Cast list for Casablanca
SELECT actor.name
FROM actor JOIN casting ON actor.id=casting.actorid
WHERE casting.movieid = 27;

-- Alien cast list
SELECT actor.name
FROM actor
JOIN casting ON actor.id=casting.actorid
WHERE casting.movieid=(SELECT id FROM movie WHERE title = 'Alien');

-- Harrison Ford movies
SELECT movie.title
FROM movie JOIN casting ON movie.id = casting.movieid
WHERE casting.actorid=(SELECT id FROM actor WHERE name = 'Harrison Ford');

-- Harrison Ford as a supporting character
SELECT movie.title
FROM movie JOIN casting ON movie.id = casting.movieid
WHERE casting.actorid=(SELECT id FROM actor WHERE name = 'Harrison Ford') AND casting.ord>1;

-- Lead actors in 1962 movies
SELECT movie.title, actor.name
FROM movie JOIN casting ON movie.id = casting.movieid
JOIN actor ON actor.id=casting.actorid
WHERE movie.yr=1962 AND casting.ord=1;

-- Busy years for Rock Hudson
SELECT movie.yr, COUNT(movie.title) FROM
  movie JOIN casting ON movie.id=movieid
        JOIN actor   ON actorid=actor.id
WHERE actor.name='Rock Hudson'
GROUP BY yr
HAVING COUNT(movie.title) > 2;

-- Lead actor in Julie Andrews movies
SELECT title, name FROM movie
JOIN casting x ON movie.id = movieid
JOIN actor ON actor.id =actorid
WHERE ord=1 AND movieid IN
(SELECT movieid FROM casting y
JOIN actor ON actor.id=actorid
WHERE name='Julie Andrews');

-- Actors with 15 leading roles
SELECT name
FROM actor JOIN casting ON (actor.id = actorid AND (SELECT COUNT(ord)
       FROM casting y
       WHERE actorid = actor.id AND ord=1) >= 15)
GROUP BY name;

-- 14
SELECT title, COUNT(actorid) AS cast
FROM movie JOIN casting ON movie.id=casting.movieid
WHERE yr=1978
GROUP BY title
ORDER BY cast DESC, title;

-- 15
SELECT name
FROM actor JOIN casting ON actor.id=casting.actorid
WHERE movieid IN (SELECT movieid FROM casting JOIN actor ON actor.id = casting.actorid 
AND actor.name = 'Art Garfunkel') AND name!='Art Garfunkel';

-- Using Null

-- 1
SELECT name
FROM teacher
WHERE dept IS NULL;

-- 2
SELECT teacher.name, dept.name
 FROM teacher INNER JOIN dept
           ON (teacher.dept=dept.id);

-- 3
SELECT teacher.name, dept.name
 FROM teacher LEFT JOIN dept
           ON (teacher.dept=dept.id);

-- 4
SELECT teacher.name, dept.name
 FROM teacher RIGHT JOIN dept
           ON (teacher.dept=dept.id);

-- 5
SELECT name, COALESCE(mobile, '07986 444 2266')
FROM teacher;

-- 6
SELECT teacher.name, COALESCE(dept.name, 'None')
FROM teacher LEFT JOIN dept ON (teacher.dept = dept.id);

-- 7
SELECT COUNT(name), COUNT(mobile)
FROM teacher;

-- 8
SELECT dept.name, COUNT(teacher.id)
FROM teacher RIGHT JOIN dept ON (teacher.dept = dept.id)
GROUP BY dept.name;

-- 9
SELECT teacher.name, CASE WHEN (dept.id=1 OR dept.id=2)
                          THEN 'Sci'
                          WHEN (dept.id!=1 AND dept.id!=2) OR dept.id IS NULL
                          THEN 'Art'
                       END
FROM teacher LEFT JOIN dept ON (teacher.dept=dept.id);

-- 10
SELECT teacher.name, CASE WHEN (dept.id=1 OR dept.id=2)
                          THEN 'Sci'
                          WHEN dept=3
                          THEN 'Art'
                    WHEN (dept.id!=1 AND dept.id!=2 AND dept.id!=3) OR dept.id IS NULL
                          THEN 'None'
                     END
FROM teacher LEFT JOIN dept ON (teacher.dept=dept.id);

-- Self join

-- 1
SELECT COUNT(id)
FROM stops;

-- 2
SELECT id
FROM stops
WHERE name = 'Craiglockhart';

-- 3
SELECT stops.id, stops.name
FROM stops JOIN route ON stops.id=route.stop
WHERE route.num='4' AND route.company='LRT';

-- 4
SELECT company, num, COUNT(*)
FROM route WHERE stop=149 OR stop=53
GROUP BY company, num HAVING COUNT(*)=2;

-- 5
SELECT a.company, a.num, a.stop, b.stop
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
WHERE a.stop=53 AND b.stop=149;

-- 6
SELECT a.company, a.num, stopa.name, stopb.name
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart' AND stopb.name='London Road';

-- 7
SELECT DISTINCT a.company, a.num
FROM route a JOIN route b ON (a.company=b.company AND a.num=b.num)
WHERE a.stop=115 AND b.stop=137;

-- 8
SELECT a.company, a.num
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart' AND stopb.name='Tollcross';

-- 9
SELECT DISTINCT stopa.name, a.company, a.num
FROM route a
  JOIN route b ON (a.num=b.num AND a.company=b.company)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopb.name='Craiglockhart';

-- 10
SELECT DISTINCT a.num, a.company, stopb.name ,  c.num,  c.company
FROM route a JOIN route b
ON (a.company = b.company AND a.num = b.num)
JOIN ( route c JOIN route d ON (c.company = d.company AND c.num= d.num))
JOIN stops stopa ON (a.stop = stopa.id)
JOIN stops stopb ON (b.stop = stopb.id)
JOIN stops stopc ON (c.stop = stopc.id)
JOIN stops stopd ON (d.stop = stopd.id)
WHERE  stopa.name = 'Craiglockhart' AND stopd.name = 'Sighthill'
            AND  stopb.name = stopc.name
ORDER BY LENGTH(a.num), b.num, stopb.id, LENGTH(c.num), d.num;
