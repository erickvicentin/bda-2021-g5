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
DELIMITER //
CREATE TRIGGER total_costos BEFORE INSERT ON Costo
FOR EACH ROW
BEGIN
       SET new.costo_total = new.costo_nave + new.costo_lanza +
       new.costo_agencia;
END //
DELIMITER ;


-- Store Procedures
-- 1

DROP PROCEDURE informeNave;
DELIMITER //
CREATE PROCEDURE informeNave (idMatricula int)
BEGIN
       DECLARE cant_orbitas,cant_tripulantes,basura_producida INT;
       
       SET cant_orbitas = (
		SELECT COUNT(*)
		FROM Esta
		GROUP BY id_nave_matricula
		HAVING id_nave_matricula = idMatricula);
       
       SET cant_tripulantes = (
		SELECT COUNT(*)
		FROM Nombre_Tripulante
		WHERE nave_matricula = idMatricula);
	   
       SET basura_producida = (
		SELECT COUNT(*)
		FROM Basura as b INNER JOIN Produce as p ON b.id = p.basura_id
		WHERE p.nave_matricula = idMatricula);
		
        SELECT cant_orbitas,cant_tripulantes,basura_producida;
END //
DELIMITER ;

CALL informeNave(330377);

-- 2
-- PARA QUE FUNCIONE LA CREACION:
SET GLOBAL log_bin_trust_function_creators = 1;

DELIMITER //
CREATE FUNCTION contarOrbitas(fecha_entrada date, n int) RETURNS INT
BEGIN
    DECLARE fecha_final date;
	DECLARE cantidad int;
	
    SET fecha_final = (
		SELECT date_add(fecha_entrada, interval n day)
	);
	
    SET cantidad = (
		SELECT COUNT(DISTINCT e.id_nave_matricula) 
        FROM Esta as e INNER JOIN Fecha_Inicio as fi ON fi.esta_id_nave_matricula = e.id_nave_matricula
        WHERE fi.dia BETWEEN fecha_entrada and fecha_final
	);
       
	RETURN cantidad;
END//
DELIMITER ;

SELECT contarOrbitas("1976-02-23", 102);



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

-- DATOS SEMI-ESTRUCURADOS: CONSULTAS
-- 1
select AVG(Accionista -> '$."principal_accionista".edad') 
From Empresa
Where (Accionista -> '$."principal_accionista"."nivel_de_estudio"') LIKE '%universitario%';


