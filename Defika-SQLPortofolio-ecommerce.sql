/* 
SQL Portofolio by DEFIKA ALVIANI
Study case in e-commerce platform
*/
--Write an SQL statement to find the first and latest order date of each buyer in each shop
SELECT shopid, buyerid, MIN(order_time) AS first_orderdate, MAX (order_time) AS last_orderdate
FROM SQLTutorial..order_tab
GROUP BY buyerid, shopid
ORDER BY buyerid


--Write an SQL statement to find buyer that make more than 1 order in 1 month
--option 1
SELECT t1.buyerid, ordermonth, COUNT(order_time) number_of_orders
FROM SQLTutorial..order_tab t1
INNER JOIN
	(
	SELECT buyerid, MONTH(order_time) ordermonth
	FROM SQLTutorial..order_tab) t2
	ON t1.buyerid=t2.buyerid
GROUP BY t1.buyerid, ordermonth
ORDER BY buyerid, ordermonth
--option 2
SELECT buyerid, MONTH(order_time) ordermonth, COUNT(order_time) number_of_orders
FROM SQLTutorial..order_tab
GROUP BY buyerid, MONTH(order_time)
ORDER BY buyerid, ordermonth


--Write an SQL statement to find the first buyer of each shop
SELECT t1.shopid, t2.orderid, buyerid, firstorder
FROM SQLTutorial..order_tab t1
INNER JOIN
	(
	SELECT shopid, MIN(orderid) orderid, MIN(order_time) firstorder
	FROM SQLTutorial..order_tab
	GROUP BY shopid) t2
	ON t1.orderid=t2.orderid
ORDER BY shopid


--Write an SQL statement to find the TOP 10 Buyer by GMV in Country ID & SG
SELECT TOP 10 t1.buyerid, country, gmv
FROM SQLTutorial..order_tab t1
INNER JOIN SQLTutorial..user_tab t2
ON t1.buyerid=t2.buyerid
WHERE country IN ('SG')
ORDER BY gmv DESC

SELECT TOP 10 t1.buyerid, country, gmv
FROM SQLTutorial..order_tab t1
INNER JOIN SQLTutorial..user_tab t2
ON t1.buyerid=t2.buyerid
WHERE country IN ('ID')
ORDER BY gmv DESC


--Write an SQL statement to find number of buyer of each country that purchased item with even and odd itemid number
--even itemid
SELECT country, COUNT(DISTINCT buyerid) number_of_buyer_even_itemid
FROM
	(
	SELECT country, buyerid
	FROM	
		(
		SELECT country, t1.buyerid, CAST(itemid AS int) itemid
		FROM SQLTutorial..order_tab t1
		INNER JOIN SQLTutorial..user_tab t2
		ON t1.buyerid=t2.buyerid
		WHERE CAST(itemid AS int)%2 = 0) a1) a2
GROUP BY country
ORDER BY country
--odd itemid
SELECT country, COUNT(DISTINCT buyerid) number_of_buyer_odd_itemid
FROM
	(
	SELECT country, buyerid
	FROM	
		(
		SELECT country, t1.buyerid, CAST(itemid AS int) itemid
		FROM SQLTutorial..order_tab t1
		INNER JOIN SQLTutorial..user_tab t2
		ON t1.buyerid=t2.buyerid
		WHERE CAST(itemid AS int)%2 = 1) a1) a2
GROUP BY country
ORDER BY country


-- Write an SQL statement to find the number of order/views & clicks/impressions of each shop
SELECT shopid, COUNT(orderid)/SUM(Item_views) order_per_views, SUM(total_clicks)/SUM(impressions) click_per_impressions
FROM
	(
	SELECT t1.shopid, orderid, Item_views, total_clicks, impressions
	FROM SQLTutorial..order_tab t1
	FULL JOIN SQLTutorial..performance_tab t2
	ON t1.shopid=t2.shopid
	WHERE impressions IS NOT NULL) a1
GROUP BY shopid
ORDER BY shopid