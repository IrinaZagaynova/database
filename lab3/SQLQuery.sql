--INSERT
--1. Без указания списка полей
INSERT INTO actor
VALUES
	('Naomi Watts', '28.09.1968', 'Great Britain'),
	('Amanda Seyfried', '03.12.1985', 'USA'),
	('Mark Wahlberg', '05.07.1971', 'USA'),
	('Emma Watson', '15.04.1990', 'Great Britain'),
	('Matthew McConaughey', '04.11.1969', 'USA');

INSERT INTO role
VALUES
	(1, 1, 'Gertrude', 'main role'),
	(2, 2, 'Chloe', 'main role'),
	(3, 5, 'Cooper', 'main role');

INSERT INTO production_company
VALUES
	('IFC Films', 1999, 'USA'),
	('StudioCanal', 1988, 'France'),
	('Legendary Pictures', 2000, 'USA');

--2. С указанием списка полей

INSERT INTO film
	(title)
VALUES
	('Ophelia'),
	('Chloe'),
	('Interstellar');

INSERT INTO rental
	(id_film, release_date, country, fees)
VALUES
	(1, '07-07-2018', 'USA', 50722),
	(2, '20-09-2009', 'USA', 3075255),
	(1, '10-09-2018', 'Russia', 79950),
	(3, '14-2-2014', 'USA', 188020017),
	(3, '06-11-2018', 'Russia', 26192066);

--3. С чтением значения из другой таблицы

INSERT film
	(title) 
SELECT name FROM role; 

--DELETE
--1. Всех записей

DELETE production_company

--2. По условию
--DELETE FROM table_name WHERE condition;

DELETE FROM actor 
WHERE country_of_residence = 'Great Britain';

--3. Очистить таблицу
--TRUNCATE

TRUNCATE TABLE production_company

--UPDATE
--1. Всех записей

UPDATE role
SET name = 'name'; 

--2. По условию обновляя один атрибут
--UPDATE table_name SET column1 = value1, column2 = value2, ... WHERE condition;

UPDATE role
SET type = 'supporting role' 
WHERE name = 'name'

--3. По условию обновляя несколько атрибутов
--UPDATE table_name SET column1 = value1, column2 = value2, ... WHERE condition;

UPDATE actor
SET full_name = 'Naomi Watts', date_of_birth = '28.09.1968', country_of_residence = 'Great Britain'
WHERE full_name = 'Amanda Seyfried';

--SELECT
--1. С определенным набором извлекаемых атрибутов (SELECT atr1, atr2 FROM...)

SELECT full_name, country_of_residence FROM actor;

--2. Со всеми атрибутами (SELECT * FROM...)

SELECT * FROM role;

--3. С условием по атрибуту (SELECT * FROM ... WHERE atr1 = "")

SELECT * FROM actor WHERE country_of_residence = 'Great Britain';

--SELECT ORDER BY + TOP (LIMIT)
--1. С сортировкой по возрастанию ASC + ограничение вывода количества записей

SELECT TOP 5 * FROM actor
ORDER BY full_name;

--2. С сортировкой по убыванию DESC

SELECT TOP 5 * FROM actor
ORDER BY date_of_birth DESC;

--3. С сортировкой по двум атрибутам + ограничение вывода количества записей

SELECT TOP 5 * FROM actor
ORDER BY full_name, date_of_birth;

--4. С сортировкой по первому атрибуту, из списка извлекаемых

SELECT full_name, date_of_birth FROM actor
ORDER BY 1;

--Работа с датами
--1. WHERE по дате

SELECT * FROM actor
WHERE date_of_birth > '20.08.1970';

--2. Извлечь из таблицы не всю дату, а только год.

SELECT * FROM actor
WHERE YEAR(date_of_birth) = 1968;

--SELECT GROUP BY с функциями агрегации
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
--1. Написать 3 разных запроса с использованием GROUP BY + HAVING
SELECT country_of_residence, COUNT(*) AS count_country_of_residence
FROM actor 
GROUP BY country_of_residence
HAVING country_of_residence = 'USA';

SELECT id_film, SUM(fees) AS sum_fees
FROM rental
GROUP BY id_film
HAVING  id_film > 1;

SELECT id_film, MIN(fees) AS min_fees
FROM rental
GROUP BY id_film
HAVING  id_film > 0;

----SELECT JOIN
--1. LEFT JOIN двух таблиц и WHERE по одному из атрибутов

SELECT full_name, date_of_birth, name AS name_role FROM actor
LEFT JOIN role ON actor.id_actor = role.id_actor
WHERE role.id_actor < 3;

--2. RIGHT JOIN. Получить такую же выборку, как и в 5.1

--5.1
SELECT TOP 5 * FROM actor
ORDER BY full_name;

SELECT TOP 5 actor.id_actor, actor.full_name, actor.date_of_birth, actor.country_of_residence FROM role
RIGHT JOIN actor ON role.id_actor = actor.id_actor
ORDER BY full_name;

--3. LEFT JOIN трех таблиц + WHERE по атрибуту из каждой таблицы

SELECT * FROM actor
LEFT JOIN role ON actor.id_actor = role.id_role
LEFT JOIN  rental ON rental.id_film = role.id_film
WHERE actor.country_of_residence != 'USA' AND rental.id_film > 1 AND role.type != 'main role'

--4. FULL OUTER JOIN двух таблиц

SELECT * FROM actor
FULL OUTER JOIN role ON role.id_actor = actor.id_actor

--Подзапросы
--1. Написать запрос с WHERE IN (подзапрос)

SELECT full_name FROM actor
WHERE id_actor IN (SELECT id_actor FROM role WHERE id_role < 3);

--2. Написать запрос SELECT atr1, atr2, (подзапрос) FROM ... 

SELECT 
	full_name,
	date_of_birth,
	(SELECT name FROM role 
	WHERE role.id_actor > 2) AS role_name
FROM actor