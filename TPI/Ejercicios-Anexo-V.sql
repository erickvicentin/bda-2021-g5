-- Ejercicios ANEXO V --
-- PROGRAMABILIDAD
-- Triggers
-- 1 

DELIMITER //
CREATE TRIGGER verificar_excent_orbita BEFORE INSERT ON Orbita FOR EACH ROW
BEGIN
       IF (new.excentricidad = 0) then
             SET new.circular= true;
       ELSE
             SET new.circular= false;
       end IF;
END//
DELIMITER ;

-- 2
DELIMITER //
CREATE TRIGGER actualizar_lanzamientos AFTER INSERT ON Lanza
FOR EACH ROW
begin
         UPDATE Agencia
         SET lanzamientos = lanzamientos+1
         WHERE nombre = new.agencia_nombre;
END//
DELIMITER ;

-- 3

-- SEGURIDAD --
-- 1
CREATE ROLE IF NOT EXISTS programador, diseñador, administrador;

-- 3
CREATE USER "diseñador"@"localhost" IDENTIFIED BY "diseñador" PASSWORD EXPIRE INTERVAL 90 DAY ;
CREATE USER "programador"@"localhost" IDENTIFIED BY "programador" PASSWORD EXPIRE INTERVAL 90 DAY;
CREATE USER "admin"@"%" IDENTIFIED BY "admin" PASSWORD EXPIRE INTERVAL 90 DAY;
GRANT ALL ON BDA_TPI.* TO "admin"@"%";
GRANT ALTER, CREATE, DELETE, DROP, INDEX, INSERT, REFERENCES, SELECT, TRIGGER, UPDATE, EVENT, LOCK TABLES ON BDA_TPI.* TO "diseñador"@"localhost"; 
GRANT SELECT, INSERT, UPDATE, TRIGGER, SHOW VIEW, CREATE VIEW ON BDA_TPI.* TO "programador"@"localhost";
GRANT "programador" TO "programador"@"localhost";
GRANT "diseñador" TO "diseñador"@"localhost";
GRANT "administrador" TO "admin"@"%";

-- 4) Estos deben hacerce via linea de comandos logueandose como cada usuario
-- mysql -u programador -pprogramador [CREAR TABLA COMO PROGRAMADOR - NO PERMITIDO]
USE BDA_TPI;
create table prueba( id int, primary key(id));

-- mysql -u diseñador -pdiseñador [CREAR USUARIO COMO DISEÑADOR - NO PERMITIDO]
USE BDA_TPI;
create user “nuevoDiseñador”@”localhost”;

-- -mysql -u admin -padmin [COMO ADMINISTRADOR TODO ESTA PERMITIDO]
USE BDA_TPI;
CREATE TABLE prueba (id INT, PRIMARY KEY(id));
INSERT INTO prueba(id) VALUES(1);
SELECT * FROM prueba;

USE erick;
