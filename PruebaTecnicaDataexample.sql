CREATE DATABASE Dataexample

USE Dataexample

CREATE TABLE GG20(
	Grupo nvarchar(100) not null,
	Continente nvarchar(100) not null
)

CREATE TABLE PG20(
	Continente nvarchar(100) not null,
	País nvarchar(100) not null,
	Población int not null,
	Área int not null
)

-- 1.1) Escribe una consulta que devuelva el detalle de Argentina (columnas: país, población, área, continente).

SELECT País, Población, Área, Continente 
FROM PG20 
WHERE País = 'Argentina'

-- 1.2) Modificando la consulta anterior, agrega la columna “grupo”

SELECT PG20.País, PG20.Población, PG20.Área, PG20.Continente, GG20.Grupo 
FROM PG20 
INNER JOIN GG20 ON PG20.Continente = GG20.Continente 
WHERE País = 'Argentina' 

-- 1.3) Escribe una consulta que devuelva los países de latinoamérica (Argentina, Mexico y Brazil) y su detalle 
-- (columnas: población y área).

SELECT PG20.Población, PG20.Área 
FROM PG20 
WHERE (País = 'Argentina' OR País = 'México' OR País = 'Brazil')

-- 1.4) Escribe una consulta que calcule la densidad poblacional (población / área) y nombre la columna “densidad”

SELECT PG20.Población/PG20.Área AS densidad 
FROM PG20

-- 1.5) Escribe la consulta que calcule la población para cada continente ordenada por población descendente

SELECT PG20.Continente, SUM(PG20.Población) AS 'población para cada continente' 
FROM PG20
GROUP BY PG20.Continente
ORDER BY 'población para cada continente' DESC  

-- 1.6) Escribe la consulta que calcule la población total de los países Latinoamerica (Argentina, Mexico y Brazil).

SELECT PG20.País, SUM(PG20.Población) AS 'población total de los países Latinoamerica'
FROM PG20
WHERE (País = 'Argentina' OR País = 'México' OR País = 'Brazil')
GROUP BY País

-- 1.7) Escribe la consulta que devuelva el listado de todos los continentes con la cantidad de países donde 
-- esa cantidad sea mayor a 1

SELECT PG20.Continente, COUNT(PG20.País)
FROM PG20
GROUP BY PG20.Continente
HAVING COUNT(PG20.País) > 1

--**********************************

CREATE TABLE Local(
	ID_Local int identity(1,1),
	Nombre nvarchar(100) not null,
	PRIMARY KEY (ID_Local)
)

CREATE TABLE Producto(
	ID int identity(1,1),
	Producto nvarchar(100) not null,
	Monto int not null,
	ID_Local nvarchar(100) not null,
	PRIMARY KEY (ID),
	--FOREIGN KEY (ID_local) REFERENCES Local(ID_Local)
)

-- 1.8) Usando las siguientes tablas de referencia, escribe la consulta que devuelva el SEGUNDO producto 
-- más caro de cada local (es decir, la respuesta tiene que traer los registros correspondientes de Prod A y Prod D).

-- ID_Local = Area
-- Monto = Costo
-- Producto = Asignaturas

WITH AgrupaMonto_CTE AS  
-- Define the CTE query.  
(  
    SELECT Producto.ID_Local, Producto.Monto,ROW_NUMBER() OVER (
    PARTITION BY Producto.ID_Local
    ORDER BY Producto.Monto DESC
)  row_num
FROM Producto
GROUP BY ID_Local, Monto)
-- Define the outer query referencing the CTE name. 
SELECT ID_Local, Monto 
FROM AgrupaMonto_CTE 
WHERE row_num = 2
ORDER BY ID_Local, Monto