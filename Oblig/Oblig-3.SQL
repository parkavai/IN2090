DROP TABLE IF EXISTS tog CASCADE;
DROP TABLE IF EXISTS togtabell CASCADE;
DROP TABLE IF EXISTS plass CASCADE;

CREATE TABLE tog (
    tognr int NOT NULL PRIMARY KEY UNIQUE,
    startStasjon text NOT NULL,
    endeStasjon text NOT NULL,
    ankomstTid timestamp NOT NULL
);

CREATE TABLE togtabell(
    tognr int NOT NULL REFERENCES tog(tognr),
    avgangstid timestamp NOT NULL,
    stasjon text NOT NULL,
    PRIMARY KEY(tognr, avgangstid)
);

CREATE TABLE plass(
    tognr int NOT NULL REFERENCES tog(tognr),
    vognNr int NOT NULL,
    plassNr int NOT NULL,
    dato date NOT NULL,
    vindu boolean NOT NULL,
    ledig boolean NOT NULL,
    PRIMARY KEY(vognnr, plassnr, tognr, dato)
);

/*
Finn de 10 skuespillerne som har spilt i flest filmer, men som har spilt i filmer
med gjennomsnitts-rating høyere enn 9, sortert etter antall filmer de har spilt i
*/

-- Først finn skuespillere som har spilt i flest filmer
WITH
gjennomsnitt AS(
    SELECT p.firstname, p.lastname
    FROM person AS p
        INNER JOIN filmparticipation AS fp USING(personid)
        INNER JOIN film AS f USING(filmid)
        INNER JOIN filmrating AS fr USING(filmid)
    WHERE fp.parttype = 'cast'
    GROUP BY p.personid, p.firstname, p.lastname
    HAVING AVG(fr.rank) > 9
)
SELECT p.firstname || ' ' || p.lastname AS navn, COUNT(*) AS antall_filmer
FROM person AS p
    INNER JOIN filmparticipation AS fp USING(personid)
    INNER JOIN film AS f USING(filmid)
WHERE fp.parttype = 'cast' AND  IN (SELECT * FROM gjennomsnitt)
GROUP BY p.personid, p.firstname, p.lastname
ORDER BY antall_filmer DESC
LIMIT 10;
