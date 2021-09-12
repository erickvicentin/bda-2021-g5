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

