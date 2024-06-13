-- 1. List each pair of actors that have worked together.

select fa1.film_id, fa1.actor_id, fa2.actor_id  from sakila.film_actor as fa1
join sakila.film_actor as fa2 
on fa1.film_id= fa2.film_id  and fa1.actor_id  > fa2.actor_id




-- 2. For each film, list actor that has acted in more films.
select fa1.film_id, fa1.actor_id, as film_count from sakila.film_actor fa1
join (select actor_id,count(film_id) as amount , max(amount) from sakila.film_actor  
        group by actor_id) fa2
GROUP BY film_id,actor_id


SELECT film_id, actor_id, count(film_id)
FROM sakila.film_actor fa1
WHERE fa1.actor_id = (
    SELECT actor_id
    FROM sakila.film_actor fa2
    WHERE fa2.film_id = fa1.film_id
    GROUP BY actor_id
    ORDER BY COUNT(film_id) DESC
    LIMIT 1
);


SELECT fa.film_id, fa.actor_id, film_count.amount
FROM sakila.film_actor fa
JOIN (
    SELECT actor_id, COUNT(film_id) AS amount 
    FROM sakila.film_actor  
    GROUP BY actor_id
) AS film_count
ON fa.actor_id = film_count.actor_id;
order by film_id desc

-- Final answer from CHATGPT since i could not figure out the logic as seen above. I was missing the idea of creating  CTEs

WITH actor_film_counts AS (
    SELECT actor_id, COUNT(film_id) AS film_count
    FROM sakila.film_actor
    GROUP BY actor_id
),
max_actor_per_film AS (
    SELECT fa.film_id, fa.actor_id, afc.film_count,
           ROW_NUMBER() OVER (PARTITION BY fa.film_id ORDER BY afc.film_count DESC) AS rn
    FROM sakila.film_actor fa
    JOIN actor_film_counts afc ON fa.actor_id = afc.actor_id
)
SELECT film_id, actor_id, film_count
FROM max_actor_per_film
WHERE rn = 1;




