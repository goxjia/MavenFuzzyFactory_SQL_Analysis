SELECT
	hr,
	ROUND(AVG(CASE WHEN wd = 0 THEN sessions ELSE NULL END), 1) AS monday,
	ROUND(AVG(CASE WHEN wd = 1 THEN sessions ELSE NULL END), 1) AS tuesday,
	ROUND(AVG(CASE WHEN wd = 2 THEN sessions ELSE NULL END), 1) AS wednsday,
	ROUND(AVG(CASE WHEN wd = 3 THEN sessions ELSE NULL END), 1) AS thursday,
	ROUND(AVG(CASE WHEN wd = 4 THEN sessions ELSE NULL END), 1) AS friday,
	ROUND(AVG(CASE WHEN wd = 5 THEN sessions ELSE NULL END), 1) AS saturday,
	ROUND(AVG(CASE WHEN wd = 6 THEN sessions ELSE NULL END), 1) AS sunday
FROM
	(
		SELECT
			DATE(created_at) AS dt,
			WEEKDAY(created_at) AS wd,
			HOUR(created_at) AS hr,
			COUNT(DISTINCT website_session_id) AS sessions
		FROM
			website_sessions
		WHERE
			created_at BETWEEN '2012-9-15'
			AND '2012-11-15'
		GROUP BY
			1,
			2,
			3
	) AS daily_sessions
GROUP BY
	1;