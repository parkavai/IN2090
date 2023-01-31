--a)
UPDATE ansatt
SET ansattdato = '2019-09-20'
WHERE ansattnr = 1;

--b)
DELETE
FROM ansatt
WHERE ansattnr = 0;
