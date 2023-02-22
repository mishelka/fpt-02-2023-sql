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


-- 6 vypiste adriesy vsetkych obchodov (2)
-- BONUS: pridajte aj mena a emaily ich manazerov
-- BONUS: k adrese pridajte aj mesto a krajinu
DROP VIEW IF EXISTS full_address;
CREATE VIEW full_address AS
    SELECT a.address_id, a.address, a.address2,
           a.district,
           c.city_id, c.city,
           ct.country_id, ct.country,
           a.postal_code, a.phone, a.last_update
    FROM address a, city c, country ct
    WHERE a.city_id = c.city_id
    AND c.country_id = ct.country_id;

select s.store_id,
       st.first_name || ' ' || st.last_name as manager,
       a.address, a.city, a.country
from full_address as a,
     store as s,
     staff as st
where
    s.address_id = a.address_id
    and s.manager_staff_id = st.staff_id;

-- 7 ktore filmy zatial neboli vratene? Vypiste ich id (183)
-- BONUS: Nazvy tychto filmov vypiste velkymi pismenami. (183)
select UPPER(f.title)
from film f, rental r, inventory i
where f.film_id = i.film_id
and r.inventory_id = i.inventory_id
and r.return_date is null;

-- 8 ktorych zakaznikov mame zo strednej Europy?
-- ('Austria', 'Czech Republic', 'Hungary', 'Poland', 'Slovakia') (14)
select * from customer
inner join full_address fa on customer.address_id = fa.address_id
where fa.country IN ('Austria', 'Czech Republic', 'Hungary', 'Poland', 'Slovakia');

-- 9 Nahraďte emaily zákazníkov s menami začínajúcimi sa
-- na ‘T’ na email@gmail.com a zákazníkov s menami
-- začínajúcimi sa na ‘M’ na email@yahoo.com (32 a 51).
update customer
    set email = 'email@email.com'
where customer.first_name LIKE 'T%';
update customer
    set email = 'email@yahoo.com'
where customer.first_name LIKE 'M%';

-- 10 Zistite, koľko trvá film Extraordinary Conquerer.
-- Originál je v minútach, ale skúste to vypísať v sekundách.
select f.title,
       (f.length)*60 as duration_in_seconds
from film f
where f.title like 'Extraordinary Conquerer';

-- 11 Vypiste adresy zoradene podla okresu (district) abecedne (vzostupne),
-- pričom prázdne okresy (null) budú zobrazené ako prvé
-- (pre kontrolu, prázdnych okresov je 3ks)
select * from full_address fa
order by fa.district nulls first;

-- 12 Vypiste zoznam filmov, v ktorych hral James Pitt (31).
select * from film
inner join film_actor fa on film.film_id = fa.film_id
inner join actor a on fa.actor_id = a.actor_id
where a.first_name = 'James'
and a.last_name = 'Pitt';

-- 13 Vypiste nazvy pozicanych (rentals) filmov, ktore sa uskutocnili v roku 2006
-- (treba pouzit funkciu EXTRACT na vybratie roku) (182)
select f.title from rental r
inner join inventory i on r.inventory_id = i.inventory_id
inner join film f on i.film_id = f.film_id
where EXTRACT(YEAR from r.rental_date) = 2006;

-- BONUS: pridajte aj adresu obchodu, z ktoreho boli pozicane
-- a priezvisko zamestnanca, ktory filmy pozical
select f.title, s.first_name,
       s.last_name, a.address, c.city, ct.country
from rental r
    inner join inventory i on r.inventory_id = i.inventory_id
    inner join film f on i.film_id = f.film_id
    inner join staff s on r.staff_id = s.staff_id
    inner join store st on s.staff_id = st.manager_staff_id
    inner join address a on s.address_id = a.address_id --da sa nahradit s full_address
    inner join city c on a.city_id = c.city_id
    inner join country ct on c.country_id = ct.country_id
where EXTRACT(YEAR from r.rental_date) = 2006;

-- to iste cez where:
select f.title, s.first_name, s.last_name, a.address, c.city, ct.country
from rental r, inventory i, film f, staff s, store st, address a, city c, country ct
where r.inventory_id = i.inventory_id
    and i.film_id = f.film_id
    and r.staff_id = s.staff_id
    and s.staff_id = st.manager_staff_id
    and s.address_id = a.address_id --da sa nahradit s full_address
    and a.city_id = c.city_id
    and c.country_id = ct.country_id
and EXTRACT(YEAR from r.rental_date) = 2006;