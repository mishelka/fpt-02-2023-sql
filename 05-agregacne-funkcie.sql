select COUNT(DISTINCT c.name)
from film f, film_category fc, category c
where f.film_id = fc.film_id
and fc.category_id = c.category_id;

select ROUND(AVG(f.rental_rate), 1)
from film f;

select max(length(first_name)) from actor; --max dlzka mena
select max(first_name) from actor; --kto je posledny v abecede
select max(f.rental_rate) from film f;

select sum(f.rental_rate)
from film f, film_category fc, category c
where f.film_id = fc.film_id
and fc.category_id = c.category_id
and c.name = 'Action';

-- zoznam vsetkych kategorii a
-- k nim priemernu cenu pozicania filmu
select c.name,
       round(avg(f.rental_rate), 2) as avg_price
from film f, film_category fc, category c
where f.film_id = fc.film_id
and fc.category_id = c.category_id
group by c.name
having round(avg(f.rental_rate), 2) > 3;

--vypis vsetky kategorie a pocty filmov v nich,
-- kde je viac ako 70 filmov
SELECT c.name, COUNT(*)
from film f, film_category fc, category c
where f.film_id = fc.film_id
and fc.category_id = c.category_id
GROUP BY c.name
HAVING COUNT(*) > 70;

-- 1. Vypiste sumarne, kolko filmov sa nachadza v jednotlivych kategoriach.
--     Pre overenie vedzte, ze v kategorii Sports sa nachadza 74 filmov a v kategorii Music 51.
select c.name, count(fc.film_id)
from category c
inner join film_category fc on c.category_id = fc.category_id
inner join film f on fc.film_id = f.film_id
group by c.category_id, c.name
order by count(fc.film_id) desc;

-- 2 max, min, priemerna dlzka
select min(length) as min_min,
      max(length) as max_min,
      round(avg(length), 2) as avg_min_sec
from film f
inner join film_category fc on f.film_id = fc.film_id
inner join category c on fc.category_id = c.category_id
where c.name LIKE 'Sci-Fi';

-- 3. Vypiste sumarne zisky pozicovne filmov po jednotlivych dnoch v mesiaci februar. Platby mame iba za tento mesiac.
select EXTRACT(DAY from p.payment_date) as day,
       EXTRACT(MONTH from p.payment_date) as month,
       SUM(amount) as profits
from payment p
where EXTRACT(MONTH from p.payment_date) = 2
group by day, month;

--4 Vypíšte zisky z vypoziciek podľa krajiny,
-- z ktorych pochazdaju zakaznici.
-- Zoznam zoraďte podľa zisku od najvyšších po najnižšie.
select fa.country, SUM(amount) as profits
from payment p
    inner join rental r on r.rental_id = p.rental_id
    join customer c on c.customer_id = r.customer_id
    inner join full_address fa on c.address_id = fa.address_id
where DATE(p.payment_date) = '2007-02-16'
group by fa.country;

select cr.country, SUM(p.amount) as sum
from rental r
  inner join payment p using(rental_id)
  inner join customer c on p.customer_id = r.customer_id
  inner join address a using(address_id)
  inner join city ct using (city_id)
  inner join country cr using (country_id)
group by cr.country
order by sum desc;

-- 5 Kolko minul Karl Seal?
select SUM(amount)
from payment p
join customer c using(customer_id)
where c.first_name LIKE 'Karl'
  AND c.last_name LIKE 'Seal';

-- a. ktori zakaznici s menom na D minuli viac ako 100 eur?
-- meno --> filter povodnych dat --> where
-- viac ako 100 eur --> filter vysledkov --> having
select c.first_name, c.last_name, SUM(amount) as vydaje
from payment p
join customer c using(customer_id)
where c.first_name LIKE 'D%'
group by c.customer_id
having SUM(amount) > 100;

-- b. vypiste mena, priezviska a vydaje vsetkych zakaznikov
select customer.first_name, customer.last_name,
       sum(amount) as vydaje
from payment
natural join customer
group by customer_id
order by vydaje desc;

-- 6 jednoducho vypis vsetkych
select a.first_name, a.last_name, count(a.actor_id)
from rental r
join customer c on r.customer_id = c.customer_id
join inventory i on r.inventory_id = i.inventory_id
join film f on f.film_id = i.film_id
join film_actor fa on f.film_id = fa.film_id
join actor a on fa.actor_id = a.actor_id
where c.first_name = 'Karl'
and c.last_name = 'Seal'
group by a.actor_id
order by count(a.actor_id) desc;

-- 6 cez vnorene selecty
SELECT
    a.first_name || ' ' || a.last_name as actor_name,
    COUNT(*)
FROM rental r
       join customer c on r.customer_id = c.customer_id
       join inventory i on r.inventory_id = i.inventory_id
       join film f on f.film_id = i.film_id
       join film_actor fa on f.film_id = fa.film_id
       join actor a on fa.actor_id = a.actor_id
       where c.first_name = 'Karl' and c.last_name = 'Seal'
GROUP BY
    actor_name
HAVING COUNT(*) = (
    SELECT MAX(watched) FROM (
       SELECT count(*) as watched from rental r1
           join customer c1 on r1.customer_id = c1.customer_id
           join inventory i1 on r1.inventory_id = i1.inventory_id
           join film f1 on f1.film_id = i1.film_id
           join film_actor fa1 on f1.film_id = fa1.film_id
           join actor a1 on fa1.actor_id = a1.actor_id
           where c1.first_name = 'Karl' and c1.last_name = 'Seal'
           group by a1.actor_id
    ) as counts
);

select a.first_name || ' ' || a.last_name as actor_name, count(*) as watched from rental r1
   join customer c1 on r1.customer_id = c1.customer_id
   join inventory i1 on r1.inventory_id = i1.inventory_id
   join film f1 on f1.film_id = i1.film_id
   join film_actor fa1 on f1.film_id = fa1.film_id
   join actor a on fa1.actor_id = a.actor_id
   where c1.first_name = 'Karl' and c1.last_name = 'Seal'
   group by a.actor_id;

-- navod:
-- SELECT
--     category,
--     type,
--     COUNT(*)
-- FROM
--     table
-- GROUP BY
--     category,
--     type
-- HAVING
--     COUNT(*) = (SELECT MAX(C) FROM (SELECT COUNT(*) AS C FROM A GROUP BY A) AS Q)