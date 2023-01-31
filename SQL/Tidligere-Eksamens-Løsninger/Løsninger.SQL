/*
Skriv en spørring som finner alle band som enten ble startet etter år 2000 eller inneholder strengen
'King' i navnet. Skriv ut navnet på bandet og datoen bandet ble startet.
*/

SELECT navn , startet
FROM band
WHERE startet >= '2000 -01 -01 ' OR navn LIKE '%King%';

/*
Skriv en spørring som finner antall timer med musikk fra sjangeren 'Pop' laget av band startet
mellom år 1990 og 2000. Merk: En time er 3600 sekunder.
*/

SELECT sum(s. spilletid )/3600.0 AS timer
FROM sjanger AS sj
    INNER JOIN band AS b USING ( sjangerID )
    INNER JOIN album AS a USING (bandID)
    INNER JOIN sang AS s USING (albumID)
WHERE sj.navn = 'Pop ' AND b.startet >= '1990 -01 -01 ' AND b.startet < '2000 -01 -01 ';


/*
Skriv en spørring som finner navnet på alle personer født på en dato hvor det enten ble startet et
nytt band, eller ble gitt ut et nytt album.
*/

SELECT navn
FROM person
WHERE født IN (
    SELECT startet
    FROM band
    ) OR født IN (
    SELECT utgitt
    FROM album
);

-- eller med union av joins:

SELECT p.navn
FROM person AS p
    INNER JOIN band AS b ON (p.født = b.startet)
UNION
SELECT p.navn
FROM person AS p
    INNER JOIN album AS a ON (p.født = a.utgitt );

-- Uten Or eller union av joins
SELECT navn
FROM person
WHERE født IN (
    SELECT startet
    FROM band
    UNION
    SELECT utgitt
    FROM album
);

-- WITH

WITH
datoband AS (
     SELECT b.startet
     FROM band AS b
),
datoalbum AS (
    SELECT a.utgitt
    from album AS a
)
SELECT p.navn
FROM person AS p
    INNER JOIN datoband ON (p.dato = datoband.startet)
    INNER JOIN datoalbum ON (p.dato = datoalbum.utgitt) 

/*
Skriv en spørring som finner antall sanger hvert band har laget (altså antall sanger på alle deres
album til sammen) for band som har laget færre enn 3 sanger. Skriv ut bandIDen, navnet på bandet og antall
sanger.
*/

SELECT b.bandID , b.navn , count(s.sangID) AS antall_sanger
FROM band AS b
    LEFT OUTER JOIN album AS a USING (bandID)
    LEFT OUTER JOIN sang AS s USING (albumID)
GROUP BY b.bandID , b.navn -- b.navn ikke nødvendig (i PostgreSQL)
HAVING count(s.sangID) < 3;

/*
Skrive en SQL-kommando som sletter alle album som ikke har noen tilhørende sanger.
*/

DELETE FROM album
WHERE albumID NOT IN (
SELECT albumID
FROM sang
);

/*
Skriv en SQL-kommando som oppdaterer barnet med bid lik 0 sin snill-verdi
til false.
*/
UPDATE barn
SET snill = false
WHERE bid = 0;

/*
Skriv en spørring som finner alle barn som ønsker seg nyttige gaver som har
navn som starter med strengen 'Sokker'. Spørringen skal returnere navnet på
barnet og navnet på gaven.
*/
SELECT b.navn AS barn, g.navn AS gave
FROM barn AS b
    INNER JOIN ønskeliste AS ø ON (b.bid = ø.barn)
    INNER JOIN gave AS g ON (ø.gave = g.gid)
WHERE g.nyttig AND g.navn LIKE 'Sokker%';

/*
Skriv en SQL-spørring som finner alle par av ulike barn som har ønsket seg
det samme. Svaret skal kun inneholde unike rader. Du kan benytte VIEWet fra
oppgave 7 om du ønsker.
*/
WITH
likt_ønske AS (
    SELECT b1.barn AS barn1, b2.barn AS barn2
    FROM ønskeliste AS b1
    INNER JOIN ønskeliste AS b2 USING (gave)
    WHERE b1.barn != b2.barn
)
SELECT DISTINCT b1.navn, b2.navn
FROM likt_ønske AS l
    INNER JOIN barn AS b1 ON (l.barn1 = b1.bid)
    INNER JOIN barn AS b2 ON (l.barn2 = b2.bid);

/*
Skriv en spørring som finner de tre mest populære nyttige gavene, og de tre
mest populære unyttige gavene. Resultatet skal inneholde navn på gaven, antall
barn som ønsker gaven, samt hvorvidt den er nyttig eller ikke. Du kan benytte
view’et fra oppgave 7.
*/
SELECT gave, count(*) AS antall_ønsker, true AS nyttig
FROM oversikt
WHERE nyttig
GROUP BY gave
ORDER BY antall_ønsker DESC
LIMIT 3
UNION
SELECT gave, count(*) as antall_ønsker, false AS nyttig
FROM oversikt
WHERE NOT nyttig
GROUP BY gave
ORDER BY antall_ønsker DESC
LIMIT 3;

/*
Skriv en spørring som tilordner gaver til barn i henhold til følgende regler:
• Snille barn får alt de ønsker seg
• Usnille får kun nyttige ting de ønsker seg. Om de ikke ønsker seg noen
nyttige ting får de gaven med navn 'Genser'.
Spørringen skal skrive ut navnet på barnet og navnet på gaven. Merk, du kan
bruke view’et fra oppgave 7.
*/
WITH
usnille_med_ønsker AS (
    SELECT bid, barn, gave
    FROM oversikt
    WHERE snill = false AND
    nyttig = true
),
usnille_uten_ønkser AS (
    SELECT navn AS barn, 'Genser' AS gave
    FROM barn
    WHERE snill = false AND
    bid NOT IN (SELECT bid FROM usnille_med_ønsker)
)
SELECT barn, gave
FROM oversikt
WHERE snill = true
UNION ALL
SELECT barn, gave
FROM usnille_med_ønsker
UNION ALL
SELECT barn, gave
FROM usnille_uten_ønsker;

/*
Skriv en SQL-spørring som finner morgendagens (17.12.2020) værmelding for
alle byer i Italia. Spørringen skal skrive ut navnet på byen, antall millimeter
regn og vindstyrken. Sorter resultatet alfabetisk på bynavn.
*/
SELECT b.navn, v.nedbør, v.vind
FROM land AS l
    INNER JOIN by AS b USING (lid)
    INNER JOIN værmelding AS v USING (bid)
WHERE l.navn = 'Italia' AND v.dato = '2020-12-17'
ORDER BY b.navn;

/*
Skriv en SQL-spørring som finner navn, totalt antall millimeter nedbør og
gjennomsnittlig vindstyrke i romjulsuka (altså fra og med dato 24.12.2020 til og
med dato 31.12.2020) for hver by.
*/

SELECT b.navn, sum(v.nedbør) AS sum_nedbør, avg(v.vind) AS avg_vind
FROM by AS b INNER JOIN værmelding AS v USING (bid)
WHERE v.dato >= '2020-12-24' AND v.dato <= '2020-12-31'
GROUP BY b.bid, b.navn;

/*
Skriv en SQL-spørring som finner navn på alle byer hvor det ikke er meldt noe
regn og ikke noe vind fra og med julaften (24.12.2020) og ut året. Spørringen
skal skrive ut navnet på byene. Du kan anta at vi har værmelding (og både
nedbør og vindstyrke) for alle byer hver dag i julen.
*/
SELECT navn
FROM by
WHERE bid NOT IN (
    SELECT bid
    FROM værmelding
    WHERE dato >= '2020-12-24' AND
    dato < '2021-01-01' AND
    (nedbør > 0 OR vind > 0)
);

-- Eller --

SELECT b.navn
FROM by AS b
    INNER JOIN værmelding AS v USING (bid)
WHERE dato >= '2020-12-24' AND
dato < '2021-01-01'
GROUP BY b.bid, b.navn
HAVING sum(v.nedbør) = 0 AND sum(v.vind) = 0;

/*
La oss si at du skal reise på ferie til Frankrike og ønsker å finne ut hvilken by
du skal reise til for å gå tur og se på museer. Skriv derfor en SQL-spørring som
finner den byen i Frankrike med opphold (0 mm. nedbør) i morgen (17.12.2020),
som har minst 3 kaféer og som har flest museer.
*/
WITH
opphold_og_kafeer AS (
    SELECT b.bid, b.navn
    FROM land AS l
        INNER JOIN by AS b USING (lid)
        INNER JOIN værmelding AS v USING (bid)
        INNER JOIN poi AS p USING (bid)
    WHERE l.navn = 'Frankrike' AND
        v.dato = '2020-12-17' AND
        v.nedbør = 0 AND
        p.type = 'Kafé'
GROUP BY b.bid, b.navn
HAVING count(*) >= 3
)
SELECT o.navn, count(*) AS antall_museer
FROM opphold_og_kafeer AS o
    INNER JOIN poi AS p USING (bid)
WHERE p.type = 'Museum'
GROUP BY o.bid, o.navn
ORDER BY antall_museer DESC
LIMIT 1;

-- Eller --

WITH
opphold_og_kafeer AS (
    SELECT b.bid, b.navn
    FROM land AS l
        INNER JOIN by AS b USING (lid)
        INNER JOIN værmelding AS v USING (bid)
        INNER JOIN poi AS p USING (bid)
    WHERE l.navn = 'Frankrike' AND
    v.dato = '2020-12-17' AND
    v.nedbør = 0 AND
    p.type = 'Kafé'
    GROUP BY b.bid, b.navn
    HAVING count(*) >= 3
),
antall_museer AS (
    SELECT b.bid, count(*) AS antall_museer
    FROM by AS b
        INNER JOIN land AS l USING (lid)
        INNER JOIN poi AS p USING (bid)
    WHERE p.type = 'Museum' AND l.navn = 'Frankrike'
    GROUP BY b.bid, b.navn
),
flest_museer AS (
    SELECT *
    FROM antall_museer
    WHERE antall_museer = (SELECT max(antall_museer) FROM antall_museer)
)
SELECT ok.navn, fm.antall_museer
FROM oppholde_og_kafeer AS ok
    INNER JOIN flest_museer AS fm USING (bid);
