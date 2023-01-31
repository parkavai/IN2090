#1
SELECT *
FROM Genre;

#2

SELECT f.filmid, f.title
FROM film AS f
WHERE f.prodyear = 1892;

#3
SELECT f.filmid, f.title
FROM film AS f
WHERE f.filmid >= 2000 AND f.filmid <= 2030;

#4
SELECT f.title, f.filmid
FROM Film AS f
WHERE f.title LIKE '%Star Wars%';

#5
SELECT p.firstname, p.lastname
FROM Person AS p
WHERE p.personid = 465221;

#6
SELECT DISTINCT f.parttype
FROM filmparticipation AS f

#7
SELECT f.title, f.prodyear
FROM film AS f
WHERE f.title LIKE '%Rush Hour%';

#8
SELECT f.filmid, f.title, f.prodyear
FROM film AS f
WHERE f.title LIKE '%Norge%';

#9
SELECT fi.filmid
FROM filmitem fi
     INNER JOIN film f ON f.filmid = fi.filmid
WHERE fi.filmtype = 'C' AND f.title = 'Love';

#10
SELECT COUNT(*) AS antallNorskeFilmer
FROM Filmcountry
WHERE country = 'Norway';
