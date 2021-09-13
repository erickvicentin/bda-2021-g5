DROP DATABASE BDA2021;
CREATE DATABASE BDA2021;


USE BDA2021;

# 1.1

CREATE TABLE if not exists cliente 
(
	cliente_id smallint auto_increment,
    almacen_id tinyint,
    nombre varchar(45) not null,
    apellido varchar(45) not null,
    fecha_nacimiento date,
    email varchar(50),
    direccion_id smallint references direccion,
    activo boolean not null,
    dia_creacion datetime not null,
    PRIMARY KEY (cliente_id)
);

ALTER TABLE cliente ADD CONSTRAINT Checkear_Edad
 CHECK (TIMESTAMPDIFF(YEAR,fecha_nacimiento,dia_creacion)>18);

#TESTS

INSERT INTO cliente (cliente_id, nombre, apellido, fecha_nacimiento, email, activo, dia_creacion)
VALUES  (1,'Juan','Gomez','1998-2-3','juan@hotmail.com',True,'2021-01-01 00:00:01');

#1.2

create table if not exists empleado
  (
	  empleado_id tinyint auto_increment,
	  nombre varchar(45) not null,
	  apellido varchar(45) not null,
	  imagen blob,
	  email varchar(50),
	  almacen_id tinyint,
	  activo boolean,
	  nombre_usuario varchar(16) unique not null,
	  contraseña varchar(40) not null,
	  ultima_actualizacion timestamp not null,
	  PRIMARY KEY(empleado_id)
  );

CREATE TABLE if not exists alquiler
(
	alquiler_id int,
    alquiler_fecha datetime,
    inventario_id mediumint UNIQUE,
    cliente_id smallint UNIQUE,
    fecha_devolucion datetime,
    empleado_id tinyint UNIQUE,
    PRIMARY KEY (alquiler_id),
    FOREIGN KEY (cliente_id) references cliente(cliente_id),
    FOREIGN KEY (empleado_id) references empleado(empleado_id)
);

CREATE TABLE if not exists direccion
(
	direccion_id smallint auto_increment,
	direccion varchar(30) not null,
	direccion2 varchar(30),
	distrito varchar(20) not null,
	ciudad_id smallint,
	postal_code varchar(10) not null,
	telefono varchar(20) not null,
	PRIMARY KEY(direccion_id)
);

create table if not exists pais
(	
	pais_id smallint not null auto_increment,
	pais varchar(50) not null,
	PRIMARY KEY(pais_id)
);

#1.3
CREATE TABLE if not exists pelicula_actor
(
	actor_id smallint UNIQUE,
    pelicula_id smallint UNIQUE,
    PRIMARY KEY (actor_id, pelicula_id),
    FOREIGN KEY (actor_id) references actor(actor_id),
    FOREIGN KEY (pelicula_id) references pelicula(pelicula_id)
);

#1.4
CREATE TABLE if not exists pago
(
	pago_id smallint UNIQUE,
    cliente_id smallint UNIQUE,
    empleado_id tinyint UNIQUE,
    alquiLer_id int,
    pago decimal(5,2),
    pago_fecha datetime,
    PRIMARY KEY (pago_id),
    FOREIGN KEY (cliente_id) REFERENCES cliente(cliente_id),
    FOREIGN KEY (empleado_id) REFERENCES empleado(empleado_id),
    FOREIGN KEY (alquiler_id) REFERENCES alquiler(alquiLer_id)
);

#1.5
create table if not exists almacen
(
	almacen_id tinyint NOT NULL,
	manager_empleado_id tinyint references empleado,
	direccion_id smallint references direccion,
	foreign key(manager_empleado_id) references empleado(empleado_id),
	foreign key(direccion_id) references direccion(direccion_id)
);

#1.6
ALTER TABLE almacen ADD PRIMARY KEY (almacen_id);
ALTER TABLE empleado ADD sueldo_hora decimal(5,2) NOT NULL;

#1.7
ALTER TABLE cliente ADD CONSTRAINT Sin_NomyAp_Iguales UNIQUE (nombre,apellido);

#TESTS
INSERT INTO cliente (cliente_id, nombre, apellido, fecha_nacimiento, email, activo, dia_creacion)
VALUES  (3,'Juan','Gomez','1991-2-3','juan@gmail.com',True,'2021-01-01 00:00:01');

#1.8
create table if not exists ciudad
(	
	ciudad_id smallint not null auto_increment,
	nombre_cuidad varchar(50) not null,
    CP int not null,
	pais_id smallint references pais,
	PRIMARY KEY(ciudad_id),
	foreign key(pais_id) references pais(pais_id)
);

alter table direccion ADD FOREIGN KEY (ciudad_id) REFERENCES ciudad(ciudad_id);

alter table cliente DROP COLUMN direccion_id;

#1.9

alter table cliente ADD COLUMN calle_cliente varchar(20) NOT NULL;
alter table cliente ADD COLUMN altura_cliente smallint;

alter table empleado ADD COLUMN domicilio_empleado smallint;
alter table empleado ADD FOREIGN KEY (domicilio_empleado) REFERENCES direccion(direccion_id);

#1.10

alter table ciudad DROP foreign key ciudad_ibfk_1;
alter table ciudad DROP COLUMN pais_id;
DROP TABLE pais;

#1.11

ALTER TABLE empleado DROP COLUMN email;

create table email_empleado
(
    email varchar(40) UNIQUE,
    empleado_id tinyint,
    empresa varchar(40),
    FOREIGN KEY (empleado_id) references empleado(empleado_id)
		ON DELETE CASCADE
);

ALTER TABLE email_empleado ADD PRIMARY KEY (email, empleado_id);

#1.12
ALTER TABLE empleado MODIFY nombre varchar(45) NOT NULL;
ALTER TABLE empleado MODIFY apellido varchar(45) NOT NULL;

#1.13
ALTER TABLE cliente ADD CONSTRAINT No_Dir_Iguales UNIQUE (calle_cliente,altura_cliente);