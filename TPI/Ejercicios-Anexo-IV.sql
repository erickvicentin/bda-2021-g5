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
select * from Agencia;

#2.2 Listar los pares en la forma (componente1, componente2), donde componente1 y
#componente2 son tales que componente1 forma parte de otro que a su vez depende
#de componente2
select par1.componente, par2.componente
from Compone_de as par1
inner join Compone_de as par2 on par1.parte_de = par2.parte_de AND NOT (par1.componente = par2.componente);

#2.3
#Listar los artículos que forman parte de todas las partes (en forma directa). Luego si la
#consulta es vacía inserte los registros que sean necesarios para que la respuesta tenga
#resultados

select componente as LComponente
from Compone_de
group by componente
having count(parte_de) = (select count(distinct(parte_de)) from Compone_de);

#2.4
#Listar, para cada nombre de parte, 
#todos los nombres de las subpartes que la componen,
#recursivamente.

with recursive misPartes as (
	select componente as comp, tp.nombre as nombre
    from Compone_de
	inner join Tipo_Componente as tp on tp.codigo = Compone_de.parte_de
    where parte_de = '11'
    
    UNION ALL
    
    select componente, tp.nombre as nombre
    from misPartes, Compone_de
    inner join Tipo_Componente as tp on tp.codigo = Compone_de.parte_de
    where misPartes.comp = Compone_de.parte_de AND 
    )
select GROUP_CONCAT(distinct tp.nombre) as partes from misPartes
inner join Tipo_Componente as tp on tp.codigo = comp;


## SECCION 3 

#3.1 Dada la consulta de naves y orbitas que estuvo añada una columna adicional que
#muestre el tiempo promedio que estuvo en cada orbita.

-- DIFERENCIA DE MESES ENTRE FECHAS
select n.matricula, n.clase_nave, group_concat(o.altura,'/', o.excentricidad,'/', o.sentido) as orbita, group_concat(fi.dia, '/', ff.dia), AVG(timestampdiff(MONTH,fi.dia,ff.dia)) as tiempo_estimado
from Fecha_Inicio as fi
inner join Fecha_Fin as ff on 
							fi.esta_id_nave_matricula = ff.esta_id_nave_matricula 
                            AND 
                            fi.esta_id_nave_clase = ff.esta_id_nave_clase
inner join Nave as n on 
						fi.esta_id_nave_matricula = n.matricula
                        AND
                        fi.esta_id_nave_clase = n.clase_nave
inner join Orbita as o on
						fi.esta_id_altura = o.altura
                        AND
                        fi.esta_id_orbita_exc = o.excentricidad
                        AND
                        fi.esta_id_sentido = o.sentido
group by fi.esta_id_nave_matricula, fi.esta_id_nave_clase, o.altura, o.excentricidad, o.sentido;
