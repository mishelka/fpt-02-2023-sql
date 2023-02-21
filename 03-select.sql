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

SELECT f.title, l.name FROM film f, language l
WHERE f.language_id = l.language_id
AND l.name = 'Japanese';


