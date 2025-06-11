-- finding the first time /billing-2 was seen SELECT
MIN(created_at) AS first_created_at,
MIN(website_pageview_id) AS first_pv_id
FROM
	website_pageviews wp
WHERE
	pageview_url = '/billing-2';
/*
-- final test analysis output
-- 筛出有billing或billing-2 page的session
CREATE TEMPORARY TABLE session_flags SELECT
website_session_id,
SUM(billing_page) AS to_billing,
SUM(billing2_page) AS to_billing2
FROM
(
-- 为每个session是否有billing或billing-2 page加flag
SELECT
*,
CASE
WHEN pageview_url = '/billing' THEN
1
ELSE
0
END AS billing_page,
CASE
WHEN pageview_url = '/billing-2' THEN
1
ELSE
0
END AS billing2_page
FROM
website_pageviews
WHERE
created_at BETWEEN '2012-09-10'
AND '2012-11-10' -- 指定的时间要求
) t
GROUP BY
website_session_id
HAVING
SUM(billing_page) = 1
OR SUM(billing2_page) = 1; -- 筛选出必须到达billing页或billing2页的session
-- 为每个session添加order信息以及增加分组字段billing_version_seen
CREATE TEMPORARY TABLE session_level_orders SELECT
sf.*,
CASE
WHEN to_billing = 1 THEN
'/billing'
ELSE
'/billing-2'
END AS billing_version_seen,
o.order_id
FROM
session_flags sf
LEFT JOIN orders o ON sf.website_session_id = o.website_session_id;
SELECT
billing_version_seen,
COUNT(DISTINCT website_session_id) AS sessions,
COUNT(DISTINCT order_id) AS orders,
COUNT(DISTINCT order_id) / COUNT(DISTINCT website_session_id) AS billing_to_order_rt
FROM
session_level_orders
GROUP BY
billing_version_seen;
*/
-- 另外一种简化的方法
SELECT
	wp.website_session_id,
	wp.pageview_url,
	o.order_id
FROM
	website_pageviews wp
	LEFT JOIN orders o ON wp.website_session_id = o.website_session_id
WHERE
	website_pageview_id >= 53550 -- 测试开始时间
	AND wp.created_at < '2012-11-10' -- 在邮件收件时间前
	AND pageview_url IN ('/billing', '/billing-2'); -- 指定需要带'/billing', '/billing-2'两个page的session