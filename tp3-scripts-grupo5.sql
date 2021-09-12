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