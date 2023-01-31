-- Oppgave 1
/*
Skriv ut en tabell med to kolonner, først rollefigurnavn, så antall ganger
dette rollefigurnavnet forekommer i filmcharacter-tabellen. Ta bare med
navn som forekommer mer enn 2000 ganger. Sorter etter fallende hyppighet.
(90/91 rader)
*/
SELECT fc.filmcharacter, COUNT(*) AS antall_forekomst
FROM filmcharacter AS fc
GROUP BY fc.filmcharacter
HAVING COUNT(fc.filmcharacter) > 2000
ORDER BY COUNT(fc.filmcharacter) DESC;

-- Oppgave 2
/*
Hvilke land forekommer bare én gang i tabellen filmcountry? Resultatet
skal kun ha én kolonne som inneholder navnene på landene. (9 rader)
*/

SELECT fc.country AS Land
FROM filmcountry AS fc
GROUP BY fc.country
HAVING COUNT(fc.country) = 1;

-- Oppgave 3
/*
Finn antall deltagere i hver deltagelsestype (parttype) per film blant kino
filmer som har ”Lord of the Rings” som del av tittelen (hint: kinofilmer
har filmtype ’C’ i tabellen filmitem). Skriv ut filmtittel, deltagelsestype og
antall deltagere. (27 rader)
*/
SELECT f.title, fp.parttype, COUNT(fp.parttype) AS antall_deltagere
FROM filmparticipation AS fp
    INNER JOIN film AS f USING (filmid)
    INNER JOIN filmitem AS fi USING (filmid)
WHERE f.title LIKE '%Lord of the Rings%' AND fi.filmtype = 'C'
GROUP BY f.title, fp.parttype;

-- Oppgave 4
/*
Finn tittel og produksjonsår på filmer som både er med i sjangeren FilmNoir og Comedy.
(3 rader)
*/

SELECT f.title, f.prodyear
FROM film as f
    INNER JOIN filmgenre AS noir USING(filmid)
    INNER JOIN filmgenre AS comedy USING(filmid)
WHERE noir.genre = 'Film-Noir' AND comedy.genre = 'Comedy';

-- Oppgave 5
/*
Hvilke TV-serier med flere enn 1000 brukerstemmer (votes) har fått den
høyeste scoren (rank) blant slike serier? Skriv ut maintitle. (3 rader)
Tips: TV-serier finnes i tabellen series, og informasjon om brukerstemmer og
score i filmrating. Husk at man kan bruke WITH dersom man vil
gjenbruke en spørring.
*/

WITH
    titler AS (
        SELECT MAX(fr.rank)
        FROM filmrating AS fr
        INNER JOIN series as s ON (fr.filmid = s.seriesid)
        WHERE fr.votes > 1000
)
SELECT s.maintitle
FROM series AS s
    INNER JOIN filmrating AS fr ON (fr.filmid = s.seriesid)
WHERE fr.votes > 1000 AND fr.rank IN (SELECT * FROM titler)
GROUP BY s.maintitle;

-- Oppgave 6
/*
Skriv en spørring som finner tittel og antall språk (fra filmlanguage) hver
film som inneholder en karakter med navn ’Mr. Bean’ (fra filmcharacter)
har. Husk å få med også de filmene som ikke har noen språk. (20 rader)
Hint: Det kan være lurt å bruke en delspørring (gjerne med en WITHklausul) for
å finne alle filmer som har karakteren ’Mr. Bean’ først.
*/

WITH
    bean AS (
        SELECT f.title, fc.partid
        FROM filmparticipation as fp
            INNER JOIN filmcharacter as fc ON (fp.partid = fc.partid)
            INNER JOIN film as f ON (fp.filmid = f.filmid)
        WHERE fc.filmcharacter = 'Mr. Bean'
    )
SELECT b.title, COUNT(fl.language) AS antall
FROM filmlanguage as fl RIGHT OUTER JOIN bean as b ON (fl.filmid = b.partid)
GROUP BY b.title;

-- Oppgave 7
/*
I tabellen filmcharacter kan vi si at unike rollenavn er rollenavn som bare
forekommer én gang i tabellen. Hvilke skuespillere (navn og antall filmer)
har spilt figurer med unikt rollenavn i mer enn 199 filmer? (3 eller 13 rader)
*/
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
