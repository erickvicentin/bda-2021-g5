-- ANEXO IV) --

##1.1)
SELECT res.matri as Matricula, res.cantidad as Cant_Basura
FROM (
	SELECT n.matricula as matri, COUNT(b.id) as cantidad
	FROM Nave as n INNER JOIN Produce as p 
        	ON n.matricula = p.nave_matricula 
        	AND n.clase_nave = p.nave_clase_nave
	INNER JOIN Basura as b ON p.basura_id = b.id
	GROUP BY n.matricula) as res
WHERE res.cantidad > 5;

-- Otra forma --
SELECT nave_matricula as 'Matricula', nave_clase_nave as 'Clase nave', count(nave_matricula) as 'Cantidad de Basura'
FROM Produce 
GROUP BY nave_matricula, nave_clase_nave 
HAVING count(nave_matricula)>5;

##1.2)
select p.basura_id, p2.basura_id, p.nave_matricula
from Produce as p
inner join Produce as p2
on p.nave_matricula = p2.nave_matricula AND p.nave_clase_nave = p2.nave_clase_nave AND NOT (p.basura_id = p2.basura_id);

##1.3)

select distinct a.nombre from Nave as n inner join Agencia as a on n.agencia_nombre=a.nombre
where (n.matricula,n.clase_nave) not in (select l.nave_matricula,l.nave_id_nave from Lanza as l);

##1.4)
SELECT o.excentricidad, o.sentido, o.altura, a.nombre as Nombre_Agencia, a.tipo as TIPO
FROM Orbita as o LEFT JOIN Lanza as l
				 ON o.excentricidad = l.orbita_excentricidad
                 AND o.sentido = l.orbita_sentido
                 AND o.altura = l.orbita_altura
                 INNER JOIN Agencia as a ON l.agencia_nombre = a.nombre
WHERE a.tipo = 'PRIVADA';

##1.5)

SELECT sup.agencia as Agencia_Publica, ne.nombre as Estado
FROM ( 
	SELECT supervisada_por as agencia
	FROM Privada 
	GROUP BY supervisada_por
	HAVING COUNT(supervisada_por) > 2) as sup
    INNER JOIN Nombre_Estado as ne ON ne.publica_agencia_nombre = sup.agencia;

-- PARTE 2 --

-- 2.1

SELECT t1.componente as 'Codigo Componente' , tc.nombre as 'Nombre Componente'
FROM (
	SELECT componente, count(componente)
	FROM Compone_de
	GROUP BY componente
	HAVING count(componente) >= 3) as t1 INNER JOIN Tipo_Componente as tc
	ON tc.codigo = t1.componente;


