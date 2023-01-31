/*
Skriv en SQL-spørring som finner morgendagens (17.12.2020) værmelding for
alle byer i Italia. Spørringen skal skrive ut navnet på byen, antall millimeter
regn og vindstyrken. Sorter resultatet alfabetisk på bynavn.
*/

-- Spørring må inneholde følgende:

-- Hent navn på byen, sum(millimeter_regn), vind.styrke

-- Hente alle byer som finnes i Italia og datoen er 17.12.2020

-- ORDER BY hvor vi sorterer etter navnet på byen

SELECT b.navn, v.nedbør, v.styrke
FROM by AS b
    INNER JOIN værmelding AS v USING(bid)
    INNER JOIN land AS l USING(lid)
WHERE l.country = 'Italia' AND v.dato = '2020-12-17'
ORDER BY b.navn;

/*
Skriv en SQL-spørring som finner navn, totalt antall millimeter nedbør og
gjennomsnittlig vindstyrke i romjulsuka (altså fra og med dato 24.12.2020 til og
med dato 31.12.2020) for hver by.
*/

-- Spørringen må inneholde følgende:

-- Navn på byen, SUM(v.nedbør), AVG(v.styrke)

-- WHERE v.dato >= '2020-12-24' AND v.dato <= '2021-01-01'

-- GROUP BY by.navn

SELECT b.navn, SUM(v.nedbør), AVG(v.styrke)
FROM by AS b
    INNER JOIN værmelding AS v USING(bid)
WHERE v.dato >= '2020-12-24' AND v.dato <= '2021-01-01'
GROUP BY b.bid, b.navn;

/*
Skriv en SQL-spørring som finner navn på alle byer hvor det ikke er meldt noe
regn og ikke noe vind fra og med julaften (24.12.2020) og ut året. Spørringen
skal skrive ut navnet på byene. Du kan anta at vi har værmelding (og både
nedbør og vindstyrke) for alle byer hver dag i julen.
*/

SELECT b.navn
FROM by AS b
    INNER JOIN værmelding AS v USING(bid)
WHERE v.dato >= '2020-12-24' AND v.dato < '2021-01-01'
GROUP BY b.bid, b.navn
HAVING SUM(v.nedbør) = 0 AND SUM(v.styrke) = 0;

/*
La oss si at du skal reise på ferie til Frankrike og ønsker å finne ut hvilken by
du skal reise til for å gå tur og se på museer. Skriv derfor en SQL-spørring som
finner den byen i Frankrike med opphold (0 mm. nedbør) i morgen (17.12.2020),
som har minst 3 kaféer og som har flest museer.
*/

(SELECT b.navn, COUNT(p.type) AS ant_kafeer
FROM by AS b
    INNER JOIN poi AS p USING(bid)
    INNER JOIN land AS l USING(lid)
    INNER JOIN værmelding AS v USING(bid)
WHERE p.type = 'Kafé' AND l.navn = 'Frankrike' AND v.dato = '2020-12-17' AND v.nedbor = 0
GROUP BY b.bid,b.navn
HAVING ant_kafeer > 3)
INTERSECT
(SELECT b.navn, COUNT(p.type) AS ant_Museer
FROM by AS b
    INNER JOIN poi AS p USING(bid)
    INNER JOIN land AS l USING(lid)
    INNER JOIN værmelding AS v USING(bid)
WHERE p.type = 'Musem' AND l.navn = 'Frankrike' AND v.dato = '2020-12-17' AND v.nedbor = 0
GROUP BY b.bid,b.navn
ORDER BY ant_Museer DESC
LIMIT 1);


/*
Finn navnet på alle firmaer (Customers og Suppliers) som kommer fra Norge eller Sverige. (6 rader)
*/

(SELECT c.company_name AS firmaer
 FROM customers AS c
 WHERE c.country = 'Norway' OR c.country = 'Sweden'
)
UNION
(SELECT s.company_name AS firmaer
 FROM suppliers AS s
 WHERE s.country = 'Norway' OR s.country = 'Sweden')

/*
Finn antall filmer som enten er komedier, eller som Jim Carrey har spilt i. (1 rad)
*/

SELECT COUNT(DISTINCT filmid) AS antall_filmer
FROM film
WHERE filmid IN (
(SELECT filmid AS komedier
FROM filmgenre AS fg
WHERE fg.genre = 'Comedy')
UNION
(SELECT fp.filmid AS Jim_Carrey
FROM filmparticipation AS fp
    INNER JOIN person AS p USING(personid)
WHERE p.firstname = 'Jim' AND p.lastname = 'Carrey')
);

/*
Finn produksjonsår og tittel for alle filmer som både Angelina Jolie og Antonio Banderas har deltatt i sammen (3).
*/

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

/*
Hvilke to fornavn forekommer mer enn 6000 ganger og akkurat like mange ganger? (Paul og Peter, vanskelig!)
*/

WITH
flest_forekomster AS (
    SELECT p.firstname, COUNT(*) AS antall
    FROM person AS p
    GROUP BY p.firstname
    HAVING COUNT(*) > 6000
)
SELECT p1.firstname, p2.firstname
FROM flest_forekomster AS p1
    INNER JOIN flest_forekomster AS p2 ON p1.antall = p2.antall
WHERE p1.firstname != p2.firstname;

/*
Finn produksjonsår for første og siste film Ingmar Bergman regisserte.
*/
SELECT MIN(prodyear) AS første_film, MAX(prodyear) AS siste_Film
FROM Film
    INNER JOIN Filmparticipation USING (filmid)
    INNER JOIN Person USING (personid)
WHERE firstname LIKE 'Ingmar' AND lastname Like 'Bergman' AND parttype = 'director';

/*
Finn tittel og produksjonsår for de filmene hvor mer enn 300 personer har deltatt,
uansett hvilken funksjon de har hatt (11).
*/

WITH
forekomster AS(
    SELECT f.filmid, COUNT(*) AS antall_personer
    FROM film AS f
        INNER JOIN filmparticipation AS fp USING(filmid)

)

SELECT f.title, f.prodyear
FROM film AS f

/*
Skriv en spørring som finner alle band som enten ble startet etter år 2000 eller inneholder strengen
'King' i navnet. Skriv ut navnet på bandet og datoen bandet ble startet.
*/

SELECT b.navn, b.startet
FROM band AS b
WHERE b.startet > 2000 OR b.navn LIKE '%King%';

/*
Skriv en spørring som finner navnet på alle personer født på en dato hvor det enten ble startet et
nytt band, eller ble gitt ut et nytt album.
*/
SELECT navn
FROM person
WHERE født IN (
SELECT startet
FROM band
UNION
SELECT utgitt
FROM album
);

/*
Skriv en spørring som finner antall sanger hvert band har laget (altså antall sanger på alle deres
album til sammen) for band som har laget færre enn 3 sanger. Skriv ut bandIDen, navnet på bandet og antall
sanger.
*/

SELECT b.bandid, b.navn, COUNT(s.sangid) AS antall_sanger
FROM band AS b
    INNER JOIN Album AS a USING(bandid)
    INNER JOIN Sang AS a USING(albumid)
GROUP BY b.bandid, b.navn 
HAVING antall_sanger < 3;
