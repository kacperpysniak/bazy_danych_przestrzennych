--CREATE DATABASE BDP_1;
CREATE EXTENSION postgis;
CREATE TABLE budynki(
	id INTEGER,
	geometria GEOMETRY,
	nazwa VARCHAR(30)
);
ALTER TABLE budynki ADD PRIMARY KEY (id);
CREATE TABLE drogi(
	id INTEGER,
	geometria GEOMETRY,
	nazwa VARCHAR(30)
);
ALTER TABLE drogi ADD PRIMARY KEY (id);
CREATE TABLE punkty_informacyjne(
	id INTEGER,
	geometria GEOMETRY,
	nazwa VARCHAR(30)
);
ALTER TABLE punkty_informacyjne ADD PRIMARY KEY (id);

INSERT INTO budynki VALUES 
(1,ST_GeomFromText('POLYGON((8 4, 10.5 4, 10.5 1.5, 8 1.5, 8 4))',0),'BuildingA'),
(2,ST_GeomFromText('POLYGON((4 7, 6 7, 6 5, 4 5, 4 7))',0),'BuildingB'),
(3,ST_GeomFromText('POLYGON((3 8, 5 8, 5 6, 3 6, 3 8))',0),'BuildingC'),
(4,ST_GeomFromText('POLYGON((9 9, 10 9, 10 8, 9 8, 9 9))',0),'BuildingD'),
(5,ST_GeomFromText('POLYGON((1 2, 2 2, 2 1, 1 1, 1 2))',0),'BuildingF');

--SELECT id,geometria,nazwa, ST_AsText(geometria) FROM budynki;
INSERT INTO drogi VALUES
(101,ST_GeomFromText('LINESTRING(7.5 10.5, 7.5 0)',0),'RoadY'),
(102,ST_GeomFromText('LINESTRING(0 4.5, 12 4.5)',0),'RoadX');

--SELECT id,geometria,nazwa, ST_AsText(geometria) FROM drogi;
INSERT INTO punkty_informacyjne VALUES
(11,ST_GeomFromText('POINT (6 9.5)',0),'K'),
(12,ST_GeomFromText('POINT (6.5 6)',0),'J'),
(13,ST_GeomFromText('POINT (9.5 6)',0),'I'),
(14,ST_GeomFromText('POINT (1 3.5)',0),'G'),
(15,ST_GeomFromText('POINT (5.5 1.5)',0),'H');

--SELECT id,geometria,nazwa, ST_AsText(geometria) FROM punkty_informacyjne;
--a)
SELECT SUM (ST_Length(geometria)) AS Długosć_Całkowita_Dróg FROM drogi;
--b)
SELECT ST_Perimeter(geometria) AS Obwód, ST_Area(geometria) as pole_powierzchni  FROM budynki WHERE nazwa = 'BuildingA';
--c)
SELECT nazwa, ST_Area(geometria) AS pole_powierzchni  FROM budynki ORDER BY nazwa;
--d)
SELECT nazwa, ST_Area(geometria) AS pole_powierzchni  FROM budynki ORDER BY ST_Area(geometria) DESC LIMIT 2;
--e)
SELECT ST_Distance(budynki.geometria, punkty_informacyjne.geometria) FROM budynki, punkty_informacyjne
WHERE budynki.nazwa = 'BuildingC' AND punkty_informacyjne.nazwa = 'G';
--f)
SELECT St_Area(c.geometria) - St_Area(St_Intersection(c.geometria, St_Buffer(b.geometria, 0.5))) FROM budynki b ,budynki c
WHERE c.nazwa = 'BuildingC' AND b.nazwa = 'BuildingB';
--g)
SELECT nazwa FROM budynki 
WHERE ST_Y(ST_Centroid(geometria)) > (SELECT ST_Y(ST_Centroid(geometria)) FROM drogi WHERE nazwa = 'RoadX');
--g,8)
SELECT ST_AREA(ST_SymDifference(geometria, ST_GeomFromText('POLYGON((4 7,6 7,6 8,4 8,4 7))',0))) FROM budynki 
WHERE nazwa = 'BuildingC';
