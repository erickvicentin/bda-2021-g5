USE sakila;

#1.1)
INSERT INTO customer (store_id,first_name, last_name, email, address_id, active, create_date)
	   VALUES ('1','TONY', 'STARK', 'anthony.stark@stark-industries.com', '10', TRUE, current_timestamp());

#1.2)


#1.3)
INSERT INTO customer (customer_id, store_id,first_name, last_name, email, address_id, active, create_date)    
VALUES ('603','1','TONY', 'STARK', 'anthony.stark@stark-industries.com', '10', TRUE, current_timestamp());

#1.4)