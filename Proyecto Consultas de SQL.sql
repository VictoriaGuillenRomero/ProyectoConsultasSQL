--2. Muestra los nombres de todas las películas con una clasificación por edades de ‘R’.

SELECT "title", f.rating 
FROM film f 
WHERE f.rating = 'R';

--3. Encuentra los nombres de los actores que tengan un “actor_id” entre 30 y 40.

SELECT CONCAT(a.first_name ,' ', a.last_name ) AS "Actores"
FROM actor a ;

--4. Obtén las películas cuyo idioma coincide con el idioma original.

SELECT f.title 
FROM film f 
WHERE f.original_language_id IS NOT NULL;
--No hay referencia a si es versión original, y todas están en idioma 1 Inglés--

--5. Ordena las películas por duración de forma ascendente.

SELECT f.title , f.rental_duration 
FROM film f 
ORDER BY f.rental_duration ASC;

--6. Encuentra el nombre y apellido de los actores que tengan ‘Allen’ en su apellido.

SELECT a.first_name ,a.last_name 
FROM actor a 
WHERE a.last_name ='ALLEN';

--7. Encuentra la cantidad total de películas en cada clasificación de la tabla “film” y muestra la clasificación junto con el recuento.

SELECT  f.special_features ,COUNT(f.special_features)
FROM film f 
GROUP BY f.special_features ;

--8. Encuentra el título de todas las películas que son ‘PG-13’ o tienen una duración mayor a 3 horas en la tabla film.

SELECT  f.title , f.rating , f.rental_duration 
FROM film f 
WHERE f.rating = 'PG-13'OR f.rental_duration >'3';

--9. Encuentra la variabilidad de lo que costaría reemplazar las películas.

SELECT  VARIANCE(f.rental_rate )
FROM film f ;

--10. Encuentra la mayor y menor duración de una película de nuestra BBDD.

SELECT  MAX(f.length )AS "duracion_maslarga",MIN(f.length )AS "duracion_mascorta"
FROM film f ;

--11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día.

SELECT  r.rental_id ,r.rental_date , p.amount 
FROM rental r 
INNER JOIN payment p 
ON r.rental_id = p.rental_id 
WHERE p.rental_id = '16048';

--12. Encuentra el título de las películas en la tabla “film” que no sean ni ‘NC-17’ ni ‘G’ en cuanto a su clasificación.

SELECT  f.title , f.rating 
FROM film f 
WHERE f.rating NOT IN ('NC-17','G');

--13. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra 
--la clasificación junto con el promedio de duración.

SELECT  f.special_features , AVG (f.length)
FROM film f 
GROUP BY f.special_features;

--14. Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos.

SELECT  f.title , f.length 
FROM film f 
WHERE f.length > '180';

--15. ¿Cuánto dinero ha generado en total la empresa?

SELECT  SUM(p.amount ) AS "pagos_totales"
FROM payment p ;

--16. Muestra los 10 clientes con mayor valor de id.

SELECT  c.customer_id , c.first_name, c.last_name 
FROM customer c 
ORDER BY c.customer_id DESC 
LIMIT 10;

--17. Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igby’.

SELECT  f.film_id ,f.title, fa.actor_id, a.first_name , a.last_name  
FROM film f 
	INNER JOIN film_actor fa 
	ON fa.film_id  = f.film_id
	INNER JOIN actor a 
	ON a.actor_id = fa.actor_id 
WHERE f.title  = 'EGG IGBY';

--18. Selecciona todos los nombres de las películas únicos.

SELECT  title, f.special_features , f.length 
FROM film f 
WHERE f.special_features = ;

--19. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla “film”.

SELECT  f.title , c."name" , f.length 
FROM film f 
	INNER JOIN film_category fc  
	ON f.film_id = fc.film_id 
	INNER JOIN category c 
	ON c.category_id = fc.category_id
WHERE c."name" = 'Comedy'
AND f.length  > '180';

--20. Encuentra las categorías de películas que tienen un promedio de duración superior a 110 minutos y muestra el nombre de la categoría
--junto con el promedio de duración.

SELECT  c."name" , AVG(f.length )
FROM film f 
	INNER JOIN film_category fc  
	ON f.film_id = fc.film_id 
	INNER JOIN category c 
	ON c.category_id = fc.category_id
GROUP BY c."name" 
HAVING AVG(f.length ) > '110';

--21. ¿Cuál es la media de duración del alquiler de las películas?

SELECT  *
FROM rental r ;

--22. Crea una columna con el nombre y apellidos de todos los actores y actrices.

SELECT CONCAT(a.first_name ,' ', a.last_name ) AS "Actores"
FROM actor a ;

--23. Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente.

SELECT DISTINCT f.title
FROM film f
JOIN inventory i
    ON f.film_id = i.film_id
JOIN rental r
    ON i.inventory_id = r.inventory_id
WHERE DIFF (r.return_date,r.rental_date) > 8
ORDER BY f.title;

--24. Encuentra las películas con una duración superior al promedio.

SELECT f.title, f.length 
FROM film f 
WHERE f.length > (
	SELECT AVG(f.length)
	FROM film f
);

--25. Averigua el número de alquileres registrados por mes.

SELECT EXTRACT (MONTH FROM r.rental_date) AS "Numero_mes", count(*) AS "Alquileres"
FROM rental r 
GROUP BY EXTRACT (MONTH FROM r.rental_date) 
ORDER BY EXTRACT (MONTH FROM r.rental_date);

--26. Encuentra el promedio, la desviación estándar y varianza del total pagado.

SELECT AVG(p.amount) AS "Prom_pagado",
	STDDEV(p.amount) AS "Desv_std_pagado",
	VARIANCE(p.amount) AS "Varianza_pagado"
FROM payment p;

--27. ¿Qué películas se alquilan por encima del precio medio?

SELECT f.title AS "Pelicula", AVG(p.amount) AS "Precio_medio"
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY f.film_id, f.title
HAVING AVG(p.amount) > (
    SELECT AVG(amount)
    FROM payment
);

--28. Muestra el id de los actores que hayan participado en más de 40 películas.

SELECT actor_id 
FROM film_actor
GROUP BY actor_id
HAVING COUNT(film_id) > 40;

--29. Obtener todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible.

SELECT
    f.film_id ,f.title AS "Película",
    COUNT(i.inventory_id) AS "Cantidad_disponible"
FROM film f
LEFT JOIN inventory i
    ON f.film_id = i.film_id
GROUP BY f.film_id, f.title
ORDER BY "Cantidad_disponible" DESC;

--30. Obtener los actores y el número de películas en las que ha actuado.

SELECT
    CONCAT(a.first_name , ' ', a.last_name ) AS "Nombre_actor",
    COUNT (fa.actor_id ) AS "Numero_películas"
FROM actor a 
JOIN film_actor fa 
    ON a.actor_id =fa.actor_id 
GROUP BY "Nombre_actor" 
ORDER BY "Numero_películas" DESC ;

--31. Obtener todas las películas y mostrar los actores que han actuado en
--ellas, incluso si algunas películas no tienen actores asociados.

SELECT
    f.title AS "Nombre_pelicula",
    CONCAT (a.first_name,' ', a.last_name) AS "Nombre_actor"
FROM film f
LEFT JOIN film_actor fa
    ON f.film_id = fa.film_id
LEFT JOIN actor a
    ON fa.actor_id = a.actor_id
ORDER BY "Nombre_pelicula" ;

--32. Obtener todos los actores y mostrar las películas en las que han
--actuado, incluso si algunos actores no han actuado en ninguna película.

SELECT
    CONCAT(a.first_name,' ',a.last_name) AS "Nombre_actor",
    f.title AS "Titulo_pelicula"
FROM actor a
LEFT JOIN film_actor fa
    ON a.actor_id = fa.actor_id
LEFT JOIN film f
    ON fa.film_id = f.film_id
ORDER BY "Nombre_actor";

--33. Obtener todas las películas que tenemos y todos los registros de alquiler.

SELECT
    f.film_id,
    f.title AS "Nombre_pelicula",
    COUNT(r.rental_id) AS "Total_alquileres"
FROM film f
LEFT JOIN inventory i
    ON f.film_id = i.film_id
LEFT JOIN rental r
    ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, "Nombre_pelicula" 
ORDER BY "Total_alquileres"  ASC;

--34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.

SELECT
    c.customer_id,
    CONCAT(c.first_name,' ', c.last_name) AS "Nombre_cliente",
    SUM(p.amount) AS "Total_gastado"
FROM customer c
INNER JOIN payment p
    ON c.customer_id = p.customer_id
GROUP BY c.customer_id, "Nombre_cliente" 
ORDER BY "Total_gastado" DESC
LIMIT 5;

--35. Selecciona todos los actores cuyo primer nombre es 'Johnny'.

SELECT a.first_name , a.last_name 
FROM actor a 
WHERE a.first_name = 'JOHNNY';

--36. Renombra la columna “first_name” como Nombre y “last_name” como Apellido.

SELECT a.first_name AS "Nombre", a.last_name AS "Apellido"
FROM actor a 
WHERE a.first_name = 'JOHNNY';

--37. Encuentra el ID del actor más bajo y más alto en la tabla actor.

SELECT
    a.actor_id,
    CONCAT(a.first_name,' ', a.last_name) AS "Nombre_actor"
FROM actor a
WHERE a.actor_id = (
    SELECT MIN(actor_id)
    FROM actor
)
OR a.actor_id = (
    SELECT MAX(actor_id)
    FROM actor
);

--38. Cuenta cuántos actores hay en la tabla “actor”.

SELECT COUNT (a.actor_id ) AS "Numero_actores"
FROM actor a;

--39. Selecciona todos los actores y ordénalos por apellido en orden ascendente.

SELECT a.first_name , a.last_name 
FROM actor a
ORDER BY a.last_name ASC;

--40. Selecciona las primeras 5 películas de la tabla “film”.

SELECT f.film_id , f.title 
FROM film f 
ORDER BY f.film_id 
LIMIT 5;

--41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre. ¿Cuál es el nombre más repetido?

SELECT a.first_name AS "Nombre_repetido", COUNT(a.first_name ) AS "Numero_repeticiones"
FROM actor a 
GROUP BY a.first_name 
ORDER BY "Numero_repeticiones" DESC;

--42. Encuentra todos los alquileres y los nombres de los clientes que los realizaron.

SELECT
    r.rental_id, CONCAT(c.first_name, ' ', c.last_name) AS "Cliente"
FROM rental r
INNER JOIN customer c
    ON r.customer_id = c.customer_id;

--43. Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.

SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS "Cliente",
    COUNT(r.rental_id) AS "Total_alquileres"
FROM customer c
INNER JOIN rental r
    ON c.customer_id = r.customer_id
GROUP BY c.customer_id, "Cliente" 
ORDER BY "Total_alquileres" ASC;

--44. Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor esta consulta? ¿Por qué? Deja después de la consulta la contestación.

SELECT
    f.title,
    c.name AS "Categoria"
FROM film f
CROSS JOIN category c;

-- No suele aportar valor para obtener información real de la base de datos.--
-- Un CROSS JOIN genera todas las combinaciones posibles entre las filas de ambas tablas.--
-- Es decir, cada película se combinará con cada categoría, independientemente de si esa película pertenece realmente a dicha categoría.--
-- Y el resultado es una tabla nueva de 1000 id de películas x 16 id de categoría = 16.000--
-- No puede tener cada película las 16 categoría asociadas --

SELECT COUNT( c.category_id  )
FROM category c  

SELECT COUNT( f.film_id   )
FROM film f 

--45. Encuentra los actores que han participado en películas de la categoría 'Action'.

SELECT a.actor_id, CONCAT(a.first_name,' ', a.last_name) AS "Nombre_actor", f.title AS "Nombre_pelicula", c."name" 
FROM actor a
JOIN film_actor fa
    ON a.actor_id = fa.actor_id
JOIN film f
    ON fa.film_id = f.film_id
JOIN film_category fc
    ON f.film_id = fc.film_id
JOIN category c
    ON fc.category_id = c.category_id
WHERE c.name = 'Action';

--46. Encuentra todos los actores que no han participado en películas.

SELECT a.actor_id, CONCAT(a.first_name,' ', a.last_name) AS "Nombre_actor"
FROM actor a
LEFT JOIN film_actor fa
    ON a.actor_id = fa.actor_id
WHERE fa.film_id IS NULL;

--47. Selecciona el nombre de los actores y la cantidad de películas en las que han participado.

SELECT
	CONCAT(a.first_name,' ', a.last_name) AS "Nombre_actor",
    COUNT(fa.film_id) AS "Nº_peliculas"
FROM actor a
JOIN film_actor fa
    ON a.actor_id = fa.actor_id
GROUP BY "Nombre_actor" 
ORDER BY "Nº_peliculas" DESC;

--48. Crea una vista llamada “actor_num_peliculas” que muestre los nombres de los actores y el número de películas en las que han participado.

CREATE VIEW actor_num_peliculas AS
SELECT
	CONCAT (a.first_name,' ', a.last_name) as "Nombre_actor",
    COUNT (fa.film_id) AS "Nº_peliculas"
FROM actor a
JOIN film_actor fa
    ON a.actor_id = fa.actor_id
GROUP by "Nombre_actor" 
ORDER BY "Nº_peliculas" DESC;

--49. Calcula el número total de alquileres realizados por cada cliente.

SELECT
    CONCAT (c.first_name,' ', c.last_name) AS "Nombre_cliente",
    COUNT (r.rental_id ) AS "Nº_alquileres"
FROM customer c
LEFT JOIN rental r
    ON c.customer_id = r.customer_id
GROUP BY "Nombre_cliente" 
ORDER BY "Nº_alquileres" DESC;

--50. Calcula la duración total de las películas en la categoría 'Action'.

SELECT
    SUM(f.length) AS "Duracion_accion"
FROM film f
JOIN film_category fc
    ON f.film_id = fc.film_id
JOIN category c
    ON fc.category_id = c.category_id
WHERE c.name = 'Action';

--51. Crea una tabla temporal llamada “cliente_rentas_temporal” para almacenar el total de alquileres por cliente.

WITH "cliente_rentas_temporal" AS (
	SELECT
	    CONCAT (c.first_name,' ', c.last_name) AS "Nombre_cliente",
	    COUNT(r.rental_id ) AS "Nº_alquileres"
	FROM customer c
	LEFT JOIN rental r
	    ON c.customer_id = r.customer_id
	GROUP BY "Nombre_cliente" 
	ORDER BY "Nº_alquileres" DESC
)
SELECT "Nombre_cliente", "Nº_alquileres"
FROM  "cliente_rentas_temporal";

--52. Crea una tabla temporal llamada “peliculas_alquiladas” que almacene las películas que han sido alquiladas al menos 10 veces.

WITH "peliculas_alquiladas" AS (
	SELECT
	    f.title AS "Nombre_película" ,
	    COUNT(r.rental_id ) AS "Nº_alquileres"
	FROM film f 
	JOIN inventory i 
	    ON i.film_id =f.film_id 
	JOIN rental r 
		ON i.inventory_id =r.inventory_id 
	GROUP BY f.title  
	HAVING COUNT(r.rental_id ) >10
)
SELECT "Nombre_película" , "Nº_alquileres"
FROM  "peliculas_alquiladas";

--53. Encuentra el título de las películas que han sido alquiladas por el cliente con el nombre ‘Tammy Sanders’ y que
--aún no se han devuelto. Ordena los resultados alfabéticamente por título de película.

SELECT CONCAT (c.first_name , ' ', c.last_name ) AS "Nombre_cliente", f.title AS "Peli_no_devuelta"
FROM customer c
JOIN rental r
    ON c.customer_id = r.customer_id
JOIN inventory i
    ON r.inventory_id = i.inventory_id
JOIN film f
    ON i.film_id = f.film_id
WHERE c.first_name = 'TAMMY'
  AND c.last_name = 'SANDERS'
  AND r.return_date IS NULL
ORDER BY f.title ASC;

--54. Encuentra los nombres de los actores que han actuado en al menos una película que pertenece a la categoría ‘Sci-Fi’. 
--Ordena los resultados alfabéticamente por apellido.

SELECT CONCAT (a.first_name , ' ', a.last_name  ) AS "Nombre_actores", f.title AS "Peli_Sci-Fi"
FROM actor a
JOIN film_actor fa
    ON a.actor_id = fa.actor_id
JOIN film f
    ON fa.film_id = f.film_id
JOIN film_category fc
    ON fa.film_id = fc.film_id
JOIN category c
    ON fc.category_id = c.category_id
WHERE c.name = 'Sci-Fi'
ORDER BY "Nombre_actores" ASC;

--55. Encuentra el nombre y apellido de los actores que han actuado en películas que se alquilaron después de que la película
--‘Spartacus Cheaper’ se alquilara por primera vez. Ordena los resultados alfabéticamente por apellido.

SELECT CONCAT(a.last_name ,' ', a.first_name ) AS "Nombre_actor",
	COUNT (a.actor_id )
FROM actor a
JOIN film_actor fa
    ON a.actor_id = fa.actor_id
JOIN film f
    ON fa.film_id = f.film_id
JOIN inventory i
    ON f.film_id = i.film_id
JOIN rental r
    ON i.inventory_id = r.inventory_id
WHERE r.rental_date >
      (
          SELECT MIN(r2.rental_date)
          FROM rental r2
          JOIN inventory i2
              ON r2.inventory_id = i2.inventory_id
          JOIN film f2
              ON i2.film_id = f2.film_id
          WHERE f2.title = 'SPARTACUS CHEAPER'
      )
GROUP BY a.actor_id
ORDER BY "Nombre_actor" ASC;

--56. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría ‘Music’.

SELECT a.actor_id , CONCAT(a.first_name,' ', a.last_name) AS "Nombre_actor"
FROM actor a
WHERE a.actor_id NOT IN (
    SELECT fa.actor_id
    FROM film_actor fa
    JOIN film_category fc
        ON fa.film_id = fc.film_id
    JOIN category c
        ON fc.category_id = c.category_id
    WHERE c.name = 'Music'
)
ORDER BY a.actor_id  ;

--57. Encuentra el título de todas las películas que fueron alquiladas por más de 8 días.

SELECT DISTINCT f.title
FROM film f
JOIN inventory i
    ON f.film_id = i.film_id
JOIN rental r
    ON i.inventory_id = r.inventory_id
WHERE r.return_date - r.rental_date > INTERVAL '8 days'
ORDER BY f.title ;

--58. Encuentra el título de todas las películas que son de la misma categoría Que ‘Animation’.

SELECT f.film_id , f.title
FROM film f
JOIN film_category fc
    ON f.film_id = fc.film_id
JOIN category c
    ON fc.category_id = c.category_id
WHERE c.name = 'Animation'
ORDER BY f.title;

--59. Encuentra los nombres de las películas que tienen la misma duración que la película con el título ‘Dancing Fever’.
--Ordena los resultados alfabéticamente por título de película.

SELECT  f.film_id ,f.title  
FROM film f 
WHERE f.length  = (
    SELECT f2.length 
    FROM film f2 
    WHERE f2.title = 'DANCING FEVER'
)
ORDER BY f.title ;

--60. Encuentra los nombres de los clientes que han alquilado al menos 7 películas distintas. Ordena los resultados alfabéticamente por apellido.

SELECT 
	c.customer_id ,
	CONCAT(c.last_name ,' ', c.first_name ) AS "Nombre_cliente",
    COUNT(DISTINCT i.film_id) AS "Nº_peliculas"
FROM customer c
JOIN rental r
    ON c.customer_id = r.customer_id
JOIN inventory i
    ON r.inventory_id = i.inventory_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(DISTINCT i.film_id) >= 7
ORDER BY "Nombre_cliente" ASC;

--61. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.

SELECT
    c.name AS "Categoria",
    COUNT(r.rental_id) AS "Nº_alquileres"
FROM category c
JOIN film_category fc
    ON c.category_id = fc.category_id
JOIN inventory i
    ON fc.film_id = i.film_id
JOIN rental r
    ON i.inventory_id = r.inventory_id
GROUP BY "Categoria" ;

--62. Encuentra el número de películas por categoría estrenadas en 2006.

SELECT
    c.name AS "Categoria",
    COUNT(f.film_id ) AS "Nº_peliculas"
FROM category c
JOIN film_category fc
    ON c.category_id = fc.category_id
JOIN film f
    ON fc.film_id = f.film_id
WHERE f.release_year = 2006
GROUP BY "Categoria" ;

--63. Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos.

--No entiendo qué se me pide, qué se supone que debería mostrar por eso está sin hacer. Supongo que será algo con JOIN, pero no sé cual es el objetivo.


--64. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, 
--su nombre y apellido junto con la cantidad de Películas alquiladas.

SELECT
    c.customer_id,
    CONCAT (c.first_name,' ', c.last_name) AS "Nombre_cliente",
    COUNT(r.rental_id) AS "Peliculas_alquiladas"
FROM customer c
JOIN rental r
    ON c.customer_id = r.customer_id
GROUP BY c.customer_id
ORDER BY "Peliculas_alquiladas"  DESC;





















