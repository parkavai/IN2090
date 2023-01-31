# Oppgave 1

SELECT *
FROM Filmitem AS fi
WHERE fi.filmid IN (
    SELECT f.filmid
    FROM Film AS f
    WHERE f.prodyear = 1894
);

-- eller

SELECT *
FROM Filmitem AS fi
     INNER JOIN Film AS f ON (f.filmid = fi.filmid)
WHERE f.prodyear = 1894;

# Oppgave 2

SELECT p.firstname, p.lastname
FROM Person AS p
WHERE p.gender = 'F' AND p.personid IN (
    SELECT fp.personid
    FROM Filmparticipation AS fp
    WHERE fp.filmid = 357076 AND fp.parttype = 'cast'
  )
ORDER BY p.lastname;

-- Alternativ med "Join"
SELECT p.firstname, p.lastname
FROM Person as p INNER JOIN Filmparticipation as fp USING (personid)
WHERE p.gender = 'F' AND fp.filmid = 357076 AND fp.parttype = 'cast';
ORDER BY p.lastname;
