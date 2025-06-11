USE mavenfuzzyfactory;

SELECT
	count(DISTINCT ws.website_session_id) AS sessions,
	count(DISTINCT order_id) AS orders,
	concat(round(count(DISTINCT order_id) / count(DISTINCT ws.website_session_id)* 100, 2) , '%') AS CVR
FROM
	website_sessions ws
LEFT JOIN orders o
		USING(website_session_id)
WHERE
	ws.created_at<'2012-4-14'
	AND utm_source = 'gsearch'
	AND utm_campaign = 'nonbrand';