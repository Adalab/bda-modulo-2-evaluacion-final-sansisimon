USE `sakila`;

-- 1.Selecciona todos los nombres de las películas sin que aparezcan duplicados.
/* NOTA: la tabla de peliculas no tiene nombres de pelis con duplicados, porque todos los resultados 
a las query devuelven el mismo número de filas*/
-- COMPROBACIONES:
SELECT title
FROM film; -- 1000 rows

SELECT title
FROM film
GROUP BY title; -- 1000 rows

/* solución: */
SELECT DISTINCT title
FROM film; -- 1000 rows


-- **********************************************************************************************************************************
-- 2. muestra los nombres de todas las películas que tengan una clasificación de "PG-13"
-- solución:
SELECT title
FROM film
WHERE rating = 'PG-13'; -- 223 rows

-- comprobación:
SELECT rating, COUNT(title)
FROM film
GROUP BY rating; -- comprobamos que PG-13 son 223 registros


-- **********************************************************************************************************************************
-- 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción
SELECT title, description
FROM film
WHERE description LIKE '%amazing%';


-- **********************************************************************************************************************************
-- 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos
/* nota Sandra: Entendemos que la columna "length" es "duración". La columna viene expresada en minutos y 
es de tipo UNSIGNED (que impide negativos)*/
SELECT title
FROM film
WHERE length > 120;


-- **********************************************************************************************************************************
-- 5. Recupera los nombres de todos los actores
SELECT first_name, last_name
FROM actor;  


-- **********************************************************************************************************************************
-- 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido
SELECT first_name, last_name
FROM actor
WHERE last_name LIKE '%Gibson%';


-- **********************************************************************************************************************************
-- 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20
SELECT first_name, last_name
FROM actor
WHERE actor_id BETWEEN 10 AND 20;


-- **********************************************************************************************************************************
-- 8. Encuentra el título de las películas en la tabla `film` que no sean ni "R" ni "PG-13" en cuanto a su clasificación
SELECT title
FROM film
WHERE NOT rating = 'R' AND NOT rating = "PG-13";


-- **********************************************************************************************************************************
-- 9. Encuentra la cantidad total de películas en cada clasificación de la tabla `film` y muestra la clasificación junto con el recuento
SELECT rating, COUNT(rating)
FROM film
GROUP BY rating; -- > comprobación: La suma de todos los count = 1000. Es correcto porque 1000 = numero de registros total de la tabla film.


-- **********************************************************************************************************************************
-- 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y 
-- apellido junto con la cantidad de películas alquiladas
/*----------------------------
sucio pregunta 10:
-------------------------*/
SELECT *
FROM film; -- film_id

SELECT *
FROM inventory; -- film_id, inventory_id

SELECT *
FROM customer; -- customer_id, first_name, last_name// 599 rows

SELECT *
FROM rental; -- inventory_id, customer_id

/*----------------------------
solución pregunta 10:
-------------------------*/
SELECT  c.customer_id, 
		CONCAT(c.first_name, ' ', c.last_name) AS nombre_completo, 
        COUNT(f.film_id) AS cantidad_pelis_alquiladas
			FROM film AS f
			INNER JOIN inventory AS i
			USING (film_id)
			INNER JOIN rental AS r
			USING (inventory_id)
			INNER JOIN customer AS c
			USING(customer_id)
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY c.customer_id; -- comprobación: nos devuelve 599 registros, que es el total de num clientes


-- **********************************************************************************************************************************
-- 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el 
-- recuento de alquileres
/*----------------------------
sucio pregunta 11:
-------------------------*/
SELECT *
FROM rental; -- rental_id, inventory_id // 16.044 rows

SELECT *
FROM inventory; -- film_id, inventory_id// 4.581 rows

SELECT *
FROM film_category; -- film_id, category_id// 1000 rows

SELECT *
FROM category; -- category_id, name // 16 rows

/*----------------------------
Solución pregunta 11:
-------------------------*/
SELECT c.name, COUNT(r.rental_id) AS cantidad_pelis_alquiladas
	FROM rental AS r
	INNER JOIN inventory AS i
	USING(inventory_id)
	INNER JOIN film_category AS f
	USING(film_id)
	INNER JOIN category AS c
	USING(category_id)
GROUP BY  c.name; 
-- > comprobación: 16.044 rows antes de agrupar (= num de rental_id) y 16 rows tras la argupación (= num categorías)


-- **********************************************************************************************************************************
-- 12. Encuentra el promedio de duración de las peliculas para cada clasificación de la tabla film y muestra la clasificación 
-- junto con el promedio de duración
/*----------------------------
sucio pregunta 12:
-------------------------*/
SELECT *
FROM film; -- film_id, 1000 rows 

SELECT *
FROM film_category; -- film_id, category_id// 1000 rows

SELECT *
FROM category; -- category_id, name // 16 rows

/*----------------------------
Solución pregunta 12:
-------------------------*/
SELECT c.name, ROUND(AVG(f.length),2) AS promedio_duracion_in_min
	FROM film AS f
	INNER JOIN film_category AS fc 
	USING(film_id)
	INNER JOIN category AS c
	USING(category_id)
GROUP BY c.category_id, c.name;


-- **********************************************************************************************************************************
-- 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love"
/*----------------------------
Solución pregunta 13:
-------------------------*/
SELECT a.first_name, a.last_name
	FROM actor AS a
	INNER JOIN film_actor AS fa
	USING(actor_id)
	INNER JOIN film AS f
	USING(film_id)
WHERE f.title = "Indian Love"; -- 10 rows returned

/*----------------------------
comprobación pregunta 13:
-------------------------*/
SELECT film_id
FROM film
WHERE title = "Indian Love"; -- film_id = 458

SELECT actor_id
FROM film_actor
WHERE film_id = '458'; -- 10 rows 

-- **********************************************************************************************************************************
-- 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción
SELECT title
FROM film
WHERE description LIKE '%dog%' OR 
		description LIKE '%cat%'; -- 167 rows

-- **********************************************************************************************************************************
-- 15. Hay algún actor o actriz que no aparezca en ninguna película de la tabla film_actor?
/*----------------------------
sucio pregunta 15:
-------------------------*/
SELECT actor_id
FROM actor
GROUP BY actor_id; -- 200 rows

SELECT actor_id
FROM film_actor
GROUP BY actor_id; -- 200 rows, En ppio, parece posible que el output de la pregunta 15 = "nada"

/*----------------------------
Solución pregunta 15:
-------------------------*/    
SELECT a.first_name, a.last_name
	FROM actor AS a
    WHERE a.actor_id NOT IN (SELECT actor_id
								FROM film_actor AS fa); -- lista de IDs de actores dentro de la tabla film_actor


-- **********************************************************************************************************************************
-- 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.
-- solución:
SELECT title
FROM film
WHERE release_year BETWEEN 2005 AND 2010; 

-- comprobación:
SELECT title, release_year
FROM film
WHERE release_year BETWEEN 2005 AND 2010;-- Parece que todas las pelis fueron lanzadas en 2006 (1.000 rows)

-- **********************************************************************************************************************************
-- 17. Encuentra el titulo de todas las películas que son de la misma categoría que "Family"
/* ---------------------
sucio ejercicio 17:
----------------------*/
-- filtro de categoría family (=categoría 8):
SELECT category_id
FROM category
WHERE name = 'Family'; 

-- lista de pelis de la categoría 8:
SELECT film_id
FROM film_category
WHERE category_id = (SELECT category_id
						FROM category
						WHERE name = 'Family');
/* ---------------------
solución ejercicio 17: buscar una peli dentro de una lista de pelis
----------------------*/
SELECT title
FROM film
WHERE film_id IN (SELECT film_id
					FROM film_category
					WHERE category_id = (SELECT category_id
											FROM category
											WHERE name = 'Family'));


-- **********************************************************************************************************************************
-- 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas
/* ---------------------
sucio ejercicio 18:
----------------------*/
-- Actores y sus apariciones en pelis:
SELECT actor_id, COUNT(film_id) AS apariciones_en_pelis
FROM film_actor
GROUP BY actor_id; -- >Por el output de esta subconsulta (200 rows), parece que todos los actores aparecen en más de 10 pelis

-- Actores que aparecen en más de 10 pelis:
SELECT actor_id, COUNT(film_id) AS apariciones_en_pelis
FROM film_actor
GROUP BY actor_id
HAVING COUNT(film_id) > 10; -- 200 rows

-- dejamos la subconsulta con una columna en el output:
SELECT actor_id
FROM film_actor
GROUP BY actor_id
HAVING COUNT(film_id) > 10; -- 200 rows

/* ---------------------
solución ejercicio 18: nombre y apellido de los actores que aparecen en más de 10 películas
----------------------*/
SELECT first_name, last_name
FROM actor 
WHERE actor_id IN (SELECT actor_id
					FROM film_actor
					GROUP BY actor_id
					HAVING COUNT(film_id) > 10);
                    
-- NOTA: actor_id Susan Davis: 101 y 110. Entendemos que son dos personas diferentes porque cada una tiene sus películas


-- **********************************************************************************************************************************
-- 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film
SELECT title
FROM film
WHERE rating = 'R' AND length > 120;


-- **********************************************************************************************************************************
-- 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 min y muestra
-- el nombre de la categoría junto con el promedio de duración.
SELECT c.name AS nombre_categoria, ROUND(AVG(f.length),2) AS promedio_duracion
	FROM category AS c
	INNER JOIN film_category AS fc 
	USING(category_id)
	INNER JOIN film AS f
	USING(film_id)
GROUP BY c.category_id, c.name
HAVING AVG(f.length) > 120;


-- **********************************************************************************************************************************
-- 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad 
-- de películas en las que han actuado.
SELECT  COUNT(fa.film_id) AS cantidad_pelis, CONCAT(a.first_name, ' ', a.last_name) AS nombre_actor
FROM actor AS a
INNER JOIN film_actor AS fa
USING(actor_id)
GROUP BY  a.actor_id
HAVING COUNT(film_id) >= 5
ORDER BY cantidad_pelis DESC; -- 200 rows, 

/* NOTA: Tenemos dos actor_id para el nombre Susan Davis: 101 y 110. Entendemos que son dos personas diferentes porque cada una tiene 
sus películas. Por eso agrupo por actor_id y no por CONCAT(a.first_name, ' ', a.last_name) AS nombre_actor , porque si no me cuenta 
las pelis de las dos Susan Davis en la misma fila*/


-- **********************************************************************************************************************************
-- 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una subconsulta para 
-- encontrar los reltal_ids con una duracion superior a 5 días y luego selecciona las películas correspondientes.
/* ---------------------
sucio ejercicio 22:
----------------------*/
SELECT *
FROM film; -- film_id

SELECT *
FROM inventory;-- film_id, inventory_id

SELECT *
FROM rental; -- rental_id, inventory_id

-- Lista id de alquileres que tiene un una duracion de alquiler superior a 5 días
SELECT  rental_id,
		DATE(rental_date) AS fecha_alquiler, 
		DATE(return_date) AS fecha_devolucion,
		(DATE(return_date) - DATE(rental_date)) AS duracion_alquiler
FROM rental
WHERE (DATE(return_date) - DATE(rental_date)) > 5; -- 8495 rows

-- cambiamos el select de la subquery (a sólo con una columna en el output)
SELECT  rental_id
FROM rental
WHERE (DATE(return_date) - DATE(rental_date)) > 5; -- 8495 rows

/* ---------------------
solución ejercicio 22: películas que fueron alquiladas por más de 5 días.
----------------------*/
SELECT DISTINCT f.title
	FROM film AS f
	INNER JOIN inventory AS i
	USING(film_id)
	INNER JOIN rental
	USING(inventory_id)
WHERE rental_id IN (SELECT  rental_id
					FROM rental
					WHERE (DATE(return_date) - DATE(rental_date)) > 5); -- 958 pelis en esa situacion (están agrupadas)


-- **********************************************************************************************************************************
-- 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "horror". 
-- Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego 
-- exclúyelos de la lista de actores.
/* ---------------------
sucio ejercicio 23:
----------------------*/
-- Actores que han actuado en películas de la categoría "Horror"
SELECT actor_id, a.first_name, a.last_name, c.name
	FROM actor AS a
	INNER JOIN film_actor AS fa
	USING(actor_id)
	INNER JOIN film_category AS fc
	USING(film_id)
	INNER JOIN category AS c
	USING(category_id)
WHERE c.name = 'horror';

-- Preparamos la subquery dejándola sólo con una columna en el output (Lista de ids de los actores que actúan en pelis de horror):
SELECT actor_id
	FROM actor AS a
	INNER JOIN film_actor AS fa
	USING(actor_id)
	INNER JOIN film_category AS fc
	USING(film_id)
	INNER JOIN category AS c
	USING(category_id)
WHERE c.name = 'horror'
GROUP BY actor_id; -- 156 rows

/* ---------------------
solución ejercicio 23: nombre y apellido de los actores que no han actuado en ninguna película de la categoría "horror"
----------------------*/
SELECT first_name, last_name
FROM actor
WHERE actor_id NOT IN (SELECT actor_id
						FROM actor AS a
						INNER JOIN film_actor AS fa
						USING(actor_id)
						INNER JOIN film_category AS fc
						USING(film_id)
						INNER JOIN category AS c
						USING(category_id)
					WHERE c.name = 'horror'
                    GROUP BY actor_id); -- 44 rows // comprobación: total artist_id = 200// 200-44 = 156

-- **********************************************************************************************************************************
-- 24. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 min en la tabla film.
/* ---------------------
sucio ejercicio 24:
----------------------*/
SELECT *
FROM film; -- film_id

SELECT *
FROM film_category; -- film_id, category_id

SELECT *
FROM category; -- category_id

SELECT f.title, c.name, f.length
	FROM film AS f
	INNER JOIN film_category AS fc
	USING(film_id)
	INNER JOIN category AS c
	USING(category_id)
WHERE c.name = 'comedy'
		AND f.length > 180; -- 3 rows
        
/* ---------------------
solución ejercicio 24:
----------------------*/
SELECT f.title
	FROM film AS f
	INNER JOIN film_category AS fc
	USING(film_id)
	INNER JOIN category AS c
	USING(category_id)
WHERE c.name = 'comedy'
		AND f.length > 180;


-- **********************************************************************************************************************************
-- 25.Encuentra todos los actores que han actuado juntos en al menos una película. La consulta debe mostrar el nombre 
-- y apellido de los actores y el número de películas en las que han actuado juntos

/* ---------------------
sucio ejercicio 25:
----------------------*/

/* IMPORTANTE: Cuando se define una CTE con WITH, su alcance es exclusivamente dentro de la consulta inmediatamente siguiente, 
por ejemplo, actor1 y actor2, sólo pueden ser utilizadas dentro de la consulta que sigue a WITH y no persisten después de que 
esa consulta se ejecuta.*/

-- PASO 1.Elaboro tabla de todos los actores que tienen en común una peli con otro actor (correlaciones):
WITH actor1 AS (SELECT a1.actor_id AS actor_id1, f1.film_id AS film_id
					FROM actor AS a1
					INNER JOIN film_actor  AS f1
					USING(actor_id)), -- > para poner varias CTEs una detrás de otra, hay que poner una coma entre las CTEs

	actor2 AS (SELECT a2.actor_id AS actor_id2, f2.film_id AS film_id
					FROM actor AS a2
					INNER JOIN film_actor  AS f2
					USING(actor_id)) -- > OJO! aquí no hay coma porque se acaban los WITH

SELECT actor1.actor_id1 AS id_1, 
		actor1.film_id AS peli_id,
        actor2.actor_id2 AS id_2
	FROM actor1 
	INNER JOIN actor2
	USING(film_id)
WHERE actor1.actor_id1 <> actor2.actor_id2;
-- -----------------------------------------------------
-- PASO 2. Con las correlaciones del punto (1), cuento las coincidencias entre los actores (añado otra CTE más):
WITH 
actor1 AS (SELECT a1.actor_id AS actor_id1, f1.film_id AS film_id
				FROM actor AS a1
				INNER JOIN film_actor  AS f1
				USING(actor_id)), 

actor2 AS (SELECT a2.actor_id AS actor_id2, f2.film_id AS film_id
				FROM actor AS a2
				INNER JOIN film_actor  AS f2
				USING(actor_id)),-- > Añadimos otra coma porque hacemos otro WITH

correlaciones AS (SELECT actor1.actor_id1 AS id_1, 
						actor1.film_id AS peli_id,
						actor2.actor_id2 AS id_2
							FROM actor1 
							INNER JOIN actor2
							USING(film_id)
						WHERE actor1.actor_id1 <> actor2.actor_id2)  -- > sin coma porque se acaban los WITH

SELECT id_1, COUNT(peli_id) AS coincidencias, id_2
FROM correlaciones
GROUP BY  id_1, id_2;

-- -----------------------------------------------------
-- PASO 3. Con las coincidencias del punto (2), añado los nombres (con otra CTE más):
WITH 
actor1 AS (SELECT a1.actor_id AS actor_id1, f1.film_id AS film_id
				FROM actor AS a1
				INNER JOIN film_actor  AS f1
				USING(actor_id)), 

actor2 AS (SELECT a2.actor_id AS actor_id2, f2.film_id AS film_id
				FROM actor AS a2
				INNER JOIN film_actor  AS f2
				USING(actor_id)),

correlaciones AS (SELECT actor1.actor_id1 AS id_1, 
						actor1.film_id AS peli_id,
						actor2.actor_id2 AS id_2
							FROM actor1 
							INNER JOIN actor2
							USING(film_id)
						WHERE actor1.actor_id1 <> actor2.actor_id2),  -- > Añadimos otra coma porque hacemos otro WITH

pelis_coincidentes AS (SELECT id_1, COUNT(peli_id) AS coincidencias, id_2
							FROM correlaciones
							GROUP BY  id_1, id_2)

SELECT p.id_1, act_1.first_name, act_1.last_name, p.coincidencias, p.id_2, act_2.first_name, act_2.last_name
	FROM pelis_coincidentes AS p
	INNER JOIN actor AS act_1 -- > tabla actores original, no se puede usar la CTE de actor1
	ON p.id_1 = act_1.actor_id
	INNER JOIN actor AS act_2 -- > tabla actores original, no se puede usar la CTE de actor2
	ON p.id_2 = act_2.actor_id
WHERE p.id_1 >  p.id_2 -- > para eliminar falsos "duplicados". Paso de tener 20.868 a 10.434 rows (justo la mitad)
ORDER BY p.coincidencias DESC, p.id_1, p.id_2;

/* ---------------------
solución ejercicio 25: ejercicio final (igual que el Paso 3 pero ajustando el SELECT)
----------------------*/
WITH 
actor1 AS (SELECT a1.actor_id AS actor_id1, f1.film_id AS film_id
				FROM actor AS a1
				INNER JOIN film_actor  AS f1
				USING(actor_id)), 

actor2 AS (SELECT a2.actor_id AS actor_id2, f2.film_id AS film_id
				FROM actor AS a2
				INNER JOIN film_actor  AS f2
				USING(actor_id)),

correlaciones AS (SELECT actor1.actor_id1 AS id_1, 
						actor1.film_id AS peli_id,
						actor2.actor_id2 AS id_2
							FROM actor1 
							INNER JOIN actor2
							USING(film_id)
						WHERE actor1.actor_id1 <> actor2.actor_id2),  -- > Añadimos otra coma porque hacemos otro WITH

pelis_coincidentes AS (SELECT id_1, COUNT(peli_id) AS coincidencias, id_2
							FROM correlaciones
							GROUP BY  id_1, id_2)

SELECT act_1.first_name, act_1.last_name, p.coincidencias, act_2.first_name, act_2.last_name
	FROM pelis_coincidentes AS p
	INNER JOIN actor AS act_1 -- > tabla actores original, no se puede usar la CTE de actor1
	ON p.id_1 = act_1.actor_id
	INNER JOIN actor AS act_2 -- > tabla actores original, no se puede usar la CTE de actor2
	ON p.id_2 = act_2.actor_id
WHERE p.id_1 >  p.id_2 -- > para eliminar falsos "duplicados". Paso de tener 20.868 a 10.434 rows (justo la mitad)
ORDER BY p.coincidencias DESC, p.id_1, p.id_2;
