--a)
SELECT kundenr, kundenavn, adresse
FROM kunde;

--b)
SELECT DISTINCT a.navn
FROM ansatt AS a INNER JOIN prosjekt AS p ON (a.ansattnr = p.prosjektleder);

--c)
SELECT a.ansattnr
FROM ansatt AS a
     INNER JOIN ansattDeltarIProsjekt AS ap
       ON (a.ansattnr = ap.ansattnr)
     INNER JOIN prosjekt AS p
       ON (ap.prosjektnr = p.prosjektnr)
WHERE p.prosjektnavn = 'Ruter app';

--d)
SELECT a.ansattnr
FROM ansatt AS a
     INNER JOIN ansattDeltarIProsjekt AS ap
       ON (a.ansattnr = ap.ansattnr)
     INNER JOIN prosjekt AS p
       ON (ap.prosjektnr = p.prosjektnr)
     INNER JOIN kunde AS k
       ON (p.kundenr = k.kundenr)
WHERE k.kundenavn = 'NSB';
