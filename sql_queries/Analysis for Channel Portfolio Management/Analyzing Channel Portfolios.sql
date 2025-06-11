-- 查看有什么组合
SELECT DISTINCT
	utm_source,
	utm_campaign
FROM
	website_sessions;
SELECT
-- 	YEARWEEK(created_at) AS yr,
	MIN(DATE(created_at)) AS week_start_date,
	SUM(from_gsearch) AS gsearch_sessions,
	SUM(from_bsearch) AS bsearch_sessions
FROM
	(
		SELECT
			website_session_id,
			created_at,
			CASE
				WHEN utm_source = 'gsearch'
					AND utm_campaign = 'nonbrand' THEN
					1
				ELSE
					0
			END AS from_gsearch,
			CASE
				WHEN utm_source = 'bsearch'
					AND utm_campaign = 'nonbrand' THEN
					1
				ELSE
					0
			END AS from_bsearch
		FROM
			website_sessions
		WHERE
			created_at BETWEEN '2012-08-22'
			AND '2012-11-29'
	) t
GROUP BY
	YEARWEEK(created_at);