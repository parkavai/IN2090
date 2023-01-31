-- Oppgave 1
/*
Skriv ut en tabell med to kolonner, først rollefigurnavn, så antall ganger
dette rollefigurnavnet forekommer i filmcharacter-tabellen. Ta bare med
navn som forekommer mer enn 2000 ganger. Sorter etter fallende hyppighet.
(90/91 rader)
*/

-- Steg 1: Hent rollefigurnavnet

-- Steg 2: Lag en variabel som angir antall ganger rollefigurnavnet dukker opp (antall)

-- Steg 3: Skal kun inkludere navnene som forekommer mer enn 2000 ganger (HAVING antall >= 2000)

-- Steg 4: Sortere etter fallende hyppighet (DESC)

SELECT fc.filmcharacter, COUNT(*) AS antall
FROM filmcharacter AS fc
GROUP BY fc.filmcharacter
HAVING COUNT(*) >= 2000
ORDER BY antall DESC;

/*
Hvilke land forekommer bare én gang i tabellen filmcountry? Resultatet
skal kun ha én kolonne som inneholder navnene på landene. (9 rader)
*/

-- Steg 1: Hent land fra filmcountry

-- Steg 2: Står at vi skal ha en kolonne som inneholder
-- navnene på landene, høres ut som GROUP BY benyttes

-- Steg 3: Tilslutt hvor hvert land forekommer kun 1 gang i tabellen

SELECT fc.country AS Land, COUNT(*)
FROM filmcountry AS fc
GROUP BY fc.country
HAVING COUNT(*) = 1;


/*
Finn antall deltagere i hver deltagelsestype (parttype) per film blant kino
filmer som har ”Lord of the Rings” som del av tittelen (hint: kinofilmer
har filmtype ’C’ i tabellen filmitem). Skriv ut filmtittel, deltagelsestype og
antall deltagere. (27 rader)
*/

-- Steg 1: Lag en antall variabel som beskriver antall deltagere for hver deltagelsestype

-- Steg 2: Hvis skal finne antall deltagere for en gitt film som "Lord of the Rings" som tittel

-- Steg 3: Tilslutt skal vi skrive filmtittel, deltagelsestype og antall deltagere for den gitte filmen hvor hver deltagelsestype

SELECT f.title, fp.parttype, COUNT(*) AS antall_deltagere
FROM filmparticipation AS fp
    INNER JOIN film AS f USING(filmid)
    INNER JOIN filmitem AS ft USING(filmid)
WHERE f.title LIKE '%Lord of the Rings%' AND ft.filmtype = 'C'
GROUP BY f.title, fp.parttype;

/*
Finn tittel og produksjonsår på filmer som både er med i sjangeren FilmNoir og Comedy.
(3 rader)
*/

-- Steg 1: Finn tittel og produksjonsår for filmer med sjanger FilmNoir

-- Steg 2: Repeter steg 1, men fokuser på Comedy

-- Steg 3: Slå disse to sammen gjennom en INTERSECT

-- INTERSECT fungerer ettersom den vil ta snittet mellom de to tabellene altså hvor vi har filmer som både er FilmNoir og Comedy

(SELECT f.title, f.prodyear
FROM film AS f
    INNER JOIN filmgenre AS fg USING(filmid)
WHERE fg.genre = 'Film-Noir')
INTERSECT
(SELECT f.title, f.prodyear
FROM film AS f
    INNER JOIN filmgenre AS fg USING(filmid)
WHERE fg.genre = 'Comedy');

/*
Hvilke TV-serier med flere enn 1000 brukerstemmer (votes) har fått den
høyeste scoren (rank) blant slike serier? Skriv ut maintitle. (3 rader)
Tips: TV-serier finnes i tabellen series, og informasjon om brukerstemmer og
score i filmrating. Husk at man kan bruke WITH dersom man vil
gjenbruke en spørring.
*/

-- Steg 1: Hent de TV-seriene som har høyest rank og lag en WITH ut av dette

-- Steg 2: Plukk ut de TV-seriene som har høyest rank og over 1000 brukerstemmer

WITH
    Hoyeste AS(
        SELECT MAX(fr.rank)
        FROM filmrating AS fr
            INNER JOIN series AS s ON (fr.filmid = s.seriesid)
        WHERE fr.votes > 1000
    )
SELECT s.maintitle
FROM filmrating AS fr
    INNER JOIN series AS s ON (fr.filmid = s.seriesid)
WHERE fr.rank = (SELECT * FROM Hoyeste) AND fr.votes > 1000;

/*
Skriv en spørring som finner tittel og antall språk (fra filmlanguage) hver
film som inneholder en karakter med navn ’Mr. Bean’ (fra filmcharacter)
har. Husk å få med også de filmene som ikke har noen språk. (20 rader)
Hint: Det kan være lurt å bruke en delspørring (gjerne med en WITHklausul) for
å finne alle filmer som har karakteren ’Mr. Bean’ først.
*/

-- Steg 1: Plukk ut de filmene som inneholder Mr. Bean i en WITHklausul

-- Steg 2: Foreta en right outer join med filmlanguage og WITHklausulen
WITH
    bean AS (
        SELECT f.title, fc.partid
        FROM filmparticipation AS fp
            INNER JOIN filmcharacter AS fc ON (fp.partid = fc.partid)
            INNER JOIN film AS f ON (fp.filmid = f.filmid)
        WHERE fc.filmcharacter = 'Mr. Bean'
    )
SELECT b.title, COUNT(fl.language) AS antall
FROM filmlanguage as fl RIGHT OUTER JOIN bean as b ON (fl.filmid = b.partid)
GROUP BY b.title;

/*
I tabellen filmcharacter kan vi si at unike rollenavn er rollenavn som bare
forekommer én gang i tabellen. Hvilke skuespillere (navn og antall filmer)
har spilt figurer med unikt rollenavn i mer enn 199 filmer? (3 eller 13 rader)
*/

-- Steg 1: Hent alle de unike rollenavnene først i en WITH-klausul

-- Steg 2: Videre ha en HAVING hvor du spesifiserer at hvert unike rollenavn forekommer kun 1 gang

-- Steg 3: Deretter JOIN WITH-spørringen med den siste halvdelen av oppgaven

WITH
    unike_rollenavn AS (
        SELECT DISTINCT fc.filmcharacter
        FROM filmcharacter as fc
        GROUP BY fc.filmcharacter
        HAVING COUNT(*) = 1
)
SELECT firstname || ' ' || lastname AS navn, COUNT(*) antall_filmer
FROM filmparticipation AS fp
    INNER JOIN person USING(personid)
    INNER JOIN filmcharacter AS fc USING(partid)
WHERE fc.filmcharacter IN(SELECT filmcharacter FROM unike_rollenavn)
GROUP BY navn
HAVING COUNT(*) > 199;

SELECT b.bandid, b.navn, COUNT(*) AS antall_sanger
FROM Band AS b
    LEFT OUTER JOIN Album AS a USING(bandId)
    LEFT OUTER JOIN Sang AS s USING(albumId)
GROUP BY b.bandid, b.navn
HAVING antall_sanger = 0;

CREATE VIEW nyeste_album(navn, band, utgitt, antall_sanger)
AS a.navn, b.band, a.utgitt, COUNT(*)
FROM album AS a
    INNER JOIN band AS b USING(albumid)
    INNER JOIN sang AS s USING(sangid)
GROUP BY a.navn, b.band, a.utgitt
ORDER BY a.utgitt DESC
LIMIT 10;

/*
Skriv en SQL-spørring som finner alle par av ulike barn som har ønsket seg det
samme. Svaret skal kun inneholde unike rader
*/

-- Steg 1: Hent ut alle barn som ønsker seg noe

WITH
ønske AS(
    SELECT DISTINCT barn.bid, barn.navn
    FROM barn
        INNER JOIN ønskeliste ON (barn.bid = ønskeliste.barn)
        INNER JOIN gave ON (gave.gid = ønskeliste.gave)
)
SELECT DISTINCT ø1.navn, ø2.navn
FROM ønske AS ø1
    INNER JOIN ønske AS ø2 USING(bid)
WHERE ø1.bid != ø2.bid;

/*
Skriv en spørring som finner de tre mest populære nyttige gavene, og de tre
mest populære unyttige gavene. Resultatet skal inneholde navn på gaven, antall
barn som ønsker gaven, samt hvorvidt den er nyttig eller ikke. Du kan benytte
view’et fra oppgave 7.
*/
(SELECT g.navn, COUNT(g.gid) AS antall_barn, true AS g.nyttig
FROM gave AS g
    INNER JOIN ønskeliste AS ø ON (g.gid = ø.gave)
WHERE g.nyttig
GROUP BY g.navn, g.gid, g.nyttig
LIMIT 3)
UNION ALL
(SELECT g.navn, COUNT(g.gid) AS antall_barn, false AS g.nyttig
FROM gave AS g
    INNER JOIN ønskeliste AS ø ON (g.gid = ø.gave)
WHERE NOT g.nyttig
GROUP BY g.navn, g.gid, g.nyttig
ORDER BY antall_barn DESC
LIMIT 3)
-- de mest populære nyttige gavene

-- de mest populære unyttige gavene

/*
Skriv en spørring som tilordner gaver til barn i henhold til følgende regler:
• Snille barn får alt de ønsker seg
• Usnille får kun nyttige ting de ønsker seg. Om de ikke ønsker seg noen
nyttige ting får de gaven med navn 'Genser'.
Spørringen skal skrive ut navnet på barnet og navnet på gaven. Merk, du kan
bruke view’et fra oppgave 7.
*/

-- Lag en spørring med alle barn som får alt de ønsker seg

(SELECT b.navn, g.navn
FROM barn AS b
    INNER JOIN ønskeliste AS ø ON (b.bid = ø.barn)
    INNER JOIN gave AS g ON (g.gid = ø.gave)
WHERE b.snill)
UNION ALL
(SELECT b.navn, g.navn
FROM barn AS b
    INNER JOIN ønskeliste AS ø ON (b.bid = ø.barn)
    INNER JOIN gave AS g ON (g.gid = ø.gave)
WHERE NOT b.snill AND g.nyttig)
UNION ALL
(SELECT b.navn, g.navn, 'Genser' AS gave
FROM barn AS b
    INNER JOIN ønskeliste AS ø ON (b.bid = ø.barn)
    INNER JOIN gave AS g ON (g.gid = ø.gave)
WHERE NOT b.snill AND NOT g.nyttig)

-- Lag en spørring med alle usnille barn som får kun nyttige ting de ønsker ellers blir det 'Genser'

/*
Skriv en SQL-spørring som finner morgendagens (17.12.2020) værmelding for
alle byer i Italia. Spørringen skal skrive ut navnet på byen, antall millimeter
regn og vindstyrken. Sorter resultatet alfabetisk på bynavn.
*/
SELECT b.navn, v.nedbør AS antall_millimeter, v.vind
FROM by AS b
    INNER JOIN land AS l USING(lid)
    INNER JOIN værmelding AS v USING(bid)
WHERE l.navn = 'Italia' AND v.dato = '2020-12-17'
ORDER BY b.navn;

/*
Skriv en SQL-spørring som finner navn, totalt antall millimeter nedbør og
gjennomsnittlig vindstyrke i romjulsuka (altså fra og med dato 24.12.2020 til og
med dato 31.12.2020) for hver by.
*/
SELECT b.navn, SUM(v.nedbør) AS total_antall_nedbør, AVG(v.vind)
FROM by AS b
    INNER JOIN land AS l USING(lid)
    INNER JOIN værmelding AS v USING(bid)
WHERE v.dato >= '2020-12-12' AND v.dato <= '31.12.2020'
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
HAVING sum(v.nedb@r) = 0 AND sum(v.vind) = 0;

/*
Skriv en SQL-kommando som lager et VIEW med navn Steder som viser dagens
værmelding (nedbør i mm. og vindstyrke) for både byer og POIs i samme tabell.
Du kan anta at dagens dato finnes i variabelen current_date (slik som i PostgreSQL).
VIEWet skal ha 4 kolonner, en med navnet på stedet, en med plassering
som er landet dersom stedet er en by og adressen dersom stedet er en POI, samt
nedbør og vindstyrke. For POIs er nedbør og vindstyrke lik byen den befinner
seg i sin nedbør og vindstyrke. Vi er kun interessert i steder som faktisk har en
posisjon, altså skal posisjon aldri være NULL. F.eks. kan innholdet i VIEWet se
slik ut:
*/

CREATE VIEW Steder(navn, posisjon, nedbør, vindstyrke)
AS b.navn, l.navn, v.nedbør,v.vind
FROM by AS b
    INNER JOIN land AS l USING(lid)
    INNER JOIN værmelding AS v USING(bid)
WHERE l.navn IS NOT NULL AND v.dato = current_date
UNION ALL
AS p.navn, p.addresse, v.nedbør,v.vind
FROM poi AS p
    INNER JOIN by AS b USING(bid)
    INNER JOIN værmelding AS v USING(bid)
WHERE p.addresse IS NOT NULL AND v.dato = current_date

/*
La oss si at du skal reise på ferie til Frankrike og ønsker å finne ut hvilken by
du skal reise til for å gå tur og se på museer. Skriv derfor en SQL-spørring som
finner den byen i Frankrike med opphold (0 mm. nedbør) i morgen (17.12.2020),
som har minst 3 kaféer og som har flest museer.
*/

-- Lag WITH-spørringer som plukker ut de byene som har minst 3 kafeer
-- og byene som har flest museer

WITH
kafeer AS (
    SELECT b.bid, b.navn, COUNT(p.type) AS ant_kafeer
    FROM by AS b
        INNER JOIN poi AS p USING(bid)
    WHERE p.type = 'Kafè'
    GROUP BY b.bid
    HAVING ant_kafeer >= 3
),
museer AS(
    SELECT b.bid, b.navn, COUNT(p.type) AS antall_museer
    FROM by AS b
        INNER JOIN poi AS p USING(bid)
    WHERE p.type = 'Museum' -- Antar at museer i databasen er beskrevet slikt siden det ikke er vist i eksempelet
    GROUP BY b.bid
    ORDER BY antall_museer DESC
    LIMIT 1
),
frankrike AS(
    SELECT b.bid, b.navn
    FROM by AS b
        INNER JOIN værmelding AS v USING(bid)
        INNER JOIN land AS l USING(lid)
    WHERE v.dato = '17.12.2020' AND v.nedbør = 0 AND v.land = 'Frankrike'
)
SELECT f.navn, m.antall_museer
FROM kafeer AS k
    INNER JOIN museer AS m USING(bid)
    INNER JOIN frankrike AS f USING(bid);
