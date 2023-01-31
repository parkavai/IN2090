DROP TABLE IF EXISTS kunde CASCADE;
DROP TABLE IF EXISTS prosjekt CASCADE;
DROP TABLE IF EXISTS ansatt CASCADE;
DROP TABLE IF EXISTS ansattDeltarIProsjekt CASCADE;

CREATE TABLE kunde (
    kundenr int PRIMARY KEY,
    kundenavn text NOT NULL,
    kundeAdresse text ,
    postnr text,
    poststed text
);

CREATE TABLE ansatt (
    ansattnr int PRIMARY KEY,
    navn text NOT NULL,
    foedselsdato date,
    ansattDato date
);

CREATE TABLE prosjekt (
    prosjektnr int PRIMARY KEY,
    prosjektleder int REFERENCES ansatt(ansattnr),
    prosjektnavn text NOT NULL,
    kundenr int REFERENCES kunde(kundenr),
    status text CHECK (status = 'planlag' OR status = 'aktiv' OR status = 'ferdig')
);

CREATE TABLE ansattDeltarIProsjekt(
    ansattnr int REFERENCES ansatt(ansattnr),
    prosjektnr int REFERENCES prosjekt(prosjektnr),
    CONSTRAINT deltar_pk PRIMARY KEY(ansattnr, prosjektnr)
);
