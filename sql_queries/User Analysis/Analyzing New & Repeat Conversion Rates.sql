SELECT
	is_repeat_session,
	COUNT(DISTINCT website_session_id) AS sessions,
	COUNT(DISTINCT order_id) / COUNT(DISTINCT website_session_id) AS conv_rate,
	SUM(price_usd) / COUNT(DISTINCT website_session_id) AS rev_per_session
FROM
	(
		SELECT
			ws.website_session_id,
			ws.is_repeat_session,
			o.order_id,
			o.price_usd
		FROM
			website_sessions ws
			LEFT JOIN orders o ON ws.website_session_id = o.website_session_id
		WHERE
			ws.created_at BETWEEN '2014-1-1'
			AND '2014-11-8'
	) t
GROUP BY
	1;