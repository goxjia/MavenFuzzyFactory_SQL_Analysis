SELECT
	-- 	YEARWEEK(created_at),
	MIN(DATE(created_at)) AS week_start_date,
	SUM(CASE WHEN utm_source = 'gsearch' AND device_type = 'desktop' THEN 1 ELSE 0 END) AS g_dtop_sessions,
	SUM(CASE WHEN utm_source = 'bsearch' AND device_type = 'desktop' THEN 1 ELSE 0 END) AS b_dtop_sessions,
	CONCAT(
		ROUND(
			SUM(CASE WHEN utm_source = 'bsearch' AND device_type = 'desktop' THEN 1 ELSE 0 END) / SUM(CASE WHEN utm_source = 'gsearch' AND device_type = 'desktop' THEN 1 ELSE 0 END) * 100,
			2
		),
		'%'
	) AS b_pct_of_g_dtop,
	SUM(CASE WHEN utm_source = 'gsearch' AND device_type = 'mobile' THEN 1 ELSE 0 END) AS g_mob_sessions,
	SUM(CASE WHEN utm_source = 'bsearch' AND device_type = 'desktop' THEN 1 ELSE 0 END) AS b_mob_sessions,
	CONCAT(
		ROUND(
			SUM(CASE WHEN utm_source = 'bsearch' AND device_type = 'mobile' THEN 1 ELSE 0 END) / SUM(CASE WHEN utm_source = 'gsearch' AND device_type = 'mobile' THEN 1 ELSE 0 END) * 100,
			2
		),
		'%'
	) AS b_pct_of_g_mob
FROM
	website_sessions
WHERE
	utm_campaign = 'nonbrand'
	AND created_at BETWEEN '2012-11-4'
	AND '2012-12-22'
GROUP BY
	YEARWEEK(created_at);