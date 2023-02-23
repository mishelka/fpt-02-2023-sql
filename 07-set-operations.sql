-- spojime customerov a actorov
SELECT first_name, last_name, 'actor' as TYPE
FROM actor
WHERE actor_id <= 40
UNION
SELECT first_name, last_name, 'customer' as TYPE
FROM customer
WHERE customer_id < 40 AND last_name LIKE 'M%';

SELECT first_name, last_name
FROM actor
WHERE actor_id <= 40;

SELECT first_name, last_name
FROM customer
WHERE customer_id < 40 AND last_name LIKE 'M%';

--1a
select count(*) from (
    select first_name, last_name, email
       from customer
    union all
       select first_name, last_name, email
       from staff
    union all
       select first_name, last_name, null as email
       from actor
) as u;

--intersect
select first_name, last_name
       from actor
    intersect
       select first_name, last_name
       from customer;

select first_name, last_name
       from customer --599
    except -- -1
       select first_name, last_name
       from actor;

select first_name, last_name
       from actor --200
    except -- -1
       select first_name, last_name
       from customer;

--1b cez nejaky jedinecny identifikator - no nie je isty vysledok
-- moze sa stat, ze tam budu nejake entity v oboch tabulkach s rovnakym menom, priezviskom a id,
-- vtedy nam ten jeden udaj bude chybat
--NESPRAVNE:
-- select count(*) from (
--     select customer_id as id, first_name, last_name
--        from customer
--     union
--        select staff_id as id, first_name, last_name
--        from staff
--     union
--        select actor_id as id, first_name, last_name
--        from actor
-- ) as u;

--istejsie cez union all:
select count(*) from (
    select first_name, last_name
       from customer
    union all
       select first_name, last_name
       from staff
    union all
       select first_name, last_name
       from actor
) as u;

--2 vsetci zamestnanci a zakaznici z Kanady
select last_name, first_name, address, city, country, 'employee' as TYPE
    from staff
    inner join full_address fa on staff.address_id = fa.address_id
    where country = 'Canada'
union
select last_name, first_name, address, city, country, 'customer' as TYPE
    from customer
    inner join full_address f on customer.address_id = f.address_id
    where country = 'Canada'
order by type, last_name, first_name;

--cez vnoreny union
select u.last_name, u.first_name,  address, city, country, u.TYPE
from (
    select first_name, last_name, address_id, 'employee' as TYPE
      from staff
      union
    select last_name, first_name, address_id, 'customer' as TYPE
      from customer
) as u
inner join full_address fa on u.address_id = fa.address_id
    where country = 'Canada'
order by type, last_name, first_name;

--BONUS: Vypíšte zoznam všetkých filmov (ich názvy),
-- ktoré nepatria do kategorie 'Action'. (936)
--hint: pouzite except alebo intersect
select f.title from film f
where f.film_id not in (
    select f1.film_id from film f1
    intersect
    select fc.film_id from film_category fc
       join category p on fc.category_id = p.category_id
       and p.name = 'Action'
);
--cez except
SELECT title, film_id
FROM film
EXCEPT
    SELECT f.title, f.film_id
    FROM film f
    JOIN film_category fc
       ON f.film_id=fc.film_id
    JOIN category c
       ON fc.category_id=c.category_id
    WHERE c.name LIKE 'Action';