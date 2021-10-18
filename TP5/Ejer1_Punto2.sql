CREATE USER 'Marta'@'localhost' identified by '123';
CREATE USER 'Jorge'@'localhost' identified by '123';

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
	id INT,
    nombre VARCHAR(40),
    CONSTRAINT `PK_tipos` PRIMARY KEY(id)
);

CREATE TABLE transacciones(
	id INT,
    nro_cuenta INT,
    cant INT,
    tipo INT,
    CONSTRAINT `PK_transacciones` PRIMARY KEY(id),
    CONSTRAINT `FK_transacciones_tipos` FOREIGN KEY(tipo) REFERENCES tipos(id)
);


