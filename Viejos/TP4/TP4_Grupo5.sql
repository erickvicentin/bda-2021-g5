#1.1)
delimiter |
CREATE PROCEDURE `empleado_total_cobrado`(staff_id INT)
	BEGIN
		SELECT s.first_name Nombre, s.last_name Apellido, SUM(amount) 'Total cobrado'
		FROM payment p JOIN staff s on p.staff_id = s.staff_id 
		WHERE s.staff_id = staff_id
		GROUP BY s.staff_id;
	END;
    
CALL empleado_total_cobrado(1);


#1.2)
delimiter |
CREATE PROCEDURE `insertar_actor`(nombre VARCHAR(45), apellido VARCHAR(45))
BEGIN
INSERT INTO actor(first_name, last_name) VALUES(nombre, apellido);
END |

#1.3)
delimiter | 
CREATE PROCEDURE `listar_por_apellido`(comienza VARCHAR(20)) 
BEGIN 
	IF (comienza IS NULL OR comienza = "") THEN 
		SET comienza := "A";
	END IF;
SELECT first_name
FROM actor
WHERE first_name LIKE CONCAT(comienza,"%");
END | 

#1.4)

delimiter | 
CREATE PROCEDURE `insertar_veintiseis_actores`() 
BEGIN 
DECLARE contador INT DEFAULT  1;
	WHILE contador <= 26 DO
		CALL insertar_actor(CONCAT("Nombre_",contador),CONCAT("Apellido_",contador));
        SET contador := contador + 1;
	END WHILE;
END| 

#1.5)

delimiter |
CREATE PROCEDURE `insertar_pais`(user VARCHAR(16), pass VARCHAR(40), country VARCHAR(50))
BEGIN
	IF (SELECT EXISTS(SELECT * FROM staff WHERE user LIKE staff.username AND pass LIKE staff.password)) THEN
         INSERT INTO country(country) VALUES(country);
	ELSE
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Username or password is incorrect. Please check', MYSQL_ERRNO = 1001;
	END IF;
END |

# TRIGGERS

#1.6)

delimiter | 
CREATE TRIGGER after_category_delete
	BEFORE DELETE ON category
    FOR EACH ROW
BEGIN
	DELETE FROM film_category 
    WHERE old.category_id = category_id;
END |
delimiter ;

#1.7)
#1.8)
#1.9)

#2.1

create table TP4.CERVEZAS(
nombre varchar(40),
fabricante varchar(60),
primary key (nombre)
)

create table TP4.PRECIOS(
bar varchar(60),
cerveza varchar (40) not null,
precio decimal(6,2),
foreign key (cerveza) references CERVEZAS(nombre)	
);

#2.2
insert into CERVEZAS values ('brahma','Cerveceria Quilmes'),('quilmes','Cerveceria Quilmes'),
							('Imperial Golden','Coca Cola'),('Imperial Larger','Coca Cola');
                            
insert into PRECIOS values ('La republica','brahma',200),('La republica','quilmes',200),
('La republica','Imperial Golden',250),('La republica','Imperial Larger',250);

#2.3
delimiter | 
create trigger before_precios_insert
	before insert on PRECIOS
    for each row
begin
	if (new.cerveza) not in (SELECT nombre from CERVEZAS) then
	insert into CERVEZAS values (new.cerveza,null);
    end if;
    
end
|
delimiter ;

#2.4
create index bar_inx on PRECIOS(bar);

create table TP4.SUPER_PRECIOS(
bar varchar(60),
cerveza varchar (40), -- marca de la cerveza
precio decimal(6,2),
fecha date,
primary key (bar,cerveza),
foreign key (bar) references PRECIOS(bar),
foreign key (cerveza) references CERVEZAS(nombre)	
)

delimiter | 
create trigger after_precios_update
	after update on PRECIOS
    for each row
begin
	if new.precio > 150 then
	insert into SUPER_PRECIOS values (new.bar,new.cerveza,new.precio,current_date());
    end if;
    
end;
|
delimiter ;

#3.1
CREATE TABLE if not exists SOCIO
(	
	num_soc int not null auto_increment,
	nombre varchar(50) not null,
	direccion varchar(50) not null,
    telefono varchar(13) not null,
	PRIMARY KEY(num_soc)
);

#3.2
INSERT INTO SOCIO (nombre, direccion, telefono)
VALUES  ('Pedro Lopez','Las Heras 521','379154252525'),
		('Julian Cardozo','Pio 4 321','0379154353535'),
        ('Pablo Quintana','Calle Siempre Viva 201','0379154454545'),
        ('Belen Vera','Hipodromo 212','0379154555555'),
        ('Catalina Rivera','San Martin 562','0379154656565'),
        ('Benjamin Rodriguez','Belgrano 234','0379154757575'),
        ('Augusto Caceres','Marcelo Gallardo 912','0379154858585'),
        ('Sofia Lucero','Las Monta??as 422','0379154959595');
        
#3.3 y 3,4
CREATE TABLE if not exists SOCIO_BAJA
(	
	num_soc smallint not null,
	nombre varchar(50) not null,
	direccion varchar(50) not null,
    telefono varchar(13) not null,
    fecha_baja datetime not null,
	PRIMARY KEY(num_soc)
);

SELECT * FROM SOCIO;

#3.5
CREATE TRIGGER crearBackup
    AFTER DELETE
    ON SOCIO FOR EACH ROW
    INSERT INTO SOCIO_BAJA (num_soc, nombre, direccion, telefono, fecha_baja) VALUES (old.num_soc, old.nombre, 
    old.direccion, old.telefono, NOW());

#5.1)
CREATE TABLE tiempo (
	fecha DATE PRIMARY KEY NOT NULL, 
	dia INT NOT NULL, 
	dia_semana VARCHAR(50) NOT NULL, 
	mes VARCHAR(50) NOT NULL, 
	cuatrimestre VARCHAR(50) NOT NULL, 
	anio INT NOT NULL);
    
#5.2)
delimiter |
CREATE PROCEDURE devolver_mes(num INT)
    BEGIN
        CASE num
            WHEN 1 THEN SELECT 'Enero';
            WHEN 2 THEN SELECT 'Febrero';
            WHEN 3 THEN SELECT 'Marzo';
            WHEN 4 THEN SELECT 'Abril';
            WHEN 5 THEN SELECT 'Mayo';
            WHEN 6 THEN SELECT 'Junio';
            WHEN 7 THEN SELECT 'Julio';
            WHEN 8 THEN SELECT 'Agosto';
            WHEN 9 THEN SELECT 'Septiembre';
            WHEN 10 THEN SELECT 'Octubre';
            WHEN 11 THEN SELECT 'Noviembre';
            WHEN 12 THEN SELECT 'Diciembre';
        END CASE;
    END;
|

#5.3)
delimiter |
CREATE PROCEDURE insertar_tiempos (desde DATE, hasta DATE)
    BEGIN
        WHILE desde <= hasta DO
            INSERT INTO tiempo (fecha, dia, dia_semana, mes, cuatrimestre, anio)
            VALUES (
                DATE(desde),
                DATE(desde),
                DAYNAME(desde),
                MONTHNAME(desde),
                QUARTER(desde),
                YEAR(desde));
            SELECT DATE(desde),
                DAY(desde),
                DAYNAME(desde),
                MONTHNAME(desde),
                QUARTER(desde),
                YEAR(desde);
            
           SET desde = DATE_ADD(desde,INTERVAL 1 DAY);
        END WHILE;
    END 

|


#5.5)
create table ventas (
	id_Venta int primary key,
	fecha date not null,
	producto varchar(50) not null,
	unidades_vendidas int not null,
	precio_unitario decimal (5,2) not null);

#5.6)
delimiter |
create procedure registrar_venta (id int, fecha date, producto varchar(50), cantidad int, preciouni decimal(5,2))
    begin
        insert into ventas (id_Venta, fecha, producto, unidades_vendidas, precio_unitario)
        values (
                id,
                fecha,
                producto,
                cantidad,
                preciouni);
        select
                id,
                fecha,
                producto,
                cantidad,
                preciouni;
    end;
|

#5.8)
delimiter |
create procedure mostrar_estadisticas_prueba (num int)
    begin
        case num
            when 1 then
                -- Valor total de las ventas.
                select id_Venta as Venta, (unidades_vendidas*precio_unitario) as Precio_Total
                from ventas
                order by Precio_Total desc;
            when 2 then
                -- Valor total de las ventas en el a??o 2011.
                select id_Venta as Venta, (unidades_vendidas*precio_unitario) as Precio_Total, fecha as Fecha
                from ventas
                where year(fecha) = 2011
                order by Precio_Total desc;
            when 3 then
                -- Valor total de las ventas en 2012.
                select id_Venta as Venta, (unidades_vendidas*precio_unitario) as Precio_Total, fecha as Fecha
                from ventas
                where year(fecha) = 2012
                order by Precio_Total desc;
            when 4 then
                -- Listado ordenado de las ventas por d??a de la semana.
                select id_Venta as Venta, (unidades_vendidas*precio_unitario) as Precio_Total, dayname(fecha) as D??a
                from ventas
                order by dayofweek(fecha) asc;
            when 5 then
                -- Listado ordenado de las ventas por mes del a??o.
                select id_Venta as Venta, (unidades_vendidas*precio_unitario) as Precio_Total, monthname(fecha) Mes, year(fecha) as A??o
                from ventas
                order by month(fecha) asc;
            when 6 then
                -- Listado ordenado de la ventas por cuatrimestre del a??o.
                select id_Venta as Venta, (unidades_vendidas*precio_unitario) as Precio_Total, quarter(fecha) as Cuatrimestre, year(fecha) as A??o
                from ventas
                order by quarter(fecha) asc;
        end case;
    end;
|
