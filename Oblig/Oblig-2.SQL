# Oppgave 2

# a.)

SELECT *
FROM timelistelinje
WHERE timelistelinje.timelistenr = 3;

# b.)
SELECT COUNT(*) AS antTimelister
FROM timeliste;

# c.)
SELECT * AS antikkeUtbetaltpengerfor
FROM timeliste
WHERE timeliste.status !=  'utbetalt';

# d.)
SELECT COUNT(*) AS antall, COUNT(pause) AS antallmedpause
FROM timelistelinje;

# e.)
SELECT COUNT(*) AS antikkePauser
FROM timelistelinje
WHERE timelistelinje.pause IS NULL;

# Oppgave 3

# a.)
SELECT sum(varighet)/60 AS antIkkeUtbetalt
FROM timeliste AS t INNER JOIN varighet AS v ON (t.timelistenr = v.timelistenr)
WHERE t.status != 'utbetalt';

# b.)
SELECT DISTINCT t.timelistenr, t.beskrivelse
FROM timeliste AS t INNER JOIN timelistelinje AS tl ON (t.timelistenr = tl.timelistenr)
WHERE tl.beskrivelse LIKE '%test%' OR tl.beskrivelse LIKE '%Test%';

# c.)
SELECT sum(varighet)/60*200 AS UtbetaltePenger
FROM timeliste AS t INNER JOIN varighet AS v ON (t.timelistenr = v.timelistenr)
WHERE t.status = 'utbetalt';

# Oppgave 4

# a.)
/*
NATURAL JOIN vil ikke fungere da NATURAL JOIN slår sammen kolonner som har identiske
kolonnenavn. I dette tilfellet, tilsvarer den identiske kolonnen hvor timelistenr tilsvarer 2,
og har beskrivelse "Innføring". Dette er fordi både timeliste og timelistelinje
har disse attributtene i seg som er følgende: timelistenr og beskrivelse. Dette er
da grunnen til hvorfor vi får forskjellig returverdi for begge spørringene. Den andre spørringen
vil da skrive ut antallet hvor både timeliste og timelistelinje, har samme timelistenr så
vi kan forvente en større returverdi enn spørringen med NATURAL JOIN.
*/

# b.)
/*
Akkurat som forrige så vil NATURAL JOIN slå sammen kolonner med identiske kolonnenavn.
Det enese som både varighet og timeliste deler, er da timelistenr. Derfor så får vi
34 antall rader for denne spørringen da det eneste som er likt mellom begge tabellene
er at de har lik timelistenr og ingen andre attributter. Den andre spørringen vil returnere
antallet hvor både varighet og timeliste har samme timelistenr. Dermed så får vi at begge
spørringene gir samme antall i dette tilfellet.
*/
