
--INSERT
--1. ��� �������� ������ �����
INSERT INTO [actor]
VALUES
	('Naomi Watts', DATEFROMPARTS ( 1968, 09, 28 ), 'Great Britain'),
	('Amanda Seyfried', DATEFROMPARTS ( 1985, 12, 03 ), 'USA'),
	('Mark Wahlberg', DATEFROMPARTS ( 1971, 07, 05 ), 'USA'),
	('Emma Watson', DATEFROMPARTS ( 1990, 04, 15 ), 'Great Britain'),
	('Matthew McConaughey', DATEFROMPARTS ( 1969, 11, 04 ), 'USA');

INSERT INTO [role]
VALUES
	(1, 1, 'Gertrude', 'main role'),
	(2, 2, 'Chloe', 'main role'),
	(3, 5, 'Cooper', 'main role');

INSERT INTO [production_company]
VALUES
	('IFC Films', 1999, 'USA'),
	('StudioCanal', 1988, 'France'),
	('Legendary Pictures', 2000, 'USA');

--2. � ��������� ������ �����

INSERT INTO [film]
	(title)
VALUES
	('Ophelia'),
	('Chloe'),
	('Interstellar');

INSERT INTO [rental]
	(id_film, release_date, country, fees)
VALUES
	(1, DATEFROMPARTS ( 2018, 07, 07 ), 'USA', 50722),
	(2,  DATEFROMPARTS ( 2009, 09, 20 ), 'USA', 3075255),
	(1, DATEFROMPARTS ( 2018, 09, 10 ), 'Russia', 79950),
	(3, DATEFROMPARTS ( 2014, 10, 14 ), 'USA', 188020017),
	(3, DATEFROMPARTS ( 2018, 11, 06 ), 'Russia', 26192066);

--3. � ������� �������� �� ������ �������

INSERT [film]
	(title) 
SELECT name FROM role; 

--DELETE
--1. ���� �������

DELETE [production_company]

--2. �� �������
		--DELETE FROM table_name WHERE condition;

DELETE FROM [actor] 
WHERE country_of_residence = 'Great Britain';

--3. �������� �������
		--TRUNCATE

TRUNCATE TABLE [production_company]

--UPDATE
--1. ���� �������

UPDATE [role]
SET name = 'name'; 

--2. �� ������� �������� ���� �������
		--UPDATE table_name SET column1 = value1, column2 = value2, ... WHERE condition;

UPDATE [role]
SET type = 'supporting role' 
WHERE name = 'name'

--3. �� ������� �������� ��������� ���������
		--UPDATE table_name SET column1 = value1, column2 = value2, ... WHERE condition;

UPDATE [actor]
SET full_name = 'Naomi Watts', date_of_birth = DATEFROMPARTS ( 1968, 09, 28 ), country_of_residence = 'Great Britain'
WHERE full_name = 'Amanda Seyfried';

--SELECT
--1. � ������������ ������� ����������� ��������� (SELECT atr1, atr2 FROM...)

SELECT full_name, country_of_residence FROM [actor];

--2. �� ����� ���������� (SELECT * FROM...)

SELECT * FROM [role];

--3. � �������� �� �������� (SELECT * FROM ... WHERE atr1 = "")

SELECT * FROM [actor] WHERE country_of_residence = 'Great Britain';

--SELECT ORDER BY + TOP (LIMIT)
--1. � ����������� �� ����������� ASC + ����������� ������ ���������� �������

SELECT TOP 5 * FROM actor
ORDER BY full_name;

--2. � ����������� �� �������� DESC

SELECT TOP 5 * FROM actor
ORDER BY date_of_birth DESC;

--3. � ����������� �� ���� ��������� + ����������� ������ ���������� �������

SELECT TOP 5 * FROM actor
ORDER BY full_name, date_of_birth;

--4. � ����������� �� ������� ��������, �� ������ �����������

SELECT full_name, date_of_birth FROM actor
ORDER BY 1;

--������ � ������
--1. WHERE �� ����

SELECT * FROM actor
WHERE date_of_birth > DATEFROMPARTS ( 1970, 08, 20 );

--2. ������� �� ������� �� ��� ����, � ������ ���.

SELECT * FROM actor
WHERE YEAR(date_of_birth) = 1968;

--SELECT GROUP BY � ��������� ���������
--1. MIN

SELECT id_film, MIN(fees) AS fees
FROM rental 
GROUP BY id_film; 

--2. MAX

SELECT id_film, MAX(fees) AS fees
FROM rental 
GROUP BY id_film; 

--3. AVG

SELECT id_film, AVG(fees) AS avg_fees
FROM rental 
GROUP BY id_film; 

--4. SUM

SELECT id_film, SUM(fees) AS sum_fees
FROM rental 
GROUP BY id_film; 

--5. COUNT

SELECT id_film, COUNT(*) AS count_id_film
FROM rental
GROUP BY id_film; 

--SELECT GROUP BY + HAVING
--1. �������� 3 ������ ������� � �������������� GROUP BY + HAVING
SELECT 
	country_of_residence, COUNT(*) AS count_country_of_residence
FROM 
	actor 
GROUP BY country_of_residence
HAVING country_of_residence = 'Great Britain';

SELECT 
	id_film, SUM(fees) AS sum_fees
FROM 
	rental
GROUP BY id_film
HAVING  id_film > 1;

SELECT 
	id_film, MIN(fees) AS avg_fees
FROM 
	rental
GROUP BY id_film
HAVING  id_film > 0;

----SELECT JOIN
--1. LEFT JOIN ���� ������ � WHERE �� ������ �� ���������

SELECT full_name, date_of_birth, name AS name_role
FROM actor
LEFT JOIN role ON actor.id_actor = role.id_actor
WHERE role.id_actor < 3;

--2. RIGHT JOIN. �������� ����� �� �������, ��� � � 5.1

--5.1
SELECT TOP 5 * FROM actor
ORDER BY full_name;

SELECT TOP 5 * FROM role
RIGHT JOIN actor ON role.id_actor = actor.id_actor
ORDER BY full_name;

--3. LEFT JOIN ���� ������ + WHERE �� �������� �� ������ �������

SELECT * FROM actor
LEFT JOIN role ON actor.id_actor = role.id_role
LEFT JOIN  rental ON rental.id_film = role.id_film
WHERE actor.country_of_residence != 'Great Britain' AND rental.id_film > 1 AND role.type = 'main role'

--4. FULL OUTER JOIN ���� ������

SELECT * FROM actor
FULL OUTER JOIN role ON role.id_actor = actor.id_actor

--����������
--1. �������� ������ � WHERE IN (���������)

SELECT full_name FROM actor
WHERE id_actor IN (SELECT id_actor FROM role WHERE id_role < 3);

--2. �������� ������ SELECT atr1, atr2, (���������) FROM ... 

SELECT 
	full_name,
	date_of_birth,
	(SELECT name FROM [role] 
	WHERE actor.id_actor = role.id_actor) AS role_name
FROM [actor]