SELECT
	yr,
	mo,
	nonbrand,
	brand,
	brand / nonbrand AS brand_pct_of_nonbrand,
	direct,
	direct / nonbrand AS direct_pct_of_nonbrand,
	organic,
	organic / nonbrand AS organic_pct_of_nonbrand
FROM
	(
		SELECT
			YEAR(created_at) AS yr,
			MONTH(created_at) AS mo,
			SUM(CASE WHEN utm_campaign = 'nonbrand' THEN 1 ELSE 0 END) AS nonbrand,
			SUM(CASE WHEN utm_campaign = 'brand' THEN 1 ELSE 0 END) AS brand,
			SUM(CASE WHEN utm_campaign IS NULL AND utm_source IS NULL AND http_referer IS NULL THEN 1 ELSE 0 END) AS direct,
			SUM(CASE WHEN utm_campaign IS NULL AND utm_source IS NULL AND http_referer IS NOT NULL THEN 1 ELSE 0 END) AS organic
		FROM
			website_sessions
		WHERE
			created_at < '2012-12-23'
		GROUP BY
			1,
			2
	) t;