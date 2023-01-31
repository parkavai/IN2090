# 1
/*
Finn ut hvor mange produksjoner (altså alt som forekommer I filmparticipation-tabellen)
hver person med etternavn 'Abbott' har deltatt i (husk å få med de som har deltatt i 0 filmer). (243 rader)
*/
SELECT p.personid, p.firstname, p.lastname, COUNT(p.personid) AS produksjoner
FROM filmparticipation AS fp RIGHT OUTER JOIN person AS p USING (personid)
WHERE p.lastname = 'Abbott'
GROUP BY p.personid, p.firstname, p.lastname;

# 2
/*
Finn tittel på alle Western-filmer laget etter 2007 som ikke har en rating. (14 rader)
*/

-- a.)
SELECT f.title
FROM film AS f
     INNER JOIN filmgenre AS g USING (filmid)
WHERE f.filmid NOT IN (SELECT filmid FROM filmrating) AND
      g.genre = 'Western' AND
      f.prodyear > 2007;
);

-- b.)
SELECT f.title
FROM film AS f
     INNER JOIN filmgenre AS g USING (filmid)
     LEFT OUTER JOIN filmrating AS r USING (filmid)
WHERE r.filmid IS NULL AND
      g.genre = 'Western' AND
      f.prodyear > 2007;
-- c.)
SELECT title
FROM film
WHERE prodyear > 2007 AND
      filmid IN (
        (SELECT filmid
         FROM filmgenre
         WHERE genre = 'Western')
        EXCEPT
        (SELECT filmid
         FROM filmrating));

-- d.)
SELECT f.title
FROM film AS f
     INNER JOIN filmgenre AS fg
     USING (filmid)
WHERE f.prodyear > 2007 AND
      fg.genre = 'Western' AND
      NOT EXISTS (
        SELECT *
        FROM filmrating AS r
        WHERE r.filmid = f.filmid);

# 3
/*
Finn antall filmer som enten er komedier, eller som Jim Carrey har spilt i. (1 rad)
*/

SELECT count(DISTINCT filmid) AS nr_movies
FROM film
WHERE filmid IN (
    (SELECT filmid
     FROM filmgenre
     WHERE genre = 'Comedy')
    UNION
    (SELECT fp.filmid
     FROM person AS p
          INNER JOIN filmparticipation AS fp
          USING (personid)
     WHERE p.firstname = 'Jim' AND p.lastname = 'Carrey'));

-- eller

SELECT count(*) AS nr_movies
FROM (SELECT DISTINCT filmid
      FROM film
      WHERE filmid IN (
          (SELECT filmid
           FROM filmgenre
           WHERE genre = 'Comedy')
          UNION
          (SELECT fp.filmid
           FROM person AS p
                INNER JOIN filmparticipation AS fp
                USING (personid)
           WHERE p.firstname = 'Jim' AND p.lastname = 'Carrey'))) AS t;

-- Finn tittel på alle filmer som som Jim Carrey har spilt i, men som ikke er komedier. (62 rader)
# 4
SELECT title
FROM film
WHERE filmid IN (
   (SELECT fp.filmid
    FROM person AS p
         INNER JOIN filmparticipation AS fp
         USING (personid)
    WHERE p.firstname = 'Jim' AND p.lastname = 'Carrey')
           EXCEPT
   (SELECT filmid
    FROM filmgenre
    WHERE genre = 'Comedy'));

-- eller

SELECT f.title
FROM film AS f
    INNER JOIN filmparticipation AS fp USING (filmid)
    INNER JOIN person AS p USING (personid)
WHERE p.firstname = 'Jim' AND
     p.lastname = 'Carrey' AND
     f.filmid NOT IN
       (SELECT filmid
        FROM filmgenre
        WHERE genre = 'Comedy');

/*
Finn navnet på alle firmaer (Customers og Suppliers) som kommer fra Norge eller Sverige. (6 rader)
*/
# 5
(SELECT company_name
 FROM customers
 WHERE country = 'Sweden' OR
       country = 'Norway')
UNION
(SELECT company_name
 FROM suppliers
 WHERE country = 'Norway' OR
       country = 'Sweden');

/*
Bruk EXISTS for å finne navnet på alle kunder som har kjøpt Pavlova. (31 rader)
*/
# 6
SELECT c.company_name
FROM customers AS c
WHERE EXISTS (
   SELECT *
   FROM orders AS o
        INNER JOIN order_details AS d USING (order_id)
        INNER JOIN products AS p USING (product_id)
   WHERE o.customer_id = c.customer_id AND
         p.product_name = 'Pavlova');

/*
Finn ut hvor mange kunder som befinner seg i samme land som hver leverandør (Supplier).
Resultatet skal være to kolonner, en med leverandørnavnet, og en kolonne med antall kunder
fra samme land. Sorter resultatet etter antall kunder I synkende rekkefølge. (29 rader)
*/
# 7
SELECT s.company_name, count(c.customer_id) AS num_customers
FROM suppliers AS s
     LEFT OUTER JOIN customers AS c
       USING (country)
GROUP BY s.supplier_id
ORDER BY num_customers DESC;
