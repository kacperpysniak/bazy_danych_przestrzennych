--CREATE DATABASE alaska;

CREATE EXTENSION postgis;
--4.
CREATE TABLE tableB AS SELECT DISTINCT popp.gid, popp.cat, popp.f_codedesc, popp.f_code, popp.type, popp.geom
FROM majrivers, popp
WHERE popp.f_codedesc='Building' AND ST_DWithin(majrivers.geom, popp.geom, 100000.0)
ORDER BY popp.gid;

SELECT COUNT ( DISTINCT popp.gid )AS ilość_budynków
FROM majrivers, popp
WHERE popp.f_codedesc='Building' AND ST_DWithin(majrivers.geom, popp.geom, 100000.0);

--5.

--a)
SELECT name AS Max_East_Airport 
FROM airportsNew 
ORDER BY ST_X(geom) 
DESC LIMIT 1;

SELECT name AS Max_West_Airport 
FROM airportsNew 
ORDER BY ST_X(geom) 
LIMIT 1;

--b)
INSERT INTO airportsNew(geom) SELECT ST_Centroid(ST_MakeLine(geom)) FROM airportsNew 
WHERE (  airportsNew.name='ANNETTE ISLAND' OR  airportsNew.name='ATKA');

UPDATE airportsNew SET name='airportB',elev=100.000 WHERE airportsNew.geom='0101000000205F77A77378F040F2053A31C6603F41';
--6
SELECT PI()*1000*1000 + 2*1000*ST_Distance(airports.geom, lakes.geom) AS Pole_Obszaru FROM airports, lakes  
WHERE( airports.name='AMBLER' AND  lakes.names='Iliamna Lake');
--7
--Nie mogę wykonać zadania ponieważ każda próba wyświetlenia geometri z 3 tabel jednocześnie kończy się zawieszeniem komputera 