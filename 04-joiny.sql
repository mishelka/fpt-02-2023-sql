-- address select cez inner join
SELECT a.address_id, a.address, a.address2,
           a.district, c.city, ct.country,
           a.postal_code, a.phone, a.last_update
FROM address a
   INNER JOIN city c ON a.city_id = c.city_id
   INNER JOIN country ct ON c.country_id = ct.country_id;
--    , city c, country ct
-- WHERE a.city_id = c.city_id
-- AND c.country_id = ct.country_id;

-- vyber filmy ktore nie su v inventari
SELECT f.film_id, title, inventory_id
FROM
    film f
LEFT JOIN inventory i
ON i.film_id = f.film_id
WHERE i.film_id IS NULL
ORDER BY i.film_id NULLS FIRST;

-- 1 vyber recenziu, ktora nema film
SELECT fr.review as review, f.title as film
FROM
    film f
RIGHT JOIN film_review fr
ON fr.film_id = f.film_id
WHERE fr.film_id IS NULL;

-- 2 Vyber filmy, ktore nemaju recenziu (1000-2 = 998)
select *
from film f
left join film_review fr
on fr.film_id = f.film_id
-- order by fr.review_id nulls first; --to check
where fr.review_id is null; --to filter

-- 3 Ktori zamestnanci nikomu nepozicali ani jeden film? (8)
-- vypiste ich mena, priezviska a emaily
-- vypiste aj ich adresy (!pozor na pocet, niektori zamestnanci nemaju adresu)
select * from staff s
left join rental r on s.staff_id = r.staff_id
-- order by r.rental_id nulls first; --to check
where r.rental_id is null; --to filter

-- then select data and add address:
select s.first_name, s.last_name, a.address
from staff s
    left join rental r on s.staff_id = r.staff_id
    left join address a on s.address_id = a.address_id --left aby mi pridal aj tie staffy, kde address je null
where r.rental_id is null;

--to iste s inym poradim tabuliek
select s.first_name, s.last_name, a.address
from rental r
    right join staff s on s.staff_id = r.staff_id
    left join address a on s.address_id = a.address_id
where r.rental_id is null;

--este inak
select s.first_name, s.last_name, a.address
from address a
    right join staff s on s.address_id = a.address_id
    left join rental r on s.staff_id = r.staff_id
where r.rental_id is null;

-- 4 Ktore vypozicky (rentals) este nemali ziadnu platbu? (1452)

-- = take rentals, ktore nie su referovane z tabulky payment
select *
from rental r
left join payment p on r.rental_id = p.rental_id
-- order by p.rental_id nulls first; --to check
where p.rental_id is null; --to filter

-- 4a Ku kazdej pozicke vypiste meno a priezvisko
-- zakaznika a nazov pozicaneho filmu
select c.first_name || ' ' || c.last_name as customer,
       f.title as film,
       r.*
from payment p
right join rental r on r.rental_id = p.rental_id
join inventory i on r.inventory_id = i.inventory_id
join film f on i.film_id = f.film_id
join customer c on r.customer_id = c.customer_id
-- order by p.rental_id nulls first; --to check
where p.rental_id is null; --to filter

-- Kolko ich bolo zaplatenych celkovo? (14596)
select count(*)
from payment p
join rental r on p.rental_id = r.rental_id;

-- 5 Su nejake platby,
-- ktore sa neviazu k ziadnej vypozicke (rental)? (0)
select count(*)
from payment p
left join rental r on p.rental_id = r.rental_id
where r.rental_id is null;

-- 6 Ktory zamestnanec nema ziadneho sefa?
-- Vypiste nazov jeho pozicie.
-- Mal by to byt General Manager.
select distinct sef.first_name, sef.last_name
from staff zam
right join staff sef on zam.reports_to = sef.staff_id
where zam.reports_to is not null;

-- Vypiste mena sefov vsetkych zamestnancov.
select zam.first_name, zam.last_name, zam.title
from staff zam
         left join staff sef on zam.reports_to = sef.staff_id
where zam.reports_to is null;

-- 7 Ktori zamestnanci nepracuju v ziadnom oddeleni? (0)
-- pozn. pre test si mozes znulovat niektory store_id v zamestnancoch
select * from staff s
where s.store_id is null;

-- 8 Ktorý film nebol nikdy požičaný?
-- Vypiste jeho nazov a rok vydania (1)
-- herci, ktori v nom hraju
-- adresa storu, kde ho maju

select f.title, f.release_year,
       a.first_name || ' ' || a.last_name as actors,
       add.address, c.city, ct.country
from film f
join inventory i on f.film_id = i.film_id
join film_actor fa on f.film_id = fa.film_id
join actor a on fa.actor_id = a.actor_id
join store s on i.store_id = s.store_id
join address add on s.address_id = add.address_id
join city c on add.city_id = c.city_id
join country ct on c.country_id = ct.country_id
left join rental r on i.inventory_id = r.inventory_id
where r.rental_id is null;

--check:
select *
from film f
join inventory i on f.film_id = i.film_id
full outer join rental r on i.inventory_id = r.inventory_id
order by r.rental_id nulls first; --to check

--a teraz join a filter:
select f.title
from film f
join inventory i on f.film_id = i.film_id
left join rental r on i.inventory_id = r.inventory_id
where r.rental_id is null;

-- herci, ktori v nom hraju:
select f.title, a.first_name || ' ' || a.last_name as actor
from film f
join inventory i on f.film_id = i.film_id
left join rental r on i.inventory_id = r.inventory_id
join film_actor fa on f.film_id = fa.film_id
join actor a on fa.actor_id = a.actor_id
where r.rental_id is null;

-- aj adresa obchodu, v ktorom maju film:
select
    f.title,
    a.first_name || ' ' || a.last_name as actor,
    add.address, add.city, add.country
from film f
join inventory i on f.film_id = i.film_id
left join rental r on i.inventory_id = r.inventory_id
join film_actor fa on f.film_id = fa.film_id
join actor a on fa.actor_id = a.actor_id
join store s on i.store_id = s.store_id
join full_address add on s.address_id = add.address_id
where r.rental_id is null;

-- adresa pridana bez pouzitia view:
select
    f.title,
    a.first_name || ' ' || a.last_name as actor,
    add.address, c.city, ct.country
from film f
join inventory i on f.film_id = i.film_id
left join rental r on i.inventory_id = r.inventory_id
join film_actor fa on f.film_id = fa.film_id
join actor a on fa.actor_id = a.actor_id
join store s on i.store_id = s.store_id
join address add on s.address_id = add.address_id
join city c on add.city_id = c.city_id
join country ct on c.country_id = ct.country_id
where r.rental_id is null;