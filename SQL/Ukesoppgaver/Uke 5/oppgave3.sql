# Oppgave 1

SELECT f.title, fg.genre
FROM film AS f
     INNER JOIN filmgenre AS fg ON f.filmid = fg.filmid
WHERE f.title = 'Pirates of the Caribbean: The Legend of Jack Sparrow';

# Oppgave 2

SELECT *
FROM film AS f
     INNER JOIN filmgenre AS fg USING (filmid)
WHERE filmid = 985057;

-- Delspørring
SELECT *
FROM filmgenre as fg
WHERE fg.filmid in(
    SELECT f.filmid
    FROM film AS f
    WHERE f.filmid = 985057
)
;

# Oppgave 3

SELECT f.title, f.prodyear, fi.filmtype
FROM Film AS f, Filmitem AS fi
WHERE f.prodyear = 1894 AND f.filmid = fi.filmid;

-- eller

SELECT f.title, f.prodyear, fi.filmtype
FROM Film AS f NATURAL JOIN Filmitem AS fi
WHERE f.prodyear = 1894;

-- eller

SELECT f.title, f.prodyear, fi.filmtype
FROM Film AS f INNER JOIN Filmitem AS fi ON f.filmid = fi.filmid
WHERE f.prodyear = 1894;

# Oppgave 4

SELECT DISTINCT p.firstname, p.lastname, fp.filmid
FROM Person AS p, Filmparticipation AS fp
WHERE p.gender = 'F'
  AND fp.filmid = 357076
  AND fp.parttype = 'cast'
  AND p.personid = fp.personid;

-- eller

SELECT DISTINCT p.firstname, p.lastname, fp.filmid
FROM Person AS p NATURAL JOIN Filmparticipation AS fp
WHERE p.gender = 'F'
  AND fp.filmid = 357076
  AND fp.parttype = 'cast';

-- eller

SELECT DISTINCT p.firstname, p.lastname, fp.filmid
FROM Person AS p INNER JOIN Filmparticipation AS fp ON p.personid = fp.personid
WHERE p.gender = 'F'
  AND fp.filmid = 357076
  AND fp.parttype = 'cast';

  -- BONUS:

 SELECT DISTINCT p.firstname, p.lastname, fp.filmid, f.title
 FROM Person AS p, Filmparticipation AS fp, Film AS f
 WHERE p.gender = 'F'
   AND fp.filmid = 357076
   AND fp.parttype = 'cast'
   AND p.personid = fp.personid
   AND fp.filmid = f.filmid;

 -- eller

 SELECT DISTINCT p.firstname, p.lastname, fp.filmid, f.title
 FROM Person AS p NATURAL JOIN Filmparticipation AS fp NATURAL JOIN Film AS f
 WHERE p.gender = 'F'
   AND fp.filmid = 357076
   AND fp.parttype = 'cast';

 -- eller

 SELECT DISTINCT p.firstname, p.lastname, fp.filmid, f.title
 FROM Person AS p INNER JOIN Filmparticipation AS fp ON p.personid = fp.personid
   INNER JOIN Film AS f ON fp.filmid = f.filmid
 WHERE p.gender = 'F'
   AND fp.filmid = 357076
   AND fp.parttype = 'cast';

# Oppgave 5

-- a.   INNER JOIN
SELECT DISTINCT p.personid, p.lastname, p.firstname, s.maintitle
FROM Person p
     INNER JOIN Filmparticipation AS fp ON p.personid = fp.personid
     INNER JOIN Series AS s ON s.seriesid = fp.filmid
WHERE s.maintitle = 'South Park';

-- b.    Implisitt join
SELECT DISTINCT p.personid, p.lastname, p.firstname, s.maintitle
FROM Person AS p, Filmparticipation AS fp, Series AS s
WHERE s.seriesid = fp.filmid
    AND p.personid = fp.personid
    AND maintitle = 'South Park';

-- c.   NATURAL JOIN
SELECT DISTINCT p.personid, p.lastname, p.firstname, s.maintitle
FROM Person AS p
     NATURAL JOIN Filmparticipation AS fp
     NATURAL JOIN Series AS s
WHERE s.maintitle LIKE 'South Park';

-- d.
/*
NATURAL JOIN joiner “automatisk” på attributtene som har samme navn.
Dette fungerer i join-operasjonen mellom tabellen Person og Filmparticipation
fordi begge har attributtet personid som det joines på.
Men mellom Filmparticipation og Series er det ingen attributter med felles navn:
vi må joine på filmparticipation.filmid og series.seriesid, og det går ikke med NATURAL JOIN.
Vi må derfor bruke en annen join-metode (som i a eller b).
*/

# Oppgave 6

SELECT DISTINCT p.firstname, p.lastname, fp.parttype, f.title
FROM Person AS p
     INNER JOIN Filmparticipation AS fp USING (personid)
     INNER JOIN film AS f USING (filmid)
WHERE title = 'Harry Potter and the Goblet of Fire' AND parttype = 'cast';

# Oppgave 7

SELECT DISTINCT p.firstname || ' ' || p.lastname AS name
FROM film AS f
     INNER JOIN filmparticipation AS fp USING (filmid)
     INNER JOIN person AS p USING (personid)
WHERE fp.parttype = 'cast'
AND f.title = 'Baile Perfumado';

# Oppgave 8

SELECT film.title, person.firstname || ' ' || person.lastname AS fullname
FROM filmcountry
     INNER JOIN film USING (filmid)
     INNER JOIN filmparticipation USING (filmid)
     INNER JOIN person USING (personid)
WHERE filmcountry.country = 'Norway'
    AND parttype = 'director'
    AND prodyear < 1960;
