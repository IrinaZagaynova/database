--1. Добавить внешние ключи

ALTER TABLE room
ADD FOREIGN KEY (id_hotel) REFERENCES hotel(id_hotel)

ALTER TABLE room
ADD FOREIGN KEY (id_room_category) REFERENCES room_category(id_room_category)

ALTER TABLE room_in_booking
ADD FOREIGN KEY (id_room) REFERENCES room(id_room)

ALTER TABLE room_in_booking
ADD FOREIGN KEY (id_booking) REFERENCES booking(id_booking)

ALTER TABLE booking
ADD FOREIGN KEY (id_client) REFERENCES client(id_client)


--2. Выдать информация о клиентах гостиницы "Космос", проживающих в номерах категории "Люкс" на 1 апреля 2019г

SELECT client.id_client, client.name, client.phone FROM client
JOIN booking ON client.id_client = booking.id_client
JOIN room_in_booking ON booking.id_booking = room_in_booking.id_booking
JOIN room ON room_in_booking.id_room = room.id_room
JOIN hotel ON room.id_hotel = hotel.id_hotel
JOIN room_category ON room.id_room_category = room_category.id_room_category
WHERE hotel.name = N'Космос' and 
	room_category.name = N'Люкс' and
	room_in_booking.checkin_date <= '01.04.2019' and
	room_in_booking.checkout_date > '01.04.2019';

--3. Дать список свободных номеров всех гостиниц на 22 апреля

SELECT * FROM room
WHERE id_room NOT IN (
	SELECT room_in_booking.id_room FROM room_in_booking
	RIGHT JOIN room ON room.id_room = room_in_booking.id_room
	WHERE room_in_booking.checkin_date <= '22.04.2019' and 
	room_in_booking.checkout_date > '22.04.2019')
ORDER BY room.id_room;

--4. Дать количество проживающих в гостинице "Космос" на 23 марта по каждой категории номеров

SELECT room_category.id_room_category, room_category.name, COUNT(*) AS count_room_category FROM room_category
JOIN room ON room_category.id_room_category = room.id_room_category
JOIN room_in_booking ON room.id_room = room_in_booking.id_room
JOIN hotel ON room.id_hotel = hotel.id_hotel
WHERE hotel.name = N'Космос' and
	room_in_booking.checkin_date <= '23.04.2019' and
	room_in_booking.checkout_date > '23.04.2019'
GROUP BY room_category.id_room_category, room_category.name;

--5. Дать список последних проживавших клиентов по всем комнатам гостиницы "Космос", выехавшим в апреле с указанием даты выезда

SELECT client.id_client, client.name, room.id_room, max_room_in_booking_cd FROM room
JOIN room_in_booking ON room.id_room = room_in_booking.id_room
JOIN booking ON room_in_booking.id_booking = booking.id_booking
JOIN client ON booking.id_client = client.id_client
JOIN (
	SELECT room_in_booking.id_room, MAX(room_in_booking.checkout_date) AS max_room_in_booking_cd FROM room_in_booking
	WHERE YEAR(room_in_booking.checkout_date) = '2019' and
		MONTH(room_in_booking.checkout_date) = '04'
	GROUP BY room_in_booking.id_room) 
	AS selected_room_in_booking ON selected_room_in_booking.id_room = room.id_room
JOIN hotel ON room.id_hotel = hotel.id_hotel
WHERE hotel.name = N'Космос' and
	room_in_booking.checkout_date = selected_room_in_booking.max_room_in_booking_cd
ORDER BY room.id_room;

--6. Продлить на 2 дня дату проживания в гостинице "Космос" всем клиентам комнат категории "Бизнес", которые заселились 10 мая

UPDATE room_in_booking
SET room_in_booking.checkout_date = DATEADD(day, 2, checkout_date)
FROM room_in_booking
JOIN room ON room_in_booking.id_room = room.id_room
JOIN hotel ON room.id_hotel = hotel.id_hotel
JOIN room_category ON room.id_room_category = room_category.id_room_category
WHERE hotel.name = N'Космос' and
	room_category.name = N'Бизнес' and
	room_in_booking.checkin_date = '10.05.2019';

--7. Найти все "пересекающиеся" варианты проживания

SELECT * FROM room_in_booking b1, room_in_booking b2
WHERE
	b1.id_room = b2.id_room and
	b1.id_booking != b2.id_booking and
	b1.checkin_date < b2.checkin_date and 
	b2.checkin_date < b1.checkout_date
ORDER BY b1.id_room_in_booking;

--8. Создать бронирование в транзакции

BEGIN TRANSACTION 

INSERT INTO booking VALUES(1, '2020.05.01')
INSERT INTO room_in_booking VALUES(SCOPE_IDENTITY(), 20, '2020.05.05', '2020.05.10')

ROLLBACK;

--9. Добавить необходимые индексы для всех таблиц

CREATE NONCLUSTERED INDEX [IX_hotel_hotel_name] ON [dbo].[hotel]
(
	[name] ASC
)

CREATE NONCLUSTERED INDEX [IX_hotel_room_id_hotel] ON [dbo].[room]
(
	[id_hotel] ASC
)

CREATE NONCLUSTERED INDEX [IX_hotel_room_id_room_category] ON [dbo].[room]
(
	[id_room_category] ASC
)

CREATE NONCLUSTERED INDEX [IX_hotel_room_category_name] ON [dbo].[room_category]
(
	[name] ASC
)

CREATE NONCLUSTERED INDEX [IX_hotel_room_in_booking_id_room] ON [dbo].[room_in_booking]
(
	[id_room] ASC
)

CREATE NONCLUSTERED INDEX [IX_hotel_room_in_booking_id_booking] ON [dbo].[room_in_booking]
(
	[id_booking] ASC
)

CREATE NONCLUSTERED INDEX [IX_hotel_room_in_booking_checkin_date_checkout_date] ON [dbo].[room_in_booking]
(
	[checkin_date] ASC,
	[checkout_date] ASC
)

CREATE NONCLUSTERED INDEX [IX_hotel_room_in_booking_checkout_date] ON [dbo].[room_in_booking]
(
	[checkout_date] ASC
)

CREATE NONCLUSTERED INDEX [IX_hotel_booking_id_client] ON [dbo].[booking]
(
	[id_client] ASC
)

