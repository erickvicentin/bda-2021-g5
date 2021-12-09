CREATE DATABASE ejer3;
USE ejer3;

CREATE TABLE IF NOT EXISTS arrendatario(
	cuit INTEGER NOT NULL,
    nombre VARCHAR(35) NOT NULL,
    apellido VARCHAR(40) NOT NULL,
    PRIMARY KEY(cuit)
);

CREATE TABLE IF NOT EXISTS duenio(
    cuit INTEGER NOT NULL,
    nombre VARCHAR(35) NOT NULL,
    apellido VARCHAR(40) NOT NULL,
    PRIMARY KEY(cuit)
);

CREATE TABLE IF NOT EXISTS casa(
    id_casa INTEGER NOT NULL,
    cuit INTEGER NOT NULL,
    nro INTEGER NOT NULL,
    calle VARCHAR(40) NOT NULL,
    ciudad VARCHAR(40) NOT NULL,
    PRIMARY KEY(id_casa),
    FOREIGN KEY(cuit) REFERENCES duenio(cuit)
);

CREATE TABLE IF NOT EXISTS arrienda(
	cuit INTEGER NOT NULL,
    id_casa INTEGER NOT NULL,
    deuda INTEGER NOT NULL,
    PRIMARY KEY(cuit, id_casa),
    FOREIGN KEY(cuit) REFERENCES arrendatario(cuit),
    FOREIGN KEY(id_casa) REFERENCES casa(id_casa)
);

CREATE TABLE IF NOT EXISTS telefonos(
    fono INTEGER NOT NULL,
    cuit INTEGER NOT NULL, 
    PRIMARY KEY(fono),
    FOREIGN KEY(cuit) REFERENCES duenio(cuit) 
);





