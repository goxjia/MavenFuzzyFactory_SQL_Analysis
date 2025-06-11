-- 找出所有到达fuzzy和bear两个网页的session，并打上product_seen的标签
CREATE TEMPORARY TABLE limited_sessions SELECT
	website_session_id,
	-- 	pageview_url,
	CASE
		WHEN pageview_url = '/the-original-mr-fuzzy' THEN
			'mrfuzzy'
		ELSE
			'lovebear'
	END AS product_seen
FROM
	website_pageviews
WHERE
	created_at BETWEEN '2013-1-6'
	AND '2013-4-10'
	AND pageview_url IN ('/the-original-mr-fuzzy', '/the-forever-love-bear');
-- 为session每个环节设置一个flag
CREATE TEMPORARY TABLE sessions_with_flags SELECT
	ls.website_session_id,
	product_seen,
	pageview_url,
	CASE
		WHEN pageview_url = '/cart' THEN
			1
		ELSE
			0
	END AS cart_page,
	CASE
		WHEN pageview_url = '/shipping' THEN
			1
		ELSE
			0
	END AS shipping_page,
	CASE
		WHEN pageview_url = '/billing-2' THEN
			1
		ELSE
			0
	END AS billing_page,
	CASE
		WHEN pageview_url = '/thank-you-for-your-order' THEN
			1
		ELSE
			0
	END AS thank_you_page
FROM
	limited_sessions ls
	LEFT JOIN website_pageviews wp ON ls.website_session_id = wp.website_session_id;
-- 计算到达特定层级的session数量，以product_seen分组
SELECT
	product_seen,
	COUNT(DISTINCT website_session_id) AS sessions,
	SUM(cart_page) AS to_cart,
	SUM(shipping_page) AS to_shipping,
	SUM(billing_page) AS to_billing,
	SUM(thank_you_page) AS to_thank_you
FROM
	sessions_with_flags
GROUP BY
	1;
	
-- 计算漏斗每个环节转化率
SELECT
	product_seen,
	SUM(cart_page) / COUNT(DISTINCT website_session_id) AS product_page_click_rt,
	SUM(shipping_page) / SUM(cart_page) AS cart_click_rt,
	SUM(billing_page) / SUM(shipping_page) AS shipping_click_rt,
	SUM(thank_you_page) / SUM(billing_page) AS billing_click_rt
FROM
	sessions_with_flags
GROUP BY
	1;