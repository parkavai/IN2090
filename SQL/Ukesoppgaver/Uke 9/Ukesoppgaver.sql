/*
Hvilke verdier forekommer i attributtet filmtype i relasjonen filmitem?
Lag en oversikt over filmtypene og hvor mange filmer innen hver type (7).
*/

SELECT filmtype, COUNT(*) AS antall_hver_type
FROM filmitem
GROUP BY filmtype;

/*
Skriv ut serietittel, produksjonsår og antall episoder for de 15 eldste TV-seriene
i filmdatabasen (sortert stigende etter produksjonsår).
*/

SELECT s.maintitle, s.firstprodyear, COUNT(*) AS antall_episoder
FROM series AS s
    INNER JOIN episode AS e USING(seriesid)
GROUP BY s.maintitle, s.firstprodyear
ORDER BY s.firstprodyear ASC
LIMIT 15;

/*
Mange titler har vært brukt i flere filmer. Skriv ut en oversikt over titler som har
vært brukt i mer enn 30 filmer. Bak hver tittel skriv antall ganger den er brukt.
Ordne linjene med hyppigst forekommende tittel først. (12 eller 26)
*/

SELECT f.title, COUNT(*) AS antall_forekomster
FROM film AS f
GROUP BY f.title
HAVING COUNT(*) > 30
ORDER BY f.title DESC;

/*
Finn de “Pirates of the Caribbean”-filmene som er med i flere enn 3 genre (4)
*/

WITH
    pirates AS (
        SELECT f.title
        FROM film AS f
        WHERE f.title LIKE '%Pirates of the Caribbean%'
    )
SELECT f.title
FROM film AS f
    INNER JOIN filmgenre AS fg USING(filmid)
WHERE f.title IN (SELECT * FROM pirates)
GROUP BY f.title
HAVING COUNT(*) > 3;

/*
Finn filmene som er med i flest genrer: Skriv ut filmid, tittel og antall genre,
og sorter fallende etter antall genre. Du kan begrense resultatet til 25 rader.
*/

SELECT f.filmid, f.title, COUNT(fg.genre) AS genre
FROM film AS f INNER JOIN filmgenre AS fg USING(filmid)
GROUP BY f.filmid, f.title
ORDER BY COUNT(fg.genre) DESC
LIMIT 25;

/*
Hvilke filmer (tittel og score) med over 100 000 stemmer har en høyere score enn
snittet blant filmer med over 100 000 stemmer (subspørring!) (20).
*/

SELECT f.title, fr.rank
FROM film AS f
    INNER JOIN filmrating AS fr USING(filmid)
WHERE fr.votes > 100000 AND fr.rank >= (
    SELECT avg(fr.rank)
    FROM filmrating AS fr
    WHERE fr.votes > 100000
);

/*
Hvilke 100 verdier (fornavn) forekomer hyppigst i firstname-attributtet i tabellen Person?
*/

SELECT p.firstname, COUNT(*) AS forekomster
FROM person AS p
WHERE p.firstname IS NOT NULL
GROUP BY p.firstname
ORDER BY forekomster DESC
LIMIT 100;

/*
Hvilke to fornavn forekommer mer enn 6000 ganger og akkurat like mange ganger? (Paul og Peter, vanskelig!)
*/

WITH
flest AS(
    SELECT p.firstname, COUNT(*) AS antall
    FROM person AS p
    GROUP BY p.firstname
    HAVING COUNT(*) > 6000
)
SELECT f.firstname, f1.firstname
FROM flest AS f
    INNER JOIN flest AS f1 ON(f.antall = f1.antall)
WHERE f.firstname != f1.firstname
GROUP BY f.firstname, f1.firstname;

/*
Finn navn og antall filmer for personer som har deltatt i mer enn 15 filmer i 2008,
2009 eller 2010, men som ikke har deltatt i noen filmer i 2005 (2).
*/

SELECT p.firstname || ' ' || p.lastname AS navn, COUNT(*) antall_filmer
FROM filmparticipation AS fp
    INNER JOIN person AS p USING(personid)
    INNER JOIN film AS f USING(filmid)
WHERE (f.prodyear = 2008 OR f.prodyear = 2009 OR f.prodyear = 2010) AND fp.personid NOT IN (
    SELECT personid
    FROM filmparticipation AS fp JOIN film AS f USING (filmid)
    WHERE f.prodyear = 2005
)
GROUP BY navn
HAVING COUNT(DISTINCT filmid) > 15;

/*
Finn tittel på alle Western-filmer laget etter 2007 som ikke har en rating. (14 rader)
*/

(SELECT f.title
FROM film AS f
    INNER JOIN filmgenre AS fg USING(filmid)
    LEFT OUTER JOIN filmrating AS fr USING(filmid)
WHERE fg.genre = 'Western' AND f.prodyear > 2007)
EXCEPT
(SELECT filmid FROM filmrating);
