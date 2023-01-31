DROP TABLE IF EXISTS kunde CASCADE;
DROP TABLE IF EXISTS prosjekt CASCADE;
DROP TABLE IF EXISTS ansatt CASCADE;
DROP TABLE IF EXISTS ansattDeltarIProsjekt CASCADE;

CREATE TABLE kunde(
    kundenr INT PRIMARY KEY,
    kundenavn TEXT NOT NULL,
    kundeadresse TEXT,
    postnummer TEXT,
    poststed TEXT
);

CREATE TABLE ansatt(
    ansattnr INT PRIMARY KEY,
    navn TEXT NOT NULL,
    fødselsdato DATE,
    ansattDato DATE
);

CREATE TABLE prosjekt(
    prosjektnr INT PRIMARY KEY,
    prosjektleder INT REFERENCES ansatt(ansattnr),
    prosjektnavn TEXT NOT NULL,
    kundenr INT REFERENCES kunde(kundenr),
    status TEXT CHECK (status = 'planlagt' OR status = 'aktiv' OR status = 'ferdig')
);

CREATE TABLE ansattDeltarIProsjekt(
    ansattnr int REFERENCES ansatt(ansattnr),
    prosjektnr int REFERENCES prosjekt(prosjektnr),
    CONSTRAINT deltar_pk PRIMARY KEY (ansattnr, prosjektnr)
);

INSERT INTO kunde VALUES (0, 'per', 'gateveien 1', '0001', 'Oslo'),
(1, 'kari', null, null, null);

INSERT INTO ansatt VALUES (0, 'ola', '1998-01-01', '2016-01-05'),
(1, 'nils', null, null);

INSERT INTO prosjekt VALUES (0, 0, 'topp', 1, 'aktiv');

INSERT INTO ansattDeltarIProsjekt VALUES (0,0), (1,0);

SELECT k.kundenr, k.kundenavn, k.kundeadresse
FROM kunde AS k;
