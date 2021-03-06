## EJERCICIO 1 - PUNTO 2 

#Creacion de usuarios
CREATE USER 'Marta'@'localhost' identified by '123';
CREATE USER 'Jorge'@'localhost' identified by '123';


#CREACION DE TODAS LAS TABLAS
CREATE TABLE ciudades(
	id INT,
    nombre VARCHAR(40) NOT NULL,
    CONSTRAINT `PK_ciudades` PRIMARY KEY(id)
);

CREATE TABLE sucursales(
	id INT,
    nombre VARCHAR(40) NOT NULL,
    direccion VARCHAR(60) NOT NULL,
    ciudad INT NOT NULL,
    CONSTRAINT `PK_sucursales` PRIMARY KEY(id),
    CONSTRAINT `FK_sucursales_ciudades` FOREIGN KEY(ciudad) REFERENCES ciudades(id)
);

CREATE TABLE clientes(
	dni VARCHAR(8) NOT NULL,
    nombre VARCHAR(40) NOT NULL,
    apellido VARCHAR(40) NOT NULL,
    tel INT,
    CONSTRAINT `PK_clientes` PRIMARY KEY(dni)
);

CREATE TABLE cuentas(
	id INT,
	id_suc INT,
    saldo DECIMAL(10,2) NOT NULL,
	CONSTRAINT `PK_cuentas` PRIMARY KEY(id)
);

CREATE TABLE clientes_cuentas(
	dni VARCHAR(8) NOT NULL,
    id_cuenta INT NOT NULL,
    CONSTRAINT `PK_clientes_cuentas` PRIMARY KEY(dni,id_cuenta),
    CONSTRAINT `FK_clientes_cuentas_clientes` FOREIGN KEY(dni) REFERENCES clientes(dni),
    CONSTRAINT `FK_clientes_cuentas_cuentas` FOREIGN KEY(id_cuenta) REFERENCES cuentas(id)
);

CREATE TABLE tipos(
	id INT AUTO_INCREMENT,
    nombre VARCHAR(40),
    CONSTRAINT `PK_tipos` PRIMARY KEY(id)
);

ALTER TABLE tipos
MODIFY COLUMN id INT AUTO_INCREMENT;

DESCRIBE tipos;

SET FOREIGN_KEY_CHECKS=1;
INSERT INTO tipos(nombre) VALUES('Corrientes');

CREATE TABLE transacciones(
	id INT,
    nro_cuenta INT,
    cant INT,
    tipo INT,
    CONSTRAINT `PK_transacciones` PRIMARY KEY(id),
    CONSTRAINT `FK_transacciones_tipos` FOREIGN KEY(tipo) REFERENCES tipos(id)
);

## FIN DE CREACION DE TODAS LAS TABLAS

SHOW GRANTS FOR 'Jorge'@'localhost';

ALTER USER 'Jorge'@'localhost'
IDENTIFIED BY '123'
ACCOUNT UNLOCK;

ALTER USER 'Marta'@'localhost'
IDENTIFIED BY '123';

#e) 

CREATE USER 'Miguel'@'localhost'
IDENTIFIED BY '123';

GRANT ALL privileges ON `sakila`.* TO 'Miguel'@'localhost';

SHOW GRANTS FOR CURRENT_USER();

SELECT EVENT_SCHEMA, EVENT_NAME FROM INFORMATION_SCHEMA.EVENTS
WHERE DEFINER = 'Miguel@localhost';
SELECT ROUTINE_SCHEMA, ROUTINE_NAME, ROUTINE_TYPE
FROM INFORMATION_SCHEMA.ROUTINES
WHERE DEFINER = 'Miguel@localhost';
SELECT TRIGGER_SCHEMA, TRIGGER_NAME FROM INFORMATION_SCHEMA.TRIGGERS
WHERE DEFINER = 'Miguel@localhost';
SELECT TABLE_SCHEMA, TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS
WHERE DEFINER = 'Miguel@localhost';

SELECT DISTINCT DEFINER FROM INFORMATION_SCHEMA.EVENTS;
SELECT DISTINCT DEFINER FROM INFORMATION_SCHEMA.ROUTINES;
SELECT DISTINCT DEFINER FROM INFORMATION_SCHEMA.TRIGGERS;
SELECT DISTINCT DEFINER FROM INFORMATION_SCHEMA.VIEWS;

SELECT * FROM INFORMATION_SCHEMA.ROUTINES
WHERE DEFINER = 'wizard@%';

SELECT * FROM INFORMATION_SCHEMA.VIEWS
WHERE DEFINER = 'Miguel@localhost'
LIMIT 10;

SELECT * FROM INFORMATION_SCHEMA.VIEWS
WHERE DEFINER = 'wizard@%' AND TABLE_NAME = 'sin_last_update2';

UPDATE `mysql`.`proc` p SET definer = 'user@%' WHERE definer='root@%';

UPDATE INFORMATION_SCHEMA.VIEWS SET DEFINER = 'wizard@%' WHERE DEFINER = 'user_name@host_name' AND db='sakila';

SELECT CONCAT("ALTER DEFINER=`wizard`@`%` VIEW ", 
table_name, " AS ", view_definition, ";") 
FROM information_schema.views
WHERE definer = 'Miguel@localhost' AND  table_schema='sakila';

ALTER DEFINER=`wizard`@`%` VIEW sin_last_update2 AS 
select `sakila`.`address`.`address_id` AS `address_id`,
`sakila`.`address`.`address` AS `address`,
`sakila`.`address`.`address2` AS `address2`,
`sakila`.`address`.`phone` AS `phone`,
`sakila`.`address`.`location` AS `location` 
from `sakila`.`address`;

SELECT * FROM information_schema.views
WHERE definer = 'Miguel@localhost'
LIMIT 10;

DROP USER 'Miguel'@'localhost';

#d) 
SHOW GRANTS FOR 'Marta'@'localhost';
FLUSH PRIVILEGES;

USE sakila;
GRANT SELECT ON sakila.clientes to 'Marta'@'localhost' WITH GRANT OPTION;
GRANT SELECT ON sakila.clientes to '%'@'localhost' WITH GRANT OPTION;


#e) 
DELIMITER $$
CREATE PROCEDURE SP_CuentasPorCliente (nomb_cli VARCHAR(45))
BEGIN
    SELECT SUM(saldo) 
	FROM cuentas 
	WHERE cuentas.id IN (SELECT id_cuenta
				FROM clientes_cuentas
				INNER JOIN clientes AS cli
				ON cli.dni = clientes_cuentas.dni
				WHERE cli.nombre = nomb_cli);
END $$
DELIMITER ;



SELECT id_cuenta
				FROM clientes_cuentas
				INNER JOIN clientes AS cli
				ON cli.dni = clientes_cuentas.dni
				WHERE cli.nombre = 'Miguel';

INSERT INTO cuentas(id, id_suc, saldo) VALUES(2,1,100);
INSERT INTO clientes(dni,nombre,apellido,tel) VALUES(11111111,"Miguel","Ito",1234);
INSERT INTO clientes_cuentas VALUES(11111111,2);


SELECT * FROM cuentas;
SELECT * FROM clientes_cuentas;

CALL SP_CuentasPorCliente('Miguel');

GRANT EXECUTE ON PROCEDURE SP_CuentasPorCliente TO 'Marta'@'localhost';
GRANT EXECUTE ON PROCEDURE SP_CuentasPorCliente TO 'Jorge'@'localhost';

#f)
SELECT user FROM mysql.user;

GRANT SELECT ON sakila.cuentas to 'Marta'@'localhost';
GRANT SELECT ON sakila.cuentas to 'jPerez'@'localhost';
GRANT SELECT ON sakila.cuentas to 'Jorge'@'localhost';
GRANT SELECT ON sakila.cuentas to 'aFernandez'@'localhost';


#h)
GRANT SELECT, INSERT, UPDATE ON sakila.transacciones TO 'Marta'@'localhost';
GRANT SELECT, INSERT, UPDATE ON sakila.transacciones TO 'Jorge'@'localhost';

#h) 
REVOKE SELECT, INSERT, UPDATE ON sakila.transacciones from 'Marta'@'localhost';
REVOKE SELECT, INSERT, UPDATE ON sakila.transacciones from 'Jorge'@'localhost';

CREATE ROLE 'administrativo';

GRANT SELECT, INSERT, UPDATE ON sakila.transacciones TO 'administrativo';

GRANT 'administrativo' TO 'Marta'@'localhost';
GRANT 'administrativo' TO 'Jorge'@'localhost';

#Para activar los roles
SET ROLE ALL; SELECT CURRENT_ROLE();

#Para chequear el rol asignado
SELECT CURRENT_ROLE();

#Para probar
Use sakila;
insert into transacciones values(125,222,1,2);
select * from transacciones;
