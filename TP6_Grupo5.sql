CREATE DATABASE db_name;

CREATE TABLE db_name.db_table (
	id int NOT NULL AUTO_INCREMENT,
    campo1 varchar(128) NOT NULL,
    PRIMARY KEY (id)
) ENGINE=innodb;

INSERT INTO db_name.db_table (campo1)
VALUES('fila1');

#Bloqueos de filas

START TRANSACTION;
SELECT id, campo1
FROM db_name.db_table
WHERE id=1
FOR UPDATE;

## Bloqueo con SHARE MODE

START TRANSACTION;
SELECT id, campo1
FROM db_name.db_table
WHERE id=1
LOCK IN SHARE MODE;

# Acá tenemos que hacer la lectura y update en la otra sesion
START TRANSACTION;
SELECT id, campo1
FROM db_name.db_table
WHERE id=1
LOCK IN SHARE MODE;

UPDATE db_name.db_table
SET campo1='fila3'
WHERE id=1;
