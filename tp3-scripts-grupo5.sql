#USE sakila;

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
SELECT c.customer_id, c.first_name
FROM customer c JOIN rental r USING(customer_id)
WHERE EXTRACT(year FROM r.rental_date)=2004 AND c.customer_id 
NOT IN (SELECT c.customer_id
		FROM customer c JOIN rental r USING(customer_id)
		WHERE EXTRACT(year FROM r.rental_date)=2005);

#1.38)
SELECT s1.staff_id CodStaff, s1.first_name Nombre, s1.last_name Apellido
FROM (SELECT s.staff_id
	  FROM (staff s JOIN rental r USING(staff_id)) JOIN payment p USING(rental_id)
      GROUP BY s.staff_id
      HAVING COUNT(r.rental_id) > 10 AND SUM(p.amount) > 50) AS tab
JOIN staff s1 USING(staff_id);

#1.39)
SELECT a.actor_id CodActor, a.first_name Nombre, a.last_name Apellido
FROM (SELECT fa.actor_id
	  FROM (film_actor fa JOIN film f USING(film_id)) JOIN film_category fc USING(film_id)
      GROUP BY fa.actor_id
HAVING COUNT(DISTINCT(f.film_id)) > 5 AND COUNT(DISTINCT(fc.category_id)) > 2)
AS tab JOIN actor a USING(actor_id) LIMIT 10;

#1.40)
SELECT first_name, last_name, customer_id
FROM (SELECT customer_id
	  FROM (SELECT c.customer_id, COUNT(r.rental_id) AS veces_alquilado
			FROM ((customer c JOIN rental r USING(customer_id)) JOIN inventory i USING(inventory_id)) 
            JOIN film f USING(film_id)
            GROUP BY c.customer_id) AS t1
	  JOIN (SELECT res.customer_id, SUM(res.retr_no_entr) AS tot_retr
			FROM (SELECT *
				  FROM (SELECT c.customer_id, COUNT(*) AS retr_no_entr
						FROM ((customer c JOIN rental r USING(customer_id)) JOIN inventory i USING(inventory_id)) 
						JOIN film f USING(film_id)
                        WHERE r.return_date IS NULL AND DATEDIFF(current_date(), r.rental_date) > f.rental_duration
                        GROUP BY c.customer_id) AS tab1
				  UNION (SELECT c.customer_id, COUNT(*) AS retr_entr
						 FROM ((customer c JOIN rental r USING(customer_id)) JOIN inventory i USING(inventory_id)) 
						 JOIN film f USING(film_id)
						 WHERE r.return_date IS NOT NULL AND DATEDIFF(r.return_date, r.rental_date) > f.rental_duration
				  GROUP BY c.customer_id)
                  ORDER BY customer_id) AS res
			GROUP BY res.customer_id) as t2 USING(customer_id)
	   WHERE (t2.tot_retr*100)/t1.veces_alquilado > 40) AS id_clientes_atrasados
JOIN customer cr USING(customer_id);

#1.41)
CREATE OR REPLACE VIEW peliculas_sin_alquilar_20 AS 
    SELECT Inv.title, Inv.film_id, Inv.inventario, Alq.alquiladas, (Alq.alquiladas / Inv.inventario) porcentaje_alquiler
	FROM (SELECT f.title, f.film_id, count(*) inventario
		  FROM film f JOIN inventory i ON f.film_id = i.film_id
		  GROUP BY f.title, f.film_id) Inv 
	JOIN (SELECT i.film_id , count(*) alquiladas
		  FROM inventory i JOIN rental r ON i.inventory_id = r.inventory_id
		  WHERE r.return_date IS NULL
		  GROUP BY film_id) Alq ON (Inv.film_id = Alq.film_id)
	WHERE (Alq.alquiladas / Inv.inventario) > 0.2 ;
            
SELECT * FROM peliculas_sin_alquilar_20;

#1.42)
SELECT c.customer_id, concat(c.first_name, ' ', last_name) Nombre, r.rental_date
FROM rental r JOIN customer c ON r.customer_id = c.customer_id 
	 JOIN (SELECT rental_date_dia dia_con_mayor_alquiler, count(*) alquileres
		   FROM (SELECT DATE(rental_date) rental_date_dia 
				 FROM rental) t1
		   GROUP BY t1.rental_date_dia
		   ORDER BY alquileres DESC LIMIT 1) t2 ON DATE(r.rental_date) = t2.dia_con_mayor_alquiler
           LIMIT 10;
           
#1.43)
SELECT c.customer_id, concat(c.first_name, ' ', last_name) Nombre, r.rental_date
FROM rental r JOIN customer c ON r.customer_id = c.customer_id JOIN
		(SELECT min(DATE(rental_date)) primer_alquiler
		 FROM rental) t1 ON DATE(r.rental_date) = t1.primer_alquiler;

#1.44)
SELECT c.customer_id ID, c.first_name Nombre, c.last_name Apellido
FROM rental r JOIN customer c ON r.customer_id = c.customer_id	
WHERE r.rental_date BETWEEN '2005-01-01' AND '2006-12-31';

#1.45)
SELECT *
FROM
  (SELECT i.film_id, ejemplares.ejemplares, sum(p.amount) ingreso
   FROM payment p
   JOIN rental r ON r.rental_id = p.rental_id
   JOIN inventory i ON r.inventory_id = i.inventory_id
   JOIN
     (SELECT f.film_id, count(*) ejemplares
      FROM inventory i
      JOIN film f ON i.film_id = f.film_id
      GROUP BY f.film_id) ejemplares ON ejemplares.film_id = i.film_id
   WHERE ejemplares.ejemplares < 5
   GROUP BY i.film_id) Film_ejemplares_total_ingreso
WHERE ingreso > 200;

#1.46)
SELECT DISTINCT c.customer_id, concat(c.first_name, ' ', c.last_name) AS Nombre
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
WHERE r.inventory_id in
    (SELECT DISTINCT i.inventory_id
     FROM film f
     JOIN film_category fc ON f.film_id = fc.film_id
     JOIN category c ON fc.category_id = c.category_id
     JOIN inventory i ON i.film_id = f.film_id
     WHERE c.name = 'Action') ;
     
#1.47)
SELECT DISTINCT concat(s.first_name, ' ', s.last_name) AS Nombre ,c.name
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON f.film_id = i.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON c.category_id = fc.category_id
JOIN staff s ON s.staff_id = r.staff_id
ORDER BY Nombre, c.name

#Ejercicio 4
#4.1)
#a 
SELECT DISTINCT s.sname
FROM suppliers s INNER JOIN catalog c ON c.sid=s.sid INNER JOIN parts p ON p.pid=c.pid
WHERE p.color LIKE '%Red%';

#b
SELECT c.sid
FROM catalog c INNER JOIN parts p ON p.pid=c.pid
WHERE p.color like '%Red%'
UNION
SELECT c.sid
FROM catalog c INNER JOIN parts p ON p.pid=c.pid
WHERE p.color like '%Green%';

#c 
select distinct s.sname
from suppliers s inner join catalog c on c.sid=s.sid inner join parts p on p.pid=c.pid
where p.color like '%Red%' or s.address like '%221 Packer Street%';

#d 
select c.sid
from catalog c inner join parts p on p.pid=c.pid
where p.color like '%Red%' and c.sid in (select c2.sid 
from catalog c2 inner join parts p2 on c2.pid=p2.pid
where p2.color like '%Green%');

#e
select s.sid
from suppliers s
where not exists ((select p.pid 
from parts p 
where not exists (select c.pid
from catalog c 
where c.pid=p.pid and s.sid=c.sid)));

#f 
select s.sid
from suppliers s
where not exists((select p.pid
from parts p
where p.color like '%Red%' and not exists (select c.pid
from catalog c
where c.pid=p.pid and s.sid=c.sid)));

#g 
select s.sid
from suppliers s 
where not exists((select p.pid from parts p 
where p.color like '%Red%' and not exists(select c.pid from catalog c
where c.pid=p.pid and s.sid=c.sid)))
UNION
select s.sid
from suppliers s 
where not exists((select p.pid from parts p 
where p.color like '%Green%' and not exists (select c.pid from catalog c
where c.pid=p.pid and s.sid=c.sid)));

#h 
select s.sid
from suppliers s
where not exists((select p.pid from parts p 
where p.color like '%Red%' and not exists(select c.pid from catalog c 
where c.pid=p.pid and s.sid=c.sid))) and s.sid not in (select s.sid from suppliers s 
where not exists((select p.pid from parts p 
where p.color like '%Green%' and not exists(select c.pid from catalog c 
where c.pid=p.pid and s.sid=c.sid))));

#i 
select distinct c1.sid, c2.sid
from catalog c1, catalog c2 
where c1.sid<>c2.sid and c1.cost>c2.cost;

#j 
select p.pid from parts p, (select c.pid as pid, count(c.sid) as contador 
from catalog c group by c.pid) t
where t.pid=p.pid and t.contador>1;

#k 
CREATE VIEW vista_k AS
select c.pid
from catalog c inner join suppliers s on s.sid=c.pid
where c.cost = (select max(c1.cost)
from catalog c1
where s.sid=c1.sid and s.sname="Yosemite Sham");

#l
create view vw_menosde200 as
select distinct c.pid from catalog c 
where c.cost<200;

#4.2)
#a 
select distinct c.eid from certified c inner join aircraft a on a.aid=c.aid
where a.aname like '%Boeing%';

#b 
select distinct e.ename
from employees e inner join certified c on c.eid=e.eid inner join aircraft a on a.aid=c.aid
where a.aname like '%Boeing%';

#f
select distinct e.eid from employees e
where e.salary = (select max(e.salary) from employees e);

#g 
select e.eid from employees e
where e.salary =(select max(e.salary)
from employees e
where e.salary< (select max(e.salary) from employees e));

#h
select e.eid from employees e, (select c.eid as eid, count(c.aid) as contador from certified c
group by c.eid) t2
where e.eid=t2.eid and
t2.contador=(select max(t.contador) from (select c.eid as eid, count(c.aid) as contador from certified c group by c.eid) t);

#i
create view vw_certx3 as
select distinct c.eid
from certified c
group by c.eid
having count(*)=3;

#j 
create view vw_sumasalary as
select sum(e.salary) from employees e;

#4.3) 
#a
SELECT s.sname
FROM faculty f INNER JOIN class c ON c.fid=f.fid INNER JOIN enrolled i ON i.cname=c.name INNER JOIN student s ON s.snum=i.snum
WHERE f.fname LIKE'I%_Teach';

#b
SELECT c.name
FROM class c
WHERE c.room='R128' and c.name IN(
	SELECT c.name
	FROM class c INNER JOIN enrolled i ON c.name=i.cname
	WHERE c.name IN(
		SELECT Count(snum)>5
		FROM class c INNER JOIN  enrolled i ON c.name=i.cname
		GROUP BY(c.name)))

#c
SELECT s.sname
FROM (student s INNER JOIN enrolled i ON i.snum=s.snum INNER JOIN class c ON c.name=i.cname),
	(student s2 INNER JOIN  enrolled i2 ON i2.snum=s2.snum INNER JOIN class c2 ON c2.name=i2.cname)
WHERE c.name<>c2.name AND c.meets_at=c2.meets_at AND s.snum=s2.snum

#d
SELECT DISTINCT f.fname
FROM faculty f INNER JOIN class c on c.fid=f.fid

#e
SELECT t.fname
FROM(
	SELECT f.fname,COUNT(*) as CantCursos
	FROM faculty f INNER JOIN class c on f.fid=c.fid
	GROUP BY f.fid)t
WHERE t.CantCursos<5

#f
SELECT standing,AVG(s.age)
FROM student s
GROUP BY  s.standing

#g
SELECT standing,AVG(s.age)
FROM student s
WHERE s.standing<>'JR'
GROUP BY s.standing

#h
SELECT s.sname, tb.Cursos
FROM (
SELECT i.snum, COUNT(c.name) as cursos
FROM class c INNER JOIN enrolled i on i.cname=c.name
WHERE c.room='R128'
GROUP BY i.snum
)tb INNER JOIN student s ON s.snum=tb.snum
GROUP BY  s.snum

#i 
CREATE VIEW vw_maximainsc AS
SELECT s.sname
FROM student s INNER JOIN (
	SELECT i.snum as snum, COUNT(i.cname) as contador
	FROM enrolled i
	GROUP BY (i.snum)
)t ON t.snum=s.snum
WHERE t.contador=(
	SELECT MAX(t2.contador)
FROM(
	SELECT i.snum as snum, COUNT(i.cname) as contador
FROM enrolled i
GROUP BY (i.snum)
) t2);

#j
CREATE VIEW vw_noinscriptos AS
select t.sname from(
	select s.sname from student s
	where s.snum not in(
		select i.snum
	from enrolled i)
) as t;

#k
set sql_mode='';
select t2.age, t2.standing
from(
	select s.age as age, s.standing as standing, count(s.snum) as contador
	from student s order by s.age) t2
where t2.contador= (
	select max(t.contador)
	from( 
		select s.age as age, s.standing as standing, count(s.snum) as contador
		from student s
		order by s.age)t);
        
#4.4)
#a
select sof.ename, sof.age
from( select e.ename, e.age
from emp e, dept d, works w
where d.did=w.did and w.eid=e.eid and d.dname='Software') as sof,
(select e.ename, e.age
from emp e, dept d, works w
where d.did = w.did and e.eid and d.dname = 'Hardware') as Har
where sof.ename = Har.ename and sof.age = Har.age;

#b
select distinct d.managerid
from dept d,(select d.managerid, sum(d.budget) as sal
from dept d
group by d.managerid) as x
where d.managerid=x.managerid and x.sal>1000000;

#c
select e.ename
from emp e,(select x.managerid
from (select d.managerid, sum(d.budget) as sal
from dept d
group by d.managerid) as x
where x.sal = (select max(y.sal) from (select sum(d.budget) as sal from dept d
group by d.managerid) as y)) as f
where e.eid=f.managerid;

#d
select x.managerid
from (select d.managerid, sum(d.budget) as sal
from dept d
group by d.managerid) as x
where x.sal>5000000;

#e
select x.managerid
from (select d.managerid, sum(d.budget) as sal
from dept d
group by d.managerid) as x
where x.sal=(select max(y.sal) from (select sum(d.budget) as sal from dept d
group by d.managerid) as y);

#f
create view vw_presupuesto as
select distinct e.ename
from (select d.managerid
from dept d
where d.budget>1000000) as d2,
(select d.managerid from dept d
where d.budget<5000000) as d3, emp e
where d2.managerid=d3.managerid and e.eid=d2.managerid;