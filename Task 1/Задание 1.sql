/* История про заказчика Джека
 
	Пришел как-то ко мне Джек, сказал что он тут строит дома и продает их своему 
другу-олигарху Роману. Попросил меня Джек составить список всех его домов, но
когда футбольная команда Романа проигрывает, он не покупает дома, поэтому Джеку 
приходится продавать дома разным людям. Поразмыслив, Джек сказал, что сдавать 
дома выгодно... 
И я ему сделал базу */

drop database IF EXISTS jack;
 
create database jack;
 
create table jack.houses
(
id INT NOT NULL AUTO_INCREMENT,
house_number VARCHAR(255) NULL,
street VARCHAR(255) NULL,
build_date DATE NULL,
 
current_sale_amount Decimal(19,2) NULL,
current_rent_month_amount Decimal(10,2) NULL,
current_rent_day_amount Decimal(10,2) NULL,
 
status VARCHAR(30) NOT NULL,
 
PRIMARY KEY (id)
);
 
create table jack.construction_payments
(
id INT NOT NULL AUTO_INCREMENT,
house_id INT NOT NULL,
amount Decimal(19,2) NOT NULL,
payment_comment VARCHAR(255) NULL,
 
PRIMARY KEY (id),
FOREIGN KEY (house_id) references jack.houses (id)
);
 
create table jack.renters
(
id INT NOT NULL AUTO_INCREMENT,
name VARCHAR(255),
 
PRIMARY KEY (id)
);
 
create table jack.rents
(
id INT NOT NULL AUTO_INCREMENT,
house_id INT NOT NULL,
renter_id INT NOT NULL,
amount Decimal(19,2) NOT NULL,
payment_date DATE NOT NULL,
rent_from DATE NOT NULL,
rent_to DATE NOT NULL,
is_payed BIT default 0,
 
PRIMARY KEY (id),
FOREIGN KEY (house_id) references jack.houses (id),
FOREIGN KEY (renter_id) references jack.renters (id)
);
 
/*data*/
INSERT INTO jack.houses (house_number, street, status, build_date, current_sale_amount)
VALUES
(1, "Бейкер стрит", "for sale", "1999/01/01", 10000000),
(2, "Бейкер стрит", "for rent day", "2001/03/06", null),
("221B", "Бейкер стрит", "for rent month", "2004/07/14", null),
("L1№4", "Малхолланд Драйв", "for rent month", "1993/02/15", null),
(2, "Малхолланд Драйв", "for rent month", "1999/01/01", null),
(4, "Тисовая улица", "sold", "1980/07/31", 50000000),
(5, "Косой переулок", "for rent month", "2000/03/20", null),
(1, "Улица Вязов", "for rent day", "1984/01/01", null),
(2, "Улица Вязов", "for rent day", "1985/01/01", null),
(3, "Улица Вязов", "for rent day", "1987/01/01", null),
(10, "Улица Вязов", "under construction", null, null);
 
INSERT INTO jack.construction_payments (house_id, amount, payment_comment)
VALUES
(1, 1000000, "покупка земли"),
(2, 2000000, "покупка земли"),
(3, 1000000, "покупка земли"),
(4, 1000000, "покупка земли"),
(5, 1000000, "покупка земли"),
(6, 1000000, "покупка земли"),
(7, 1000000, "покупка земли"),
(1, 5000000, "материалы"),
(2, 4000000, "материалы"),
(3, 5000000, "материалы"),
(4, 4000000, "материалы"),
(5, 4000000, "материалы"),
(6, 3000000, "материалы"),
(7, 3000000, "материалы"),
(1, 5000, "зп строителей"),
(2, 4000, "зп строителей"),
(3, 5000, "зп строителей"),
(4, 4000, "зп строителей"),
(5, 4000, "зп строителей"),
(6, 3000, "зп строителей"),
(7, 3000, "зп строителей"),
(1, 50000, "евроремонт"),
(2, 1000000, "взятки"),
(3, 50000, "евроремонт"),
(4, 1000000, "взятки"),
(5, 40000, "евроремонт"),
(6, 30000, "евроремонт"),
(7, 1000000, "взятки");
 
INSERT INTO jack.renters (name)
VALUES
("Шерлок Х."),
("Доктор В."),
("Девид Л."),
("Гарри П."),
("Фредди К.");
 
INSERT INTO jack.rents (house_id, renter_id, amount, payment_date, is_payed, rent_from, rent_to)
VALUES
(2, 2, 800, "2017/02/20", 1, "2017/02/20", "2017/02/20"),
(2, 2, 800, "2017/02/21", 1, "2017/02/21", "2017/02/21"),
(2, 2, 800, "2017/02/22", 1, "2017/02/22", "2017/02/22"),
(2, 2, 900, "2017/02/23", 1, "2017/02/23", "2017/02/23"),
(2, 2, 900, "2017/02/24", 1, "2017/02/24", "2017/02/24"),
(2, 2, 1000, "2017/02/25", 0, "2017/02/25", "2017/02/25"),
(2, 2, 1000, "2017/02/26", 0, "2017/02/26", "2017/02/26"),
(2, 2, 1000,  "2017/02/27", 0, "2017/02/27", "2017/02/27"),
(2, 2, 1000,  "2017/02/28", 0, "2017/02/28", "2017/02/28"),
(3, 1, 5000,  "2016/10/01", 1, "2016/10/01", "2016/10/31"),
(3, 1, 5000,  "2016/11/01", 1, "2016/11/01", "2016/11/30"),
(3, 1, 5000,  "2016/12/01", 0, "2016/12/01", "2016/12/31"),
(3, 1, 5000,  "2017/01/01", 0, "2017/01/01", "2017/01/31"),
(3, 1, 5000,  "2017/02/01", 0, "2017/02/01", "2017/02/28"),
(3, 1, 5000,  "2017/03/01", 0, "2017/03/01", "2017/03/31"),
(4, 3, 3000,  "2016/12/01", 1, "2016/12/01", "2016/12/31"),
(4, 3, 3000,  "2017/01/01", 1, "2017/01/01", "2017/01/31"),
(4, 3, 3000,  "2017/02/01", 1, "2017/02/01", "2017/02/28"),
(4, 3, 3000,  "2017/03/01", 1, "2017/03/01", "2017/03/31"),
(8, 5, 500,  "1984/01/02", 0, "1984/01/02",  "1984/01/02"),
(9, 5, 500,  "1984/01/02", 0, "1984/01/02",  "1984/01/02"),
(10, 5, 500,  "1984/01/02", 0, "1984/01/02",  "1984/01/02"),
(8, 5, 500,  "1984/01/03", 0, "1984/01/03",  "1984/01/03"),
(9, 5, 500,  "1984/01/03", 0, "1984/01/03",  "1984/01/03"),
(10, 5, 500,  "1984/01/03", 0, "1984/01/03",  "1984/01/03"),
(8, 5, 500,  "1984/01/04", 0, "1984/01/04",  "1984/01/04"),
(9, 5, 500,  "1984/01/04", 0, "1984/01/04",  "1984/01/04"),
(10, 5, 500,  "1984/01/04", 0, "1984/01/04",  "1984/01/04"),
(7, 4, 7000,  "2017/01/01", 1, "2017/01/01", "2017/01/31"),
(7, 4, 7000,  "2017/02/01", 1, "2017/02/01", "2017/02/28"),
(7, 4, 7000,  "2017/03/01", 1, "2017/03/01", "2017/03/31"),
(7, 4, 7000,  "2017/04/01", 1, "2017/04/01", "2017/04/30"),
(7, 4, 7000,  "2017/05/01", 1, "2017/05/01", "2017/05/31"),
(7, 4, 7000,  "2017/06/01", 1, "2017/06/01", "2017/06/30");
 
/*queries*/
/* И жил так Джек не ведая печали, но захотел он узнать: */

/*1. Сколько у меня домов в аренде, а сколько на продажу и сколько я уже продал?*/
SELECT status, count(*) as 'count'
from jack.houses GROUP BY status;
 
SELECT 'rent' as 'status', count(*) as 'count'
FROM jack.houses WHERE status like "%rent%";
 
SELECT 'sold' as 'status', count(*) as 'count'
FROM jack.houses WHERE status = "sold";
 
SELECT 'for sale' as 'status', count(*) as 'count'
FROM jack.houses WHERE status = "for sale";
 
/*
2. Сколько у меня арендаторов и кто, когда и сколько платит?
*/
select count(*) as 'Renters count' from jack.renters;
 
select count(distinct(renter_id)) as 'Renters active in 2017'
from jack.rents
where payment_date > '2016/12/31';
 
select name, payment_date, amount, is_payed
from jack.rents, jack.renters
WHERE jack.rents.renter_id = jack.renters.id
order by renter_id, payment_date;
 
/*
3. Сколько стоит всё моё недвижимое имущество?
*/
SELECT sum(amount) as 'Total amount'
FROM jack.construction_payments
WHERE house_id in (select id from jack.houses where status = "sold" );
 
/*
4. Когда были построены мои дома на Бейкер стрит и Малхолланд Драйв?
*/
 
SELECT street, house_number, build_date
FROM jack.houses
WHERE street in ('Бейкер стрит', 'Малхолланд Драйв')
Order by street;
 
/*
5. Сколько арендаторов не заплатили за последние 3 месяца?
*/
 
select distinct(name) as 'Renters who not payed in last 3 months'
from jack.rents, jack.renters
WHERE jack.rents.renter_id = jack.renters.id
and is_payed = 0 and payment_date > DATE_SUB(CURRENT_TIMESTAMP,Interval 3 MONTH);
 
/*
За сколько был построен дом, за сколько продан.
*/
 
select street, house_number,
(SELECT sum(amount) FROM jack.construction_payments
WHERE jack.houses.id = house_id) as "build amount",
(IF (status = "sold", current_sale_amount, "not sold")) as "sold amount"
from jack.houses;
 
/*
Кто сейчас живет в арендуемом доме и когда надо взымать арендную плату.
*/
 
select house_number, /*street,*/ name,
(select payment_date from jack.rents
where jack.houses.id = jack.rents.house_id
and jack.rents.renter_id = jack.renters.id
and is_payed = 0 order by payment_date limit 1
) as 'first not payed payment'
from jack.houses, jack.rents, jack.renters
where jack.houses.id = jack.rents.house_id
and jack.rents.renter_id = jack.renters.id
and rent_from <= CURRENT_DATE
and rent_to >= CURRENT_DATE
;
 
/*
служебные поля:
 
is_deleted BIT default 0,
creation_time DATETIME DEFAULT CURRENT_TIMESTAMP,
modification_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
*/
 
/*=================RESULT===============*/
 
mysql> source D:\jack.sql
Query OK, 4 rows affected (0.58 sec)
 
Query OK, 1 row affected (0.00 sec)
 
Query OK, 0 rows affected (0.16 sec)
 
Query OK, 0 rows affected (0.21 sec)
 
Query OK, 0 rows affected (0.17 sec)
 
Query OK, 0 rows affected (0.26 sec)
 
Query OK, 11 rows affected (0.03 sec)
Records: 11  Duplicates: 0  Warnings: 0
 
Query OK, 28 rows affected (0.09 sec)
Records: 28  Duplicates: 0  Warnings: 0
 
Query OK, 5 rows affected (0.03 sec)
Records: 5  Duplicates: 0  Warnings: 0
 
Query OK, 34 rows affected (0.09 sec)
Records: 34  Duplicates: 0  Warnings: 0
 
+--------------------+-------+
| status             | count |
+--------------------+-------+
| for rent day       |     4 |
| for rent month     |     4 |
| for sale           |     1 |
| sold               |     1 |
| under construction |     1 |
+--------------------+-------+
5 rows in set (0.00 sec)
 
+--------+-------+
| status | count |
+--------+-------+
| rent   |     8 |
+--------+-------+
1 row in set (0.00 sec)
 
+--------+-------+
| status | count |
+--------+-------+
| sold   |     1 |
+--------+-------+
1 row in set (0.00 sec)
 
+----------+-------+
| status   | count |
+----------+-------+
| for sale |     1 |
+----------+-------+
1 row in set (0.00 sec)
 
+---------------+
| Renters count |
+---------------+
|             5 |
+---------------+
1 row in set (0.00 sec)
 
+------------------------+
| Renters active in 2017 |
+------------------------+
|                      4 |
+------------------------+
1 row in set (0.00 sec)
 
+------------------+--------------+---------+----------+
| name             | payment_date | amount  | is_payed |
+------------------+--------------+---------+----------+
| Шерлок Х.        | 2016-10-01   | 5000.00 | O        |
| Шерлок Х.        | 2016-11-01   | 5000.00 | O        |
| Шерлок Х.        | 2016-12-01   | 5000.00 |          |
| Шерлок Х.        | 2017-01-01   | 5000.00 |          |
| Шерлок Х.        | 2017-02-01   | 5000.00 |          |
| Шерлок Х.        | 2017-03-01   | 5000.00 |          |
| Доктор В.        | 2017-02-20   |  800.00 | O        |
| Доктор В.        | 2017-02-21   |  800.00 | O        |
| Доктор В.        | 2017-02-22   |  800.00 | O        |
| Доктор В.        | 2017-02-23   |  900.00 | O        |
| Доктор В.        | 2017-02-24   |  900.00 | O        |
| Доктор В.        | 2017-02-25   | 1000.00 |          |
| Доктор В.        | 2017-02-26   | 1000.00 |          |
| Доктор В.        | 2017-02-27   | 1000.00 |          |
| Доктор В.        | 2017-02-28   | 1000.00 |          |
| Девид Л.         | 2016-12-01   | 3000.00 | O        |
| Девид Л.         | 2017-01-01   | 3000.00 | O        |
| Девид Л.         | 2017-02-01   | 3000.00 | O        |
| Девид Л.         | 2017-03-01   | 3000.00 | O        |
| Гарри П.         | 2017-01-01   | 7000.00 | O        |
| Гарри П.         | 2017-02-01   | 7000.00 | O        |
| Гарри П.         | 2017-03-01   | 7000.00 | O        |
| Гарри П.         | 2017-04-01   | 7000.00 | O        |
| Гарри П.         | 2017-05-01   | 7000.00 | O        |
| Гарри П.         | 2017-06-01   | 7000.00 | O        |
| Фредди К.        | 1984-01-02   |  500.00 |          |
| Фредди К.        | 1984-01-02   |  500.00 |          |
| Фредди К.        | 1984-01-02   |  500.00 |          |
| Фредди К.        | 1984-01-03   |  500.00 |          |
| Фредди К.        | 1984-01-03   |  500.00 |          |
| Фредди К.        | 1984-01-03   |  500.00 |          |
| Фредди К.        | 1984-01-04   |  500.00 |          |
| Фредди К.        | 1984-01-04   |  500.00 |          |
| Фредди К.        | 1984-01-04   |  500.00 |          |
+------------------+--------------+---------+----------+
34 rows in set (0.00 sec)
 
+--------------+
| Total amount |
+--------------+
|   4033000.00 |
+--------------+
1 row in set (0.00 sec)
 
+---------------------------------+--------------+------------+
| street                          | house_number | build_date |
+---------------------------------+--------------+------------+
| Бейкер стрит                    | 1            | 1999-01-01 |
| Бейкер стрит                    | 2            | 2001-03-06 |
| Бейкер стрит                    | 221B         | 2004-07-14 |
| Малхолланд Драйв                | L1№4         | 1993-02-15 |
| Малхолланд Драйв                | 2            | 1999-01-01 |
+---------------------------------+--------------+------------+
5 rows in set (0.00 sec)
 
+----------------------------------------+
| Renters who not payed in last 3 months |
+----------------------------------------+
| Шерлок Х.                              |
| Доктор В.                              |
+----------------------------------------+
2 rows in set (0.00 sec)
 
+---------------------------------+--------------+--------------+-------------+
| street                          | house_number | build amount | sold amount |
+---------------------------------+--------------+--------------+-------------+
| Бейкер стрит                    | 1            |   6055000.00 | not sold    |
| Бейкер стрит                    | 2            |   7004000.00 | not sold    |
| Бейкер стрит                    | 221B         |   6055000.00 | not sold    |
| Малхолланд Драйв                | L1№4         |   6004000.00 | not sold    |
| Малхолланд Драйв                | 2            |   5044000.00 | not sold    |
| Тисовая улица                   | 4            |   4033000.00 | 50000000.00 |
| Косой переулок                  | 5            |   5003000.00 | not sold    |
| Улица Вязов                     | 1            |         NULL | not sold    |
| Улица Вязов                     | 2            |         NULL | not sold    |
| Улица Вязов                     | 3            |         NULL | not sold    |
| Улица Вязов                     | 10           |         NULL | not sold    |
+---------------------------------+--------------+--------------+-------------+
11 rows in set (0.00 sec)
 
+--------------+------------------+-------------------------+
| house_number | name             | first not payed payment |
+--------------+------------------+-------------------------+
| 2            | Доктор В.        | 2017-02-25              |
| 221B         | Шерлок Х.        | 2016-12-01              |
| L1№4         | Девид Л.         | NULL                    |
| 5            | Гарри П.         | NULL                    |
+--------------+------------------+-------------------------+
4 rows in set (0.00 sec)