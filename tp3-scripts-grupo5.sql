USE sakila;

#1.1)
INSERT INTO customer (store_id,first_name, last_name, email, address_id, active, create_date)
	   VALUES ('1','TONY', 'STARK', 'anthony.stark@stark-industries.com', '10', TRUE, current_timestamp());

#1.2)
INSERT INTO staff (first_name, last_name, address_id, email, store_id, active , username, password, last_update)
VALUES ('Thor', 'Odin Son', '5', 'thor@asgard.gov', '2','1', 'thor', 'avengers', NOW());

#1.3)
INSERT INTO customer (customer_id, store_id,first_name, last_name, email, address_id, active, create_date)    
VALUES ('603','1','TONY', 'STARK', 'anthony.stark@stark-industries.com', '10', TRUE, current_timestamp());

#1.4)
DELETE FROM film_actor;
INSERT INTO film_actor (actor_id, film_id, last_update) 
	SELECT (SELECT MIN(actor_id) FROM actor), film.film_id, NOW()
    FROM film;

#1.5)
UPDATE film_actor
SET actor_id = (SELECT actor_id FROM actor WHERE first_name = 'JENNIFER' AND last_name = 'DAVIS')
WHERE film_id = '20';

#1.6)
UPDATE rental
SET rental_date = '2004-12-23' 
WHERE rental_id = '5';

#1.7)
UPDATE payment, rental SET amount = amount*0.9 
WHERE payment.payment_date = rental.rental_date;

#1.8)
UPDATE rental 
SET staff_id = 3
WHERE staff_id=1;

#1.9)
DELETE FROM rental WHERE rental_date < '2005-05-30';

#1.10)
DELETE FROM staff where email is NULL;

#1.11)
SELECT staff_id, first_name, last_name
FROM staff
WHERE first_name LIKE '%JON%';

#1.12)
SELECT COUNT(*) FROM rental WHERE rental_date>'2005-06-30';

#1.13)
SELECT i.film_id, count(*) 
FROM film AS f 
	JOIN inventory AS i USING(film_id)  
		JOIN rental as r using(inventory_id) 
GROUP BY i.film_id;

#1.14)
SELECT * FROM rental WHERE rental_date BETWEEN '2005-12-20' AND '2006-01-10';

#1.15)
SELECT *
FROM rental 
WHERE DATEDIFF(return_date, rental_date)>2;

#1.16)
SELECT COUNT(DISTINCT customer_id) 
FROM rental 
WHERE rental_date > '2006-01-31';

#1.17)Basado en que el campo clave es autoincremental
INSERT INTO staff(first_name,last_name,address_id,store_id,username) 
VALUES('Black','Widow',1,1,'nat.romanoff');

#1.18) Basado en que el campo clave es autoincremental
INSERT INTO category(name)
VALUES('NOMBRE');

#1.19)
CREATE TEMPORARY TABLE temp_customer SELECT * FROM customer;
SET FOREIGN_KEY_CHECKS=0;
DELETE FROM customer;
UPDATE temp_customer SET customer_id = customer_id+1;
INSERT INTO customer(customer_id,store_id,first_name,last_name,email,address_id,active,create_date,last_update) 
SELECT* FROM temp_customer;
UPDATE customer SET customer_id = customer_id-1;
SET FOREIGN_KEY_CHECKS=1;

#1.20)
UPDATE address SET phone = CONCAT('9-', phone);

#1.21)
UPDATE film SET rental_duration = rental_duration+2 
WHERE rental_rate<10;

#1.22)
SELECT * 
FROM rental r
ORDER BY r.rental_id DESC LIMIT 1;

#1.23)
SELECT DISTINCT s.last_name
FROM staff AS s, (	SELECT s1.last_name, COUNT(*) AS rep_apellidos
				FROM staff AS s1
                GROUP BY s1.last_name) AS t1
WHERE s.last_name = t1.last_name AND t1.rep_apellidos > 1;

#1.24)
SELECT COUNT(*) AS 'Cant. por fecha'
FROM (SELECT DATE(r.rental_date) AS date_rental
	  FROM rental r) AS t1
GROUP BY t1.date_rental;

#1.25)
CREATE VIEW vw_promedio_dias AS 
(SELECT film_id AS Pelicula, AVG(TIMESTAMPDIFF(DAY, r.rental_date, r.return_date)) AS Promedios
FROM (rental AS r JOIN inventory AS i USING(inventory_id)) JOIN film AS f USING(film_id)
WHERE r.return_date IS NOT NULL
GROUP BY film_id);
 
SELECT * FROM vw_promedio_dias;
 
#1.26)
CREATE VIEW vw_empleados_pagos AS
(SELECT staff_id AS Empleado, COUNT(payment_id) Cantidad_Pagos
FROM staff AS s JOIN payment AS p USING(staff_id)
GROUP BY staff_id 
HAVING COUNT(*) > 10);
  
SELECT * FROM vw_empleados_pagos;
  
#1.27)
SELECT c.first_name AS Nombre, c.last_name AS Apellido, a.address AS Domicilio, a.phone AS Telefono
FROM address AS a JOIN customer AS c USING(address_id)
WHERE a.address REGEXP '[0-9] A'
LIMIT 10;
  
SELECT c.first_name AS Nombre, c.last_name AS Apellido, a.address AS Domicilio, a.phone AS Telefono
FROM address AS a JOIN customer AS c USING(address_id)
WHERE a.address LIKE 'A%' AND a.phone = ''
LIMIT 10;
  
#1.28)
SELECT r.rental_date, c.first_name, c.last_name, f.title, s.first_name, s.last_name
FROM rental AS r, film AS f, inventory AS i, customer AS c, staff AS s
WHERE r.inventory_id = i.inventory_id AND
	  r.customer_id = c.customer_id AND
	  r.staff_id = s.staff_id AND
	  i.film_id = f.film_id
LIMIT 20;

#1.29)
SELECT r.rental_id AS RentalID, datediff(return_date, rental_date) AS DiasPrestado, p.amount AS monto
FROM rental AS r, payment AS p
WHERE r.rental_id = p.rental_id
LIMIT 10;

#1.30)
SELECT c.customer_id AS Cliente, c.first_name AS Nombre, c.last_name AS Apellido, r1.rental_id AlquierNro
FROM ((SELECT r.customer_id, SUM(p.amount)
	   FROM rental r JOIN payment p USING(customer_id)
       GROUP BY r.customer_id
       HAVING SUM(p.amount) > 250) AS tab JOIN customer c USING(customer_id)) 
JOIN rental r1 USING(customer_id)
LIMIT 10;
  
#1.31)
SELECT DISTINCT(c.customer_id) AS Cliente, c.first_name AS Nombre, c.last_name AS Apellido
FROM (customer AS c JOIN rental AS r USING(customer_id)) JOIN staff AS s USING(staff_id)
WHERE s.first_name LIKE 'Jon' and s.last_name LIKE 'Stephens'
ORDER BY c.customer_id
LIMIT 10;

#1.32)
SELECT c.customer_id, c.first_name, c.last_name, DATE(r.rental_date), count(*) 'Cantidad de rentas'
FROM customer c JOIN rental r USING(customer_id) 
GROUP BY c.customer_id, DATE(r.rental_date)
HAVING COUNT(*)>1
LIMIT 10;

#1.33)
SELECT s.staff_id, s.first_name, s.last_name, COUNT(*) 'N pagos atendidos'
FROM staff s JOIN payment p USING(staff_id)
WHERE p.amount>5
GROUP BY s.staff_id
LIMIT 10;

#1.34)
CREATE OR REPLACE VIEW view_tot_alqXcat_pel AS
(SELECT c.name AS Categoria, t1.cant as Cantidad
 FROM (SELECT fc.category_id, COUNT(r.rental_id) AS cant
	   FROM ((rental AS r JOIN inventory AS i USING(inventory_id)) JOIN film AS f USING(film_id)) JOIN film_category fc USING(film_id)
	   GROUP BY fc.category_ID) AS t1 JOIN category c USING(category_id));

#1.35)
SELECT f.film_id, f.title
FROM film f
WHERE f.film_id IN (SELECT fa.film_id
					FROM film_actor fa JOIN actor a USING(actor_id)
					WHERE a.first_name LIKE '%JENNIFER%' AND a.last_name LIKE '%DAVIS%');

#1.36)
SELECT c.customer_id ClienteNro, COUNT(DISTINCT(i.film_id)) 'Peliculas Alquiladas'
FROM (customer c JOIN rental r USING(customer_id)) JOIN inventory i USING(inventory_id)
GROUP BY c.customer_id
HAVING COUNT(i.film_id) > 50;

#1.37)

