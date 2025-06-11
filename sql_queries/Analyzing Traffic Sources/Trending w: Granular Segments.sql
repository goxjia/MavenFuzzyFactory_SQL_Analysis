WITH basic_query AS (
SELECT
	min(date(ws.created_at)) AS week_start_date,
	count(DISTINCT CASE
		WHEN device_type = 'desktop' THEN ws.website_session_id
	END) AS dtop_sessions,
	count(DISTINCT CASE
		WHEN device_type = 'desktop' THEN order_id
	END) AS dtop_orders,
	count(DISTINCT CASE
			WHEN device_type = 'mobile' THEN ws.website_session_id
		END) AS mob_sessions,
	count(DISTINCT CASE
			WHEN device_type = 'mobile' THEN order_id
		END) AS mob_orders,
	count(DISTINCT order_id) AS total_orders
FROM
		website_sessions ws
LEFT JOIN orders o ON
	ws.website_session_id = o.website_session_id
WHERE
		ws.created_at >= '2012-4-15'
	AND ws.created_at<'2012-6-9'
	AND utm_source = 'gsearch'
	AND utm_campaign = 'nonbrand'
GROUP BY
	week(ws.created_at))
SELECT
	week_start_date,
	dtop_sessions,
	dtop_orders,
	concat(round(dtop_orders / dtop_sessions, 2), '%') AS dtop_cvr,
	mob_sessions,
	mob_orders,
	concat(round(mob_orders / mob_sessions, 2), '%') AS mob_cvr
FROM
	basic_query;