/* -- 找出到达过/products页的session_id CREATE TEMPORARY TABLE session_arrived_products SELECT website_session_id FROM website_pageviews WHERE created_at BETWEEN '2012-10-6' AND '2013-4-6' AND pageview_url = '/products'; -- 找出以上session的最后一次pageview CREATE TEMPORARY TABLE session_last_pv SELECT
sap.website_session_id,
MAX(wp.website_pageview_id) AS last_pv_id
FROM
session_arrived_products sap
LEFT JOIN website_pageviews wp ON sap.website_session_id = wp.website_session_id
GROUP BY
1;
-- 	判断products后是否还有下一次pageview,并做出标记
CREATE TEMPORARY TABLE session_w_next_pg_flag SELECT
slp.website_session_id,
slp.last_pv_id,
wp.pageview_url AS last_pageview,
CASE
WHEN wp.pageview_url <> '/products' THEN
slp.website_session_id
ELSE
NULL
END AS w_next_pg_session
FROM
session_last_pv slp
LEFT JOIN website_pageviews wp ON slp.last_pv_id = wp.website_pageview_id;
-- 找出session是否到过fuzzy或bear页面，并做出标记
CREATE TEMPORARY TABLE session_product_flag SELECT
sap.website_session_id,
wp.created_at,
CASE
WHEN wp.created_at >= '2013-1-6' THEN
'B. Post_Product_2'
ELSE
'A. Pre_Product_2'
END AS time_period,
wp.pageview_url,
CASE
WHEN wp.pageview_url = '/the-original-mr-fuzzy' THEN
1
ELSE
0
END AS fuzzy_page,
CASE
WHEN wp.pageview_url = '/the-forever-love-bear' THEN
1
ELSE
0
END AS bear_page
FROM
session_arrived_products sap
LEFT JOIN website_pageviews wp ON sap.website_session_id = wp.website_session_id;
-- session级别的信息整合
CREATE TEMPORARY TABLE session_level_integration SELECT
spf.website_session_id,
time_period,
COUNT(DISTINCT w_next_pg_session) AS next, -- 结果为0的就是没有products下一个page的
SUM(fuzzy_page) AS fuzzy,
SUM(bear_page) AS bear
FROM
session_product_flag spf
INNER JOIN session_w_next_pg_flag snf USING (website_session_id)
GROUP BY
1,
2;
SELECT
time_period,
COUNT(DISTINCT website_session_id) AS sessions,
SUM(next) AS w_next_pg,
SUM(next) / COUNT(DISTINCT website_session_id) AS pct_w_next_pg,
SUM(fuzzy) AS to_fuzzy,
SUM(fuzzy) / COUNT(DISTINCT website_session_id) AS pct_to_fuzzy,
SUM(bear) AS to_lovebear,
SUM(bear) / COUNT(DISTINCT website_session_id) AS pct_to_lovebear
FROM
session_level_integration
GROUP BY
1;
*/
-- 老师的方法
-- 找出每个到达products的session及其信息
CREATE TEMPORARY TABLE session_reached_products SELECT
	website_session_id,
	created_at,
	CASE
		WHEN created_at >= '2013-1-6' THEN
			'B. Post_Product_2'
		ELSE
			'A. Pre_Product_2'
	END AS time_period,
	website_pageview_id
FROM
	website_pageviews
WHERE
	created_at BETWEEN '2012-10-6'
	AND '2013-4-6'
	AND pageview_url = '/products';
-- 	找出每个session下一页的id
CREATE TEMPORARY TABLE session_w_next_pageview_id SELECT
	srp.website_session_id,
	time_period,
	MIN(wp.website_pageview_id) AS next_pageview_id
FROM
	session_reached_products srp
	LEFT JOIN website_pageviews wp ON srp.website_session_id = wp.website_session_id
	AND srp.website_pageview_id < wp.website_pageview_id -- 找出同一个session的后续的pageview id
GROUP BY
	1,
	2;
-- 	找出每个session下一页的url，并加上flag
CREATE TEMPORARY TABLE session_w_next_pageview_flag SELECT
	swnpi.website_session_id,
	time_period,
	pageview_url AS next_pageview_url,
	CASE
		WHEN wp.pageview_url = '/the-original-mr-fuzzy' THEN
			1
		ELSE
			0
	END AS fuzzy_page,
	CASE
		WHEN wp.pageview_url = '/the-forever-love-bear' THEN
			1
		ELSE
			0
	END AS bear_page
FROM
	session_w_next_pageview_id swnpi
	LEFT JOIN website_pageviews wp ON swnpi.next_pageview_id = wp.website_pageview_id;
SELECT
	time_period,
	COUNT(DISTINCT website_session_id) AS sessions,
	COUNT(next_pageview_url) AS w_next_pg,
	COUNT(next_pageview_url) / COUNT(DISTINCT website_session_id) AS pct_w_next_pg,
	SUM(fuzzy_page) AS to_fuzzy,
	SUM(fuzzy_page) / COUNT(DISTINCT website_session_id) AS pct_to_fuzzy,
	SUM(bear_page) AS to_lovebear,
	SUM(bear_page) / COUNT(DISTINCT website_session_id) AS pct_to_lovebear
FROM
	session_w_next_pageview_flag
GROUP BY
	1;