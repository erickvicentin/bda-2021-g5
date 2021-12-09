#i

drop procedure if exists pa_actores_obtener;
DELIMITER //
CREATE PROCEDURE pa_actores_obtener (idpelicula varchar(30))
BEGIN
DECLARE i INT DEFAULT 0;
DECLARE j INT DEFAULT 0;
DECLARE pelicula TEXT DEFAULT '';
SELECT ExtractValue(catalogo, 'count(/CatalogoPeliculas/Pelicula)') INTO j FROM nuevos_catalogos;
	WHILE i <= j and idpelicula not like pelicula Do
		SET i = i + 1;
		set pelicula = (SELECT ExtractValue(catalogo,'/CatalogoPeliculas/Pelicula[$i]/Titulo') FROM nuevos_catalogos);
	end while;
  SELECT fecha_alta,ExtractValue(catalogo,'/CatalogoPeliculas/Pelicula[$i]/Actores/Actor') FROM nuevos_catalogos;
END //
DELIMITER ;

call  pa_actores_obtener ("Titanic");

#ii

drop procedure if exists obtener_titulo;
DELIMITER //
CREATE PROCEDURE obtener_titulo (idactor varchar(30))
BEGIN
DECLARE i INT DEFAULT 0;
DECLARE j INT DEFAULT 0;
DECLARE genero1 text DEFAULT '';
set idactor= concat('%',idactor,'%');
SELECT ExtractValue(catalogo, 'count(/CatalogoPeliculas/Pelicula)') INTO j FROM nuevos_catalogos;
	WHILE i <= j  Do
		SET i = i + 1;
		if (SELECT ExtractValue(catalogo,'/CatalogoPeliculas/Pelicula[$i]/Actores/Actor') FROM nuevos_catalogos) like idactor   then
        SELECT fecha_alta,ExtractValue(catalogo,'/CatalogoPeliculas/Pelicula[$i]/Titulo') FROM nuevos_catalogos;
        end if;
	end while;
		
END //
DELIMITER ;
call obtener_titulo ('Dicaprio');

# iii
drop procedure if exists obtener_duracion;
DELIMITER //
CREATE PROCEDURE obtener_duracion (genero1 varchar(30))
BEGIN
DECLARE i INT DEFAULT 0;
DECLARE j INT DEFAULT 0;

SELECT ExtractValue(catalogo, 'count(/CatalogoPeliculas/Pelicula)') INTO j FROM nuevos_catalogos;
	WHILE i <= j  Do
		SET i = i + 1;
		if (SELECT ExtractValue(catalogo,'/CatalogoPeliculas/Pelicula[$i]/Genero') FROM nuevos_catalogos) like genero1 then
        SELECT ExtractValue(catalogo,'/CatalogoPeliculas/Pelicula[$i]/Duracion') FROM nuevos_catalogos;
        end if;
	end while;
		
END //
DELIMITER ;
call obtener_duracion ('Thriller');

# iv
drop procedure if exists act_peliculas;
DELIMITER //
CREATE PROCEDURE act_peliculas ()
BEGIN
DECLARE i INT DEFAULT 0;
DECLARE j INT DEFAULT 0;

SELECT ExtractValue(catalogo, 'count(/CatalogoPeliculas/Pelicula)') INTO j FROM nuevos_catalogos;
	WHILE i <= j  Do
		SET i = i + 1;
		if (SELECT ExtractValue(catalogo,'/CatalogoPeliculas/Pelicula[$i]/Formato') FROM nuevos_catalogos) like 'VHS' then
		UPDATE nuevos_catalogos 
        SET catalogo = UpdateXML(catalogo,'/CatalogoPeliculas/Pelicula[$i]/Formato','<Formato>Blue-Ray</Formato>');
        end if;
	end while;
		
END //
DELIMITER ;
call act_peliculas ();
