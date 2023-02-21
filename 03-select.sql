SELECT * from film; --1000

SELECT title, description from film; --len 2 stlpce

SELECT title, description
    FROM film
    WHERE title LIKE 'A%' --46
    ORDER BY title, description;

SELECT title, description
    FROM film
    WHERE title LIKE 'A%s'
    AND description LIKE '% Dog %'; --8 / 1

SELECT DISTINCT LENGTH(first_name) FROM customer
    ORDER BY LENGTH(first_name); --599

SELECT DISTINCT first_name FROM customer; --591

SELECT first_name || ' ' || last_name as full_name,
       email
    FROM customer;

SELECT 5 * 3 as result;

SELECT COUNT(*) FROM film_category;

-- priklad vsetci zamestnanci a ich full adresy
SELECT s.first_name as staff_name,
       s.last_name as staff_surname,
       a.address, c.city, a.postal_code, ct.country
    FROM address a, city c, country ct, staff s
    WHERE a.city_id = c.city_id
    AND c.country_id = ct.country_id
    AND s.address_id = a.address_id;

-- 1
SELECT
  c.first_name, c.last_name,
  ROUND(p.amount) as payment
FROM
  payment p, customer c
WHERE
  c.customer_id = p.customer_id
  AND p.amount >= 10
ORDER BY
  p.amount DESC;

-- 2 modifikovane - aj s nazvami filmov
select f.title, c.name
from
    category c, film f, film_category fc
where
    fc.film_id = f.film_id
    AND fc.category_id = c.category_id
order by c.name;

-- 3
SELECT f.title, l.name FROM film f, language l
WHERE f.language_id = l.language_id
AND l.name = 'Japanese';

-- 4 kolko akcnych filmov sa nachadza v nasej databaze? (64)
select COUNT(f.*)
from
    category c, film f, film_category fc
where
    fc.film_id = f.film_id
    AND fc.category_id = c.category_id
    AND c.name LIKE 'Action';

-- 5 vypiste pocet vsetkych filmov v obchode so store_id 1 (2270)
select COUNT(f.*)
from store s, film f, inventory i
where i.film_id = f.film_id
    and i.store_id = s.store_id
    and s.store_id = 1;

-- 6
