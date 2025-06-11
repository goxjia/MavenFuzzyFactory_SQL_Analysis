SELECT
	device_type,
	count(ws.website_session_id) AS sessions,
	count(o.order_id) AS orders,
	concat(round(count(o.order_id) / count(ws.website_session_id)* 100, 2), '%') AS session_to_order_conv_rate
FROM
	website_sessions ws
LEFT JOIN orders o ON
	ws.website_session_id = o.website_session_id
WHERE
	ws.created_at<'2012-5-11'
	AND utm_source = 'gsearch'
	AND utm_campaign = 'nonbrand'
GROUP BY
	1
ORDER BY
	4 DESC;
