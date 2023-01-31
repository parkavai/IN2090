
#1

/*
Hvilke verdier forekommer i attributtet filmtype i relasjonen filmitem?
Lag en oversikt over filmtypene og hvor mange filmer innen hver type (7).
*/

SELECT filmtype, count(filmid)
FROM filmitem
GROUP BY filmtype;

#2

/*
Skriv ut serietittel, produksjonsår og antall episoder for de 15 eldste TV-seriene
i filmdatabasen (sortert stigende etter produksjonsår).
*/
SELECT s.seriesid, s.maintitle, s.firstprodyear, count(e.seriesid) AS antall_episoder
FROM series AS s INNER JOIN episode as e USING (seriesid)
GROUP BY s.seriesid, s.maintitle, s.firstprodyear
ORDER BY s.firstprodyear ASC
LIMIT 15;

#3

/*
Mange titler har vært brukt i flere filmer. Skriv ut en oversikt over titler som har
vært brukt i mer enn 30 filmer. Bak hver tittel skriv antall ganger den er brukt.
Ordne linjene med hyppigst forekommende tittel først. (12 eller 26)
*/
SELECT f.title, count(f.title) AS antall_filmer
FROM film AS f
GROUP BY f.title
HAVING count(f.title) > 30
ORDER BY antall_filmer ASC;

-- Bare kinofilmer (12 rader)

SELECT title, COUNT(*) AS ant
FROM film INNER JOIN filmitem ON film.filmid = filmitem.filmid
WHERE filmitem.filmtype = 'C'
GROUP BY title
HAVING COUNT(*) > 30
ORDER BY ant DESC;

#4
/*
Finn de “Pirates of the Caribbean”-filmene som er med i flere enn 3 genre (4)
*/
SELECT f.title
FROM film as f INNER JOIN filmgenre as g USING (filmid)
WHERE f.title LIKE '%Pirates of the Caribbean%'
GROUP BY f.title
HAVING COUNT(g.genre) > 3;

#5
/*
Hvilke verdier (fornavn) forekommer hyppigst i firstname-attributtet i tabellen Person?
Finn alle fornavn, og sorter fallende etter antall forekomster.
Ikke tell med forekomster der fornavn-verdien er tom.
Begrens gjerne antall rader. (176030 rader, 16108 for flest fornavn)
*/
SELECT p.firstname, count(p.firstname) AS antall_forekomster
FROM person as p
WHERE p.firstname IS NOT NULL
GROUP BY p.firstname
ORDER BY antall_forekomster DESC
LIMIT 30;

#6

/*
Finn filmene som er med i flest genrer: Skriv ut filmid, tittel og antall genre,
og sorter fallende etter antall genre. Du kan begrense resultatet til 25 rader.
*/
SELECT f.filmid, f.title, count(g.genre) AS antall_genre
FROM film as f INNER JOIN filmgenre as g USING (filmid)
GROUP BY f.filmid, f.title
ORDER BY count(g.genre) DESC
LIMIT 25;

#7

/*
Lag en oversikt over regissører som har regissert mer enn 5 norske filmer. (60)
*/

SELECT lastname || ', ' || firstname AS navn
FROM Filmcountry
     JOIN Film USING (filmid)
     JOIN Filmparticipation USING (filmid)
     JOIN Person USING (personid)
WHERE country = 'Norway' AND
      parttype = 'director'
GROUP BY lastname, firstname
HAVING COUNT(*) > 5;


#8

/*
Skriv ut serieid, serietittel og produksjonsår for TV-serier, sortert fallende
etter produksjonsår. Begrens resultatet til 50 filmer. Tips: Ikke ta med serier
der produksjonsåret er null.
*/

SELECT s.seriesid, s.maintitle, s.firstprodyear
FROM series AS s
WHERE s.firstprodyear IS NOT NULL
GROUP BY s.seriesid, s.maintitle, s.firstprodyear
ORDER BY s.firstprodyear DESC
LIMIT 50;

#9
/*
Hva er gjennomsnittlig score (rank) for filmer med over 100 000 stemmer (votes)?
*/
SELECT avg(fr.rank)
FROM filmrating AS fr
WHERE fr.votes > 100000;

#10
/*
Hvilke filmer (tittel og score) med over 100 000 stemmer har en høyere score enn
snittet blant filmer med over 100 000 stemmer (subspørring!) (20).
*/
SELECT f.title, fr.rank
FROM film as f INNER JOIN filmrating as fr USING (filmid)
WHERE fr.votes > 100000 AND fr.rank >= (
    SELECT avg(fr.rank)
    FROM filmrating AS fr
    WHERE fr.votes > 100000);


#11
/*
Hvilke 100 verdier (fornavn) forekomer hyppigst i firstname-attributtet i tabellen Person?
*/

SELECT p.firstname, count(p.firstname) AS antall_forekomster
FROM person as p
WHERE p.firstname IS NOT NULL
GROUP BY p.firstname
ORDER BY antall_forekomster DESC
LIMIT 100;

#12
/*
Hvilke to fornavn forekommer mer enn 6000 ganger og akkurat like mange ganger? (Paul og Peter, vanskelig!)
*/
WITH
  ant_fornavn AS (
    SELECT firstname AS fornavn, COUNT(*) AS antall
    FROM Person
    GROUP BY firstname
    HAVING COUNT(*) > 5999
  )
SELECT A.fornavn, A.antall, B.fornavn, B.antall
FROM ant_fornavn AS A INNER JOIN ant_fornavn AS B
     ON A.antall = B.antall AND A.fornavn != B.fornavn;

-- eller

SELECT A.fornavn, A.antall, B.fornavn, B.antall
FROM (
  SELECT firstname AS fornavn, COUNT(*) AS antall
  FROM Person
  GROUP BY firstname
  HAVING COUNT(*) > 5999) AS A
INNER JOIN (
  SELECT firstname AS fornavn, COUNT(*) AS antall
  FROM Person
  GROUP BY firstname
  HAVING COUNT(*) > 5999) AS B
ON A.antall = B.antall AND A.fornavn != B.fornavn;

#13
/*
Hvor mange filmer har Tancred Ibsen regissert?
*/
SELECT COUNT(DISTINCT filmid) AS tancredIbsenFilmer
FROM Filmparticipation JOIN Person USING (personid)
WHERE lastname = 'Ibsen' AND
      firstname = 'Tancred' AND
      parttype = 'director';

-- eller

SELECT COUNT(*) AS tancredIbsenFilmer
FROM (
  SELECT DISTINCT filmid AS tancredIbsenFilmer
  FROM Filmparticipation JOIN Person USING (personid)
  WHERE lastname = 'Ibsen' AND
        firstname = 'Tancred' AND
        parttype = 'director'
) AS t;

#14
/*
Lag en oversikt (filmtittel) over norske filmer med mer enn én regissør (135).
*/
SELECT f.filmid, f.title AS filmtittel
FROM Filmcountry
     JOIN Film AS f USING (filmid)
     JOIN Filmparticipation USING (filmid)
     JOIN Person USING (personid)
WHERE country = 'Norway' AND
      parttype = 'director'
GROUP BY f.filmid, f.title
HAVING COUNT(*) > 1;

#15
/*
Finn regissører som har regissert alene mer enn 5 norske filmer (utfordring!) (49)
*/
SELECT lastname || ', ' || firstname AS navn, COUNT(*) AS antall
FROM Filmcountry
     JOIN Film USING (filmid)
     JOIN Filmparticipation USING (filmid)
     JOIN Person USING (personid)
WHERE country = 'Norway' AND
      parttype = 'director' AND
      filmid NOT IN ( -- Norske filmer med mer enn én regissør
           SELECT filmid
           FROM Filmcountry
                JOIN Film USING (filmid)
                JOIN Filmparticipation USING (filmid)
                JOIN Person USING (personid)
           WHERE country = 'Norway' AND
                 parttype = 'director'
           GROUP BY filmid, title
           HAVING COUNT(*) > 1
        )
GROUP BY lastname, firstname
HAVING COUNT(*) > 5
ORDER BY antall DESC;

#16
/*
Finn tittel, produksjonsår og filmtype for alle kinofilmer som ble produsert i året 1893 (4)
*/

SELECT f.title, f.prodyear, fi.filmtype
FROM film AS f JOIN filmitem AS fi USING (filmid)
WHERE f.prodyear = 1893;

#17
/*
Finn navn på alle skuespillere (cast) i filmen Baile Perfumado (14).
*/
SELECT firstname || ' ' || lastname AS navn
FROM Filmparticipation
    INNER JOIN Person USING (personid)
    INNER JOIN Film USING (filmid)
WHERE title LIKE 'Baile Perfumado' AND parttype LIKE 'cast';

#18
/*
Finn tittel og produksjonsår for alle filmene som Ingmar Bergman har vært
regissør (director) for. Sorter tuplene kronologisk etter produksjonsår (62).
*/
SELECT title, prodyear
FROM Film
    INNER JOIN Filmparticipation USING (filmid)
    INNER JOIN Person USING (personid)
WHERE firstname LIKE 'Ingmar' AND lastname Like 'Bergman' AND parttype = 'director'
ORDER BY prodyear;

#19
/*
Finn produksjonsår for første og siste film Ingmar Bergman regisserte
*/
SELECT MIN(f.prodyear) AS first, MAX(f.prodyear) AS last
FROM film AS f
     JOIN filmparticipation AS fp USING (filmid)
     JOIN person AS p USING (personid)
WHERE fp.parttype LIKE 'director' AND
      p.lastname LIKE 'Bergman' AND
      p.firstname LIKE 'Ingmar';

#20
/*
Finn tittel og produksjonsår for de filmene hvor mer enn 300 personer har deltatt,
uansett hvilken funksjon de har hatt (11).
*/
SELECT f.title, f.prodyear, COUNT(*) AS participants
FROM film AS f JOIN filmparticipation AS fp USING (filmid)
GROUP BY f.title, f.prodyear
HAVING COUNT(DISTINCT fp.personid) > 300
ORDER BY participants DESC;

#21
/*
Finn oversikt over regissører som har regissert kinofilmer over et stort tidsspenn.
I tillegg til navn, ta med antall kinofilmer og første og siste år (prodyear) personen hadde regi.
Skriv ut alle som har et tidsintervall på mer enn 49 år mellom første og siste film og
sorter dem etter lengden på dette tidsintervallet, de lengste først (188).
*/

SELECT p.firstname || ' ' || p.lastname AS navn, COUNT(*) AS regissert,
        MIN(f.prodyear) AS first, MAX(f.prodyear) AS last,
        MAX(f.prodyear) - MIN(f.prodyear) AS periode
FROM film AS f
     INNER JOIN filmparticipation AS fp USING (filmid)
     INNER JOIN filmitem AS i USING (filmid)
     INNER JOIN person AS p USING (personid)
WHERE fp.parttype LIKE 'director' AND i.filmtype = 'C'
GROUP BY p.personid, name
HAVING (MAX(f.prodyear) - MIN(f.prodyear) > 49)
ORDER BY periode DESC;

#22
/*
Finn filmid, tittel og antall medregissører (parttype ’director’) (0 der han har regissert alene)
for filmer som Ingmar Bergman har regissert (62).
*/
WITH ingmarbergmanmovies AS (
  SELECT fp.filmid
  FROM filmparticipation AS fp
       INNER JOIN person AS p ON fp.personid = p.personid
  WHERE fp.parttype = 'director' AND
        p.firstname = 'Ingmar' AND
        p.lastname = 'Bergman'
),
ant_regissorer AS (
  SELECT fp.filmid, COUNT(*) ant
  FROM filmparticipation AS fp
  WHERE fp.filmid IN (SELECT * FROM ingmarbergmanmovies)
  AND fp.parttype = 'director'
  GROUP BY fp.filmid
)
SELECT f.filmid, f.title, (ar.ant - 1) AS ant_medregissorer
FROM film AS f INNER JOIN ant_regissorer AS ar ON f.filmid = ar.filmid;

-- eller

WITH ingmarbergmanmovies AS (
  SELECT fp.filmid
  FROM filmparticipation AS fp
       INNER JOIN person AS p ON fp.personid = p.personid
  WHERE fp.parttype = 'director' AND
        p.firstname = 'Ingmar' AND
        p.lastname = 'Bergman'
)
SELECT f.filmid, f.title, COUNT(*) ant
FROM filmparticipation AS fp
    INNER JOIN film AS f USING(filmid)
WHERE fp.filmid IN (SELECT * FROM ingmarbergmanmovies)
AND fp.parttype = 'director'
GROUP BY f.filmid, f.title;

#23
/*
Finn filmid, antall involverte personer, produksjonsår og rating for alle
filmer som Ingmar Bergman har regissert. Ordne kronologisk etter produksjonsår (56).
*/
WITH ingmarbergmanmovies AS (
  SELECT fp.filmid
  FROM filmparticipation AS fp
       INNER JOIN person AS p ON fp.personid = p.personid
  WHERE fp.parttype = 'director' AND
        p.firstname = 'Ingmar' AND
        p.lastname = 'Bergman'
)
SELECT f.filmid, COUNT(*) AS ant_involverte, f.prodyear, fr.rank
FROM filmparticipation AS fp
    INNER JOIN film as f USING(filmid)
    INNER JOIN filmrating AS fr USING(filmid)
WHERE fp.filmid IN (SELECT * FROM ingmarbergmanmovies)
GROUP BY f.filmid, f.prodyear, fr.rank
ORDER BY f.prodyear;

-- eller

WITH ingmarbergmanmovies AS (
  SELECT fp.filmid
  FROM filmparticipation AS fp INNER JOIN person AS p ON fp.personid = p.personid
  WHERE fp.parttype = 'director'
  AND p.firstname = 'Ingmar'
  AND p.lastname = 'Bergman'
),
crew AS (
  SELECT fp.filmid, COUNT(*) as ant
  FROM filmparticipation AS fp
  WHERE fp.filmid IN (SELECT * FROM ingmarbergmanmovies)
  GROUP BY filmid
)
SELECT f.filmid, c.ant, f.prodyear, fr.rank AS rating
FROM film AS f
     INNER JOIN crew c ON f.filmid = c.filmid
     INNER JOIN filmrating fr ON fr.filmid = f.filmid
WHERE f.filmid IN (SELECT * FROM ingmarbergmanmovies)
ORDER BY f.prodyear;

# 24
/*
Finn produksjonsår og tittel for alle filmer som både Angelina Jolie og
Antonio Banderas har deltatt i sammen (3).
*/

WITH angelina AS (
    SELECT f.filmid, f.title, f.prodyear
    FROM filmparticipation AS fp
        INNER JOIN film AS f USING (filmid)
        INNER JOIN person AS p USING (personid)
    WHERE p.firstname LIKE 'Angelina' AND p.lastname LIKE 'Jolie'
),
antonio AS(
    SELECT f.filmid, f.title, f.prodyear
    FROM filmparticipation AS fp
        INNER JOIN film AS f USING (filmid)
        INNER JOIN person AS p USING (personid)
    WHERE p.firstname LIKE 'Antonio' AND p.lastname LIKE 'Banderas'
)
SELECT f.title, f.prodyear
FROM angelina AS a
    INNER JOIN film AS f USING(filmid)
    INNER JOIN antonio AS b USING(filmid);

-- ELLER --

SELECT f.title, f.prodyear
FROM film AS f
     JOIN filmparticipation AS fp USING (filmid)
     JOIN person AS p USING (personid)
WHERE p.firstname = 'Angelina' AND
      p.lastname = 'Jolie' AND
      fp.filmid IN (
        SELECT fp2.filmid
        FROM filmparticipation AS fp2 JOIN person AS p USING (personid)
        WHERE p.firstname = 'Antonio' AND
              p.lastname = 'Banderas'
      );

-- ELLER --

(SELECT f.prodyear, f.title
FROM film AS f
    INNER JOIN filmparticipation AS fp USING(filmid)
    INNER JOIN person AS p USING(personid)
WHERE p.firstname = 'Angelina' AND p.lastname = 'Jolie')
INTERSECT
(SELECT f.prodyear, f.title
FROM film AS f
    INNER JOIN filmparticipation AS fp USING(filmid)
    INNER JOIN person AS p USING(personid)
WHERE p.firstname = 'Antonio' AND p.lastname = 'Banderas');

# 25
/*
Finn tittel, navn og roller for personer som har hatt mer enn én rolle i samme film
blant kinofilmer som ble produsert i 2003. (Med forskjellige roller mener vi cast,
director, producer osv. Vi skal altså ikke ha med de som har to ulike cast-roller)
*/
SELECT DISTINCT f.title, concat(p.firstname, ' ', p.lastname) AS name, fp.parttype
FROM film AS f
     JOIN filmparticipation AS fp USING (filmid)
     JOIN person AS p USING (personid)
INNER JOIN (
    SELECT fp.personid, fp.filmid
    FROM filmparticipation AS fp
         JOIN film USING (filmid)
         JOIN filmitem USING (filmid)
    WHERE film.prodyear = 2003 AND
          filmitem.filmtype = 'C'
    GROUP BY fp.personid, fp.filmid
    HAVING count(distinct parttype) > 1
) q ON q.filmid = fp.filmid AND q.personid = fp.personid
ORDER BY name ASC;

-- eller

SELECT DISTINCT f.title, p.firstname || ' ' || p.lastname as name, fp.parttype
FROM film AS f
     JOIN filmitem AS fi USING (filmid)
     JOIN filmparticipation AS fp USING (filmid)
     JOIN person AS p USING (personid)
WHERE f.prodyear = 2003 AND
      fi.filmtype = 'C'
GROUP BY f.title, p.firstname, p.lastname, fp.parttype, fp.personid, f.filmid
HAVING (
    SELECT count(distinct fp1.parttype)
    FROM filmparticipation AS fp1
    WHERE fp1.personid = fp.personid AND
          f.filmid = fp1.filmid) > 1
ORDER BY f.title, name, fp.parttype;

#26
/*
Finn navn og antall filmer for personer som har deltatt i mer enn 15 filmer i 2008,
2009 eller 2010, men som ikke har deltatt i noen filmer i 2005 (2).
*/
SELECT p.firstname || ' ' || p.lastname AS name, count(distinct filmid) AS antall
FROM film AS f
     JOIN filmparticipation AS fp USING (filmid)
     JOIN person AS p USING (personid)
WHERE f.prodyear IN (2008,2009,2010) AND fp.personid NOT IN (
    SELECT personid
    FROM filmparticipation AS fp JOIN film AS f USING (filmid)
    WHERE f.prodyear = 2005
)
GROUP BY fp.personid, name
HAVING count(distinct filmid) > 15;

#27
/*
Finn navn på regissør og filmtittel for filmer hvor mer enn 200 personer har deltatt,
uansett hvilken funksjon de har hatt. Ta ikke med filmer som har hatt flere (mer enn én) regissører (33).
*/

SELECT p.firstname || ' ' || p.lastname AS Navn, f.title AS filmtittel
FROM filmparticipation AS fp
    INNER JOIN film AS f USING(filmid)
    INNER JOIN person as p USING(personid)
WHERE fp.parttype = 'director' AND
f.filmid IN (
    SELECT fp.filmid
    FROM filmparticipation as fp
        INNER JOIN person as p USING(personid)
    GROUP BY fp.filmid
    HAVING COUNT(*) > 200
)
AND f.filmid NOT IN (
    SELECT fp.filmid
    FROM filmparticipation as fp
        INNER JOIN person as p USING(personid)
    WHERE fp.parttype = 'director'
    GROUP BY fp.filmid
    HAVING COUNT(*) > 1
)
ORDER BY Navn;

-- eller --
SELECT p.firstname, p.lastname, f.title
FROM film AS f
     JOIN filmparticipation AS fp USING (filmid)
     JOIN person AS p USING (personid)
WHERE fp.parttype = 'director' AND
      f.filmid IN (
        SELECT f.filmid
        FROM film AS f JOIN filmparticipation AS fp USING (filmid)
        GROUP BY f.filmid
        HAVING count(distinct fp.personid) > 200
      ) AND
      f.filmid NOT IN (
        SELECT f.filmid
        FROM film AS f JOIN filmparticipation AS fp USING (filmid)
        WHERE fp.parttype='director'
        GROUP BY f.filmid
        HAVING count(fp.parttype) > 1
      );

--eller
SELECT p.firstname || ' ' || p.lastname as name, f.title
FROM film AS f
     JOIN filmparticipation AS fp USING (filmid)
     JOIN person AS p USING (personid)
INNER JOIN (
    SELECT filmid
    FROM filmparticipation
    WHERE parttype = 'director'
    AND filmid IN (
        SELECT filmid
        FROM filmparticipation AS fp
        GROUP BY filmid
        HAVING count(*) > 200
    )
    GROUP BY filmid
    HAVING count(*) = 1
) q ON q.filmid = fp.filmid
WHERE parttype = 'director';

#28
/*
Finn navn i leksikografisk orden på regissører som har regissert alene kinofilmer
med mer enn 150 deltakere og som har en regissørkarriere (jf. spørsmål 19) på mer enn 49 år (7).
*/

SELECT p.lastname || ', ' || p.firstname AS name
FROM person AS p
WHERE p.personid IN (
    SELECT fp.personid
    FROM filmparticipation AS fp
    WHERE parttype = 'director'
    AND fp.filmid IN (
        SELECT filmid
        FROM filmparticipation JOIN film AS f USING (filmid)
        WHERE parttype = 'director'
        AND filmid IN (
            SELECT filmid
            FROM filmparticipation AS fp
            GROUP BY filmid
            HAVING count(*) > 150
        )
        GROUP BY filmid
        HAVING count(*) = 1
    )
) AND p.personid IN (
    SELECT fp.personid
    FROM filmparticipation AS fp
         JOIN film AS f USING (filmid)
         JOIN filmitem i USING (filmid)
    WHERE fp.parttype = 'director'
        AND i.filmtype = 'C'
    GROUP BY fp.personid
    HAVING max(f.prodyear)-min(f.prodyear) > 49
)
ORDER BY name ASC;

-- eller

SELECT DISTINCT p.firstname, p.lastname
FROM film AS f0
     JOIN filmparticipation AS fp USING (filmid)
     JOIN person AS p USING (personid)
WHERE fp.parttype = 'director' AND
exists (SELECT f.filmid
        FROM film AS f
             JOIN filmitem AS fi USING (filmid)
             JOIN filmparticipation AS fp1 USING (filmid)
        WHERE fp1.parttype = 'director' AND fi.filmtype='C' AND fp1.personid = fp.personid AND f.filmid
        IN (SELECT f2.filmid
            FROM film AS f2
                 JOIN filmitem AS fi2 USING (filmid)
                 JOIN filmparticipation AS fp3 USING (filmid)
            WHERE fp3.parttype='director' AND fi2.filmtype='C' AND f2.filmid
            IN (SELECT f3.filmid
                FROM film AS f3
                     JOIN filmitem AS fi3 USING (filmid)
                     JOIN filmparticipation AS fp4 USING (filmid)
                WHERE fi3.filmtype ='C'
                GROUP BY f3.filmid
                HAVING count(distinct fp4.personid) > 150)
        GROUP BY f2.filmid
        HAVING count(fp3.parttype) = 1))
GROUP BY p.firstname, p.lastname
HAVING (max(f0.prodyear) - min(f0.prodyear) > 49)
ORDER BY p.firstname, p.lastname DESC

-- eller med WITH

WITH
  film_150_participants AS ( -- Filmer med 150 deltakere
    SELECT filmid
    FROM filmparticipation
    GROUP BY filmid
    HAVING count(*) > 150
  ),
  film_only_director AS  ( -- Filmer med kun én 'director'
    SELECT fp.filmid
    FROM filmparticipation AS fp
         INNER JOIN film AS f USING (filmid)
         INNER JOIN film_150_participants USING (filmid)
    WHERE fp.parttype = 'director'
    GROUP BY fp.filmid
    HAVING count(*) = 1
  ),
  person_only_director AS ( -- Personen som er den ene 'director'
    SELECT personid
    FROM filmparticipation
    WHERE parttype = 'director' AND
          filmid IN (SELECT filmid FROM film_only_director)
  ),
  career_49_years AS ( -- Personer som har regissør-karriære på mer enn 49 år
    SELECT fp.personid
    FROM filmparticipation AS fp
         INNER JOIN filmitem AS i USING (filmid)
         INNER JOIN film AS f USING (filmid)
    WHERE fp.parttype = 'director' AND i.filmtype = 'C'
    GROUP BY personid
    HAVING max(f.prodyear) - min(f.prodyear) > 49
  )
-- Kombiner det over og hent ut navn
SELECT DISTINCT p.firstname, p.lastname
FROM person_only_director AS od
     INNER JOIN career_49_years AS c USING (personid)
     INNER JOIN person AS p USING (personid)
ORDER BY p.firstname, p.lastname;

/*
Finn de 10 skuespillerne som har spilt i flest filmer, men som har spilt i filmer
med gjennomsnitts-rating høyere enn 9, sortert etter antall filmer de har spilt i
*/

WITH
played_in AS (
    SELECT DISTINCT fp.personid , fp.filmid , r.rank
    FROM filmparticipation AS fp
        INNER JOIN film AS f USING (filmid)
        INNER JOIN filmrating AS r USING (filmid)
    WHERE fp.parttype = 'cast'
)
SELECT p.personid , p.firstname , p.lastname , count(*) AS nr_played_in
FROM person AS p
    INNER JOIN played_in AS pi USING (personid )
GROUP BY p.personid , p.firstname , p.lastname
HAVING avg(pi.rank) > 9
ORDER BY nr_played_in DESC
LIMIT 10;
