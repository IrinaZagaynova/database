--1. Добавить внешние ключи.

ALTER TABLE production
ADD FOREIGN KEY (id_medicine) REFERENCES medicine(id_medicine)

ALTER TABLE production
ADD FOREIGN KEY (id_company) REFERENCES company(id_company)

ALTER TABLE dealer
ADD FOREIGN KEY (id_company) REFERENCES company(id_company)

ALTER TABLE [order]
ADD FOREIGN KEY (id_production) REFERENCES production(id_production)

ALTER TABLE [order]
ADD FOREIGN KEY (id_dealer) REFERENCES dealer(id_dealer)

ALTER TABLE [order]
ADD FOREIGN KEY (id_pharmacy) REFERENCES pharmacy(id_pharmacy)

--2. Выдать информацию по всем заказам лекарства "Кордерон" компании "Аргус"
--с указанием названий аптек, дат, объема заказов.

SELECT medicine.name, company.name, pharmacy.name, [order].date, [order].quantity FROM medicine
JOIN production ON medicine.id_medicine = production.id_medicine
JOIN company ON production.id_company = company.id_company
JOIN [order] ON production.[id_production] = [order].id_production
JOIN pharmacy ON [order].id_pharmacy = pharmacy.id_pharmacy
WHERE medicine.name = N'Кордерон' AND
	company.name = N'Аргус';

--3. Дать список лекарств компании "Фарма", на которые не были сделаны заказы до 25 января.

SELECT medicine.id_medicine, medicine.name FROM medicine
JOIN production ON medicine.id_medicine = production.id_medicine
JOIN [order] ON production.[id_production] = [order].id_production
JOIN company ON production.id_company = company.id_company
WHERE company.[name] = N'Фарма' AND production.id_production NOT IN (
	SELECT [order].id_production FROM [order]
	WHERE [order].date <= '25.01.2019')
GROUP BY medicine.id_medicine, medicine.name;

--4. Дать минимальный и максимальный баллы лекарств каждой фирмы, которая
--оформила не менее 120 заказов.

SELECT company.id_company, company.name, MIN(production.rating) AS min, MAX(production.rating) AS max, COUNT([order].id_order) AS count FROM production
JOIN company ON company.id_company = production.id_company
JOIN [order] ON production.id_production = [order].id_production
GROUP BY company.id_company, company.name
HAVING COUNT([order].id_order) >= 120;

--5. Дать списки сделавших заказов аптек по всем дилерам компании "AstraZeneca".
--Если у дилера нет заказов, в названии аптеки проставить NULL.

SELECT dealer.id_dealer, dealer.name, pharmacy.name FROM dealer
LEFT JOIN company ON dealer.id_company = company.id_company
LEFT JOIN [order] ON [order].id_dealer = dealer.id_dealer 
LEFT JOIN pharmacy ON pharmacy.id_pharmacy = [order].id_pharmacy
WHERE company.name = 'AstraZeneca'
ORDER BY dealer.id_dealer;

--6. Уменьшить на 20% стоимость всех лекарств, если она превышает 3000, 
--а длительность лечения не более 7 дней.

UPDATE production 
SET production.price = 0.8 * production.price
WHERE production.id_production IN (
		SELECT production.id_production FROM production
		JOIN medicine ON production.id_medicine = medicine.id_medicine
		WHERE production.price > 3000 AND medicine.cure_duration <= 7 );

--7. Добавить необходимые индексы.

CREATE NONCLUSTERED INDEX [IX_medicine_name] ON [dbo].[medicine]
(
	[name] ASC
)

CREATE NONCLUSTERED INDEX [IX_production_id_company] ON [dbo].[production]
(
	[id_company] ASC
)

CREATE NONCLUSTERED INDEX [IX_production_id_medicine] ON [dbo].[production]
(
	[id_medicine] ASC
)

CREATE NONCLUSTERED INDEX [IX_production_price] ON [dbo].[production]
(
	[price] ASC
)

CREATE NONCLUSTERED INDEX [IX_production_rating] ON [dbo].[production]
(
	[rating] ASC
)

CREATE NONCLUSTERED INDEX [IX_company_name] ON [dbo].[company]
(
	[name] ASC
)

CREATE NONCLUSTERED INDEX [IX_dealer_id_company] ON [dbo].[dealer]
(
	[id_company] ASC
)

CREATE NONCLUSTERED INDEX [IX_order_id_production] ON [dbo].[order]
(
	[id_production] ASC
)

CREATE NONCLUSTERED INDEX [IX_order_id_dealer] ON [dbo].[order]
(
	[id_dealer] ASC
)

CREATE NONCLUSTERED INDEX [IX_order_id_pharmacy] ON [dbo].[order]
(
	[id_pharmacy] ASC
)

CREATE NONCLUSTERED INDEX [IX_order_date] ON [dbo].[order]
(
	[date] ASC
)
