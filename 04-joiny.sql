-- address select cez inner join
-- SELECT a.address_id, a.address, a.address2,
--            a.district, c.city, ct.country,
--            a.postal_code, a.phone, a.last_update
-- FROM address a
--    INNER JOIN city c ON a.city_id = c.city_id
--    INNER JOIN country ct ON c.country_id = ct.country_id;
--    , city c, country ct
-- WHERE a.city_id = c.city_id
-- AND c.country_id = ct.country_id;

SELECT f.film_id, title, inventory_id
FROM
    film f
LEFT JOIN inventory i
ON i.film_id = f.film_id
WHERE i.film_id IS NULL
ORDER BY i.film_id NULLS FIRST;

--right join
SELECT fr.review as review, f.title as film
FROM
    film f
RIGHT JOIN film_review fr
ON fr.film_id = f.film_id
WHERE fr.film_id IS NULL;