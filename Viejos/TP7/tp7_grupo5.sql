USE world_x;

show tables;

DESCRIBE city;

SELECT * 
from country
limit 1;

select name
from city
where Info -> '$.Population' > 1000000;

select *
from city
where name LIKE 'Buenos Aires';


# Mostrar un listado “entendible” de la información registrada de los 10 últimos países ordenados por código (campo Code).

select JSON_EXTRACT(doc, "$.GNP") as GNP, 
json_extract(doc,"$._id") as id, 
json_extract(doc, "$.Code") as Code, 
json_extract(doc, "$.Name") as Name,
json_extract(doc, "$.IndepYear") as IndepYear,
json_extract(doc, "$.geography.Region") as Region,
json_extract(doc, "$.geography.Continent") as Continent,
json_extract(doc, "$.geography.SurfaceArea") as SurfaceArea,
json_extract(doc, "$.geography.Region") as Region,
json_extract(doc, "$.government.HeadOfState") as HeadOfState,
json_extract(doc, "$.government.GovernmentForm") as GovernmentForm,
json_extract(doc, "$.demographics.Population") as Population,
json_extract(doc, "$.demographics.LifeExpectancy") as LifeExpectancy
from countryinfo
order by json_extract(doc, "$.Code") DESC
LIMIT 10;

select doc -> "$.government" from countryinfo;

SELECT JSON_KEYS(doc) FROM countryinfo;
SELECT JSON_KEYS(doc -> "$.demographics") FROM countryinfo;