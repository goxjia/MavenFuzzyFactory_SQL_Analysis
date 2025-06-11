SELECT
	device_type,
	utm_source,
	COUNT(DISTINCT ws.website_session_id) AS sessions,
	COUNT(DISTINCT o.order_id) AS orders,
	COUNT(DISTINCT o.order_id) / COUNT(DISTINCT ws.website_session_id) AS conv_rate
FROM
	website_sessions ws
	LEFT JOIN orders o ON ws.website_session_id = o.website_session_id
WHERE
	ws.created_at BETWEEN '2012-8-22'
	AND '2012-9-19'
	AND ws.utm_campaign = 'nonbrand'
GROUP BY
	1,
	2;