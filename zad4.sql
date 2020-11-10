--CREATE DATABASE cw4;
CREATE EXTENSION postgis;
CREATE TABLE obiekty(
	nazwa VARCHAR(30),
	geometria GEOMETRY
);

INSERT INTO obiekty VALUES 
('obiekt1',ST_CurveToLine(ST_GeomFromText('COMPOUNDCURVE((0 1, 1 1),CIRCULARSTRING(1 1, 2 0, 3 1, 4 2, 5 1),(5 1, 6 1))',0 ))),
('obiekt2',ST_CurveToLine(ST_GeomFromText('CURVEPOLYGON(COMPOUNDCURVE((10 6, 14 6),CIRCULARSTRING(14 6, 16 4, 14 2, 12 0, 10 2),(10 2, 10 6)),CIRCULARSTRING(11 2,12 3, 13 2, 12 1, 11 2))',0 ))),
('obiekt3',ST_GeomFromText('POLYGON((7 15, 10 17, 12 13, 7 15))',0)),
('obiekt4',ST_GeomFromText('LINESTRING(20 20, 25 25, 27 24, 25 22, 26 21, 22 19, 20.5 19.5)',0)),
('obiekt5',ST_GeomFromText('MULTIPOINT Z(30 30 59,38 32 234)',0)),
('obiekt6',ST_GeomFromText('GEOMETRYCOLLECTION(LINESTRING(1 1, 3 2),POINT(4 2))',0));

--SELECT nazwa, geometria FROM obiekty;
--1
SELECT ST_Area(ST_Buffer((ST_ShortestLine(a.geometria,b.geometria)),5)) 
FROM obiekty a, obiekty b WHERE a.nazwa='obiekt4' AND b.nazwa='obiekt3';
--2
SELECT ST_AsText(ST_MakePolygon(ST_AddPoint(o.geometria,'POINT(20 20)'))) AS geometria
FROM obiekty o WHERE nazwa='obiekt4';
UPDATE obiekty SET geometria=ST_GeomFromText('POLYGON((20 20,25 25,27 24,25 22,26 21,22 19,20.5 19.5,20 20))',0)
WHERE obiekty.nazwa='obiekt4';
--3
INSERT INTO obiekty(geometria) SELECT ST_Union(a.geometria,b.geometria) 
FROM obiekty a, obiekty b WHERE a.nazwa='obiekt4' AND b.nazwa='obiekt3';

SELECT ST_AsText(ST_Union(a.geometria,b.geometria))
FROM obiekty a, obiekty b WHERE a.nazwa='obiekt4' AND b.nazwa='obiekt3';

UPDATE obiekty SET nazwa='obiekt7'
WHERE geometria=ST_GeomFromText('MULTIPOLYGON(((20 20,25 25,27 24,25 22,26 21,22 19,20.5 19.5,20 20)),((7 15,10 17,12 13,7 15)))',0);
--SELECT nazwa, geometria FROM obiekty WHERE nazwa='obiekt7';
--4
SELECT (ST_Area(ST_Buffer((a.geometria),5)) +
 ST_Area(ST_Buffer((b.geometria),5)) +
 ST_Area(ST_Buffer((c.geometria),5))+
 ST_Area(ST_Buffer((d.geometria),5))+
 ST_Area(ST_Buffer((e.geometria),5))) AS SUMA_BUFOROW
FROM obiekty a, obiekty b, obiekty c, obiekty d, obiekty e
WHERE  b.nazwa='obiekt3' AND a.nazwa='obiekt4' AND c.nazwa='obiekt6' AND d.nazwa='obiekt7' AND e.nazwa='obiekt5';

