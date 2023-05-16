CREATE DATABASE Dataexample

USE Dataexample

CREATE TABLE GG20(
	Grupo nvarchar(100) not null,
	Continente nvarchar(100) not null
)

CREATE TABLE PG20(
	Continente nvarchar(100) not null,
	Pa�s nvarchar(100) not null,
	Poblaci�n int not null,
	�rea int not null
)

-- 1.1) Escribe una consulta que devuelva el detalle de Argentina (columnas: pa�s, poblaci�n, �rea, continente).

SELECT Pa�s, Poblaci�n, �rea, Continente 
FROM PG20 
WHERE Pa�s = 'Argentina'

-- 1.2) Modificando la consulta anterior, agrega la columna �grupo�

SELECT PG20.Pa�s, PG20.Poblaci�n, PG20.�rea, PG20.Continente, GG20.Grupo 
FROM PG20 
INNER JOIN GG20 ON PG20.Continente = GG20.Continente 
WHERE Pa�s = 'Argentina' 

-- 1.3) Escribe una consulta que devuelva los pa�ses de latinoam�rica (Argentina, Mexico y Brazil) y su detalle 
-- (columnas: poblaci�n y �rea).

SELECT PG20.Poblaci�n, PG20.�rea 
FROM PG20 
WHERE (Pa�s = 'Argentina' OR Pa�s = 'M�xico' OR Pa�s = 'Brazil')

-- 1.4) Escribe una consulta que calcule la densidad poblacional (poblaci�n / �rea) y nombre la columna �densidad�

SELECT PG20.Poblaci�n/PG20.�rea AS densidad 
FROM PG20

-- 1.5) Escribe la consulta que calcule la poblaci�n para cada continente ordenada por poblaci�n descendente

SELECT PG20.Continente, SUM(PG20.Poblaci�n) AS 'poblaci�n para cada continente' 
FROM PG20
GROUP BY PG20.Continente
ORDER BY 'poblaci�n para cada continente' DESC  

-- 1.6) Escribe la consulta que calcule la poblaci�n total de los pa�ses Latinoamerica (Argentina, Mexico y Brazil).

SELECT PG20.Pa�s, SUM(PG20.Poblaci�n) AS 'poblaci�n total de los pa�ses Latinoamerica'
FROM PG20
WHERE (Pa�s = 'Argentina' OR Pa�s = 'M�xico' OR Pa�s = 'Brazil')
GROUP BY Pa�s

-- 1.7) Escribe la consulta que devuelva el listado de todos los continentes con la cantidad de pa�ses donde 
-- esa cantidad sea mayor a 1

SELECT PG20.Continente, COUNT(PG20.Pa�s)
FROM PG20
GROUP BY PG20.Continente
HAVING COUNT(PG20.Pa�s) > 1

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
-- m�s caro de cada local (es decir, la respuesta tiene que traer los registros correspondientes de Prod A y Prod D).

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