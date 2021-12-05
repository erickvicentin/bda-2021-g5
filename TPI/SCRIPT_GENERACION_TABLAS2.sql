-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema BDA_TPI
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `BDA_TPI` ;

-- -----------------------------------------------------
-- Schema BDA_TPI
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `BDA_TPI` DEFAULT CHARACTER SET utf8 ;
USE `BDA_TPI` ;

-- -----------------------------------------------------
-- Table `BDA_TPI`.`Basura`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `BDA_TPI`.`Basura` ;

CREATE TABLE IF NOT EXISTS `BDA_TPI`.`Basura` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `peso` REAL NOT NULL,
  `velocidad` REAL NOT NULL,
  `tamaño` REAL NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BDA_TPI`.`Posicion`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `BDA_TPI`.`Posicion` ;

CREATE TABLE IF NOT EXISTS `BDA_TPI`.`Posicion` (
  `r` REAL NOT NULL,
  `delta` REAL NOT NULL,
  `theta` REAL NOT NULL,
  `fecha_pos` DATE NOT NULL,
  `id_pos` INT NOT NULL,
  PRIMARY KEY (`id_pos`),
  INDEX `id_idx` (`id_pos` ASC) VISIBLE,
  CONSTRAINT `id`
    FOREIGN KEY (`id_pos`)
    REFERENCES `BDA_TPI`.`Basura` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BDA_TPI`.`Genera`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `BDA_TPI`.`Genera` ;

CREATE TABLE IF NOT EXISTS `BDA_TPI`.`Genera` (
  `id_genera` INT NOT NULL,
  `id_generado` INT NOT NULL,
  `fecha` DATE NOT NULL,
  INDEX `id_genera_idx` (`id_genera` ASC) VISIBLE,
  INDEX `id_generado_idx` (`id_generado` ASC) VISIBLE,
  PRIMARY KEY (`id_genera`, `id_generado`),
  CONSTRAINT `id_genera`
    FOREIGN KEY (`id_genera`)
    REFERENCES `BDA_TPI`.`Basura` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `id_generado`
    FOREIGN KEY (`id_generado`)
    REFERENCES `BDA_TPI`.`Basura` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BDA_TPI`.`Clase_Nave`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `BDA_TPI`.`Clase_Nave` ;

CREATE TABLE IF NOT EXISTS `BDA_TPI`.`Clase_Nave` (
  `cod_clase` INT NOT NULL,
  PRIMARY KEY (`cod_clase`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BDA_TPI`.`Tipo_Componente`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `BDA_TPI`.`Tipo_Componente` ;

CREATE TABLE IF NOT EXISTS `BDA_TPI`.`Tipo_Componente` (
  `codigo` INT NOT NULL,
  `diametro` REAL NOT NULL,
  `peso` REAL NOT NULL,
  PRIMARY KEY (`codigo`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BDA_TPI`.`Tiene`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `BDA_TPI`.`Tiene` ;

CREATE TABLE IF NOT EXISTS `BDA_TPI`.`Tiene` (
  `cod_clase` INT NOT NULL,
  `cod_tipo` INT NOT NULL,
  PRIMARY KEY (`cod_clase`, `cod_tipo`),
  INDEX `cod_tipo_idx` (`cod_tipo` ASC) VISIBLE,
  CONSTRAINT `cod_clase`
    FOREIGN KEY (`cod_clase`)
    REFERENCES `BDA_TPI`.`Clase_Nave` (`cod_clase`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `cod_tipo`
    FOREIGN KEY (`cod_tipo`)
    REFERENCES `BDA_TPI`.`Tipo_Componente` (`codigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BDA_TPI`.`Agencia`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `BDA_TPI`.`Agencia` ;

CREATE TABLE IF NOT EXISTS `BDA_TPI`.`Agencia` (
  `nombre` VARCHAR(45) NOT NULL,
  `personal` INT NOT NULL,
  `tipo` VARCHAR(45) NULL,
  PRIMARY KEY (`nombre`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BDA_TPI`.`Nave`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `BDA_TPI`.`Nave` ;

CREATE TABLE IF NOT EXISTS `BDA_TPI`.`Nave` (
  `mision` VARCHAR(15) NOT NULL,
  `matricula` INT NOT NULL,
  `agencia_nombre` VARCHAR(45) NOT NULL,
  `clase_nave` INT NOT NULL,
  PRIMARY KEY (`matricula`, `clase_nave`),
  INDEX `fk_Nave_Agencia1_idx` (`agencia_nombre` ASC) VISIBLE,
  INDEX `fk_Nave_Clase_Nave1_idx` (`clase_nave` ASC) VISIBLE,
  CONSTRAINT `fk_Nave_Agencia1`
    FOREIGN KEY (`agencia_nombre`)
    REFERENCES `BDA_TPI`.`Agencia` (`nombre`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Nave_Clase_Nave1`
    FOREIGN KEY (`clase_nave`)
    REFERENCES `BDA_TPI`.`Clase_Nave` (`cod_clase`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BDA_TPI`.`Nombre_Tripulante`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `BDA_TPI`.`Nombre_Tripulante` ;

CREATE TABLE IF NOT EXISTS `BDA_TPI`.`Nombre_Tripulante` (
  `nombre` VARCHAR(45) NOT NULL,
  `apellido` VARCHAR(45) NOT NULL,
  `nave_matricula` INT NOT NULL,
  `nave_clase_nave` INT NOT NULL,
  PRIMARY KEY (`nave_matricula`, `nave_clase_nave`),
  INDEX `fk_Nombre_Tripulante_Nave1_idx` (`nave_matricula` ASC, `nave_clase_nave` ASC) VISIBLE,
  CONSTRAINT `fk_Nombre_Tripulante_Nave1`
    FOREIGN KEY (`nave_matricula` , `nave_clase_nave`)
    REFERENCES `BDA_TPI`.`Nave` (`matricula` , `clase_nave`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BDA_TPI`.`Produce`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `BDA_TPI`.`Produce` ;

CREATE TABLE IF NOT EXISTS `BDA_TPI`.`Produce` (
  `nave_matricula` INT NOT NULL,
  `nave_clase_nave` INT NOT NULL,
  `basura_id` INT NOT NULL,
  PRIMARY KEY (`nave_matricula`, `nave_clase_nave`, `basura_id`),
  INDEX `fk_Produce_Nave1_idx` (`nave_matricula` ASC, `nave_clase_nave` ASC) VISIBLE,
  INDEX `fk_Produce_Basura1_idx` (`basura_id` ASC) VISIBLE,
  CONSTRAINT `fk_Produce_Nave1`
    FOREIGN KEY (`nave_matricula` , `nave_clase_nave`)
    REFERENCES `BDA_TPI`.`Nave` (`matricula` , `clase_nave`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Produce_Basura1`
    FOREIGN KEY (`basura_id`)
    REFERENCES `BDA_TPI`.`Basura` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BDA_TPI`.`Orbita`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `BDA_TPI`.`Orbita` ;

CREATE TABLE IF NOT EXISTS `BDA_TPI`.`Orbita` (
  `excentricidad` REAL NOT NULL,
  `sentido` VARCHAR(15) NOT NULL,
  `altura` REAL NOT NULL,
  `circular` TINYINT NOT NULL,
  `geoestacionaria` TINYINT NOT NULL,
  PRIMARY KEY (`excentricidad`, `sentido`, `altura`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BDA_TPI`.`Esta`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `BDA_TPI`.`Esta` ;

CREATE TABLE IF NOT EXISTS `BDA_TPI`.`Esta` (
  `id_nave_clase` INT NOT NULL,
  `id_nave_matricula` INT NOT NULL,
  `id_orbita_exc` REAL NOT NULL,
  `id_sentido` VARCHAR(15) NOT NULL,
  `id_altura` REAL NOT NULL,
  PRIMARY KEY (`id_nave_clase`, `id_nave_matricula`, `id_orbita_exc`, `id_sentido`, `id_altura`),
  INDEX `id_orbita_idx` (`id_orbita_exc` ASC, `id_sentido` ASC, `id_altura` ASC) VISIBLE,
  CONSTRAINT `id_nave`
    FOREIGN KEY (`id_nave_clase` , `id_nave_matricula`)
    REFERENCES `BDA_TPI`.`Nave` (`clase_nave` , `matricula`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `id_orbita`
    FOREIGN KEY (`id_orbita_exc` , `id_sentido` , `id_altura`)
    REFERENCES `BDA_TPI`.`Orbita` (`excentricidad` , `sentido` , `altura`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BDA_TPI`.`Fecha_Inicio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `BDA_TPI`.`Fecha_Inicio` ;

CREATE TABLE IF NOT EXISTS `BDA_TPI`.`Fecha_Inicio` (
  `dia` DATE NULL,
  `hora` TIME NULL,
  `esta_id_nave_clase` INT NOT NULL,
  `esta_id_nave_matricula` INT NOT NULL,
  `esta_id_orbita_exc` REAL NOT NULL,
  `esta_id_sentido` VARCHAR(15) NOT NULL,
  `esta_id_altura` INT NOT NULL,
  PRIMARY KEY (`esta_id_nave_clase`, `esta_id_nave_matricula`, `esta_id_orbita_exc`, `esta_id_sentido`, `esta_id_altura`),
  CONSTRAINT `fk_Fecha_Inicio_Esta1`
    FOREIGN KEY (`esta_id_nave_clase` , `esta_id_nave_matricula` , `esta_id_orbita_exc` , `esta_id_sentido` , `esta_id_altura`)
    REFERENCES `BDA_TPI`.`Esta` (`id_nave_clase` , `id_nave_matricula` , `id_orbita_exc` , `id_sentido` , `id_altura`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BDA_TPI`.`Fecha_Fin`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `BDA_TPI`.`Fecha_Fin` ;

CREATE TABLE IF NOT EXISTS `BDA_TPI`.`Fecha_Fin` (
  `dia` DATE NULL,
  `hora` TIME NULL,
  `esta_id_nave_clase` INT NOT NULL,
  `esta_id_nave_matricula` INT NOT NULL,
  `esta_id_orbita_exc` REAL NOT NULL,
  `esta_id_sentido` VARCHAR(15) NOT NULL,
  `esta_id_altura` INT NOT NULL,
  PRIMARY KEY (`esta_id_nave_clase`, `esta_id_nave_matricula`, `esta_id_orbita_exc`, `esta_id_sentido`, `esta_id_altura`),
  CONSTRAINT `fk_Fecha_Fin_Esta`
    FOREIGN KEY (`esta_id_nave_clase` , `esta_id_nave_matricula` , `esta_id_orbita_exc` , `esta_id_sentido` , `esta_id_altura`)
    REFERENCES `BDA_TPI`.`Esta` (`id_nave_clase` , `id_nave_matricula` , `id_orbita_exc` , `id_sentido` , `id_altura`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BDA_TPI`.`Gravita`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `BDA_TPI`.`Gravita` ;

CREATE TABLE IF NOT EXISTS `BDA_TPI`.`Gravita` (
  `id_basura` INT NOT NULL,
  `orbita_excentricidad` REAL NOT NULL,
  `orbita_sentido` VARCHAR(15) NOT NULL,
  `orbita_altura` REAL NOT NULL,
  PRIMARY KEY (`id_basura`),
  INDEX `fk_Gravita_Orbita1_idx` (`orbita_excentricidad` ASC, `orbita_sentido` ASC, `orbita_altura` ASC) VISIBLE,
  CONSTRAINT `id_basura`
    FOREIGN KEY (`id_basura`)
    REFERENCES `BDA_TPI`.`Basura` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Gravita_Orbita1`
    FOREIGN KEY (`orbita_excentricidad` , `orbita_sentido` , `orbita_altura`)
    REFERENCES `BDA_TPI`.`Orbita` (`excentricidad` , `sentido` , `altura`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BDA_TPI`.`Publica`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `BDA_TPI`.`Publica` ;

CREATE TABLE IF NOT EXISTS `BDA_TPI`.`Publica` (
  `agencia_nombre` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`agencia_nombre`),
  CONSTRAINT `esp_agencia`
    FOREIGN KEY (`agencia_nombre`)
    REFERENCES `BDA_TPI`.`Agencia` (`nombre`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BDA_TPI`.`Privada`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `BDA_TPI`.`Privada` ;

CREATE TABLE IF NOT EXISTS `BDA_TPI`.`Privada` (
  `agencia_nombre` VARCHAR(45) NOT NULL,
  `supervisada_por` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`agencia_nombre`),
  INDEX `fk_Privada_Publica1_idx` (`supervisada_por` ASC) VISIBLE,
  CONSTRAINT `fk_Privada_Agencia1`
    FOREIGN KEY (`agencia_nombre`)
    REFERENCES `BDA_TPI`.`Agencia` (`nombre`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Privada_Publica1`
    FOREIGN KEY (`supervisada_por`)
    REFERENCES `BDA_TPI`.`Publica` (`agencia_nombre`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BDA_TPI`.`Nombre_Estado`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `BDA_TPI`.`Nombre_Estado` ;

CREATE TABLE IF NOT EXISTS `BDA_TPI`.`Nombre_Estado` (
  `nombre` VARCHAR(45) NOT NULL,
  `publica_agencia_nombre` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`publica_agencia_nombre`),
  INDEX `fk_Nombre_Estado_Publica1_idx` (`publica_agencia_nombre` ASC) VISIBLE,
  CONSTRAINT `fk_Nombre_Estado_Publica1`
    FOREIGN KEY (`publica_agencia_nombre`)
    REFERENCES `BDA_TPI`.`Publica` (`agencia_nombre`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BDA_TPI`.`Lanza`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `BDA_TPI`.`Lanza` ;

CREATE TABLE IF NOT EXISTS `BDA_TPI`.`Lanza` (
  `nave_id_nave` INT NOT NULL,
  `nave_matricula` INT NOT NULL,
  `agencia_nombre` VARCHAR(45) NOT NULL,
  `orbita_excentricidad` REAL NOT NULL,
  `orbita_sentido` VARCHAR(15) NOT NULL,
  `orbita_altura` REAL NOT NULL,
  PRIMARY KEY (`nave_id_nave`, `nave_matricula`, `agencia_nombre`, `orbita_excentricidad`, `orbita_sentido`, `orbita_altura`),
  INDEX `fk_Lanza_Agencia1_idx` (`agencia_nombre` ASC) VISIBLE,
  INDEX `fk_Lanza_Orbita1_idx` (`orbita_excentricidad` ASC, `orbita_sentido` ASC, `orbita_altura` ASC) VISIBLE,
  CONSTRAINT `fk_Lanza_Nave1`
    FOREIGN KEY (`nave_id_nave` , `nave_matricula`)
    REFERENCES `BDA_TPI`.`Nave` (`clase_nave` , `matricula`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Lanza_Agencia1`
    FOREIGN KEY (`agencia_nombre`)
    REFERENCES `BDA_TPI`.`Agencia` (`nombre`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Lanza_Orbita1`
    FOREIGN KEY (`orbita_excentricidad` , `orbita_sentido` , `orbita_altura`)
    REFERENCES `BDA_TPI`.`Orbita` (`excentricidad` , `sentido` , `altura`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BDA_TPI`.`Fecha_Lanzamiento`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `BDA_TPI`.`Fecha_Lanzamiento` ;

CREATE TABLE IF NOT EXISTS `BDA_TPI`.`Fecha_Lanzamiento` (
  `dia` DATE NULL,
  `hora` TIME NULL,
  `lanza_nave_id_nave` INT NOT NULL,
  `lanza_nave_matricula` INT NOT NULL,
  `lanza_agencia_nombre` VARCHAR(45) NOT NULL,
  `lanza_orbita_excentricidad` INT NOT NULL,
  `lanza_orbita_sentido` VARCHAR(15) NOT NULL,
  `lanza_orbita_altura` INT NOT NULL,
  PRIMARY KEY (`lanza_nave_id_nave`, `lanza_nave_matricula`, `lanza_agencia_nombre`, `lanza_orbita_excentricidad`, `lanza_orbita_sentido`, `lanza_orbita_altura`),
  CONSTRAINT `fk_Fecha_Lanzamiento`
    FOREIGN KEY (`lanza_nave_id_nave` , `lanza_nave_matricula` , `lanza_agencia_nombre` , `lanza_orbita_excentricidad` , `lanza_orbita_sentido` , `lanza_orbita_altura`)
    REFERENCES `BDA_TPI`.`Lanza` (`nave_id_nave` , `nave_matricula` , `agencia_nombre` , `orbita_excentricidad` , `orbita_sentido` , `orbita_altura`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BDA_TPI`.`Empresa`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `BDA_TPI`.`Empresa` ;

CREATE TABLE IF NOT EXISTS `BDA_TPI`.`Empresa` (
  `id_empresa` INT NOT NULL,
  `capital` REAL(10,2) NULL,
  `nombre` VARCHAR(45) NULL,
  `CIF` VARCHAR(11) NULL,
  PRIMARY KEY (`id_empresa`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BDA_TPI`.`Financia`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `BDA_TPI`.`Financia` ;

CREATE TABLE IF NOT EXISTS `BDA_TPI`.`Financia` (
  `porcentaje` REAL(2,2) NOT NULL,
  `empresa_idempresa` INT NOT NULL,
  `privada_Agencia_nombre` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`porcentaje`, `empresa_idempresa`, `privada_Agencia_nombre`),
  INDEX `fk_Financia_Empresa1_idx` (`empresa_idempresa` ASC) VISIBLE,
  INDEX `fk_Financia_Privada1_idx` (`privada_Agencia_nombre` ASC) VISIBLE,
  CONSTRAINT `fk_Financia_Empresa1`
    FOREIGN KEY (`empresa_idempresa`)
    REFERENCES `BDA_TPI`.`Empresa` (`id_empresa`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Financia_Privada1`
    FOREIGN KEY (`privada_Agencia_nombre`)
    REFERENCES `BDA_TPI`.`Privada` (`agencia_nombre`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
