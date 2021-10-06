CREATE SCHEMA IF NOT EXISTS `ejer4` DEFAULT CHARACTER SET utf8 ;
USE `ejer4` ;

CREATE TABLE IF NOT EXISTS `Estudios` (
  `nombre` VARCHAR(45) NOT NULL,
  `website` VARCHAR(45) NOT NULL,
  `direccion` VARCHAR(60) NULL,
  PRIMARY KEY (`nombre`, `website`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Series` (
  `titulo` VARCHAR(45) NOT NULL,
  `creador` VARCHAR(45) NOT NULL,
  `website` VARCHAR(45) NULL,
  `fecha_inicio` DATE NULL,
  `fecha_fin` DATE NULL,
  `estudios_nombre` VARCHAR(45) NOT NULL,
  `estudios_website` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`titulo`, `creador`),
  CONSTRAINT `FK_series_estudios`
    FOREIGN KEY (`estudios_nombre` , `estudios_website`)
    REFERENCES `Estudios` (`nombre` , `website`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `episodios` (
  `id_serie` VARCHAR(45) NOT NULL,
  `series_titulo` VARCHAR(45) NOT NULL,
  `series_creador` VARCHAR(45) NOT NULL,
  `rating` INT NULL,
  `descripcion` VARCHAR(45) NULL,
  `url_multimedia` VARCHAR(45) NULL,
  `fecha_emision` DATE NULL,
  `temporada` VARCHAR(45) NULL,
  PRIMARY KEY (`id_serie`, `series_titulo`, `series_creador`),
  CONSTRAINT `FK_episodios_series`
    FOREIGN KEY (`series_titulo` , `series_creador`)
    REFERENCES `Series` (`titulo` , `creador`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Personajes` (
  `series_titulo` VARCHAR(45) NOT NULL,
  `series_creador` VARCHAR(45) NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `rol` VARCHAR(45) NULL,
  PRIMARY KEY (`series_titulo`, `series_creador`, `nombre`),
  CONSTRAINT `FK_personajes_series`
    FOREIGN KEY (`series_titulo` , `series_creador`)
    REFERENCES `Series` (`titulo` , `creador`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Actores` (
  `nombre` VARCHAR(45) NOT NULL,
  `website` VARCHAR(45) NULL,
  PRIMARY KEY (`nombre`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Protagonizan` (
  `episodios_id_serie` VARCHAR(45) NOT NULL,
  `episodios_series_titulo` VARCHAR(45) NOT NULL,
  `episodios_series_creador` VARCHAR(45) NOT NULL,
  `personajes_id_serie` INT NOT NULL,
  `personajes_series_titulo` VARCHAR(45) NOT NULL,
  `personajes_series_creador` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`episodios_id_serie`, `episodios_series_titulo`, `episodios_series_creador`, `personajes_id_serie`, `personajes_series_titulo`, `personajes_series_creador`),
  CONSTRAINT `FK_protagonizan_episodios`
    FOREIGN KEY (`episodios_id_serie` , `episodios_series_titulo` , `episodios_series_creador`)
    REFERENCES `episodios` (`id_serie` , `series_titulo` , `series_creador`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_protagonizan_personajes`
    FOREIGN KEY (`personajes_series_titulo` , `personajes_series_creador`)
    REFERENCES `Personajes` (`series_titulo` , `series_creador`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Participan` (
  `series_titulo` VARCHAR(45) NOT NULL,
  `series_creador` VARCHAR(45) NOT NULL,
  `actores_nombre` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`series_titulo`, `series_creador`, `actores_nombre`),
  CONSTRAINT `FK_participan_series`
    FOREIGN KEY (`series_titulo` , `series_creador`)
    REFERENCES `Series` (`titulo` , `creador`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_participan_actores`
    FOREIGN KEY (`actores_nombre`)
    REFERENCES `Actores` (`nombre`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Interpreta` (
  `personajes_id_serie` INT NOT NULL,
  `personajes_series_titulo` VARCHAR(45) NOT NULL,
  `personajes_series_creador` VARCHAR(45) NOT NULL,
  `actores_nombre` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`personajes_id_serie`, `personajes_series_titulo`, `personajes_series_creador`, `actores_nombre`),
  CONSTRAINT `FK_interpreta_personajes`
    FOREIGN KEY (`personajes_series_titulo` , `personajes_series_creador`)
    REFERENCES `Personajes` (`series_titulo` , `series_creador`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_interpreta_actores`
    FOREIGN KEY (`actores_nombre`)
    REFERENCES `Actores` (`nombre`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;
