-- Step 1: 找出所有符合时间限制的session_id，以及打上time_period标签，并左联结orders提取order_id和items_purchased, price_usd，以计算conv_rate, products_per_order, aov, rev_per_cart_session
-- Step 2: 聚合计算，以time_period分组
-- Step 1
CREATE TEMPORARY TABLE session_w_order_column SELECT
	ws.website_session_id,
	ws.created_at,
	CASE
		WHEN ws.created_at >= '2013-12-12' THEN
			'B. Post_Cross_Sell'
		ELSE
			'A. Pre_Cross_Sell'
	END AS time_period,
	order_id,
	items_purchased,
	price_usd
FROM
	website_sessions ws
	LEFT JOIN orders o ON ws.website_session_id = o.website_session_id
WHERE
	ws.created_at BETWEEN '2013-11-12'
	AND '2014-1-12';
	
-- Step 2
SELECT
	time_period,
	COUNT(DISTINCT website_session_id) AS sessions,
	COUNT(DISTINCT order_id) AS orders,
	COUNT(DISTINCT order_id) / COUNT(DISTINCT website_session_id) AS conv_rate,
	SUM(price_usd) / COUNT(DISTINCT order_id) AS aov,
	SUM(items_purchased) / COUNT(DISTINCT order_id) AS products_per_order,
	SUM(price_usd) / COUNT(DISTINCT website_session_id) AS revenue_per_cart_session
FROM
	session_w_order_column
GROUP BY
	time_period;