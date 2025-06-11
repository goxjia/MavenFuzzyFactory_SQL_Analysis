-- Step 0: 找出符合限制的所有url，以供参考
-- Step 1: 找出所有到达/cart页的session_id（使用where筛选url），注意添加时间限制，以及打上time_period标签
-- Step 2: 使用上述session_id左联结匹配出url，利用url打标签，标注是否到达/shipping页，即漏斗中cart的下一页，注意此时是pageview_level的flag
-- Step 3: 使用MAX聚合出session_level_flag
-- Step 4: 左联结orders提取order_id和items_purchased, price_usd，以计算products_per_order, aov, rev_per_cart_session
-- Step 5: 聚合计算，以time_period分组
-- Step 0
SELECT DISTINCT
	pageview_url
FROM
	website_pageviews
WHERE
	created_at BETWEEN '2013-8-25'
	AND '2013-10-25';
	
-- Step 1
CREATE TEMPORARY TABLE arrived_cart SELECT
	website_session_id,
	created_at,
	CASE
		WHEN created_at >= '2013-9-25' THEN
			'B. Post_Cross_Sell'
		ELSE
			'A. Pre_Cross_Sell'
	END AS time_period,
	website_pageview_id
FROM
	website_pageviews
WHERE
	pageview_url IN ('/cart')
	AND created_at BETWEEN '2013-8-25'
	AND '2013-10-25';
-- Step 2
CREATE TEMPORARY TABLE pageview_level_flag SELECT
	ac.website_session_id,
	time_period,
	pageview_url, -- pageview_url为空说明该session到达cart后随即bounce跳出
	CASE
		WHEN pageview_url = '/shipping' THEN
			1
		ELSE
			0
	END AS ship_page
FROM
	arrived_cart ac
	LEFT JOIN website_pageviews wp ON ac.website_session_id = wp.website_session_id
	AND wp.website_pageview_id > ac.website_pageview_id; -- 筛选出/cart往后的pageview
-- Step 3
CREATE TEMPORARY TABLE session_level_flag SELECT
	website_session_id,
	time_period,
	MAX(ship_page) AS to_ship
FROM
	pageview_level_flag
GROUP BY
	1,
	2;
-- Step 4
CREATE TEMPORARY TABLE session_w_order_column SELECT
	slf.website_session_id,
	time_period,
	to_ship,
	order_id,
	items_purchased,
	price_usd
FROM
	session_level_flag slf
	LEFT JOIN orders o ON slf.website_session_id = o.website_session_id;
-- Step 5
SELECT
	time_period,
	COUNT(DISTINCT website_session_id) AS cart_sessions,
	SUM(to_ship) AS click_throughs,
	SUM(to_ship) / COUNT(DISTINCT website_session_id) AS cart_ctr,
	SUM(items_purchased) / COUNT(DISTINCT order_id) AS products_per_order,
	SUM(price_usd) / COUNT(DISTINCT order_id) AS aov,
	SUM(price_usd) / COUNT(DISTINCT website_session_id) AS revenue_per_cart_session
FROM
	session_w_order_column
GROUP BY
	time_period;