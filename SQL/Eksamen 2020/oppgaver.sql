/*
Skriv en SQL-spørring som finner morgendagens (17.12.2020) værmelding for
alle byer i Italia. Spørringen skal skrive ut navnet på byen, antall millimeter
regn og vindstyrken. Sorter resultatet alfabetisk på bynavn.
*/

SELECT b.navn, COUNT(v.nedbør) AS antall_millimeter, v.vind AS vindstyrke
FROM by AS b
    INNER JOIN værmelding AS v USING(bid)
    INNER JOIN land as l USING(lid)
WHERE l.navn = 'Italia' AND v.dato = '2020-12-17'
ORDER BY b.navn;

/*
Skriv en SQL-spørring som finner navn, totalt antall millimeter nedbør og
gjennomsnittlig vindstyrke i romjulsuka (altså fra og med dato 24.12.2020 til og
med dato 31.12.2020) for hver by.
*/

SELECT b.navn, SUM(v.nedbør) AS total_antall_nedbør, AVG(v.vind)
FROM by AS b
    INNER JOIN værmelding AS v USING(bid)
WHERE v.dato >= '2020-12-24' AND v.dato <= '2020-12-31'
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
WHERE (v.dato >= '2020-12-24' AND v.dato <= 2020-12-31)
HAVING SUM(v.nedbør) = 0 AND SUM(v.vind) = 0;

/*
Skriv en SQL-kommando som lager et VIEW med navn Steder som viser dagens
værmelding (nedbør i mm. og vindstyrke) for både byer og POIs i samme tabell.
Du kan anta at dagens dato finnes i variabelen current_date (slik som i PostgreSQL).
VIEWet skal ha 4 kolonner, en med navnet på stedet, en med plassering
som er landet dersom stedet er en by og adressen dersom stedet er en POI, samt
nedbør og vindstyrke. For POIs er nedbør og vindstyrke lik byen den befinner
seg i sin nedbør og vindstyrke. Vi er kun interessert i steder som faktisk har en
posisjon, altså skal posisjon aldri være NULL.
*/

CREATE VIEW Steder()
