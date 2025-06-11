SELECT
	YEAR(ws.created_at) AS yr,
	MONTH(ws.created_at) AS mo,
	-- 	11月订单量高是由于21和26这两天的当天销量高，对应为black Friday 和cyber Monday，12月的还不清楚。所以1月的订单量比11月低是周期性影响，并不是推出product2的锅
	-- 	DATE(ws.created_at) as dt,
	COUNT(DISTINCT o.order_id) AS orders,
	COUNT(DISTINCT o.order_id) / COUNT(DISTINCT ws.website_session_id) AS conv_rate,
	SUM(price_usd) / COUNT(DISTINCT ws.website_session_id) AS revenue_per_session,
	COUNT(DISTINCT CASE WHEN primary_product_id = 1 THEN o.order_id ELSE NULL END) AS product_one_orders,
	COUNT(DISTINCT CASE WHEN primary_product_id = 2 THEN o.order_id ELSE NULL END) AS product_two_orders
FROM
	website_sessions ws
	LEFT JOIN orders o ON ws.website_session_id = o.website_session_id
WHERE
	ws.created_at BETWEEN '2012-4-1'
	AND '2013-4-5'
GROUP BY
	1,
	2
	-- 	3;